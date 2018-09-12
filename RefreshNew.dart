import 'dart:ui';

import 'package:flutter/material.dart';

// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// The over-scroll distance that moves the indicator to its maximum
// displacement, as a percentage of the scrollable's container extent.
const double _kDragContainerExtentPercentage = 0.25;

// How much the scroll's drag gesture can overshoot the RefreshLayout's
// displacement; max displacement = _kDragSizeFactorLimit * displacement.
const double _kDragSizeFactorLimit = 1.5;

// When the scroll ends, the duration of the refresh indicator's animation
// to the RefreshLayout's displacement.
const Duration _kIndicatorSnapDuration = const Duration(milliseconds: 150);

// The duration of the ScaleTransition that starts when the refresh action
// has completed.
const Duration _kIndicatorScaleDuration = const Duration(milliseconds: 200);

/// The signature for a function that's called when the user has dragged a
/// [RefreshLayout] far enough to demonstrate that they want the app to
/// refresh. The returned [Future] must complete when the refresh operation is
/// finished.
///
/// Used by [RefreshLayout.onRefresh].
typedef Future<Null> RefreshCallback(bool refresh);

typedef StateChange<T>(T value, bool refresh);

// The state machine moves through these modes only when the scrollable
// identified by scrollableKey has been scrolled to its min or max limit.
enum RefreshLayoutMode {
  drag, // Pointer is down.
  armed, // Dragged far enough that an up event will run the onRefresh callback.
  refresh, // Running the refresh callback.
  done // Animating the indicator's fade-out after not arming.
}

/// A widget that supports the Material "swipe to refresh" idiom.
///
/// When the child's [Scrollable] descendant overscrolls, an animated circular
/// progress indicator is faded into view. When the scroll ends, if the
/// indicator has been dragged far enough for it to become completely opaque,
/// the [onRefresh] callback is called. The callback is expected to update the
/// scrollable's contents and then complete the [Future] it returns. The refresh
/// indicator disappears after the callback's [Future] has completed.
///
/// If the [Scrollable] might not have enough content to overscroll, consider
/// settings its `physics` property to [AlwaysScrollableScrollPhysics]:
///
/// ```dart
/// new ListView(
///   physics: const AlwaysScrollableScrollPhysics(),
///   children: ...
//  )
/// ```
///
/// Using [AlwaysScrollableScrollPhysics] will ensure that the scroll view is
/// always scrollable and, therefore, can trigger the [RefreshLayout].
///
/// A [RefreshLayout] can only be used with a vertical scroll view.
///
/// See also:
///
///  * <https://material.google.com/patterns/swipe-to-refresh.html>
///  * [RefreshLayoutState], can be used to programmatically show the refresh indicator.
///  * [RefreshProgressIndicator], widget used by [RefreshLayout] to show
///    the inner circular progress spinner during refreshes.
///  * [CupertinoRefreshControl], an iOS equivalent of the pull-to-refresh pattern.
///    Must be used as a sliver inside a [CustomScrollView] instead of wrapping
///    around a [ScrollView] because it's a part of the scrollable instead of
///    being overlaid on top of it.
class RefreshLayout extends StatefulWidget {
  /// Creates a refresh indicator.
  ///
  /// The [onRefresh], [child], and [notificationPredicate] arguments must be
  /// non-null. The default
  /// [displacement] is 40.0 logical pixels.
  const RefreshLayout({
    Key key,
    @required this.child,
    this.header,
    this.footer,
    this.valueChanged,
    this.stateChanged,
    this.elastic = 2.5,
    this.canrefresh: true,
    this.canloading: true,
    this.displacement: 45.0,
    @required this.onRefresh,
    this.notificationPredicate: defaultScrollNotificationPredicate,
  })
      : assert(child != null),
        assert(onRefresh != null),
        assert(notificationPredicate != null),
        assert(elastic != null),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// The refresh indicator will be stacked on top of this child. The indicator
  /// will appear when child's Scrollable descendant is over-scrolled.
  ///
  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;

  /// The distance from the child's top or bottom edge to where the refresh
  /// indicator will settle. During the drag that exposes the refresh indicator,
  /// its actual displacement may significantly exceed this value.
  final double displacement;

  final double elastic;

  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final RefreshCallback onRefresh;

  /// A check that specifies whether a [ScrollNotification] should be
  /// handled by this widget.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to something
  /// else for more complicated layouts.
  final ScrollNotificationPredicate notificationPredicate;

  final ValueChanged<double> valueChanged;

  final StateChange<RefreshLayoutMode> stateChanged;

  final RefreshableBuilder header;

  final RefreshableBuilder footer;

  final bool canloading;

  final bool canrefresh;

  @override
  State<StatefulWidget> createState() => _RefreshLayoutState();
}

