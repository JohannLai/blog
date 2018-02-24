title: MySQL优化笔记----慢查询日志
date: 2017-02-28 10：11：12
categories:
- 技术
- 分享
- 笔记
- MySQL
tags:
- MySQL
---



> 之前做过一个项目，会员量才两位就出现了后台查询数据缓慢的情况！我使用慢查询优化进行解决。
> 引言：MySQL的慢查询日志是MySQL提供的一种日志记录，它用来记录在MySQL中响应时间超过阀值的语句，具体指运行时间超过long_query_time值的SQL，则会被记录到慢查询日志中。long_query_time的默认值为10，意思是运行10S以上的语句。默认情况下，Mysql数据库并不启动慢查询日志，需要我们手动来设置这个参数，当然，如果不是调优需要的话，一般不建议启动该参数，因为开启慢查询日志会或多或少带来一定的性能影响。慢查询日志支持将日志记录写入文件，也支持将日志记录写入数据库表。


<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>




## 引言：
引言：MySQL的慢查询日志是MySQL提供的一种日志记录，它用来记录在MySQL中响应时间超过阀值的语句，具体指运行时间超过long_query_time值的SQL，则会被记录到慢查询日志中。long_query_time的默认值为10，意思是运行10S以上的语句。默认情况下，Mysql数据库并不启动慢查询日志，需要我们手动来设置这个参数，当然，如果不是调优需要的话，一般不建议启动该参数，因为开启慢查询日志会或多或少带来一定的性能影响。慢查询日志支持将日志记录写入文件，也支持将日志记录写入数据库表。


#### 官方文档
> The slow query log consists of SQL statements that took more than long_query_time seconds to execute and required at least min_examined_row_limit rows to be examined. The minimum and default values of long_query_time are 0 and 10, respectively. The value can be specified to a resolution of microseconds. For logging to a file, times are written including the microseconds part. For logging to tables, only integer times are written; the microseconds part is ignored.

By default, administrative statements are not logged, nor are queries that do not use indexes for lookups. This behavior can be changed usinglog_slow_admin_statements and log_queries_not_using_indexes, as described later.



## 慢查询日志相关参数
MySQL 慢查询的相关参数解释：

`slow_query_log`    ：是否开启慢查询日志，1表示开启，0表示关闭。

`log-slow-queries` ：旧版（5.6以下版本）MySQL数据库慢查询日志存储路径。可以不设置该参数，系统则会默认给一个缺省的文件host_name-slow.log

`slow-query-log-file`：新版（5.6及以上版本）MySQL数据库慢查询日志存储路径。可以不设置该参数，系统则会默认给一个缺省的文件host_name-slow.log

`long_query_time` ：慢查询阈值，当查询时间多于设定的阈值时，记录日志。

`log_queries_not_using_indexes`：未使用索引的查询也被记录到慢查询日志中（可选项）。
> Atention: log_output：日志存储方式。log_output='FILE'表示将日志存入文件，默认值是'FILE'。log_output='TABLE'表示将日志存入数据库，这样日志信息就会被写入到mysql.slow_log表中。

##慢查询日志配置
 正常情况下慢查询优化slow_query_log的值是OFF，表示慢查询日志是关闭的，可以通过set它的值来开启
```SQL
mysql> show variables  like '%slow_query_log%';
+---------------------+----------------------------------------------------+
| Variable_name       | Value                                              |
+---------------------+----------------------------------------------------+
| slow_query_log      | OFF                                                |
| slow_query_log_file | /home/johannlai/MysqlData/mysql/DB-Server-slow.log |
+---------------------+----------------------------------------------------+
2 rows in set (0.00 sec)
 
mysql> set global slow_query_log=1;
Query OK, 0 rows affected (0.09 sec)
 
mysql> show variables like '%slow_query_log%';
+---------------------+----------------------------------------------------+
| Variable_name       | Value                                              |
+---------------------+----------------------------------------------------+
| slow_query_log      | ON                                                 |
| slow_query_log_file | /home/johannlai/MysqlData/mysql/DB-Server-slow.log |
+---------------------+----------------------------------------------------+
2 rows in set (0.00 sec)
 
mysql> 
```
*值得注意的是：使用set global slow_query_log=1开启了慢查询日志只对当前数据库生效，`如果MySQL重启后则会失效`。如果要永久生效，就必须修改配置文件my.cnf（其它系统变量也是如此）*


