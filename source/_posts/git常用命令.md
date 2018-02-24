title: git常用命令
date: 2016-04-18 09:05:22
categories:
- 技术
- 资源
tags:
- git
---


##Git 是什么？

> #### Git的官方定义：
> Git 是一个免费开源的分布式版本控制系统，被用于高速有效地处理大大小小项目中所有文件。

<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>


---

#Git 常用的命令行

---
`说明`：<必选>  [可选]




## **创建仓库 `Create`**
- 从已有的`文件`

    cd ~/project/myproject
    git init 
    git add
 

- 从已有的`仓库`

      git clone ~/existing/repo ~/new/repo 
      git clone you@host.org:dir/project.git
 
- 为已有的本地数据文件创建远程仓库

    mkdir repo.git & cd repo.git 

    git init --bare[--shared=group]      
     




## **浏览 `Browse`**
- 工作目录中所有发生变化的文件
 
 git status
- 已经纳入版本管理的文件所发生的变化
 
 git diff
- 在`ID1`和`ID2`之间发生的变化
 
 git log
   
- 变更的历史
 
 git log
-  查看带文件修改记录的变更历史 
 
 git watchanged
-  谁在什么时间修改了文件中的什么内容 
 
 git blame <FILE> 
-  查看特定变更的`ID`的更新细节 

 git show <ID> 
-  查看特定变更`ID`中的特定文件的变更细节 

 git diff <ID>:<FILE> 
-  All 所有的本地分支 

 git branch  //带有“×” 标记的是当前分支 
-  按模式搜索 
  
 git grep <PATTERN> [PATH]


## **分支 `Branch`**
-  切换到分支 BRANCH 

 git checkout <BRANCH> 
-  把分支`B1`合并到分支`B2` 

 git checkout <B2> 
  git merge <B1> 
-  在当前的`HEAD`分支上创建一个分支 

 git branch <BRANCH>
-  在其他的分支`BASE`上创建一个新分支 `NEW` 

 git checkout <NEW> <BASE>
-  删除 

    git branch -d <BRANCH>

## **更新`Update`**
-  从远端 `origin` 中获取最新的变更记录 

    git fetch //不会进行合并操作 
-  从远端 `origin` 中获取最新的变更 

    git pull //获取变更之后会进行合并操作 

-  应用别处获得的补丁 

 git am -3 patch.mbox 
 //如果发生冲突，解决之后运行下面的命令
 git am --resolve 
## **发布`Publish`**
-  提交所有本地修改 

 git commit -a 
-  给他人准备一个补丁 

 git format-patch origin
-  把变更发布到远端`origin` 

 git push [REMOTE] [BRANCH] 
-  标记一个版本或者里程碑 

 git tag <VERSION_NAME> 
## **恢复`Revert`**
-  恢复到最后提交状态 

 git checkout -f | git reset --hard
    
   //注意：无法撤消硬重置 （hard reset）
-  撤消最后的提交 

 git revert HEAD
     //会生成新的提交记录
-  撤消特定的提交 

 git revert <ID>
     //会生成新的提交记录
-  修改特定的提交 

 git commit -a --amend
     //在编辑了一个损坏的文件之后
-  签出文件的一个特定的版本`ID` 

 git checkout <ID> <FILE>
>To be  continue...
