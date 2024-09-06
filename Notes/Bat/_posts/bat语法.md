[参考资料](https://blog.csdn.net/finghting321/article/details/105244088)

**注意：BAT脚本文件为ANSI编码（否则出现中文乱码）**

### 1.注释

**rem**注释时，不执行后面的语句，但会显示；

**:: 注释内容**（第一个冒号后也可以跟任何一个非字母数字的字符）

**%注释内容%**（可以用作行间注释，不能出现重定向符号和管道符号）

### 2.开启关闭回显

@置于语句前则该条语句不会回显（无视echo on）

echo off关闭回显功能，直到出现echo on，但其本身会回显，往往和@一起使用，即@echo off（关闭所有回显功能）

### 3.输出和换行

echo后加内容即输出该内容，如：echo "welcome!"；

echo.换行命令，即echo后加一个点

### 4.设置标题title

​     返回值判断

```
@echo off
::title设置标题
title 启动标题
::用以判断上一条命令是否执行成功，默认为0，出错为1
echo %errorlevel%
if %errorlevel% 0 echo 执行成功
if  %errorlevel% 0 (
	echo 执行成功
) else (
	echo 执行失败
)
pause
```

### 5.if语句

注意：if语句块在执行时是当做一条语句加载的，故需要延迟赋值来解决其内部变量引用的问题 

```
::if常规用法，注意空格
@echo off
:start
set /p a=
if not %a%==1 (
	echo 请输入1
	goto start
) else (
	echo 输入正确
)
pause>nul
```

### 6.set用法

接收用户输入数据

```
@echo off
set /p param=请输入密码：
echo %param%
pause
```

定义变量和延迟赋值

```
::输出为1
@echo off
set a=1
set a=2&echo %a%
pause
```

系统变量

```
@echo off
::查看所有环境变量
set
::查看环境变量JAVA_HOME的值
if defined JAVA_HOME echo %JAVA_HOME%
```

定义数字表达式

```
@echo off
set a=1&set b=6
set c=%a%+%b%
::输出1+6
echo %c%
set d=a+b
::输出a+b
echo %d%
set /a e=a+b
::输出7
echo %e%
pause
```

### 7.ping命令

```
@echo off
ping 172.20.34.22
::无休止ping某地址
ping www.baidu.com -t
```

### 8.start命令

 注意：执行start时将开启一个新线程来执行该程序，原程序不受影响继续执行 

```
@echo off
echo 当前正在运行的批处理文件所在路径：%~dp0
start /b %~dp0bin\zkServer
pause
```

### 9.timeout延迟

```
@echo off
set a=1
::延迟五秒输出
timeout 5 >nul
echo %a%
pause
```

### 10.call使用 

调用子脚本，在当前程序中运行子脚本代码，子脚本执行完后继续执行本程序之后的代码

```
call test1.bat
```

### 11.ren命令重命名文件(夹)

```
@echo off
::将1.txt重命名为58.bat
ren d:\test\1.txt 58.bat
::将d:\test\目录下所有文件名为1开头的txt文件改为bat文件
ren d:\test\1*.txt *.bat
::将d:\test\目录下所有文件名为1开头三个字符的bat改为txt文件
ren d:\test\1??.bat ???.txt
```

### 12.xcopy命令复制文件 

```
@echo off
::将D:\test目录下所有文件(夹)复制到F:\test1
::/F目录下所有文件(夹),/y已存在时直接覆盖
xcopy D:\test F:\test1 /e /y
```

### 13.del命令删除文件 

```
@echo off
::删除该层目录下的所有文件,需要确认[Y/N]
del d:\test
pause
::不需要确认
del /q d:\test
::删除该目录下所有层级的文件,不删除文件夹,需要逐个文件夹确认
del /s d:\test
::删除文件111.png,不需要确认
del d:\test\111.png
```

### 14.move命令移动文件(夹)

```
@echo off
::文件夹移动,如果test文件夹存在,则将test5文件夹移动到test文件夹下
::如果test文件夹不存在，则将test5文件夹移动到test1文件夹下并重命名为test
::注意：文件夹移动不能跨分区
move e:\test5 e:\test1\test
::将d:\test\1.txt文件移动到e:\下并重命名为23.txt
::如果该目录已存在23.txt,则会覆盖
move d:\test\1.txt e:\23.txt>nul&&echo 移动成功并重命名
::将e:\23.txt文件移动到e:\test文件夹下
move e:\23.txt e:\test>nul&&echo 移动到文件夹下
```

### 15.md命令创建文件夹

```
::创建文件夹
md e:\test\test1
::文件夹名有空格需要加引号
md "e:\test op"
::空格隔开，创建多个
md e:\test1 e:\test9\test2 "e:\test5 test6"
```

### 16.变量%0--%9

%0指该文件本身，%1--%9为接收到的参数

### 17.for语句

```
@echo off
set str=c d e f g h i j k l m n o p q r s t u v w x y z
echo 当前硬盘的分区有：
for %%i in (%str%) do if exist %%i: echo %%i:
pause
```

### 18.goto

  指定跳转到标签，找到标签后，程序将处理从下一行开始的命令。

  语法：goto label （label是参数，指定所要转向的批处理程序中的行）

  行用 ：label 表示

```
@echo off
:start
cls
set /p numis=请输入数字1或2：
if /i "%numis%"=="1" goto 1
if /i "%numis%"=="2" (goto 2) else (echo 输入有误!&&pause>nul&&goto start)

:1
echo 你输入的是1
pause>nul&&goto start
:2
echo 你输入的是2
pause>nul&&goto start
```