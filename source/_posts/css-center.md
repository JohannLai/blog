title: CSS学习笔记----水平居中、垂直居中、水平垂直居中方法总结
date: 2017-02-20 16：12：03
categories:
- 技术
- 分享
- 笔记
tags:
- CSS
- 居中
---



> “44”年前，我们就把人类送上了月球，但现在我们仍然没有办法在CSS中实现垂直居中！ ——James Anderson


<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>




## 引言：
作为一名合格的web开发者，总结是对我们的的成长只关重要的，它不只是我们记录下我们学习过的东西，更重要的是，他体现了我们的思考！


#### 水平居中
在CSS中，对元素的**水平居中**是比较简单的。如果他是一个行内元素，就对他的父级元素应用：
```CSS
   text-align:center;
```

#### 单行文字的垂直居中：
```
line-height:30px;
height:30px;
```
#### 让有宽度的div水平居中：
```
margin: 0 auto;
width:300px;//必须要有**宽度**，margin:0 auto才能让它居中
```

#### 让*绝对定位*的div垂直居中：
```
position:absolute;
top:0;
bottom:0;
margin:auto 0;  /*垂直方向的auto 发挥的作用*/
width:300px;
height:300px;
```


#### 同理，让绝对定位的div水平和垂直方向都居中：

position:absolute;
top:0;
left: 0;
right:0;
bottom:0; /* 上下左右都有设置，才能使用下面的auto*/
margin:auto; 
width:300px;
height:300px;


#### 未知宽高的容器的水平垂直方向居中：

width:300px;
height:300px;
position:absolute;
top:50%;
left:50%;
transform:translate(-50%,-50%); /**注：transform属性，低版本浏览器不兼容，例如IE8*/


#### 水平垂直居中记得要想到flexbox:

css终于有了一种简单的垂直居中的方法！
```
.container{
  display: flex;
  align-items: center;
  justify-content: center;
}
.container .div{
//whatever
}
```
此时**.div无论是否已知宽高**，都能两个方向居中。


TA的兼容情况如下：
<img src="http://www.ruanyifeng.com/blogimg/asset/2015/bg2015071003.jpg" alt="http://www.ruanyifeng.com/"/>

#### 垂直居中（表格布局法）
```
.container{
  display: table;
}
.container .div{
  display: table-cell;
  vertical-align:middle;
}
```

## 思考
#### 为什么height=line-height就能垂直居中？

读了[张鑫旭大神](http://www.zhangxinxu.com/)的文章：

-行高指的是什么？ **行高指的是文本行的基线间的距离。**
- 什么是基线？**基线不是文字的下端沿。是英文字母X的下端沿。**

- 文字有顶线，底线，基线和中线，用以确定文字行的位置。

- 什么是行距？ **行高与字体尺寸之间的差。**
还要理解一个概念 -- 行内框     行内元素会生成一个行内框。它无法显示出来，但是又确实存在。
     在没有其他因素影响的时候，行内框等于内容区域。



    > 设定行高可以增加或者减少行内框的高度，即：将行距的值（行高-字体尺寸）除以2，分别加到内容区域的上下两边。这是理解的关键，也就是内容区域的上面和下面均等增加一个距离。可以在一段文字上进行调试看看，发现增加减小line

> height时，文字是整体上下缩进的，而非第一行不动，后面的向上靠拢。
网上都是这么说的，把line-height值设置为height一样大小的值可以实现单行文字的垂直居中。这句话确实是正确的，但其实也是有问题的。问题在于height，看我的表述：“把line-height设置为您需要的box的大小可以实现单行文字的垂直居中”，差别在于我把height去掉了，这个height是多余的，您不信您可以自己试试。


**此处应该有个大坑**
让line-height等于height，使文字垂直居中的方法，与字体有关？
建议 ：因为行高等于高的居中设置法，对微软雅黑 有问题，所以千万不要 在行高，高度跟字体大小差不多的情况下 设置overflow：hidden。


> 参考资料
>  * [css行高line-height的一些深入理解及应用](http://www.zhangxinxu.com/wordpress/2009/11/css%E8%A1%8C%E9%AB%98line-height%E7%9A%84%E4%B8%80%E4%BA%9B%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3%E5%8F%8A%E5%BA%94%E7%94%A8/)
>  * [Flex 布局教程：语法篇](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html?utm_source=tuicool)






