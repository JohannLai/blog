title: Nginx debug  错误[emerg] “server” directive is not allowed here
date: 2017-01-09 22:31:22
categories:
- 技术
- debug
tags:
- nginx
---


  最近nginx部署ssl证书的时候，突然出现了

    nginx: [emerg] "server" directive is not allowed here

   这样的错误，后来发现：
> #### 正确的检测修改的Nginx的语法是否错误的命令应该是：
> sudo nginx -t -c /etc/nginx/nginx.conf

<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>


---

# Nginx Debug错误[emerg] “server” directive is not allowed here

---


- **服务器环境** ：ubuntu 14.04, nginx/1.4.6；
- **执行命令** ：sudo nginx -t -c /etc/nginx/conf.d/default.conf；
- **命令目的** ：重启nginx出错，查看新修改的nginx是否有错误，避免上线导致服务器出错。


一开始以为是语法错误，仔细检查过，并且使用官方配置文件还是出错



最后自己根据网上的资料猜测，是我进行语法检测的对象有问题。

要检测现有的修改过的Nginx配置是否有错误，不是单单检测那个修改过的扩展的 **.conf** 文件。而是不管任何时候，始终都是去检测主文件 **/etc/nginx/nginx.conf** ，只有这样，才能顺利的在对应的模块加载扩展的 .conf 文件。

这样一来保证了配置的前后语境的正确性，二来，这样才是真正的检测（完全和实际运行情况相符）


所以正确的检测修改的Nginx的语法是否错误的命令应该是： 

    sudo nginx -t -c /etc/nginx/nginx.conf



