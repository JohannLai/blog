title: JavaScript学习笔记----浅谈Ajax
date: 2017-02-20 16：12：03
categories:
- 技术
- 分享
- 笔记
tags:
- Ajax
- JavaScript
---



> 引言：作为一名合格的web开发者，时刻保持了解工具的内部原理是非常重要的，这对于我们使用工具发明工具非常有用。

Ajax - "asynchronous(异步的) JavaScript and XML"
是一种可以在不刷新页面的基础上从服务器上面获取数据的技术。它使用浏览器为内嵌的 XMLHttpRequest (XHR)  去服务器请求数据并且处理服务器返回的数据。


<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>




## 引言：
作为一名合格的web开发者，时刻保持了解工具的内部原理是非常重要的，这对于我们使用工具发明工具非常有用。

#### Ajax - "asynchronous(异步的) JavaScript and XML"
是一种可以在不刷新页面的基础上从服务器上面获取数据的技术。它使用浏览器为内嵌的 **XMLHttpRequest (XHR)**  去服务器请求数据并且处理服务器返回的数据。



#### $.Ajax

我们可以在下面两种场景使用$jQuery的`$.ajax()`方法。
我们可以使用配置对象作为他的唯一的参数，我们也可以传递一个URL和可选的配置作为他的参数
#### 第一种方法：

```javascript
// 创建一个当ajax成功的时候会调用的回调函数
var updatePage = function( resp ) {
  $( '#target').html( resp.people[0].name );
};

// 创建一个当ajax失败的时候会调用的回调函数
var printError = function( req, status, err ) {
  console.log( 'something went wrong', status, err );
};

// 创建一个描述ajax请求的对象
var ajaxOptions = {
  url: '/data/people.json',
  dataType: 'json',
  success: updatePage,
  error: printError
};

//发起请求!
$.ajax(ajaxOptions);
```

当然，你也可以只传递一个`$.ajax`对象，和使用`success` 和`fail`回调。

#### 下面的这种方法更加容易维护：
```
$.ajax({
  url: '/data/people.json',
  dataType: 'json',
  success: function( resp ) {
  $( '#target').html( resp.people[0].name );
  },
  error: function( req, status, err ) {
  console.log( 'something went wrong', status, err );
  }
});
```

#### 正如前面提到的,如果你想使用默认配置 `$.ajax()` ,或者如果你想使用相同的配置几个url。你也可以通过一个URL和一个可选的配置对象调用 `$.ajax()` 方法
```JavaScript
$.ajax( '/data/people.json', {
  type: 'GET',
  dataType: 'json',
  success: function( resp ) {
  console.log( resp.people );
  },
  error: function( req, status, err ) {
  console.log( 'something went wrong', status, err );
  }
});
```

## 原生JavaScript写法
这个函数是为了创建一个跨浏览器兼容的 `XHR` 对象.对于 `IE 浏览器`,所使用的是 `ActiveXObject` 函数来创建 XHR 对象.
而对于其他浏览器则直接使用 `XMLHttpRequest API` 来创建 XHR 对象.
```
function createXHR(){
    if(typeof XMLHttpRequest != 'undefinded') {

        return new XMLHttpRequest();
    } else if(typeof ActiveXObject != 'undefined') {

        if(typeof argument.callee.activeXString != 'string') { //函数形参

            var versions = ['MSXML2.XMLHttp', 'MSXML2.XMLHttp.2.0', 'MSXML2.XMLHttp.3.0', 'MSXML2.XMLHttp.4.0', 'MSXML2.XMLHttp.5.0', 'MSXML2.XMLHttp.6.0'];

            for(var i = 0; i < versions.length; i++) {

                try {
                    new ActiveXObject(versions[i]);
                    argument.callee.activeXString = versions[i]; //用于告知与创建 ActiveXOPbject 对象版本
                    break;
                } catch(ex){
                    //pass
                }
            }

        }

        return new ActiveXObject(argument.callee.activeXString);
    } else {

        alert('Your bowers is not support XHR!');
    }
}
```

#### 使用 `AJAX` 请求数据

```
var xhr = createXHR();

xhr.onreadystatechange = function(){

    if(xhr.readyState == 4) {
        if(xhr.status == 200) {
            var data = xhr.responseText;// xhr.responseXML
        }
    }
}

xhr.open('get', 'http://johannlai.com', true);  //只是预处理连接,并没有实际建立连接或发送请求
//xhr.setRequestHeader('Content-type', 'text/plain');  //设置请求头部
xhr.send(null);
```

#### 发送POST请求：
```
xhr.post = function(url, data, callback, async){
    var queue = [];
    for(var key in data) {

        queue.push(encodeURLComponent(key) + '=' + encodeURLComponent(data[key]));
    }
    //注意与 GET 请求的区别
    xhr.send('GET', url, queue.join('&'), callback, true);
}
```
#### 发送 GET 请求:
```
xhr.get = function(url, data, callback, async){
    var queue = [];
    for(var key in data) {

         queue.push(encodeURLComponent(key) + '=' + encodeURLComponent(data[key]));
    }
    //注意 GET 请求中的数据放在 URI 中(查询字符串, '?' 后面的数据)
     xhr.send('GET', url + (queue.length ? '?' + queue.join('&') : '') , null, callback, true);
}
```
## 跨域问题 CORS

跨域问题一直是 Web 开发的一个难题,涉及了 **Web 安全**,浏览器内核等方面的知识,如果只是一直使用像 `Jquery` 这样的
工具库而不去了解它的内部原理的话,那么遇到浏览器的报错
```
XMLHttpRequest cannot load http://api.johannlai.com. Origin http://localhost:8080 is not allowed by Access-Control-Allow-Origin.
```
显然会一头雾水，但是如果我们理解了他的内部原理，我们可以很容易的找到解决方法！

