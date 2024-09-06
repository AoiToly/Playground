print("Hello World")
print("------------------------")

-- 这是一个Lua入门脚本，记录了我学习Lua的过程，基于Windows系统
-- 其中，我会将文字描述用单行注释表示，将示例代码用多行注释表示
-- 参考教程：
-- 菜鸟教程，https://www.runoob.com/lua/lua-tutorial.html
-- Lua5.4中文参考手册，https://atom-l.github.io/lua5.4-manual-zh/

-------------------------------------------------------------------------------

-- 环境安装

-- 以下安装均基于Windows系统

-- 5.1版本
-- 直接安装即可，https://github.com/rjpcomputing/luaforwindows/releases

-- 5.1以上版本
-- 参考，https://blog.csdn.net/chihaihai/article/details/109036858
-- 安装MinGW，以build lua的源代码，下载地址：https://nuwen.net/mingw.html
-- 下载后，直接选择合适的位置安装，用这种方式需要7z压缩工具或者git
-- 运行安装目录下的set_distro_paths.bat脚本
-- 查看环境变量，将安装位置的bin目录加入系统变量的path中（上述脚本已经做了）
-- 在cmd中运行where gcc可以查看是否安装成功
-- 如果上述指令无效，并且环境变量中已经加入bin文件夹，可以重启再看是否成功
-- 打开lua官网，https://www.lua.org/download.html
-- 选择合适的版本，下载source code
-- 将source code转移至合适的目录中
-- 使用指令解压tar文件，例如tar -zxvf lua-5.4.7.tar.gz
-- 创建bat文件，并写入
--[[
setlocal
:: Lua安装绝对路径
set lua_install_dir=D:\MySoftware\Lua\5.4.7
:: Lua源码绝对路径
set lua_build_dir=D:\MySoftware\Lua\lua-5.4.7
:: 进入Lua源码路径并使用mingw中的gcc编译器进行编译Lua
cd /D %lua_build_dir%
make PLAT=mingw
echo **** BUILD LUA FINISH ****
:: 创建Lua安装目录以及该目录下的doc，bin，include和lib目录
mkdir %lua_install_dir%
mkdir %lua_install_dir%\doc
mkdir %lua_install_dir%\bin
mkdir %lua_install_dir%\include
mkdir %lua_install_dir%\lib
::拷贝编译后的文件到doc，bin，include和lib目录中
copy %lua_build_dir%\doc\*.* %lua_install_dir%\doc\*.*
copy %lua_build_dir%\src\*.exe %lua_install_dir%\bin\*.*
copy %lua_build_dir%\src\*.dll %lua_install_dir%\bin\*.*
copy %lua_build_dir%\src\luaconf.h %lua_install_dir%\include\*.*
copy %lua_build_dir%\src\lua.h %lua_install_dir%\include\*.*
copy %lua_build_dir%\src\lualib.h %lua_install_dir%\include\*.*
copy %lua_build_dir%\src\lauxlib.h %lua_install_dir%\include\*.*
copy %lua_build_dir%\src\lua.hpp %lua_install_dir%\include\*.*
copy %lua_build_dir%\src\liblua.a %lua_install_dir%\lib\liblua.a
echo **** COPY LUA FINISH ****
:: Lua编译成功后设置Lua的环境变量来安装Lua
setx Path "%lua_install_dir%\bin;%Path%" /m
echo **** SET LUA ENV VAR  FINISH ****
pause
--]]
-- 以管理员身份运行此脚本
-- 该脚本build了lua的source code，并且将lua加入了环境变量
-- 同样，可以通过将bin文件目录加入系统变量的path中来手动添加环境变量
-- 自此，安装完成，在cmd中输入lua -v查看安装情况

-- 使用vscode运行执行lua文件
-- 建议安装腾讯的Lua插件

-------------------------------------------------------------------------------

-- 基本语法

-- 这是单行注释，这个可以加在实际执行的代码后面

--[[
这是
多行
注释
--]]

-- 尽量不要用下划线+大写字母的组合定义变量，这是保留字的定义方式
-- 如_VERSION，这是Lua内部的全局变量

-- nil表示变量不存在
-- 变量默认为全局变量，输出未赋值的全局变量不会出错，只会得到结果nil
-- print(b)
-- 如果想要删除一个全局变量，只需要给它赋值nil
--[[ b = 10
print(b)
b = nil
print(b)
]]

-------------------------------------------------------------------------------

-- 数据类型

-- Lua是动态类型语言，变量不需要定义，只要赋值即可
-- 8个基本类型：nil, boolean, number, string, userdata, function, thread, table

--[[
print(type("Hello world"))      -- string
print(type(10.4*3))             -- number
print(type(print))              -- function
print(type(type))               -- function
print(type(true))               -- boolean
print(type(nil))                -- nil
print(type(type(X)))            -- string
--]]


-- nil
-- nil 表示无效值，在条件表达式中相当于false

-- 对于全局变量和table，如果给全局变量和table里的一个变量赋值nil，则等同于把他们删掉
--[[
tab1 = { key1 = "val1", key2 = "val2", "val3" }
for k, v in pairs(tab1) do
    print(k .. " - " .. v)
end
print("------------------------")
tab1.key1 = nil
for k, v in pairs(tab1) do
    print(k .. " - " .. v)
end
--]]

-- nil作比较时应该加上双引号，这是因为type方法返回的是string
--[[
print(type(X) == nil)    -- false
print(type(X) == "nil")  -- true
--]]