那么现在我们理论上在mysql源码里是判断大于long_query_time，而非大于等于，的查询就会被记录下来。

下面这里踩了一个大坑！

```SQL
mysql> show variables like 'long_query_time%';
+-----------------+-----------+
| Variable_name   | Value     |
+-----------------+-----------+
| long_query_time | 10.000000 |
+-----------------+-----------+
1 row in set (0.00 sec)
 
mysql> set global long_query_time=4;
Query OK, 0 rows affected (0.00 sec)
 
mysql> show variables like 'long_query_time';
+-----------------+-----------+
| Variable_name   | Value     |
+-----------------+-----------+
| long_query_time | 10.000000 |
+-----------------+-----------+
1 row in set (0.00 sec)
```

我修改了变量long_query_time，但是查询变量long_query_time的值还是10，难道没有修改到呢？注意：使用命令 set global long_query_time=4修改后，需要重新连接或新开一个会话才能看到修改值。


下面我把`long_query_time`设置为2
`set global long_query_time=4;`

然后测试一下慢查询日志，就会发现下面的信息
```SQL
	mysql> select sleep(3);
+----------+
| sleep(3) |
+----------+
|        0 |
+----------+
1 row in set (3.00 sec)
 
[johann@johann-Inspiron ~]# more /tmp/mysql_slow.log
/usr/sbin/mysqld, Version: 5.6.20-enterprise-commercial-advanced-log (MySQL Enterprise Server - Advanced Edition (Commercial)). started with:
Tcp port: 0  Unix socket: (null)
Time                 Id Command    Argument
/usr/sbin/mysqld, Version: 5.6.20-enterprise-commercial-advanced-log (MySQL Enterprise Server - Advanced Edition (Commercial)). started with:
Tcp port: 0  Unix socket: (null)
Time                 Id Command    Argument
# Time: 160616 17:24:35
# User@Host: root[root] @ localhost []  Id:     5
# Query_time: 3.002615  Lock_time: 0.000000 Rows_sent: 1  Rows_examined: 0
SET timestamp=1466069075;
select sleep(3);
```

#### 另外，如果你想查询有多少条慢查询记录，可以使用系统变量。

```
mysql> show global status like '%Slow_queries%';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| Slow_queries  | 2104  |
+---------------+-------+
1 row in set (0.00 sec)
 
mysql> 
```

## 日志分析工具mysqldumpslow
```Shell
[johann@johann-Inspiron ~]# mysqldumpslow --help
Usage: mysqldumpslow [ OPTS... ] [ LOGS... ]
 
Parse and summarize the MySQL slow query log. Options are
 
  --verbose    verbose
  --debug      debug
  --help       write this text to standard output
 
  -v           verbose
  -d           debug
  -s ORDER     what to sort by (al, at, ar, c, l, r, t), 'at' is default
                al: average lock time
                ar: average rows sent
                at: average query time
                 c: count
                 l: lock time
                 r: rows sent
                 t: query time  
  -r           reverse the sort order (largest last instead of first)
  -t NUM       just show the top n queries
  -a           don't abstract all numbers to N and strings to 'S'
  -n NUM       abstract numbers with at least n digits within names
  -g PATTERN   grep: only consider stmts that include this string
  -h HOSTNAME  hostname of db server for *-slow.log filename (can be wildcard),
               default is '*', i.e. match all
  -i NAME      name of server instance (if using mysql.server startup script)
  -l           don't subtract lock time from total time
```

#### Example 
得到返回记录集**最多**的10个SQL。

`mysqldumpslow -s r -t 10 /database/mysql/mysql06_slow.log`

得到访问**次数**最多的**10个SQL**

`mysqldumpslow -s c -t 10 /database/mysql/mysql06_slow.log`

得到按照**时间排序**的前10条里面含有左连接的查询语句。

`mysqldumpslow -s t -t 10 -g “left join” /database/mysql/mysql06_slow.log`

另外建议在使用这些命令时结合 | 和more 使用 ，否则有可能出现刷屏的情况。

`mysqldumpslow -s r -t 20 /mysqldata/mysql/mysql06-slow.log | more`

> 参考资料
>  * [MySQL 文档 6.4.5 The Slow Query Log](https://dev.mysql.com/doc/refman/5.7/en/slow-query-log.html)