class _RefreshLayoutState extends State<RefreshLayout>
    with TickerProviderStateMixin {
  RefreshLayoutMode _mode;
  double _dragOffset;
  bool _isRefreshDrag;
  GlobalKey _key;
  GlobalKey<_RefreshableState> _headerKey;
  GlobalKey<_RefreshableState> _footerKey;
  AnimationController _positionController;

  @override
  void initState() {
    super.initState();
    _positionController = new AnimationController(
        vsync: this, lowerBound: -1.0, upperBound: 1.0, value: 0.0);
    _key = new GlobalKey();
    _headerKey = new GlobalKey<_RefreshableState>();
    _footerKey = new GlobalKey<_RefreshableState>();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = new NotificationListener<ScrollNotification>(
      key: _key,
      onNotification: _handleScrollNotification,
      child: new NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleGlowNotification,
        child: AnimatedBuilder(
            animation: _positionController,
            builder: (c, w) {
              var transY = _positionController.value *
                  widget.displacement *
                  _kDragSizeFactorLimit;
              if (widget.valueChanged != null) {
                widget.valueChanged(transY);
              }
              return Transform.translate(
                  offset: Offset(0.0, transY),
                  child: _RefreshWrap(
                      height: widget.displacement,
                      header: _Refreshable(
                        height: widget.displacement,
                        child: widget.header,
                        key: _headerKey,
                      ),
                      content: widget.child,
                      footer: _Refreshable(
                        height: widget.displacement,
                        child: widget.footer,
                        key: _footerKey,
                      )));
            }),
      ),
    );
    return child;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) return false;
    if (_mode == RefreshLayoutMode.drag) {
      notification.disallowGlow();
      return true;
    }
    return false;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification) ||
        _mode == RefreshLayoutMode.refresh) return false;

    if (notification is ScrollStartNotification &&
        _isAtEdge(notification) &&
        _mode == null &&
        _start(notification)) {
      _onStateChange(RefreshLayoutMode.drag);
      setState(() {
        _mode = RefreshLayoutMode.drag;
      });
      return false;
    }
    if (_dragOffset == null) return false;
    if (notification is ScrollUpdateNotification) {
      if (_mode == RefreshLayoutMode.drag || _mode == RefreshLayoutMode.armed) {
        if (_getEdgetValue(notification) > 0.0) {
          _dismiss();
        } else {
          _dragOffset -= notification.scrollDelta;
          _checkDragOffset();
        }
      }
      if (_mode == RefreshLayoutMode.armed &&
          notification.dragDetails == null) {
        // On iOS start the refresh when the Scrollable bounces back from the
        // overscroll (ScrollNotification indicating this don't have dragDetails
        // because the scroll activity is not directly triggered by a drag).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_mode == RefreshLayoutMode.drag || _mode == RefreshLayoutMode.armed) {
        _dragOffset -= notification.overscroll / widget.elastic;
        _checkDragOffset();
      }
    } else if (notification is ScrollEndNotification) {
      switch (_mode) {
        case RefreshLayoutMode.armed:
        /**
         * 未设置刷新头时直接还原
         */
          if ((_isRefreshDrag && widget.header == null) ||
              (!_isRefreshDrag && widget.footer == null)) {
            _dismiss();
          } else {
            _show();
          }
          break;
        case RefreshLayoutMode.drag:
          _dismiss();
          break;
        default:
        // do nothing
          break;
      }
    }
    return false;
  }

  void _onStateChange(RefreshLayoutMode mode) {
    if (_isRefreshDrag == null || _isRefreshDrag) {
      _headerKey.currentState._stateChange(mode);
    } else {
      _footerKey.currentState._stateChange(mode);
    }
    if (widget.stateChanged != null) {
        widget.stateChanged(mode, _isRefreshDrag);
    }
  }

  void _checkDragOffset() {
    assert(_mode == RefreshLayoutMode.drag || _mode == RefreshLayoutMode.armed);
    var maxpull = widget.displacement * _kDragSizeFactorLimit;
    if (_dragOffset.abs() > maxpull) {
      _dragOffset = _dragOffset.isNegative ? -maxpull : maxpull;
    }
    double newValue = _dragOffset / maxpull;
    _positionController.value = _isRefreshDrag
        ? newValue.clamp(0.0, 1.0)
        : newValue.clamp(-1.0, 0.0); // this triggers various rebuilds
    if (_mode == RefreshLayoutMode.drag &&
        _dragOffset.abs() > widget.displacement) {
      _mode = RefreshLayoutMode.armed;
      _onStateChange(RefreshLayoutMode.armed);
    }
  }

  bool _isAtEdge(ScrollNotification notification) =>
      (widget.canrefresh && notification.metrics.extentBefore == 0.0) ||
          (widget.canloading && notification.metrics.extentAfter == 0.0);

  bool _start(ScrollNotification notification) {
    _isRefreshDrag = notification.metrics.extentBefore == 0.0;
    _dragOffset = 0.0;
    _positionController.value = 0.0;
    return true;
  }

  double _getEdgetValue(ScrollNotification notification) =>
      _isRefreshDrag
          ? notification.metrics.extentBefore
          : notification.metrics.extentAfter;

  void show(bool isRefresh) {
    _isRefreshDrag = isRefresh;
    _mode = RefreshLayoutMode.armed;
    _show();
  }

  void _show() async {
    final Completer<void> completer = new Completer<void>();
    await _positionController
        .animateTo(
        _isRefreshDrag
            ? (1.0 / _kDragSizeFactorLimit)
            : (-1.0 / _kDragSizeFactorLimit),
        duration: _kIndicatorSnapDuration)
        .then<void>((Null value) {
      if (mounted && _mode == RefreshLayoutMode.armed) {
        assert(widget.onRefresh != null);
        _onStateChange(RefreshLayoutMode.refresh);
        setState(() {
          // Show the indeterminate progress indicator.
          _mode = RefreshLayoutMode.refresh;
        });

        final Future<void> refreshResult = widget.onRefresh(_isRefreshDrag);
        assert(() {
          if (refreshResult == null)
            FlutterError.reportError(new FlutterErrorDetails(
              exception: new FlutterError(
                  'The onRefresh callback returned null.\n'
                      'The RefreshIndicator onRefresh callback must return a Future.'),
              context: 'when calling onRefresh',
              library: 'material library',
            ));
          return true;
        }());
        if (refreshResult == null) return;
        refreshResult.whenComplete(() {
          if (mounted && _mode == RefreshLayoutMode.refresh) {
            completer.complete();
            _dismiss();
          }
        });
      }
    });
  }

  void _dismiss() async {
    _onStateChange(RefreshLayoutMode.done);
    await _positionController
        .animateTo(0.0, duration: _kIndicatorSnapDuration)
        .whenComplete(() {
      _dragOffset = null;
      _isRefreshDrag = null;
      setState(() {
        _mode = null;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _positionController.dispose();
  }
}

typedef Widget RefreshableBuilder(BuildContext context,
    RefreshLayoutMode state);
//
//class _ContetWrap extends StatefulWidget {
//  final RefreshableBuilder child;
//
//  _ContetWrap({this.child, Key key}) :super(key: key);
//
//  @override
//  State<StatefulWidget> createState() => _ContetWrapState();
//}
//
//class _ContetWrapState extends State<_ContetWrap> {
//  RefreshLayoutMode state;
//
//  void _stateChange(RefreshLayoutMode state) {
//    this.state = state;
//    if (mounted) {
//      setState(() {});
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) => widget.child(context, state);
//}

class _Refreshable extends StatefulWidget {
  final double height;
  final RefreshableBuilder child;

  const _Refreshable({@required this.height, @required this.child, Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RefreshableState();
}

class _RefreshableState extends State<_Refreshable> {
  RefreshLayoutMode state;

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: widget.height,
      child: Center(child: widget.child(context, state)),
    );
  }

  void _stateChange(RefreshLayoutMode state) {
    this.state = state;
    if (mounted) {
      setState(() {});
    }
  }
}

class _RefreshWrap extends CustomMultiChildLayout {
  _RefreshWrap({
    Key key,
    double height = 45.0,
    @required _Refreshable header,
    @required Widget content,
    @required _Refreshable footer,
  }) : super(
      key: key,
      delegate: _ReshLayoutDelegate(height),
      children: <Widget>[
        LayoutId(id: _ID.HEADER, child: header),
        LayoutId(id: _ID.CONTENT, child: content),
        LayoutId(id: _ID.FOOTER, child: footer),
      ]);
}

class _ReshLayoutDelegate extends MultiChildLayoutDelegate {
  final double height;

  _ReshLayoutDelegate(@required this.height);

  @override
  void performLayout(Size size) {
    if (hasChild(_ID.HEADER)) {
      var box = new BoxConstraints.tightFor(width: size.width);
      layoutChild(_ID.HEADER, box);
      positionChild(_ID.HEADER, Offset(0.0, -height));
    }
    if (hasChild(_ID.CONTENT)) {
      var box = new BoxConstraints.tight(size);
      layoutChild(_ID.CONTENT, box);
      positionChild(_ID.CONTENT, Offset.zero);
    }
    if (hasChild(_ID.FOOTER)) {
      var box = new BoxConstraints.tightFor(width: size.width);
      layoutChild(_ID.FOOTER, box);
      positionChild(_ID.FOOTER, Offset(0.0, size.height));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}


enum _ID { HEADER, CONTENT, FOOTER }
