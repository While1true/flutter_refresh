gif看起来很快
![2018-06-04-17-42-35.gif](https://upload-images.jianshu.io/upload_images/6456519-8e40c45f174d2a6b.gif?imageMogr2/auto-orient/strip)
## progress使用
```

## 大小确定 radius=（宽度-gap*(count+1)）/(2*count)   gap=radius/2
 const MyProgress({@required this.size, this.milliseconds: 300, this.color: Colors
      .green, this.count: 4});

child: new MyProgress(size: new Size(100.0, 20.0))
```
