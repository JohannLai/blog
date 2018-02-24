title: 文档就绪事件（`document ready`）的兼容问题

date: 2017-03-18 20：12：03
categories:
- 分享
- 笔记
tags:
- DOM
---


#### 文档就绪事件（`document ready`）的兼容问题

ready 我们称为“就绪”事件。
在**W3C DOM**兼容浏览器里面是用DOMContentLoaded实现的，这个在《高程》里面曾经提及过。

ready事件是在整个`DOM`文档加载完成以后触发的，表明，现在可以遍历`DOM`文档了。

**但是在跨浏览器中，使用这个事件的时候，避免不了需要再做一次支持旧版本IE（IE9以前的版本）的工作**



<Excerpt in index | 首页摘要> 
<!-- more -->
<The rest of contents | 余下全文>




## 技巧1
#### 介绍
使用[Diego Perini创建的一种方法](http://javascript.nwbox.com/IEContentLoaded)，

#### 原理
尝试将文档滚动到最左边（自然位置）。该尝试会一直继续，一直失败，一直到`DOM`加载完成以后，才停止，
所以如果我们不断尝试执行该操作（使用定时器，确保不阻止事件循环），在操作成功时，我们就会知道，`DOM`已经就绪（ready）了。

```javascript
The IEContentLoaded source code

/*
 *
 * IEContentLoaded.js
 *
 * Author: Diego Perini (diego.perini at gmail.com) NWBOX S.r.l.
 * Summary: DOMContentLoaded emulation for IE browsers
 * Updated: 05/10/2007
 * License: GPL
 * Version: TBD
 *
 * Copyright (C) 2007 Diego Perini & NWBOX S.r.l.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see http://javascript.nwbox.com/IEContentLoaded/GNU_GPL.txt.
 *
 */

// @w	window reference
// @fn	function reference
function IEContentLoaded (w, fn) {
	var d = w.document, done = false,
	// only fire once
	init = function () {
		if (!done) {
			done = true;
			fn();
		}
	};
	// polling for no errors
	(function () {
		try {
			// throws errors until after ondocumentready
			d.documentElement.doScroll('left');
		} catch (e) {
			setTimeout(arguments.callee, 50);
			return;
		}
		// no errors, fire
		init();
	})();
	// trying to always fire before onload
	d.onreadystatechange = function() {
		if (d.readyState == 'complete') {
			d.onreadystatechange = null;
			init();
		}
	};
}
```

## 技巧二
在文档上添加监听`onreadystatechange`(代码如上)文档了。
这个事件和`doScroll`技巧不太一致——Dom就绪时，该事件会一直触发，但是有时候他会触发好长的时间（但是总在load事件之前）/
即使有这个弱点，但是，至少确保了在load事件之前发生了一点事情。

## 技巧三

检查`document.readyState`属性。该属性可在所有的浏览器当中使用，用于记录当时的DOM加载状态，
我们需要知道的是，什么时候到了`complete`状态。
在IE浏览器当中，加载用的时间可能很长，`readyState`有可能过早地报告完成`complete`状态，这就是为什么我们不能完全依赖他的原因。

> 更多关于文档状态的资料可以打开MDN文档 ：https://developer.mozilla.org/zh-CN/docs/Web/API/Document/readyState


## 实现跨浏览器的DOM ready事件

```javascript
  <script type="text/javascript">
    (function(){
      var isReady = false,   //假设一开始的时候还没就绪
          contentLoadedHandler;
      function ready() {
        if(!ready){
          triggerEvent(document, "ready");  
          isReady = true;
        }
      }

      //如果程序已经就绪，直接触发ready函数。
      if(document.readyState === "complete") {
        ready();
      }

      //对于W3C浏览器，创建一个DOMContentLoaded事件处理程序，然后再删除自身
      if(document.addEventListener){
        contentLoadedHandler = function () {
          document,removeEventlistener(
            "DOMContentLoaded", contentLoadedHandler,false
          );
          ready();
        }
        document.addEventListener(
          "DOMContentLoaded", contentLoadedHandler,false
        );  //将刚刚创建的contentLoadedHandler处理程序绑定到DOMContentLoaded上面
      }

      //对于IE模型的浏览器，创建一个处理程序，在文档readyState 为complete状态时，删除自身并触发ready处理程序。
      else if(document.attachEvent){
        contentLoadedHandler = function () {
          if (document.readyState === "complete") {
            document.detachEvent(
              "onreadystatechange", contentLoadedHandler
            )；
          ready();
          }
        }
      };

      document.attachEvent(
        "onreadystatechange", contentLoadedHandler);
      );

      var toplevel = false;
      try{
        toplevel = window.frameElemt == null;
      }
      catch(e){
        if (document.documentElement.doScroll && toplevel){
          doScrollCheck();
        }
      }
      //定义滚动检测函数，持续进行滚动。
      function doScrollCheck(){
        if(isReady)return;
        try {
          document.documentElement.doScroll("left");
        }
        catch(e){
          setTimeout(doScrollCheck,1);
          return;
        }
        ready();
      }
    })();
  </script>
```