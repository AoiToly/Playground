# 常用指令

```bat
# 查看所有容器
docker ps

# 查看所有镜像
docker image ls

# 创建并运行容器，并进入容器的终端
docker run -it -p 8002:8800 [image] /bin/bash
# -p用于设置端口

# 打开、关闭容器
docker start/stop [container]

# 运行容器
docker exec [container] /bin/bash
# -it表示进入容器的终端
# -c后可跟需要在容器中执行的指令
# -d表示在后台运行

# 将文件复制到容器中
docker cp [source address] [container]:[target address]

# 将容器更新到镜像中
docker commit [container] [image]

# 将镜像push到docker hub中
# 该操作需要先通过docker login指令登录，并且hub仓库中存在与目标镜像同名的仓库
docker push [image]

# 将镜像从hub中拉取下来
docker pull [image]
```

# docker 卷

数据卷是一个可供一个或多个容器使用的特殊目录，它绕过UFS,可以提供很多有用的特性： - 数据卷可以在容器之间共享和重用 - 对数据卷的修改会立马生效 - 对数据卷的更新，不会影响镜像 - 数据卷默认会一直存在，即使容器被删除 Docker中提供了两种挂载方式，-v和-mount

数据卷和挂载的区别：

1. 挂载可以自由指定宿主机上的任意文件夹作为挂载目录，而数据卷不行，数据卷存储在一块由docker管理的区域
2. 挂载所指定的目录只能被一个容器使用，而数据卷可以由多个容器共享