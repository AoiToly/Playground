# SVN

[svn使用教程 · SVN使用教程 (svnbucket.com)](https://svnbucket.com/posts/svn-tutorial/)

## 使用教程

### Checkout检出代码

1. 在SVNBucket的项目详情-源码页面-复制SVN地址
2. 在你需要保存代码的地方右键选择`SVN Chekout...`
3. 填写SVN地址，填写保存目录，输入SVNBucket网站登录用户名密码。
4. 点击确定就能同步代码到本地了。

### Update更新代码

右键 SVN Update 更新代码，这样就能把其他人提交的代码同步到自己电脑上了

### Commit提交代码

提交代码也很简单，右键`SVN Commit...`，填入提交描述，就可以把本地提交的代码提交到服务器了。
在提交代码前我们应该`update`下代码，这是个好习惯，可以避免覆盖别人的代码和代码冲突。

### 忽略文件

有时候某些目录或者文件我们不想提交到 SVN 服务器，这时我们可以忽略这些文件。
下面演示忽略 temp 目录和 *.map 文件

![img](https://sjwx.easydoc.xyz/46901064/files/jxpm140s.gif)

撤销忽略，文件的操作方式步骤是一样的，目录的有点不一样，请看下面演示

![img](https://sjwx.easydoc.xyz/46901064/files/jxpm1a0t.gif)

### 撤销本地修改

当我们本地修改了一些文件，但想退回SVN的最新版本时：

右键选中需要撤销的文件，TortoiseSVN->Revert 就可以丢弃本地修改了。

### 撤销已经提交的代码

1. 右键TortoiseSVN ==> show log 查看提交记录
2. 选择我们需要回去的版本，右键选择`Revert to this version`，这样就回去了指定的版本
3. 最后你还需要`commit`下撤销后的代码到SVN仓库

### SVN仓库目录和开发建议

建议每个仓库的根目录都创建trunk、branches、tags目录，这是经典的 SVN 目录结构，方便开发和维护
![svn教程经典目录](https://sjwx.easydoc.xyz/46901064/files/jxpm6d1n.jfif)

个人比较喜欢的开发模式是，开发时都在`trunk`写代码，上线产品后就创建分支到`branches`目录，线上版本出问题了，我们应该在对应的分支上进行修复，并且把修复后的代码合并到主干上。

### 创建分支

1. 右键 trunk 目录 => 右键TortoiseSVN => Branch/tag
2. 填写分支路径`/branches/online1.0`，填写注释，选择最用最新的版本开分支

### 合并代码

假设我们在分支上修复了一个线上的BUG，需要把代码那个代码合并到主干来，操作步骤：

1. 在分支的根目录点击`show log`
2. 选中需要合并过去主干的提交记录（可以多选）
3. 点击`merge revision to ...`
4. 选择主干的根目录，点击确定，就合并过去了。
5. 在主干上提交这次合并的内容

另外如果你有大量的代码需要合并或者不知道哪些提交记录需要合并，可以使用`Beyond Compare`来进行对比合并，也是非常方便的，[视频教程使用BeyondCompare做复杂代码合并](https://www.bilibili.com/video/BV1k4411m7mP?p=8)。

### 切换分支

右键TortoiseSVN => Switch => 选择需要切换的分支，点击确定就可以了

### 修改仓库地址

如果您的仓库地址变了，是不是需要重新checkout一份代码呢？

快速更换：右键点击仓库根目录 => TortoiseSVN => relocate，修改仓库地址，点击确定后就修改好了

## 常用命令

[svn常用命令 · SVN使用教程 (svnbucket.com)](https://svnbucket.com/posts/svn-commands-tutorial/)