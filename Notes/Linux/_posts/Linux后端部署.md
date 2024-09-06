# 后端部署

2023.12.8

记录了本周将开发环境（Windows11）中的后端工程部署到服务器中所遇到的问题和经验

## 基础设施

使用Docker存储后端工程的镜像，以减少部署工作量

由于开发环境是Windows，使用WSL2模拟Linux系统环境以生成Docker镜像

采用Docker hub存储镜像，方便服务器端文件共享

服务器为阿里云ECS服务器，1核2G



## Windows环境下Linux环境部署

关于如何安装WSL，可以查看[微软官方教程](https://learn.microsoft.com/zh-cn/windows/wsl/install)以及[知乎文章](https://zhuanlan.zhihu.com/p/146545159)

关于如何在WSL中安装Docker，可以查看[微软官方教程](https://learn.microsoft.com/zh-cn/windows/wsl/tutorials/wsl-containers)



## 服务器远程免密登录以及文件传输

### 关于服务器，可以通过ssh的方式免密登录

1. 在主机端和服务器端使用RSA算法生成公私钥文件，代码如下：

   ```sh
   # 生成公私钥文件，指定算法、邮箱
   ssh-keygen -t rsa -C "xxxxxx@xx.com"
   # 其他需要填的部分都可以忽略不填
   ```

2. 生成完成后，在系统提示的信息中可以找到公私钥所在的地址，其中id_rsa.pub即为公钥文件、id_rsa为私钥文件，将主机端的私钥复制下来，添加到服务器公私钥所在目录下的`authorized_keys`文件中
3. 在主机端使用``ssh 服务器密码@服务器公网ip`即可免密登录服务器端

注意：不要用WSL中的虚拟linux主机这么做，亲测失败

### 文件传输

在Windows系统向Linux系统传输文件可以在认证ssh之后使用scp命令，使用方法类似cp命令

```shell
scp <主机文件地址> <服务器用户名>@<服务器IP>:<目标地址>
```

而如果主机是Linux系统，scp已弃用，可以使用rsync命令

参考[通过 SSH 在远程和本地系统之间传输文件的 4 种方法 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/507876254)



## 关于后端部署

目前想到了两种实现方案

### 方案一

使用docker-compose部署

详细可以参考文章[手把手教你Docker部署若依项目（后端服务）-CSDN博客](https://blog.csdn.net/m0_46698142/article/details/114889286)，应该是可以实现的，但本次并没有这么做

### 方案二

后端、数据库分开部署

原本连数据库都想着通过镜像部署的，但网上提供的Dockerfile一次性生成Mysql镜像的方案并不可行，原因是我想要在Dockerfile中把数据库的表结构和数据通过sql文件的方式一次性存入数据库之中，但这个需要先启动MySQL服务，但经过测试发现，在容器中启动MySQL的命令例如`service`、`systemctl`都无法使用，因此无法使用，如果有什么其他解决方案，可以告知。

不过考虑到MySQL不需要多次使用image部署，只需要使用sql文件更新表结构和数据即可，因此本次部署并没有生成MySQL和Redis的镜像。

部署Mysql和Redis的时候记得修改端口号，并重启服务应用端口号

### 后端镜像生成

首先对工程文件进行打包，在ruoyi框架中，找到bin文件夹，执行其中的`package.bat`脚本，然后在ruoyi-admin/target文件夹中找到.jar文件，将其置入WSL中（不放进去也行，毕竟WSL是能访问宿主机目录的），并在同文件夹下创建Dockerfile文件，内容如下

```dockerfile
FROM docker.io/lwieske/java-8
# copy jar包 命名为 app.jar
COPY *.jar /app.jar
# 暴露端口，这一行是复制来的，但一般会在创建容器的时候指定端口号，所以没啥用，因此注释掉了
# EXPOSE 8080
# 启动 jar包 可通过 PARAM 配置启动参数，后面的参数用于调整不同环境下使用的配置文件
# --spring.profiles.active命令中，填druid或不填表示开发环境
# pro表示生产环境，即47服务器
# test表示测试环境，即局域网内服务器
ENTRYPOINT java  ${PARAM} -jar app.jar --spring.profiles.active=pro
```

然后在当前目录下执行命令：

```sh
docker build -t <镜像名称> .
# 最后的点表示将当前目录下的所有文件都一起打包
```

### Docker Hub传输镜像

1. 在Docker Hub中注册并登录账号
2. 创建空仓库，如果为public，则所有人均可访问，如果为private，则只有登录后才可以访问，这里默认是private
3. 在WSL中执行指令`docker login`，根据提示输入账号密码登录docker账号
4. 输入docker push <仓库拥有者>/<仓库名>:\<Tag\>即可上传到上述步骤中创建的空仓库中，此处的Tag是你自定义的记号，可以是版本号等任意内容
5. 在服务器端执行指令`docker login`登录账号，输入docker pull <仓库拥有者>/<仓库名>:\<Tag\>拉取docker镜像

### 根据镜像生成容器

执行以下命令即可

```sh
# 初版命令
docker run -d -p <主机端口>:<容器端口> --name <给容器取的名字> <镜像名>
# 由于修改网络模式和增加共享文件夹，新的命令如下
docker run -d --name rtserver --network host -v /home/ruoyi/uploadPath:/home/ruoyi/uploadPath <镜像名>
```

容器启动后，等待一段时间，可以通过以下命令查看容器的log

```sh
docker logs rtserver
```

如果log中出现ruoyi的正常启动的图标，则为启动成功

### 遇到的问题

宿主机和容器localhost问题

​	由于Docker在容器中的localhost和宿主机的localhost并不一样，因此打包后的jar文件需要修改MySQL和Redis的地址。docker在运行时就建立了虚拟网卡，并命名为docker0 我们可以在宿主机上运行ifconfig看到它，这就是宿主机建立的网桥，用于与各个容器之间通信，输入ifconfig后找到docker0，其中的第一个地址就是我们所需要的替代localhost的地址。

​	因此，我们需要修改mysql和redis的地址，此外，对于mysql，默认只有localhost可以访问它，我们需要允许MySQL进行远程访问，修改权限可以查看[解决mysql中 you are not allowed to create user with grant 的问题_you are not allowed grant-CSDN博客](https://blog.csdn.net/weixin_54061333/article/details/117458996)，如果使用这个网站中提供的方法还遇到了权限不够的问题，可以输入`flush privileges ;`指令刷新权限，然后再次尝试。



## 一些杂七杂八的技巧

### 在mysql中使用命令导入sql文件

首先可以使用heidiSQL可视化数据库软件将整个数据库导出为sql文件

然后将sql文件传到目标主机中

进入mysql，执行以下语句

```shell
source <sql文件地址>
```

### Docker Hub镜像

参考[解决目前Docker Hub国内无法访问方法汇总 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/642560164)

### 修改redis端口号

[linux下安装并配置redis 修改默认端口号,防止入侵_linux修改redis端口号-CSDN博客](https://blog.csdn.net/llllvvv/article/details/75634622)

修改了redis的端口号之后，redis-cli就无法使用了，因为默认端口是6379，可以使用下面的指令

```sh
redis-cli -p <端口号>
```

### 修改mysql密码

[linux下设置MySQL密码_linux设置mysql密码-CSDN博客](https://blog.csdn.net/qq_41664447/article/details/101733364#:~:text=linux下设置MySQL密码 1 在linux命令行中输入%23 mysql -uroot -p 并输入密码以root身份登录数据库。 2,flush privileges%3B 刷新MySQL的系统权限相关表，使新设置生效。 （还有一种方法，就是使用 service mysqld restart%3B 命令重新启动mysql服务器）)