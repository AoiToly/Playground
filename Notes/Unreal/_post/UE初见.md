# UE初见

## 初始设置

### 缓存目录修改

1. epic game launcher设置中可以修改

2. 默认缓存路径在`C:\Users\18450\AppData\Local\UnrealEngine\Common\DerivedDataCache`中，路径下文件可全部删除

3. 找到引擎安装位置，打开`引擎版本\Engine\Config\BaseEngine.ini`文件，找到`%ENGINEVERSIONAGNOSTICUSERDIR%DerivedDataCache`，将其替换为`%GAMEDIR%DerivedDataCache`

目前尚不知道上述修改中1和3是否有什么区别

### 缩放比例设置

`Ctrl + Shift + w`

### 语言设置

`Edit->Editor Preferences`中可以找到language，建议英文，因为英文界面中的名称可以和C++的取名方式对应

## 快捷键

`Ctrl + 数字键`可以保存场景相机视角，后续可以通过按对应的数字键将场景切换到目标视角

`End`可以将方块贴合地面

选中多个物体之后，`Ctrl + G`可以打组，将这些物品变为一组，也可以在打组后按`Shift + G`取消打组

`Alt + 拖坐标轴`可以快捷复制

## 可用的蓝图Node

`DoOnce`只执行一次

`Flip Flop`翻转结点，事件A、B轮流触发

`Gate`门结点，可以手动控制事件是否触发

`MutliGate`，多门结点，按某种顺序触发事件

`Switch on Name`，根据名字switch，name是专门用于命名的text，会比string更高效

`Is Valid`，验证是否为null

## 一些用得到的结构

### 枚举

创建Enumeration

###  结构体

创建结构体后，可在蓝图中Break以获得其具体的数据

### 数据表格

类似于结构体数组

### 函数库、宏库

静态方法集合

## 蓝图间通信

dispatch event

接口

## 动画

Aim Offset: 用于射击游戏

Blend Space: 多段动画混合，如左转动画和前进动画混合成左45°前进动画

Animation Montage: 用于动画切换，如动画a播放过程中突然被打断，切换为动画

可以在角色蓝图的Detail面板中，在Pawn分支下找到修改角色控制的设置