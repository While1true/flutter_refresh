# flutter_refresh

A new Flutter application.

## 基于 refreshIndicate改造
![gif](https://github.com/While1true/flutter_refresh/blob/master/2018-06-02-15-14-48.gif)

## 使用：注意事项和官方一样，比如onrefresh要返回future； child：必须为scrollable
```
RefreshLayout(
    //是否显示加载更多
    nomore: isnomore, 
    onRefresh: (refresh) {
     //true:下拉刷新 false:上拉加载
                },
    child: new ListView(children: _listBuilder(_counter) ,)))
            
```
