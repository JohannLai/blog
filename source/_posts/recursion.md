title: 遍历一个对象
date: 2017-03-09 12：10：12
categories:
- 技术
- 分享
- 笔记
tags:
- 算法
---



> 最近总是在看一些很有趣的文章



<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>


## ？？？
> 最近在读Vue的早期源码，发现挺多有趣的事情的，对象往往是一个深层次的结构，对象的某个属性可能仍然是一个对象，这种情况怎么处理？
比如说

```
let data = {
    user: {
        name: "lizhihang",
        age: "22"
    },
    address: {
        city: "Guangzhou"
    }
};
答案：`递归算法`，也就是下面代码中的walk函数。如果对象的属性仍然是一个对象的话，那么继续new一个Observer，直到到达最底层的属性位置。

```

## 递归算法
```
// 观察者构造函数
function Observer(data) {
    this.data = data;
    this.walk(data)
}

let p = Observer.prototype;

// 此函数用于深层次遍历对象的各个属性
// 采用的是递归的思路
// 因为我们要为对象的每一个属性绑定getter和setter
p.walk = function (obj) {
    let val;
    for (let key in obj) {
        // 这里为什么要用hasOwnProperty进行过滤呢？
        // 因为for...in 循环会把对象原型链上的所有可枚举属性都循环出来
        // 而我们想要的仅仅是这个对象本身拥有的属性，所以要这么做。
        if (obj.hasOwnProperty(key)) {
            val = obj[key];

            // 这里进行判断，如果还没有遍历到最底层，继续new Observer
            if (typeof val === 'object') {
                new Observer(val);
            }

            //do something
        }
    }
};
```


