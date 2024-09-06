---
abbrlink: '0'
---
# Apex 开镜灵敏度统一

参考教程：[「APEX」超简单的统一开镜灵敏度 让所有倍镜拉枪统一手感_APEX英雄_教程 (bilibili.com)](https://www.bilibili.com/video/BV1cg411K7dt/?spm_id_from=333.337.search-card.all.click&vd_source=b15701b391138cb0fc7af5c3cf24873d)

## 2.5K分辨率游戏内Fov为110时开镜灵敏度

```
1 1.1642
2 1.429
3 1.5359
4 1.5769
6 1.6074
8 1.6183
10 1.6235
```

## 方法一（较为复杂）：

打开文件夹，输入地址：

```
%USERPROFILE%\Saved Games\Respawn\Apex\profile\profile.cfg
```

找到cl_fovScale参数

```
cl_fovScale "1.55"
```

打开网址：

```
https://jscalc.io/embed/Q1gf45VCY4tmm2dq
```

其中，Field of View Input Units可以设置为In-game或Config File(cl_fovScale)，前者为Apex游戏设置中的fov，后者为cl_fovScale，并据此输入对应的fov

根据计算公式以及网站右侧的数据表，可以得到各倍镜的灵敏度：

```
倍镜灵敏度 = 倍镜HFOV / 腰射HFOV * 放大系数（Magnification）
```

打开文件夹，输入地址：

```
%USERPROFILE%\Saved Games\Respawn\Apex\local\settings.cfg
```

找到

```
mouse_zoomed_sensitivity_scalar
```

其中0 - 6分别表示1 、2、3、4、6、8、10倍镜，将得到的结果依次输入即可

## 方法二（究极暴力版）：

打开Aim lab，打开设置-控制

选择Apex，并调整灵敏度和视野范围使其和游戏内一致，其单位可以选择游戏内，也可以选择配置文件

将灵敏度选项和视野范围选项改为进阶

将瞄具射击缩放改成显示器距离，并把下面水平距离（H）的 数值改成100

将瞄具射击档案改成对应的倍镜，即可看到统一后的倍镜灵敏度是多少

