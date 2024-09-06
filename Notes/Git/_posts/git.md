# Git 教程

[参考资料：廖雪峰官方网站-Git教程](https://www.liaoxuefeng.com/wiki/896043488029600/896067074338496)

## 安装Git

### Linux

首先，你可以试着输入`git`，看看系统有没有安装Git：

```shell
$ git
The program 'git' is currently not installed. You can install it by typing:
sudo apt-get install git
```

如果你碰巧用Debian或Ubuntu Linux，通过一条`sudo apt-get install git`就可以直接完成Git的安装，非常简单。

老一点的Debian或Ubuntu Linux，要把命令改为`sudo apt-get install git-core`，因为以前有个软件也叫GIT（GNU Interactive Tools），结果Git就只能叫`git-core`了。由于Git名气实在太大，后来就把GNU Interactive Tools改成`gnuit`，`git-core`正式改为`git`。

如果是其他Linux版本，可以直接通过源码安装。先从Git官网下载源码，然后解压，依次输入：`./config`，`make`，`sudo make install`这几个命令安装就好了。

### 在Mac OS X上安装Git

如果你正在使用Mac做开发，有两种安装Git的方法。

一是安装homebrew，然后通过homebrew安装Git，具体方法请参考homebrew的文档：http://brew.sh/。

第二种方法更简单，也是推荐的方法，就是直接从AppStore安装Xcode，Xcode集成了Git，不过默认没有安装，你需要运行Xcode，选择菜单“Xcode”->“Preferences”，在弹出窗口中找到“Downloads”，选择“Command Line Tools”，点“Install”就可以完成安装了。

### 在Windows上安装Git

在Windows上使用Git，可以从Git官网直接[下载安装程序](https://git-scm.com/downloads)，然后按默认选项安装即可。

安装完成后，在开始菜单里找到“Git”->“Git Bash”，蹦出一个类似命令行窗口的东西，就说明Git安装成功！

安装完成后，还需要最后一步设置，在命令行输入：

```shell
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

因为Git是分布式版本控制系统，所以，每个机器都必须自报家门：你的名字和Email地址。你也许会担心，如果有人故意冒充别人怎么办？这个不必担心，首先我们相信大家都是善良无知的群众，其次，真的有冒充的也是有办法可查的。

注意`git config`命令的`--global`参数，用了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置，当然也可以对某个仓库指定不同的用户名和Email地址。

### 创建版本库

首先，选择一个合适的地方，创建一个空目录：

```shell
$ mkdir learngit
$ cd learngit
$ pwd
/Users/michael/learngit
```

`pwd`命令用于显示当前目录。

第二步，通过`git init`命令把这个目录变成Git可以管理的仓库：

```shell
$ git init
Initialized empty Git repository in /Users/michael/learngit/.git/
```

如果没有看到`.git`目录，是因为这个目录默认是隐藏的，可以用`ls -ah`命令查看

**注意：所有版本控制系统只能跟踪文本文件的改动，如TXT文件，而图片、视频、word文档等二进制文件无法跟进改动**

**并且建议使用UTF-8标准格式**

第三步，编写`readme.txt`文件，内容如下：

```
Git is a version control system.
Git is free software.
```

用命令`git add`告诉Git，把文件添加到仓库：

```shell
$ git add readme.txt
```

执行上面的命令，没有任何显示，这就对了，Unix的哲学是“没有消息就是好消息”，说明添加成功。

第二步，用命令`git commit`告诉Git，把文件提交到仓库：

```shell
$ git commit -m "wrote a readme file"
[master (root-commit) eaadf4e] wrote a readme file
 1 file changed, 2 insertions(+)
 create mode 100644 readme.txt
```

简单解释一下`git commit`命令，`-m`后面输入的是本次提交的说明，可以输入任意内容，当然最好是有意义的，这样你就能从历史记录里方便地找到改动记录。

嫌麻烦不想输入`-m "xxx"`行不行？确实有办法可以这么干，但是强烈不建议你这么干，因为输入说明对自己对别人阅读都很重要。实在不想输入说明的童鞋请自行Google，我不告诉你这个参数。

`git commit`命令执行成功后会告诉你，`1 file changed`：1个文件被改动（我们新添加的readme.txt文件）；`2 insertions`：插入了两行内容（readme.txt有两行内容）。

为什么Git添加文件需要`add`，`commit`一共两步呢？因为`commit`可以一次提交很多文件，所以你可以多次`add`不同的文件，比如：

```
$ git add file1.txt
$ git add file2.txt file3.txt
$ git commit -m "add 3 files."
```

### 疑难解答

Q：输入`git add readme.txt`，得到错误：`fatal: not a git repository (or any of the parent directories)`。

A：Git命令必须在Git仓库目录内执行（`git init`除外），在仓库目录外执行是没有意义的。

Q：输入`git add readme.txt`，得到错误`fatal: pathspec 'readme.txt' did not match any files`。

A：添加某个文件时，该文件必须在当前目录下存在，用`ls`或者`dir`命令查看当前目录的文件，看看文件是否存在，或者是否写错了文件名。

## 远程仓库

到目前为止，我们已经掌握了如何在Git仓库里对一个文件进行时光穿梭，你再也不用担心文件备份或者丢失的问题了。

可是有用过集中式版本控制系统SVN的童鞋会站出来说，这些功能在SVN里早就有了，没看出Git有什么特别的地方。

没错，如果只是在一个仓库里管理文件历史，Git和SVN真没啥区别。为了保证你现在所学的Git物超所值，将来绝对不会后悔，同时为了打击已经不幸学了SVN的童鞋，本章开始介绍Git的杀手级功能之一（注意是之一，也就是后面还有之二，之三……）：远程仓库。

Git是分布式版本控制系统，同一个Git仓库，可以分布到不同的机器上。怎么分布呢？最早，肯定只有一台机器有一个原始版本库，此后，别的机器可以“克隆”这个原始版本库，而且每台机器的版本库其实都是一样的，并没有主次之分。

你肯定会想，至少需要两台机器才能玩远程库不是？但是我只有一台电脑，怎么玩？

其实一台电脑上也是可以克隆多个版本库的，只要不在同一个目录下。不过，现实生活中是不会有人这么傻的在一台电脑上搞几个远程库玩，因为一台电脑上搞几个远程库完全没有意义，而且硬盘挂了会导致所有库都挂掉，所以我也不告诉你在一台电脑上怎么克隆多个仓库。

实际情况往往是这样，找一台电脑充当服务器的角色，每天24小时开机，其他每个人都从这个“服务器”仓库克隆一份到自己的电脑上，并且各自把各自的提交推送到服务器仓库里，也从服务器仓库中拉取别人的提交。

完全可以自己搭建一台运行Git的服务器，不过现阶段，为了学Git先搭个服务器绝对是小题大作。好在这个世界上有个叫[GitHub](https://github.com/)的神奇的网站，从名字就可以看出，这个网站就是提供Git仓库托管服务的，所以，只要注册一个GitHub账号，就可以免费获得Git远程仓库。

在继续阅读后续内容前，请自行注册GitHub账号。由于你的本地Git仓库和GitHub仓库之间的传输是通过SSH加密的，所以，需要一点设置：

第1步：创建SSH Key。在用户主目录下，看看有没有.ssh目录，如果有，再看看这个目录下有没有`id_rsa`和`id_rsa.pub`这两个文件，如果已经有了，可直接跳到下一步。如果没有，打开Shell（Windows下打开Git Bash），创建SSH Key：

```
$ ssh-keygen -t rsa -C "youremail@example.com"
```





你需要把邮件地址换成你自己的邮件地址，然后一路回车，使用默认值即可，由于这个Key也不是用于军事目的，所以也无需设置密码。

如果一切顺利的话，可以在用户主目录里找到`.ssh`目录，里面有`id_rsa`和`id_rsa.pub`两个文件，这两个就是SSH Key的秘钥对，`id_rsa`是私钥，不能泄露出去，`id_rsa.pub`是公钥，可以放心地告诉任何人。

第2步：登陆GitHub，打开“Account settings”，“SSH Keys”页面：

然后，点“Add SSH Key”，填上任意Title，在Key文本框里粘贴`id_rsa.pub`文件的内容：

![github-addkey-1](../images/git.assets/0.png)

点“Add Key”，你就应该看到已经添加的Key：

![github-addkey-2](../images/git.assets/0-1681899825350-1.png)

为什么GitHub需要SSH Key呢？因为GitHub需要识别出你推送的提交确实是你推送的，而不是别人冒充的，而Git支持SSH协议，所以，GitHub只要知道了你的公钥，就可以确认只有你自己才能推送。

当然，GitHub允许你添加多个Key。假定你有若干电脑，你一会儿在公司提交，一会儿在家里提交，只要把每台电脑的Key都添加到GitHub，就可以在每台电脑上往GitHub推送了。

## Git常用命令

查看状态

```shell
$ git status
```

查看修改内容

```shell
$ git diff <filename>
# 查看目标版本和工作区中某文件的区别
$ git diff Head -- <filename>
```

将文件添加到暂存区

```shell
$ git add <filename>
```

将暂存区的内容提交到当前分支

```shell
$ git commit -m "本次提交说明"
```

查看文件修改的历史纪录

```shell
$ git log
# 可以用--pretty=oneline参数将输出内容简化
$ git log --pretty=oneline
```

回退仓库版本，注意`HEAD`表示当前版本，`HEAD^`表示上一个版本，`HEAD^^`: 上上一个版本，`HEAD~100` : 往上100个版本

```shell
# 回退到上一个版本
$ git reset --hard HEAD^
```

回退版本之后，如果还想回到新版本，可以在命令行窗口中找到目标版本的`commit id`

```shell
# 输入版本号的前几位即可，没必要写全
$ git reset --hard 1094a
```

如果想回到新版本时，找不到新版本号了，可以用以下命令找到你输入的每一次命令

```shell
$ git reflog
```

丢弃工作区更改

```shell
$ git checkout -- <filename>
# 注意，没有--会变成切换分支的命令
# 另外，当工作区文件被误删时，也可以通过此命令取消工作区更改
```

撤销暂存区的修改

```shell
$ git reset HEAD <filename>
```

删除工作区文件

```shell
$ git rm <filename>
```

将远程库克隆到本地

```shell
$ git clone <address>
```

将本地仓库和远程仓库关联，远程库的名字叫origin

```shell
$ git remote add origin <remote repo address>
```

将本地库推送到远程库

```shell
# 第一次推送加上-u，将本地的master分支和远程的master分支关联
$ git push -u origin master
```

查看远程库信息

```shell
$ git remote -v
```

删除远程库，此处的删除指接触本地和远程的绑定关系

```shell
$ git remote rm origin
```

将远程主机（默认origin）的分支与本地的分支合并

```shell
git pull <远程主机名> <远程分支名>:<本地分支名>
```

创建分支

```shell
$ git branch <branch name>
```

切换分支

```shell
# 创建并切换到新的分支
$ git switch -c <branch name>
# 直接切换到目标分支
$ git switch master
$ git checkout <branch name>
```

可以将上述两条命令合并成一条，即创建+切换

```shell
$ git checkout -b dev
```

查看当前分支

```shell
$ git branch
```

合并目标分支到当前分支

```shell
$ git merge <branch name>
```

删除分支

```shell
$ git branch -d <branch name>
```