-- boolean
-- 布尔值，有true和false两个值
-- Lua中，false和nil为false，其他都为true，数字0也是true

--[[
print(type(true))       -- boolean
print(type(false))      -- boolean
print(type(nil))        -- nil
 
if false or nil then    -- false
    print("Either false or nil is true")
else
    print("Both false and nil are false")
end

if 0 then               -- true
    print("0 is true")
else
    print("0 is false")
end
--]]


-- number
-- 默认只有一种number类型，即double，默认类型可以通过修改luaconf.h里的定义


-- string
-- 字符串由一对双引号或单引号来表示
--[[
string1 = "this is string1"
string2 = 'this is string2'
--]]

-- 对一个数字字符串进行操作时，Lua会尝试将这个数字字符串转成一个数字
--[[
print("2" + 6)        -- 8
print("2" + "6")      -- 8
print("2 + 6")        -- 2 + 6
print("-2e2" * "6")   -- -1200.0
-- print("error" + 1) -- error
--]]

-- 字符串连接使用..
--[[
print("a" .. 'b')   -- ab
print(157 .. 428)   -- 157428
--]]

-- 使用#来计算字符串的强度，放在字符串前面
--[[
len = "Hello World!"
print(#len)             -- 12
print(#"Hello World!")  -- 12
--]]

-- table
-- 我的理解是类似于字典，key可以是非nil的任意数据类型，如果不进行赋值，key默认从1开始递增
--[[
local tb1 = {}
tb1["key"] = "value"
key = 10
tb1[key] = 22
tb1[key] = tb1[key] + 11
for k, v in pairs(tb1) do
    print(k .. " : " .. v)
end
local tb2 = {"apple", "pear", "orange", "grape"}
for k, v in pairs(tb2) do
    print(k .. " : " .. v)
end
print(tb2["none"])  -- nil
--]]


-- function
-- 函数被看作是“第一类值”，可以存在变量里
--[[
function factorial1(n)
    if n == 0 then
        return 1
    else
        return n * factorial1(n - 1)
    end
end
print(factorial1(5))        -- 120
print(factorial2)           -- nil
factorial2 = factorial1
print(factorial2(5))        -- 120
--]]

-- 匿名函数
--[[
function testFun(tab,fun)
    for k ,v in pairs(tab) do
        print(fun(k, v));
    end
end

tab = {key1 = "val1", key2 = "val2"}
testFun(tab,
    function(key, val)--匿名函数
        return key .." = ".. val;
    end
)
--]]


-- thread
-- Lua中并没有多线程的概念，thread只是一个能存储运行状态的数据结构
-- Lua中无法直接开启或销毁一个真正的线程，使用得更多的是协程coroutine


-- userdata
-- 自定义类型
-- 一种用户自定义数据，用于表示一种C/C++语言库所创建的类型
-- 可以将C/C++任意数据类型的数据（通常是struct和指针）存储到Lua变量中调用

-------------------------------------------------------------------------------

-- 变量
-- 三种类型：全局变量，局部变量，表中的域
-- 使用local标签的变量是局部变量，其余全是全局变量，无论它在哪儿
-- 表中的域值的就是表中的键值对
-- 尽量使用局部变量，因为相比全局变量，局部变量可以避免命名冲突并且访问速度更快

-- 多变量赋值
--[[
a, b = 2, "ff"
print(a, b)         -- 2, ff
a, b = b, a
print(a, b)         -- ff, 2
a, b, c = 0, 1
print(a, b, c)      -- 0, 1, nil
a, b = 0, 1, 2
print(a, b)         -- 0, 1
a, b, c = 0
print(a, b, c)      -- 0, nil, nil
function test()
    return 1, 2
end
a, b = test()
print(a, b)         -- 1, 2
--]]

-- 索引
-- table的索引可以用[]，也可以用.
-- t[a], t.a
-- t.a本质是gettable_event(t, i)这样的函数调用

-------------------------------------------------------------------------------

-- 循环
-- 循环控制语句
-- Lua中支持break和goto，当然goto能不用则不用

-- while循环
--[[
a = 0
while(a < 10)
do
    print(a)
    a = a + 1
end
--]]

-- for循环
-- 数值for循环
--[[
-- 从1开始每次递增2，直到i==5结束循环
for i = 1, 5, 2 do
    print(i)        // 1 3 5
end

-- 每次递增的量可以不指定，默认为1
for i = 1, 5 do
    print(i)        // 1 2 3 4 5
end
--]]
-- 泛型for循环，类似于foreach
--[[
-- ipairs为迭代器函数，用于迭代数组
a = {"one", "two", "three"}
for i, v in ipairs(a) do
    print(i, v)
end
--]]

-- repeat...until循环，类似于do...while
--[[
a = 10
repeat
    print(a)
    a = a + 1
until (a > 15)
--]]

-------------------------------------------------------------------------------

-- 流程控制
--[[
a = -99
if (a < 0)
then
    print(1)
elseif (a < 10)
then
    print(2)
else
    print(3)
end
--]]

-------------------------------------------------------------------------------

-- 函数
--[[
-- 标记local之后表示局部函数
local function swap(a, b)
    -- 多返回值
    return b, a
end
a = 1
b = 2
print(swap(a, b))       -- 2  1
--]]

-- 可变参数
--[[
-- ...表示可变参数
function calculate(n, ...)
    local s = 0
    local res = {}
    -- {...}表示一个由所有变长参数组成的数组
    for i, v in ipairs{...} do
        s = s + v
    end
    res.sum = s

    s = 0
    local args = {...}  -- 可以用变量存储变长数组，args是一个表
    for i, v in ipairs(args) do
        s = s + v
    end
    res.avg = s / #args -- #args可以获取args的元素数量

    res.count = select("#", ...)    -- 也可以通过select("#", ...)来获取元素数量
    
    sub = { select(n, ...) }    -- select(n, ...)返回从索引n到结束的所有参数

    return res, sub
end

res, sub = calculate(2, 2, 3, 4, 5)

for k, v in pairs(res) do
     print(k .. v)
end
for k, v in ipairs(sub) do
    print(k .. ":" .. v)
end
--]]

-------------------------------------------------------------------------------

-- 运算符
-- 算术运算符
--[[
a = 21
b = 10
print(a + b)        -- 31
print(a - b)        -- 11
print(a * b)        -- 210
print(a / b)        -- 2.1
print(a % b)        -- 1
print(a ^ 2)        -- 441，乘幂
print(a // b)       -- 2，整除
--]]

-- 关系运算符
--[[
a = 21
b = 10
print(a == b)   -- false
print(a ~= b)   -- true，不等于
print(a > b)    -- true
print(a < b)    -- false
print(a >= b)   -- true
print(a <= b)   -- false
--]]

-- 逻辑运算符
--[[
a = true
b = true
c = false
d = false
print(a and b)      -- true
print(a and c)      -- false
print(c or d)       -- false
print(a or c)       -- true
print(not(a and b)) -- false
--]]

-- 其他运算符
--[[
print("Hello" .. "World")   -- HelloWorld，连接两个字符串
print(#"HelloWorld")        -- 10，返回字符串长度
print(#{1, 2, 3})           -- 3，返回表长度
--]]

-- 运算符优先级（从高到低，一行内表示相同）
-- ^
-- not  -(unary)
-- *    /   %
-- +    -
-- ..
-- <    >   <=  >=  ~=  ==
-- and
-- or

-------------------------------------------------------------------------------

-- 字符串
-- 此处代码段用单行注释表示
-- 这是因为多行字符串的声明和多行注释冲突
-- str1 = 'This is a string.'
-- str2 = "This is a string."
-- str3 = [[
-- This is 
-- a multiline
-- string.
-- ]]
-- print(str1)
-- print(str2)
-- print(str3)

--[[
-- 转大写
print(string.upper("hello"))
-- 转小写
print(string.lower("HELLO"))
-- 字符串中替换，"aaaa"中寻找"a"替换为"z"，替换前3个找到的字符串
-- 返回目标字符串和替换次数
print(string.gsub("aaaa", "a", "z", 3))
-- string.find(str, substr[, init[, plain] ])
-- 寻找指定子串，找到则返回起始点和结束点，否则返回nil
-- init指定搜索起始位置，默认为1，可以是负数，表示从后往前数的字符个数
-- plain表示是否使用简单模式，true表示简单模式，false开启正则模式匹配，默认false
print(string.find("hello", "hello", 1))
-- 字符串反转
print(string.reverse("hello"))
-- 格式化字符串
print(string.format("the value is %d", 4))
-- ASCLL码转字符并连接
print(string.char(97, 98, 99, 100))
-- 字符转ASCLL码
-- string.byte(arg[, n])，n可以指定转第几个字符，默认第一个
-- n为负数时表示从后往前的第|n|个字符
print(string.byte("ABCD", 4))
-- 计算长度
print(string.len("hello"))
-- 返回字符串的n个拷贝
-- string.rep(string, n)
print(string.rep("hello", 3))
-- 连接字符串
print("hello" .. "world")
-- string.gmatch(str, pattern)
-- 返回一个迭代器函数，每一次调用这个函数，返回一个在str找到的符合pattern的子串
-- 没找到则返回nil
for word in string.gmatch("Hello Lua user", "%a+") do print(word) end
-- string.match(str, pattern[, init])
-- 从第init个字符开始寻找str中第一个配对pattern的子串，返回配对的字符串或nil
print(string.match("I have 2 questions for you.", "%d+ %a+"))
-- 字符串截取
-- string.sub(s, i[, j])
-- i小于0时表示截取最后开始数的|i|个字符
print(string.sub("hello", 2, 4))
--]]

-- 计算长度
--[[
str1 = "Hello World"
str2 = "你好世界"
print(string.len(str1))
print(string.len(str2))
print(utf8.len(str2))
--]]


-- 字符串格式化，string.format
-- 第一个参数是格式，之后是对应格式中每个代号的各种数据
-- 转义码如下
-- %c - 接受一个数字, 并将其转化为ASCII码表中对应的字符
-- %d, %i - 接受一个数字并将其转化为有符号的整数格式
-- %o - 接受一个数字并将其转化为八进制数格式
-- %u - 接受一个数字并将其转化为无符号整数格式
-- %x - 接受一个数字并将其转化为十六进制数格式, 使用小写字母
-- %X - 接受一个数字并将其转化为十六进制数格式, 使用大写字母
-- %e - 接受一个数字并将其转化为科学记数法格式, 使用小写字母e
-- %E - 接受一个数字并将其转化为科学记数法格式, 使用大写字母E
-- %f - 接受一个数字并将其转化为浮点数格式
-- %g(%G) - 接受一个数字并将其转化为%e(%E, 对应%G)及%f中较短的一种格式
-- %q - 接受一个字符串并将其转化为可安全被Lua编译器读入的格式
-- %s - 接受一个字符串并按照给定的参数格式化该字符串

-- 为进一步细化格式, 可以在%号后添加参数. 参数将以如下的顺序读入:
-- (1) 符号: 一个+号表示其后的数字转义符将让正数显示正号. 默认情况下只有负数显示符号.
-- (2) 占位符: 一个0, 在后面指定了字串宽度时占位用. 不填时的默认占位符是空格.
-- (3) 对齐标识: 在指定了字串宽度时, 默认为右对齐, 增加-号可以改为左对齐.
-- (4) 宽度数值
-- (5) 小数位数/字串裁切: 在宽度数值后增加的小数部分n, 若后接f(浮点数转义符, 如%6.3f)
-- 则设定该浮点数的小数只保留n位, 若后接s(字符串转义符, 如%5.3s)则设定该字符串只显示前n位.


-- 匹配模式
-- 用于模式匹配函数
-- string.find, string.gmatch, string.gsub, string.match
-- 单个字符(除 ^$()%.[]*+-? 外): 与该字符自身配对
-- .(点): 与任何字符配对
-- %a: 与任何字母配对
-- %c: 与任何控制符配对(例如\n)
-- %d: 与任何数字配对
-- %l: 与任何小写字母配对
-- %p: 与任何标点(punctuation)配对
-- %s: 与空白字符配对
-- %u: 与任何大写字母配对
-- %w: 与任何字母/数字配对
-- %x: 与任何十六进制数配对
-- %z: 与任何代表0的字符配对
-- %x(此处x是非字母非数字字符): 与字符x配对. 主要用来处理表达式中有功能的字符(^$()%.[]*+-?)的配对问题, 例如%%与%配对
-- [数个字符类]: 与任何[]中包含的字符类配对. 例如[%w_]与任何字母/数字, 或下划线符号(_)配对
-- [^数个字符类]: 与任何不包含在[]中的字符类配对. 例如[^%s]与任何非空白字符配对

-- 太复杂，不想记了，参考https://www.runoob.com/lua/lua-strings.html

-------------------------------------------------------------------------------

-- 数组
-- 用table实现
--[[
-- 创建数组
local arr = {10, 20, 30, 40, 50}
-- 数组长度
print(#arr)
-- 遍历数组，索引从1开始
for i = 1, #arr do
    print(arr[i])
end
-- 修改元素
arr[1] = 100
-- 添加元素
arr[6] = 60
-- 删除元素
table.remove(arr, 3)
for i = 1, #arr do
    print(arr[i])
end
-- 多维数组
-- table支持嵌套，以实现多维数组
--]]

-------------------------------------------------------------------------------

-- 迭代器
--[[
local t = { type = "fruit", "apple", "pear", "orange" }
-- pairs是所有元素的迭代器
for k, v in pairs(t) do
    print(k .. ": " .. v)
end
-- ipairs是数组的迭代器，即指迭代table中从1开始的key
for k, v in ipairs(t) do
    print(k .. ": " .. v)
end
--]]

-- 注意，在泛型for循环中
-- 包含了3个参数，迭代函数、状态常量、控制变量
-- 而迭代函数在in的后面，in后面包含两个东西
-- 其一是迭代函数指针，其二是迭代函数的参数

-- 无状态的迭代器
--[[
-- 实现数字n的平方
function square(iteratorMaxCount,currentNumber)
    if currentNumber<iteratorMaxCount
    then
       currentNumber = currentNumber+1
    return currentNumber, currentNumber*currentNumber
    end
end
 
for i, n in square, 3, 0
do
    print(i, n)
end

-- ipairs的实现
function iter (a, i)
    i = i + 1
    local v = a[i]
    if v then
       return i, v
    end
end
 
function ipairs (a)
    return iter, a, 0
end
--]]

-- 多状态的迭代器
-- 我认为多状态和无状态的迭代器本质上是一样的，并没有什么不同
-- 只是多状态的迭代器由于状态较多，使用了局部变量和闭包，仅此而已
-- 也因此，多状态的迭代器消耗更大，我们应尽可能使用无状态的迭代器，用for来保存状态
--[[
array = {"Google", "Microsoft"}

function elementIterator (collection)
   local index = 0
   local count = #collection
   -- 闭包函数
   return function ()
      index = index + 1
      if index <= count
      then
         --  返回迭代器的当前元素
         return collection[index]
      end
   end
end

for element in elementIterator(array)
do
   print(element)
end
--]]

-------------------------------------------------------------------------------

-- Table
-- 我以为，Lua中所有和单个.有关的语法都可以视作table相关
-- 即所有调用函数调用包的行为其实都是在调用table里的一个东西
-- 简单语法不作赘述，之前已有过描述

-- 初始化
-- 方括号可以指定数字索引的元素
-- 但如果又有方括号又有默认的数组初始化在同一个初始化中，如下
-- 数组初始化会将方括号的初始化覆盖掉
--[[
local t = {33, [1] = 2, [2] = 4, 45}
print(table.concat(t, ", "))
--]]


-- Table操作

-- table.concat(table[, sep[, start[, end] ] ])
-- concat是concatenate的缩写，含义为连锁，连接
-- 函数列出参数中指定table数组部分从start位置到end位置的所有元素，元素间以sep分隔开
-- 注意，该函数只会连接数组部分，即索引1开始的连续的元素，start和end左闭右闭
--[[
local fruits = {"banana","orange","apple", notArr = "notArr"}
print(table.concat(fruits))
print(table.concat(fruits, ", "))
print(table.concat(fruits, ", ", 2, 3))
--]]

-- table.insert(table[, pos], value)
-- 在指定pos位置插入值为value的一个元素，pos参数可选，默认数组部分末尾

-- table.remove(table[, pos])
-- 删除并返回table中位于pos位置的元素，pos可选，默认为最后一个元素
--[[
local fruits = {"banana", "orange", "apple"}
-- 插入
table.insert(fruits, "mango")
table.insert(fruits, 2, "grapes")
print(table.concat(fruits, ", "))
-- 删除
table.remove(fruits)
table.remove(fruits, 2)
print(table.concat(fruits, ", "))
--]]

-- table.maxn(table)
-- 返回table中所有正数key值中最大的key值，如果不存在key值为正的元素，返回0
-- 5.2版本已经删除了该方法

-- table.sort(table[, comp])
-- 根据comp函数排序，comp可选，默认升序排序
--[[
local fruits = {"banana", "orange", "apple", "grape"}
print(table.concat(fruits, ", "))
local comp = function(a, b)
    return a > b
end
table.sort(fruits, comp)
print(table.concat(fruits, ", "))
--]]

-------------------------------------------------------------------------------

-- 模块与包

-- 创建自定义模块，详见MyModule.lua文件

-- 引用模块
-- require("模块") or require "模块"
--[[
local m = require("./Module/MyModule")
print(m.constant)
m.func3()
--]]

-- C包
--[[
-- 此处代码无法执行，我并没有做深入研究，了解概念即可
local path = "./Library/luasocker.dll"
-- loadlib加载并连接到指定库，返回初始化函数
-- assert用于判断上述加载是否出错并输出错误信息
local f = assert(loadlib(path, "luaopen_socket"))
-- 调用初始化函数即可打开库
f()
--]]

-------------------------------------------------------------------------------

-- Metatable元表
-- 元表用于改变table的行为，例如可以计算两个元表的相加操作
-- 注意，在对表进行赋值、获取值的操作时会优先调用元表中定义的方法进行覆盖
-- 如果想要避免元表方法调用直接修改或获取本表的值，可以调用rawset和rawget方法
--[[
mytable = {orange = 1, apple = 2, pear = 3}
mymetatable = {}
-- 设置mytable的元表为mymetatable
setmetatable(mytable, mymetatable)
-- 获取mytable的元表
getmetatable(mytable)
--]]

-- __index
-- 用于表的访问操作
-- Table中访问一个元素时：
-- 1. 在表中查找该元素，找到则返回，找不到则继续
-- 2. 判断该表是否有元表，没有则返回nil，有则继续
-- 3. 判断元表有无__index方法，没有则返回nil，有则继续
-- 4. 如果__index是一个表，则在元表中重复上述操作，否则继续
-- 5. 如果__index方法是一个函数则继续，否则报错
-- 6. 调用该函数，调用时会传入目标table和查找的元素
--[[
mytable = setmetatable({key1 = "value1"}, { __index = { key2 = "metatablevalue" }})
print(mytable.key1,mytable.key2)
--]]

-- __newindex
-- 用于表的更新操作
-- 当给表的一个缺少的索引赋值时：
-- 1. 查找__newindex，如果不存在则进行赋值操作，否则继续
-- 2. 如果__newindex是一个表，则给这个表进行赋值操作，否则继续
-- 3. 如果__newindex是一个函数，则调用该函数，参数为table，key，value，否则继续
-- 4. 其他情况报错
--[[
-- __newindex为表的情况
mymetatable = {}
mytable = setmetatable({key1 = "value1"}, { __newindex = mymetatable })

print(mytable.key1)

mytable.newkey = "新值2"
print(mytable.newkey,mymetatable.newkey)

mytable.key1 = "新值1"
print(mytable.key1,mymetatable.key1)
--]]

-- __newindex为函数的情况
--[[
mytable = setmetatable({key1 = "value1"}, {
    __newindex = function(mytable, key, value)
        -- 使用rawset方法可以避开调用table复杂的元表操作，直接给表赋值
        rawset(mytable, key, "\""..value.."\"")
    end
})

mytable.key1 = "new value"
mytable.key2 = 4

print(mytable.key1,mytable.key2)
--]]

-- 操作符
--[[
-- 加法操作符
a = {"apple", "orange", "pear"}
b = {"grape", "banana"}
-- c = a + b -- 直接调用会报错
setmetatable(a, {
    __add = function(tablea, tableb)
        local mytable = {}
        for _, v in ipairs(tablea) do
            table.insert(mytable, v)
        end
        for _, v in ipairs(tableb) do
            table.insert(mytable, v)
        end
        return mytable
    end
})
c = a + b
print(table.concat(c, ", "))
--]]

-- 其他操作符列表
-- __add 对应 +
-- __sub 对应 -
-- __mul 对应 *
-- __div 对应 /
-- __mod 对应 %
-- __unm 对应 单目-，即相反数
-- __concat ..
-- __eq 对应 ==
-- __lt 对应 <
-- __le 对应 <=

-- __call
-- 在使用调用函数的方式调用表时调用
-- 类型为方法，参数是本表和其他参数
--[[
mytable = setmetatable({}, {__call = function(mytable, a, b, c)
        return a + b + c
    end
})
print(mytable(1, 2, 3))
--]]

-- __tostring
-- 自定义表的输出行为
--[[
mytable = setmetatable({10, 20, 30}, {__tostring = function(mytable)
        sum = 0
        for k, v in ipairs(mytable) do
            sum = sum + v
        end
        return "表的所有元素之和为: " .. sum
    end
})
print(mytable)
--]]

-- 其他元方法
-- __len 长度
-- __metatable 保护元表

-------------------------------------------------------------------------------

-- 协程coroutine
-- coroutine.create 创建协程，参数为协程函数
-- coroutine.resume 启动协程，参数为已创建的协程以及传入的参数
-- coroutine.yield 挂起协程
-- coroutine.status 查看coroutine状态，有dead、suspended、running三种
-- coroutine.wrap 创建coroutine，和create类似，但返回一个函数，调用此函数则进入协程
-- coroutine.running 返回正在跑的coroutine，一个coroutine就是一个线程，即返回线程号
-- coroutine.close 销毁一个coroutine

--[[
function foo(a, b)
    print('coroutine start, the sum is ' .. a + b)
    -- 这里yield的参数会作为结果输出
    -- yield的返回值即输入参数，可以是多参
    local value1, value2 = coroutine.yield('coroutine pause')
    print('coroutine resume, the value is ' .. value1 .. ' and ' .. value2)
    print('coroutine end')
end

local co = coroutine.create(foo)

-- 开始执行并填入参数
local status, result = coroutine.resume(co, 12, 34)
print(result)

-- 恢复执行并填入参数
status, result = coroutine.resume(co, 42, 54)
print(result)
--]]

-- 生产者消费者问题
--[[
local newProductor
local max = 50

function productor()
     local i = 0
     while i < max do
          i = i + 1
          send(i)     -- 将生产的物品发送给消费者
     end
end

function consumer()
    local i = 0
     while  i < max do
          i = receive()     -- 从生产者那里得到物品
          print(i)
     end
end

function receive()
     local status, value = coroutine.resume(newProductor)
     return value
end

function send(x)
     coroutine.yield(x)     -- x表示需要发送的值，值返回以后，就挂起该协同程序
end

-- 启动程序
newProductor = coroutine.create(productor)
consumer()
--]]

-------------------------------------------------------------------------------

-- 文件I/O
-- 有简单模式和完全模式
-- 打开文件 file = io.open(filename[, mode])
-- mode的值如下：
-- r 以只读方式打开文件，该文件必须存在
-- w 打开只写文件，文件不存在则创建，存在则将文件内容清空
-- a 以附加方式打开只写文件，文件不存在则创建，文件存在，写入的数据会被追加到文件尾（EOF符保留）
-- r+ 以可读写的方式打开文件，该文件必须存在
-- w+ 打开可读写文件，存在则内容清空，不存在则创建
-- a+ 同a，但此文件可读可写
-- b 二进制模式
-- + 表示文件可读也可以写

-- 简单模式
--[[
-- 只读方式打开文件
file = io.open("iotest.txt", "r")
-- 设置默认输入文件
io.input(file)
-- 读取文件第一行
print(io.read())
-- 关闭文件
io.close(file)

-- 以附加方式打开只写文件
file = io.open("iotest.txt", "a")
-- 设置默认输出文件
io.output(file)
-- 写入内容
io.write("\nThis is an io test.")
-- 关闭文件
io.close(file)
--]]

-- io.read
-- 读取文件
-- 可增加参数
-- *n 读取一个数字并返回
-- *a 从当前位置读取整个文件
-- *l 默认参数，读取下一行，在文件尾EOF处返回nil
-- number返回一个指定字符个数的字符串，或在EOF时返回nil

-- io.tmpfile
-- 创建一个临时文件句柄，该文件以更新模式打开，程序结束时自动删除

-- io.type(obj)
-- 检测obj是否是一个可用的文件句柄

-- io.flush
-- 向文件写入缓冲中的所有数据

-- io.lines(optional file name)
-- 返回一个迭代函数，每次调用将获得文件的一行内容，当到文件尾时返回nil但不关闭文件


-- 完全模式
-- 支持同时处理多个文件，方法用file:function代替简单模式中的部分io.function
--[[
-- 以只读方式打开文件
file = io.open("iotest.txt", "r")

-- 输出文件第一行
print(file:read())

-- 关闭打开的文件
file:close()
--]]

-- file:seek(optional whence, optional offset)
-- 设置和获取当前文件位置，成功则返回最终的文件位置（按字节），失败则返回nil并报错
-- 参数whence: 
-- set 从文件头开始
-- cur 从当前位置开始（默认）
-- end 从文件尾开始
-- 参数offset默认为0

-- file:flush()
-- 向文件写入缓冲中的所有数据

-- io.lines(optional filename)
-- 只读模式打开一个文件并返回一个迭代函数，每次调用返回一行内容，到文件尾则返回nil并关闭文件
--[[
for line in io.lines("iotest.txt") do
    print(line)    
end
--]]

-------------------------------------------------------------------------------

-- 错误处理

-- assert
-- 检查第一个参数，如果有问题，抛出错误内容
--[[
local function add(a,b)
    assert(type(a) == "number", "a 不是一个数字")
    assert(type(b) == "number", "b 不是一个数字")
    return a+b
end
add(10)
--]]

-- error
-- error(message[, level])
-- 终止正在执行的函数，并返回message的内容作为错误内容（error函数永远都不会返回）
-- level参数提示错误位置
-- level = 1[默认] 调用error位置（文件+行号）
-- level = 2 指出是哪个函数调用的error
-- level = 0 不添加错误位置信息

-- pcall
-- 保护模式执行代码
-- 参数为函数和该函数的参数
-- 调用成功返回true，调用失败返回false, errorinfo
--[[
res, errorinfo = pcall(function(i) print(i) end, 33)
if res
then
    print("true")
else
    print("false: " .. errorinfo)
end

res, errorinfo = pcall(function(i) error('error') print(i) end, 33)
if res
then
    print("true")
else
    print("false: " .. errorinfo)
end
--]]

-- xpcall
-- 可以获取更多错误信息，并更好地处理错误
-- 第一个参数是执行的函数，第二个参数是错误处理函数，后续参数是第一个参数的入参
-- 可以在错误处理函数中调用debug库
-- debug.debug 提供了一个Lua提示符，让用户来检查错误原因
-- debug.traceback 根据调用栈来构建一个扩展的错误信息
--[[
function func1(a, b)
    print(a + b)
end

function errorhandler(err)
    print("ERROR: ", err)
    print(debug.traceback())
    -- debug.debug()
end

status = xpcall(func1, errorhandler, 10)
print(status)
--]]

-------------------------------------------------------------------------------

-- 调试Debug
-- Lua提供了debug库用于提供创建我们自定义调试器的功能
-- Lua本身未提供内置的调试器

-- debug库
-- debug.debug()
-- 进入一个用户交互模式，运行用户输入的每个字符串
-- 使用简单的命令以及其它调试设置，用户可以检阅全局变量和局部变量，
-- 改变变量的值，计算一些表达式，等等
-- 输入一行仅包含 cont 的字符串将结束这个函数， 这样调用者就可以继续向下运行

-- debug.getfenv(object)
-- 返回对象的环境变量

-- debug.gethook(optional thread)
-- 返回三个表示线程钩子设置的值：当前钩子函数，当前钩子掩码，当前钩子计数

-- debug.getinfo([thread, ]f[, what])
-- 返回关于一个函数信息的表
-- 你可以直接提供该函数， 也可以用一个数字 f 表示该函数
-- 数字 f 表示运行在指定线程的调用栈对应层次上的函数：
-- 0 层表示当前函数（getinfo 自身）
-- 1 层表示调用 getinfo 的函数 （除非是尾调用，这种情况不计入栈）
-- 等等
-- 如果 f 是一个比活动函数数量还大的数字， getinfo 返回 nil

-- debug.getlocal([thread, ]f, local)
-- 此函数返回在栈的 f 层处函数的索引为 local 的局部变量 的名字和值
-- 这个函数不仅用于访问显式定义的局部变量，也包括形参、临时变量等

-- debug.getmetatable(value)
-- 把给定索引指向的值的元表压入堆栈
-- 如果索引无效，或是这个值没有元表，函数将返回 0 并且不会向栈上压任何东西

-- debug.getregistry()
-- 返回注册表，这是一个预定义出来的表，可以用来保存任何 C 代码想保存的 Lua 值

-- debug.getupvalue(f, up)
-- 此处的上值指的是函数中的局部变量
-- 此函数返回函数 f 的第 up 个上值的名字和值。 如果该函数没有那个上值，返回 nil
-- 以 '(' （开括号）打头的变量名表示没有名字的变量 （去除了调试信息的代码块）

-- debug.sethook([thread, ]hook, mask[, count])
-- 将一个函数作为钩子函数设入
-- 字符串 mask 以及数字 count 决定了钩子将在何时调用
-- 掩码是由下列字符组合成的字符串，每个字符有其含义：
-- 'c' 每当Luau调用一个函数时，调用钩子
-- 'r' 每当Lua从一个函数内返回时，调用钩子
-- 'l' 每当Lua进入新的一行时，调用钩子

-- debug.setlocal([thread, ]level, local, value)
-- 这个函数将 value 赋给栈上第 level 层函数的第 local 个局部变量
-- 如果没有那个变量，函数返回 nil
-- 如果 level 越界，抛出一个错误

-- debug.setmetatable(value, table)
-- 将 value 的元表设为 table （可以是 nil）并返回 value

-- debug.setupvalue(f, up, value)
-- 将 value 设为函数 f 的第 up 个上值
-- 如果函数没有那个上值，返回 nil，否则返回该上值的名字

-- debug.traceback([thread, ][message[, level]])
-- 如果 message 存在，且不是字符串或 nil， 函数不做任何处理直接返回 message
-- 上述message并不是参数的message
-- 否则，它返回调用栈的栈回溯信息
-- 字符串可选项 message 被添加在栈回溯信息的开头
-- 数字可选项 level 指明从栈的哪一层开始回溯 （默认为 1 ，即调用 traceback 的那里）
--[[
function myfunction ()
    print(debug.traceback("Stack trace"))
    print(debug.getinfo(1))
    print("Stack trace end")
    return 10
end
myfunction ()
print(debug.getinfo(1))
--]]

--[[
-- 创建一个函数，每次执行使值+1
function newCounter ()
    local n = 0
    local k = 0
    return function ()
        k = n
        n = n + 1
        return n
    end
end
  
counter = newCounter ()
print(counter())
print(counter())

local i = 1

repeat
    -- 获得局部变量的值
    name, val = debug.getupvalue(counter, i)
    if name then
        print ("index", i, name, "=", val)
        if(name == "n") then
            -- 修改局部变量的值
            debug.setupvalue (counter,2,10)
        end
        i = i + 1
    end -- if
until not name

print(counter())
--]]


-- 调试类型
-- 命令行调试：RemDebug、clidebugger、ctrace、xdbLua
-- LuaInterface - Debugger、Rldb、ModDebug
-- 图形界面调试：SciTE、Decoda、ZeroBrane Studio、akdebugger、luaedit

-------------------------------------------------------------------------------

-- 垃圾回收
-- Lua运行了一个垃圾收集器来收集所有死对象，即不可能再访问到的对象
-- Lua中所有用到的内存都服从自动管理
-- 间歇率：开启新的垃圾循环之前要等多久
-- 200时表示总内存量达到之前的2倍时开始新的循环
-- 步进倍率：垃圾收集器运作速度相对于内存分配速度的倍率
-- 小于100时速度过慢，永远无法完成1个循环
-- 默认值为200，表示垃圾收集器的速度时内存分配速度的两倍

-- 垃圾回收器函数
-- Lua 提供了以下函数collectgarbage ([opt [, arg]])用来控制自动内存管理:
-- collectgarbage("collect")
-- 做一次完整的垃圾收集循环

-- collectgarbage("count")
-- 以 K 字节数为单位返回 Lua 使用的总内存数
-- 这个值有小数部分，所以只需要乘上 1024 就能得到 Lua 使用的准确字节数（除非溢出）

-- collectgarbage("restart")
-- 重启垃圾收集器的自动运行

-- collectgarbage("setpause")
-- 将 arg 设为收集器的 间歇率。 返回 间歇率 的前一个值

-- collectgarbage("setstepmul")
-- 返回 步进倍率 的前一个值

-- collectgarbage("step")
-- 单步运行垃圾收集器，步长"大小"由 arg 控制
-- 传入 0 时，收集器步进（不可分割的）一步
-- 传入非 0 值 收集器收集相当于 Lua 分配这些多（K 字节）内存的工作
-- 如果收集器结束一个循环将返回 true 。

-- collectgarbage("stop")
-- 停止垃圾收集器的运行，在调用重启前，收集器只会因显式的调用运行

--[[
mytable = {"apple", "orange", "banana"}
print(collectgarbage("count"))
mytable = nil
print(collectgarbage("count"))
print(collectgarbage("collect"))
print(collectgarbage("count"))
--]]

-------------------------------------------------------------------------------

-- 面向对象
-- 封装、继承、多态、抽象
-- 类可用table+function模拟
-- 继承可用metatable模拟（不推荐用）

-- 成员函数
--[[
Account = {}
function Account.print(v)
    print("Account: " .. v)
end
Account.print("hello")
--]]

--[[
-- 基类
Rectangle = {area = 0, length = 0, breadth = 0}

-- 基类方法 new
function Rectangle:new (o,length,breadth)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.length = length or 0
    self.breadth = breadth or 0
    self.area = length*breadth
    return o
end

-- 基类方法 printArea
function Rectangle:printArea ()
    print("矩形面积为 ",self.area)
end

-- 创建对象
r = Rectangle:new(nil,10,20)

-- 访问属性
print(r.length)

-- 访问成员函数
r:printArea()

-- 派生类
Square = Rectangle:new(nil, 0, 0)

-- 派生类方法new
function Square:new(o, side)
    o = o or Rectangle:new(o, side, side)
    setmetatable(o, self)
    self.__index = self
    return o
end

-- 派生类方法printArea
function Square:printArea()
    print("正方形面积为 ", self.area)
end

-- 创建对象
s = Square:new(nil, 10)
s:printArea()
--]]

-------------------------------------------------------------------------------

-- 数据库访问
-- 使用开源LuaSQL，http://luaforge.net/projects/luasql/
-- 支持ODBC，ADO，Oracle，MySQL，SQLite和PostgreSQL
-- 使用LuaRocks来安装数据库驱动
-- https://github.com/keplerproject/luarocks/wiki/Installation-instructions-for-Windows
-- 安装不同数据库驱动：
-- luarocks install luasql-sqlite3
-- luarocks install luasql-postgres
-- luarocks install luasql-mysql
-- luarocks install luasql-sqlite
-- luarocks install luasql-odbc
-- 也可以用源码安装方式，https://github.com/keplerproject/luasql

-- 连接数据库示例
--[[
-- 下列代码无法直接运行

luasql = require "luasql.mysql"

--创建环境对象
env = luasql.mysql()

--连接数据库
conn = env:connect("数据库名","用户名","密码","IP地址",端口)

--设置数据库的编码格式
conn:execute"SET NAMES UTF8"

--执行数据库操作
cur = conn:execute("select * from role")

row = cur:fetch({},"a")

--文件对象的创建
file = io.open("role.txt","w+");

while row do
    var = string.format("%d %s\n", row.id, row.name)

    print(var)

    file:write(var)

    row = cur:fetch(row,"a")
end


file:close()  --关闭文件对象
conn:close()  --关闭数据库连接
env:close()   --关闭数据库环境
--]]