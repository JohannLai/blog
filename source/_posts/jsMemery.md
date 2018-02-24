title: 关于JavaScript的垃圾回收（GC）机制和循环引用。
date: 2017-03-24 08:30:12
categories:
- 技术
- 分享
tags:
- JavaScript
---


最近查看Mozilla 文档上的例子, 这个是在 IE 6,7 里的,
```javascript
var div = document.createElement("div");
div.onclick = function(){
  doSomething();
}; // The div has a reference to the event handler via its 'onclick' property
// The handler also has a reference to the div since the 'div' variable can be accessed within the function scope
// This cycle will cause both objects not to be garbage-collected and thus a memory leak.
```

又是一个关于在IE浏览器上面的内存泄漏的问题。

<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>


---

# 关于JavaScript的垃圾回收（GC）机制和循环引用。

---
## JavaScript的垃圾收集机制

#### 标记清除

> 到2008年止。 `IE`，`FireFox`，`Opera`，`Chrome`，`Safari`的JavaScript实现使用的都是标记清除式的GC机制（或者类似的策略），只是垃圾回收的时间和间隔互不相同。

当变量进入环境时，如在函数中var一个变量，此时将这个变量标记为进入环境，当变量离开环境的时候，则将其标记为离开环境，可以通过翻转某一个位来标记一个变量何时进入了环境。但标记不是重点，重点是标记了之后怎么来将其处理。垃圾收集器会在运行的时候给存储在内存中的所有变量都加上标记，然后，它会去掉环境中的变量以及被环境中的变量应用的标记，在此之后再把加上标记的变量都将被视为准备删除的变量。最后，垃圾收集器完成内存的清楚工作，销毁那些带标记的值并收回它们所占用的内存空间。


#### 引用计数
跟踪记录每个值被引用的次数，当这个值的引用次数变成0的时候，说明没有办法再访问这个这个值，就将其占用的内存空间收回来，下次再运行垃圾收集器的时候，就会释放哪些引用次数为0的值所占用的内存了。

但存在的一个问题是，如果有循环引用，即A有个指针指向B，B也有一个指针指向A，在采用标记清楚策略的实现中，这将是个噩梦。如果DOM元素和原生JS对象之间创建了`循环引用`，那就带来`内存泄露`的问题，解决方法是把DOM和BOM对象转换成真正的JS对象。


<img src="http://o6m29g00l.bkt.clouddn.com/2017-03-24%2010:43:12%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE.png"/>


看到这里，我不禁想起`《Javascript高级程序设计》`中提到，**IE 中有一部分对象并不是原生的JavaScript对象**， 例如**BOM*  和 **DOM** 中的对象就是C++的COM（组件对象模型， 他的GC机制就是上文说到的**引用计数**）;


请看下面的例子：
```javascript
function assignHandler () {
  var element = document.getElementById('someElement');
  element.onclick = function () {
    alert(element.id);
  };
}
```


书上描述“由于匿名函数中引用了element，所以element的引用数最少是1，**导致占用的内存永远不会被回收**。把这个就叫内存泄漏。

建议写法

```javascript
function assignHandler () {
  var element = document.getElementById('someElement');
  var id = element.id;
  element.onclick = function () {
    alert(id);
  };
  element = null;  //手工断开原生JavaScript对象与DOM元素之间的连接，**避免循环引用产生的问题**。 当
                   //当下次垃圾收集运行的时候，就会删除这些值并回收他们的内存，
}
```

> 为了解决这些问题，**IE 9** 已经把BOM和DOM对象都转换成为真正的**JavaScript**对象。这样就避免了两种垃圾收集算法并存导致的问题，也消除了常见的**内存泄露现象**

