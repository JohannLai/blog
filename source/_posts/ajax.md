title: MySQL远程连接ERROR 2003 (HY000):Can't connect to MySQL server on'XXXXX'(111) 的问题

date: 2017-02-20 16：12：03
categories:
- 分享
- 笔记
tags:
- MySQL
- debug
---


## Ajax
> 引言：解决方法：修改云主机上的/etc/mysql/my.cnf 文件，注释掉 bind_address=127.0.0.1。这句ok。



<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>




## 引言：
最近在设置MySQL的远程数据库连接，试过很多教程都是提示
```SQL
ERROR 2003 (HY000):Can't connect to MySQL server on'XXXXX'(111) 
```

#### 解决方法
解决方法：修改云主机上的/etc/mysql/my.cnf 文件，注释掉 bind_address=127.0.0.1。这句ok。


#### 安全MySQL

*(保障MySQL安全的14个最佳方法)[http://netsecurity.51cto.com/art/201311/418159.htm]