## 什么是跨域？

跨域问题是因为浏览器出于安全考虑采取同源策略,所谓同源策略就是 同协议,同域名,同端口, 如果请求的资源的
URI 不符合这三个规定,请求的资源就无法得到,这就称之为跨域问题(即跨域资源共享问题).
在浏览器已经提供了解决这个问题的方案了, 就是在请求头部加上 Origin 字段说明发起请求的域名,而服务端的响应
头部加上 `Access-Control-Allow-Origin` 字段说明允许请求资源的域名,域名不在值中的无法正确请求资源.

```
	Origin: url
	Access-Control-Allow-Origin: url
```
如果需要正确使用 `CORS` 的话,需要知道下面的几点,因为 `HTTP` 请求头部中 `Origin`, Javascript 并没有权利
控制, 而是由浏览器这个用户代理来添加的,想想也知道, 如果 Javascript 有这个权利的话, 跨域问题也就不存在了,
浏览器安全也无从谈起.

如何解决跨域问题

#### JSONP：

> 原理是：动态插入script标签，通过script标签引入一个js文件，这个js文件载入成功后会执行我们在url参数中指定的函数，并且会把我们需要的json数据作为参数传入。

由于同源策略的限制，`XMLHttpRequest`只允许请求当前源（域名、协议、端口）的资源，为了实现跨域请求，可以通过script标签实现跨域请求，然后在服务端输出JSON数据并执行回调函数，从而解决了跨域的数据请求。

优点是兼容性好，简单易用，支持浏览器与服务器双向通信。缺点是只支持GET请求。

JSONP：json+padding（内填充），顾名思义，就是把JSON填充到一个盒子里
```html
<script>
    function createJs(sUrl){

        var oScript = document.createElement('script');
        oScript.type = 'text/javascript';
        oScript.src = sUrl;
        document.getElementsByTagName('head')[0].appendChild(oScript);
    }

    createJs('jsonp.js');

    box({
      'name': 'test'
    });

    function box(json){
        alert(json.name);
    }
</script>
```
#### CORS

服务器端对于CORS的支持，主要就是通过设置`Access-Control-Allow-Origin`来进行的。如果浏览器检测到相应的设置，就可以允许Ajax进行跨域的访问。

例如在nodejs的框架Express中可以这样设置：
```JavaScript
var express=require('express');
var url=require('url');
var app=express();
var allowCrossDomain = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', 'http://localhost:8080');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    res.header('Access-Control-Allow-Credentials','true');
    next();
};
app.use(allowCrossDomain);
```
Nginx中设置如下（conf）：
```

http {
  ......
  add_header Access-Control-Allow-Origin  http://localhost:8080; #或者是需要跨域的域名，请勿设置为*，极度不安全！
  add_header Access-Control-Allow-Headers X-Requested-With;
  add_header Access-Control-Allow-Methods GET,POST,OPTIONS;
  ......
}
这样就可以实现GET,POST,OPTIONS的跨域请求的支持
也可以 add_header Access-Control-Allow-Origin http://test.johannlai.com; --指定允许的url;
```

#### 通过修改document.domain来跨子域

将子域和主域的document.domain设为同一个主域.前提条件：这两个域名必须属于同一个基础域名!而且所用的协议，端口都要一致，否则无法利用document.domain进行跨域

主域相同的使用document.domain

#### 使用window.name来进行跨域

window对象有个name属性，该属性有个特征：即在一个窗口(window)的生命周期内,窗口载入的所有的页面都是共享一个window.name的，每个页面对window.name都有读写的权限，window.name是持久存在一个窗口载入过的所有页面中的

使用HTML5中新引进的window.postMessage方法来跨域传送数据

还有flash、在服务器上设置代理页面等跨域方式。个人认为window.name的方法既不复杂，也能兼容到几乎所有浏览器，这真是极好的一种跨域方法。

## Ajax可用于无阻塞加载脚本

最近在阅读《高性能JavaScript》中也提到，XMLHTTPRequest（XHR）可以作为一种无阻塞加载脚本的方法获取脚本并且注入页面当中。

其实也是ajax，先创建一个XHR对象，然后用它下载JavaScript文件，最后通过创建动态<script>元素将代码注入页面。
例子如下：

```JavaScript
var xhr = new XMLHttpRequest();
xhr.open("get","http://johannlai.com/example.js", true);
xhr.onreadystatechange = function() {
    if(xhr.readyStatue == 4){
        if(xhr.status >= 200 && xhr.status < 300 || xhr.status == 304){
            var script = document.createElement("script");
            script.type = "text/javascript";
            script.text = xhr.responseText;
            document.body.appendChild(script);
        } 
    }
};
xhr.send(null);

```
这种方法的**优点**是，你可以下载JavaScript代码，但是不立即执行，其实也就是一个异步（**asynchronous**）的思想，由于代码在`<script>`标签之外返回的，因此他的下载后不会自动执行，这使得你可以把脚本的执行推迟到你准备好为止。
另外一个优点是，同样的代码在所有主流浏览器当中无一例外都可以**正常工作**！

> 参考资料
>  * [《 JavaScript高级程序设计（第3版） 》[美] Nicholas C. Zakas / 李松峰 / 人民邮电出版社 / 2012](https://book.douban.com/subject/10546125/)
>  * [高性能JavaScript 》【美】Nicholas C. Zakas（尼古拉斯.泽卡斯） / 丁琛 / 电子工业出版社 / 2015](https://book.douban.com/subject/26599677/)






