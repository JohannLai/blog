title: localhost----从坑谈起
categories:
  - 技术
  - 分享
  - 笔记
tags:
  - locahost
  - Django
  - laravel
date: NaN-NaN-NaN NaN:NaN:NaN
---
-从坑谈起
date: 2017-02-26 1：10：01
categories:
- 技术
- 分享
- 笔记
tags:
- locahost
- Django
- laravel
---



> 在我测试Django启动服务器localhost的服务的时候，神奇的事情发生了！！！

```
	$ python3 ./manage.py runserver
	...
	Starting development server at http://127.0.0.1:8000/
	...
```
我记得我也有项目是8000
```
 johann@johann-Inspiron $ php artisan serve
 Laravel development server started on http://localhost:8000/
```



<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>


## 什么情况！
> 在我测试Django启动服务器localhost的服务的时候，神奇的事情发生了！！！

```
	$ python3 ./manage.py runserver
	...
	Starting development server at http://127.0.0.1:8000/
	...
```
我记得我也有项目是8000
```
 johann@johann-Inspiron php artisan serve
 Laravel development server started on http://localhost:8000/
```

那么问题就来了！！！
我在`Nginx`上面部署项目的时候，如果是同一个ServerName 上面同一个端口号的话，明明就是会冲突，顿时三观全毁灭


我在认真看了一下URL！
当我打开浏览器输入`127.0.0.1:8000`的时候，启动的是Django的项目！

那到底`Laravel`的项目到哪里去了！
我没猜错，打开：`localhost:8000`的时候，是Laravel的信息！



好奇心爆炸！
`localhost != 127.0.0.1 ！！？？？`
<img src="http://img.hb.aicdn.com/a0dfafe3aedfc9a66c31bea114f40cebc60572a31f63-swnUx5_fw658" />
##  分析问题
#### netstat
这个时候，我想起了**计算机网络**中一个常用的命令`netstat`

```
$ netstat -apn | grep 8000
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 127.0.0.1:8000          0.0.0.0:*               LISTEN      5374/python3
tcp6       0      0 ::1:8000                :::*                    LISTEN      5518/php7.0
```

认真看了一下，的确listen的是8000端口，可是，这时候精彩的事情就发生了，地址没发生冲突，
> 原因是django项目默认是用**ipv4**的127.0.0.1地址，laravel项目默认用的是**ipv6**地址::1，地址不一样，那么端口相同也可以！

这个时候，我又想到一种很科学的研究方法！——**控制变量法**

我想关了两个项目，然后单独打开**Laravel**

发现必须使用下面的地址访问！
- http://localhost:8000/
- http://[::1]:8000/    /*ipv6*/


**不可以通过127.0.0.1**访问！


我马上打开 `WIKI` ，浏览了一下[localhost](https://en.wikipedia.org/wiki/Localhost)的解释，reason如下：
操作系统的`hosts`文件中的`localhost`解析一些ip：
```
127.0.0.1    localhost
::1          localhost
```

看到这里，突然发现`Laravel`这一点做得真的是实在太机智了，它考虑到我们有可能存在其他的框架会占用8000端口，然后采用了默认利用ipv6地址，从而避免启动端口冲突问题。


再查询了一下laravel的文档，在`Laravel`中，可以这样设置	端口映射。
```
 johann@johann-Inspiron $ php artisan serve --host=127.0.0.1
```