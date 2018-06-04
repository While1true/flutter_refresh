# flutter_refresh progress

A new Flutter application.

## 基于 refreshIndicate改造
![gif](https://github.com/While1true/flutter_refresh/blob/master/2018-06-02-15-14-48.gif)
![2018-06-04-17-42-35.gif](https://upload-images.jianshu.io/upload_images/6456519-8e40c45f174d2a6b.gif?imageMogr2/auto-orient/strip)
## 使用：注意事项和官方一样，比如onrefresh要返回future； child：必须为scrollable
```
RefreshLayout(
    //是否滑倒底部加载
    canloading: canloading,
    onRefresh: (refresh) {
     //true:下拉刷新 false:上拉加载
                },
    child: new ListView(children: _listBuilder(_counter) ,)))
            
```

## progress使用
```
child: new MyProgress(size: new Size(100.0, 20.0))
```
