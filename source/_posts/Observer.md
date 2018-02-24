title: JQuery中的设计模式 ——Observer (观察者)模式
date: 2017-02-28 15：40：06
categories:
- 技术
- 分享
- 笔记
tags:
- jQuery
- JavaScript
---


近日在了解JavaScript的设计模式，抽取其中的（Observer (观察者)模式）来谈一谈。

什么是观察者模式
观察者模式又叫做发布订阅模式（Public/Subscribe），它定义了一种一对多的关系，让多个观察者对象同时监听某一个主题对象，这个主题对象的状态发生改变时就会通知所有观察着对象。它是由两类对象组成，主题和观察者，主题负责发布事件，同时观察者通过订阅这些事件来观察该主体，发布者和订阅者是完全解耦的，彼此不知道对方的存在，两者仅仅共享一个自定义事件的名称。



<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>




## JQuery中的设计模式 ——Observer (观察者)模式

近日在了解JavaScript的设计模式，抽取其中的（Observer (观察者)模式）来谈一谈。

## 什么是观察者模式

> 观察者模式又叫做发布订阅模式（**Public/Subscribe**），它定义了一种一对多的关系，让多个观察者对象同时监听某一个主题对象，这个主题对象的状态发生改变时就会通知所有观察着对象。它是由两类对象组成，主题和观察者，主题负责发布事件，同时观察者通过订阅这些事件来观察该主体，发布者和订阅者是完全解耦的，彼此不知道对方的存在，两者仅仅共享一个自定义事件的名称。


## 观察者模式的好处：
比如一个模块(或者多个模块)订阅了一个主题(或者事件)，另一个模块发布这个主题时候，订阅这个主题模块就可以执行了，观察者主要让订阅者与发布者解耦，发布者不需要知道哪些模块订阅了这个主题，它只管发布这个主题就可以了，同样订阅者也无需知道那个模块会发布这个主题，它只管订阅这个主题就可以了。这样2个模块(或更多模块)就实现了关联了。
**总的来说：就是多个不同业务模块需要相互关联的时候，可以使用观察者模式。**



#### 在JQuery中
jQuery核心具有对Public/Subscribe类系统的内置支持，我们称为 *自定义事件*

**jQuery**的自定义事件可以使用下面的方法访问

``` JavaScript
	jQuery.bind(subscribe)
	jQuery.trigger()(publish)
	jQuery.unbind(unsubscribe)
	//最新版支持
	jQuery.on()
	jQuery.trigger()
	jQuery.off()
```
比如如下代码：
```
	jQuery.subscribe(“done”,fun2);

		function fun1(){

		jQuery.publish(“done”);

	}
```
> 上面的jQuery.publish(“done”);意思是执行fun1函数后，向信号中心jquery发布done信号，而jquery.subscribe(“done”,fun2)的意思是：绑定done信号，执行fun2函数。





## talk is cheap ,show me the code.
看到这里，很多人的冲动就来了，看到一个js库有一些功能，就喜欢用原生去实现一下，下面我们就来实现一下自己的**Pub/Sub模式**


``` JavaScript
	function PubSub() {
	 this.handlers = {};
	}
	PubSub.prototype = {
	 // 订阅事件
	 on: function(eventType,handler){
	  var self = this;
	  if(!(eventType in self.handlers)) {
	    self.handlers[eventType] = [];
	  }
	  self.handlers[eventType].push(handler);
	  return this;
	    },
	    // 触发事件(发布事件)
	    emit: function(eventType){
	     var self = this;
	     var handlerArgs = Array.prototype.slice.call(arguments,1);
	     for(var i = 0; i < self.handlers[eventType].length; i++) {
	     self.handlers[eventType][i].apply(self,handlerArgs);
	     }
	     return self;
	    }
	};
```

调用方式如下：

```
// 调用方式如下：

var pubsub = new PubSub();

pubsub.on('A',function(data){

console.log(1 + data);  // 执行第一个回调业务函数

});

pubsub.on('A',function(data){

console.log(2 + data); // 执行第二个业务回调函数

});

// 触发事件A

pubsub.emit('A',"我是参数");
//1我是参数

//2我是参数
```



> 参考资料
>  * [《JavaScript设计模式 》Addy Osmani / 徐涛 / 人民邮电出版社 / 2013](https://book.douban.com/subject/24744217/)






