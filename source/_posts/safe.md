title: Web安全
date: 2017-03-4 3：00：06
categories:
- 技术
- 分享
tags:
- 网络安全
---



> 当今，互联网安全已经上升到国家非常重视的一个层次。作为一个web工程师，要深刻理解web安全的重要性。下面我总结了几种常见的网络攻击以及防御技巧。

<img src="http://www.secbox.cn/wp-content/uploads/2015/09/81a4b79a2a0118ea2324621199cffefd.jpg"  />

- CSRF 攻击
- 如何进行 CSRF 防御呢？
- XSS 攻击
- 如何防御 XSS 攻击？

<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>


## CSRF 攻击
CSRF([Cross-site request forgery](https://en.wikipedia.org/wiki/Cross-site_request_forgery))
> 跨站请求伪造，也被称为：one click attack/session riding， 缩写为：CSRF/XSRF
> CSRF 可以简单理解为：攻击者盗用了你的身份，以你的名义发送恶意请求，容易造成个人隐私泄露以及财产安全。
<img src="http://www.secbox.cn/wp-content/uploads/2015/09/81a4b79a2a0118ea2324621199cffefd.jpg">

#### 如上图所示：要完成一次 CSRF 攻击，受害者必须完成：

- 登录受信任网站，并在本地生成 cookie
- 在不登出 A 的情况下，访问危险网站 B

#### 举个简单的例子：
例如某个交友网站A，它使用GET请求来完成删除好友的操作，例如：
```
 http://friend.johannlai.com/deleteFriends?name=all
```

而某个危险网站B，它的页面中带有一个这样的标签：（**注意src里面的内容**）

```
<img src="http://friend.johannlai.com/deleteFriends?name=all">
```

#### 后果
当你某一天登陆了交友网站A，然后危险网站B又弹出来的时候，恭喜你，你的好友全部被删除了。
原因很简单，就是A网站违反了HTTP规范，使用get请求更新资源。

其实就算是交友网站A 改为**POST**请求，同样是没有效果，危险网站他同样可以做一样的动作。

**可以看出，CSRF 攻击时源于 WEB 的隐式身份验证机制！WEB 的身份验证机制虽然可以保证一个请求是来自某个用户的浏览器，但无法保证该请求是经过用户批准发送的。**


## 如何进行 CSRF 防御？

CSRF 防御可以从`服务端`和`客户端`两方面着手，防御效果是从服务端着手效果比较好，现在**一般 CSRF 防御都在服务端**进行的。

#### 主要有以下的方法


-关键操作只接受 POST 请求
-验证码：

**复杂的验证码**有一个好处，就是，机器很难识别，当用户需要提交的数据需要提示用户输入验证码的时候，一般用户都特别注意，从而简单有效地防御了 CSRF 的攻击。

但是但是但是，这就让我想起了12306啊


可以看到，但是如果你自啊一个网站作出任何举动都要输入验证码的话会严重影响用户体验，所以验证码一般只出现在特殊操作里面，或者在注册时候使用。

而且，简单的验证码是非常不安全的，我自己也曾经用python写过识别验证码，准确率还可以！
<img src="http://o6m29g00l.bkt.clouddn.com/2017-03-05%2011:05:41%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE.png?e=1488686747&token=FoiyICSlYLk7vMOBABvfUhyCNEcXf4UoIyxcg5iE:jmHqXRAqeJQSCxzeHwCEssgGhys" alt="那时候用来训练模型的切出来的单个数字或者字母验证码" />





- 检测 Referer：
常见的互联网页面与页面之间是存在联系的，比如你在 [我的博客](http://johannlai.com)应该找不到通往 http://www.qq.com 的链接的，比如你在某论坛留言，那么不管你留言之后重定向到哪里，之前的网址一定保留在新页面中 Referer 属性中。

通过检查 Referer 的值，我们就可以判断这个请求是合法的还是非法的，但是**问题出在服务器不是任何时候都接受到 Referer 的值**，所以 Referer Check 一般用于监控 CSRF 攻击的发生，而`不用来抵御攻击`。

- Token：目前主流的做法是使用 Token 防御 CSRF 攻击
CSRF 攻击要成功的条件在于攻击者能够准确地预测所有的参数从而构造出合法的请求，所以根据不可预测性原则，我们可以对参数进行加密从而防止 CSRF 攻击，可以保存其原有参数不变，另外添加一个参数 Token，其值是随机的，这样攻击者因为不知道 Token 而无法构造出合法的请求进行攻击，所以我们在构造请求时候只需要保证：

- Token 要足够随机，使攻击者无法准确预测
- Token 是一次性的，即每次请求成功后要更新 Token，增加预测难度
- Token 要主要保密性，敏感操作使用 POST，防止 Token 出现在 URL 中

#### 推荐一个觉得不错 https://jwt.io/

> JWT.IO allows you to decode, verify and generate JWT.


**最后值得注意的是，过滤用户输入的内容不能阻挡 CSRF 攻击，我们需要做的事过滤请求的来源，因为有些请求是合法，有些是非法的，所以 CSRF 防御主要是过滤那些非法伪造的请求来源。**



## [XSS 攻击](https://en.wikipedia.org/wiki/Cross-site_scripting)

[XSS](https://en.wikipedia.org/wiki/Cross-site_scripting) 全称为 Cross-site script，（=.= 为什么不是CSS，哦？懂了，因为HTML）跨站脚本攻击，为了和 CSS 层叠样式表区分所以取名为 XSS，是 Web 程序中常见的漏洞。

`原理`：攻击者向有 XSS 漏洞的网站中输入恶意的 HTML 代码，当其它用户浏览该网站时候，该段 HTML 代码会自动执行，从而达到攻击的目的，如盗取用户的 Cookie，破坏页面结构，重定向到其它网站等。

例如我在评论里面写下面这句话！
```
<script>
var i=0;
while(i<5) {
    alert('我是XSS！！！ T。T');
}
</script>
```




这时候如果服务器没有过滤或转义掉这些脚本，作为内容发布到页面上，其他用户访问这个页面的时候就会运行这段脚本。那就遭受XSS了。

## 如何防御 XSS 攻击

> 网站上所有可输入的地方没有对输入内容进行处理的话，都会存在 XSS 漏洞，漏洞的危险取决于攻击代码的威力，攻击代码也不局限于 script，防御 XSS 攻击最简单直接的方法就是过滤用户的输入。

如果不需要用户输入 HTML，可以直接对用户的输入进行 HTML 转义：
```
<!--bad-->
<script>
window.location.href="http://www.johannlai.com";
</script>
```
经过转义后就成了：
```
#Good
&lt;script&gt;window.location.href=&quot;http://www.johannlai.com&quot;&lt;/script&gt;
```

#### 注意

当我们需要用户输入 HTML 的时候，需要对用户输入的内容做更加小心细致的处理。

仅仅粗暴地去掉 script 标签是没有用的，任何一个合法 HTML 标签都可以添加 `onclick` 一类的事件属性来执行 JavaScript。


## SQL 相关网络攻击

####SQL 注入：
利用现有应用程序，将(恶意) 的 `SQL` 命令注入到后台数据库引擎执行的能力，它可以通过在` Web 表单中输入 (恶意) SQL 语句`得到一个存在安全漏洞的网站上的数据库，而不是按照设计者意图去执行 SQL 语句。

#### SQL注入防御
- 永远不要信任用户的输入: 对用户的输入进行校验，可以通过正则表达式，或限制长度；对单引号和双"-"进行转换等。
- 永远不要使用动态拼装 SQL（**野生ＰＨＰer特别注意！**），可以使用参数化的 SQL 或者直接使用存储过程进行数据查询存取。
- 永远不要使用管理员权限的数据库连接，为每个应用使用单独的权限有限的数据库连接。
- 不要把机密信息直接存放，加密或者 hash 掉密码和敏感的信息。
	

## DDOS 攻击
[分布式拒绝服务](https://en.wikipedia.org/wiki/Denial-of-service_attack#Distributed_attack)(DDoS:Distributed Denial of Service)攻击指借助于客户/服务器技术，将多个计算机联合起来作为攻击平台，对一个或多个目标发动DDoS攻击，从而成倍地提高拒绝服务攻击的威力。

> 在一个项目中，我也曾经处理过DDos的情况，只是这不是黑客的攻击，是朋友公司的活动抽奖网站出现了漏洞，引起了羊毛党的注意，然后，不停地传播链接，瞬间造成了服务的一个`分布式DDos攻击`，查看log的UA发现大部分都是移动端的设备。马上采取应急预案，启动服务器正忙页面，修复漏洞，加大CPU和带宽，重新上线。要防止这个事情发生，需要做的就是加强review，加强代码上线前的测试，灰度测试。

#### 真正的DDos
> DDOS 攻击利用目标系统网络服务功能缺陷或者直接消耗其系统资源，使得该目标系统无法提供正常的服务。

> 相关新闻 [史上最严重DDoS攻击：今早大半个美国“断网”](http://tech.ifeng.com/a/20161023/44475515_0.shtml)




