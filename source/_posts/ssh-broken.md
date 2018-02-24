title: ssh连接linux服务器不断开方法
date: 2017-01-11 15：40：06
categories:
- 技术
- 分享
- 翻译
tags:
- 服务器
- tmux
- screen
---


最近ssh登录服务器配置一些东西的时候经常会出现**"Write failed: Broken pipe"**或者直接卡死的情况。服务端的系统是ubuntu.，查询了一下相关的资料，原来可以去配置服务端的sshd,或者客户端的ssh。就ok了。
另外推荐两个不错的软件：**[screen](http://www.howtogeek.com/howto/ubuntu/keep-your-ssh-session-running-when-you-disconnect/)** （服务端），**[tmux](https://github.com/tmux/tmux)** （客户端）



<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>




## ssh连接linux服务器不断开 "Write failed: Broken pipe"的解决方法

最近ssh登录服务器配置一些东西的时候经常会出现**"Write failed: Broken pipe"**或者直接卡死的情况。服务端的系统是ubuntu.，查询了一下相关的资料，原来可以去配置服务端的sshd,或者客户端的ssh。就ok了。

## 配置服务器端sshd
``` powershell
	#找到
	/etc/ssh/sshd_config
	#添加
	ClientAliveInterval  30
```

这样设置可以使到server端每30s就会向client端发送一个**keep-alive**包, 来**保持连接**
另外，可以加上下面这一行,指定发送keep-alive包的最大次数
``` powershell
	#,指定发送keep-alive包的最大次数 为60
	ClientAliveCountMax  60
```
如果发送keep-alive包**次数达到60,** 而客户端还没有反应,则server端的**sshd断开连接**
这个配置可以让连接保持30*60s == **30分钟**，也就是如果什么都不操作，30分钟后断开连接。







## 配置客户端ssh
如果**没有服务器权限**,可以配置客户端ssh,这样对这个客户端发起的所有会话都会产生效果

``` powershell
	#找到
	/etc/ssh/ssh_config
	#添加
	ServerAliveInterval 
    ServerAliveCountMax 
```
此时就是客户端定时向服务器端发送**keep-alive**包。







## 配置会话
当然登录服务次的频率不会很高，只是偶尔登录，可以指定某个特定的会话
``` powershell
	#ssh带上 -o 参数就可以以配置文件的参数指定这一次会话
	ssh -o ServerAliveInterval=30  root@192.168.12.192
```





# 推荐两款软件


## **[screen](http://www.howtogeek.com/howto/ubuntu/keep-your-ssh-session-running-when-you-disconnect/)** （服务端）
> **[screen](http://www.howtogeek.com/howto/ubuntu/keep-your-ssh-session-running-when-you-disconnect/)**就像控制台的窗口管理器。它允许您运行多个终端会话，并在它们之间轻松切换.。它也保护您不断开，因为**[screen](http://www.howtogeek.com/howto/ubuntu/keep-your-ssh-session-running-when-you-disconnect/)** 的session 当你断开时也不会断开连接。

使用前你需要在你的服务器上面安装**screen**，输入下面的命令就可以：

``` 
	sudo apt-get install screen
```

好的，现在你只要在你的server的命令行上面输入`screen`你就可以获得关于操作'screen'的一下资讯，继续按`Enter`，你就可以进入normal模式.
To disconnect (but leave the session running)
当你需要断开连接，但是保持`session`的时候，你可以

``` 
	按着 Ctrl + A 接着按 Ctrl + D 你就会看到提示 [detached]
```

To reconnect to an already running session
继续连接已经断开但是还在运行的`session`

``` 
	screen -r
```


重新连接到现有会话，或者如果没有，就创建新会话
``` 
	screen -D -r
```



在运行的`	screen session	`中创建一个新窗口

``` 
	按着 Ctrl + A 然后接着按 C  就可以进入新的窗口。
```


从一个`	screen	`窗口切换到另一个
``` 	
    敲击 Ctrl + A 然后输入 Ctrl + A 。
```


列出所有的窗口
``` 	
   敲击 Ctrl + A 接着按 W。
```

有很多其他的命令，但这些是我最常用的。







## **[tmux](https://github.com/tmux/tmux)** （客户端）
除了使用**[screen](http://www.howtogeek.com/howto/ubuntu/keep-your-ssh-session-running-when-you-disconnect/)** 以外，你还可以使用**[screen](http://www.howtogeek.com/howto/ubuntu/keep-your-ssh-session-running-when-you-disconnect/)**的一个竞争者**[tmux](https://github.com/tmux/tmux)**

``` powershell
	tmux new-session -s {name}
```

该命令创建一个session。以后当你想要连接服务器的时候，你只要：

``` powershell
	tmux a -t {name}
```







## 关于SSH

> SSH是Secure Shell的缩写, 是一个应用层的加密网络协议, 它不只可以用于远程登录, 远程命令执行,还可用于数据传输.

> 当然它由ssh Client和ssh Server端组成, 有很多实现, Ubuntu上就默认安装的OpenSSH, Client端叫做ssh, Server端叫做sshd， OpenSSH只用来做远程登录和命令执行。


> 参考资料
>  * [Keep Your SSH Session Running when You Disconnect](http://www.howtogeek.com/howto/ubuntu/keep-your-ssh-session-running-when-you-disconnect/)
>  * [stackoverflow Write failed : broken pipe](http://stackoverflow.com/questions/13228425/write-failed-broken-pipe)






