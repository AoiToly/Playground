可以使用npm指令`npm install three`直接安装threejs，但在安装过程中可能会遇到权限不够导致安装失败的问题

可以通过修改NodeJS安装目录的权限来解决问题

步骤一：

找到NodeJS安装目录，并点击属性->安全->编辑，并在完全控制一栏点击允许

步骤二：

如果还是存在权限报错的情况，在NodeJS安装目录下找到`node_cache`和`node_global`，删除并新建

