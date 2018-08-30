# flutter_refresh progress

A new Flutter application.
Flutter Debug和Release流畅度差好远！！！
## 2018-8-14

> 支持下拉刷新，上拉加载的关闭

> 支持自定义上拉加载控件，不写用一个默认的

> 使用和原生RefreshIndicate一样

## 基于 refreshIndicate改造
![gif](https://github.com/While1true/flutter_refresh/blob/master/2018-06-02-15-14-48.gif)

## 使用：注意事项和官方一样，比如onrefresh要返回future； child：必须为scrollable

loadingBuilder:是加载更多的布局，不写使用默认
```
RefreshLayout(
     //是否下拉刷新
    canrefresh:canrefresh
    //是否滑倒底部加载
    canloading: canloading,
    onRefresh: (refresh) 
    {//true:下拉刷新 false:上拉加载},
    child: new ListView(children: _listBuilder(_counter) ,),
    loadingBuilder: 
        (BuildContext context) {
           return Padding(padding: EdgeInsets.all(15.0),child: Text('正在加载中...'),);
        }))
            
```


