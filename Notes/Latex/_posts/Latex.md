---
title: Latex
abbrlink: cd177453
---



[texLive](https://www.tug.org/texlive/acquire-ios.html)

线上编辑器：overleaf

```latex
\documentclass[UTF8]{ctexart}

\title{文章的标题}
\author{Aoi}
\date{\today}

\begin{document}

\maketitle
你好！！！

\end{document}
```

# 基础命令

命令格式：\命令名{ 参数 }

\documentclass[ 编码类型 ]{ 文档类型 } 

​	指定文档类型，常见命令参数有：

​		article：普通的文章

​		book、report等

​		beamer：幻灯片格式

​		ctexart：支持简体中文和英文的混排

​	编码类型：UTF8

注意：begin之前的内容被称为前言，在其中指定大小、导入的包、格式等等信息

\begin到\end之间的内容被称为Body，在这片区域中的所有内容将会被排版到最终生成的文档中

\title{}命令可以给文档设置一个标题

\author{}命令指定作者名字

\date{}命令生成最后更改日期

​	可以配合\today命令自动生成当天的日期  \date{\today}

要显示以上信息，需要在文档的正文区添加一个\maketitle命令，这个命令会在当前位置设置文档的标题，标题的内容就是前言区定义的信息

# 格式化命令

## \textbf{LaTex}

粗体，可以将大括号内的内容粗体化

bf：bold font的缩写

## \textit{}

斜体，it：italic

## \underline{}

下划线

## 换行符

单独一个换行符会形成一个空格，两个换行符会形成换行

## \section{章节名字}

表示开启一个新的章节

## \subsection{二级章节名字}

表示开启一个二级章节

## \subsubsection{}

开启一个三级章节

## \chapter{}

对书籍排版有效，比section更大

表示书籍中的第几章

## \part{}

对书籍排版有效，比part更大

表示书籍中的第几部

## 图片

在前言中引入graphicx包

```latex
\usepackage{graphicx}
```

在正文中使用\includegraphics{}命令在当前位置添加一张图片

```latex
\includegraphics[width = 0.5\textwidth]{图片相对路径}
```

其中，方括号中可选命令的含义是0.5倍的当前假面宽度，\textwidth命令表示当前命令宽度。

如果想给图片添加标题，可以将图片嵌套在figure环境，命令详解见下方代码

```latex
\begin{figure}
\centering  // 将图片居中显示
\includegraphics[width = 0.5\textwidth]{图片相对路径}
\caption{图片标题} // 指定图片标题
\end{figure}
```

## 列表

首先，创建列表环境，环境类似于作用域，任意一对begin和end中的内容表示同一个环境

### 无序列表(itemize)

```latex
\begin{itemize}
\item 列表项1
\item 列表项2
\item 列表项3
\end{itemize}
```

### 有序列表(enumerate)

```latex
 \begin{enumerate}
 \item 列表项1
 \item 列表项2
 \item 列表项3
 \end{enumerate}
```

## 数学公式

行内公式：单个$，例如：$E=mc^2$

整行公式：使用equation环境，也可以简写成\\[的格式

```latex
\begin{equation}

\end{equation}

\[

\]
```

[在线LaTeX公式编辑器](https://latex.codecogs.com/eqneditor/editor.php)

## 表格

tabular环境

```latex
\begin{tabular}{ c c c }
单元格1 & 单元格2 & 单元格3 \\
单元格4 & 单元格5 & 单元格6 \\
单元格7 & 单元格8 & 单元格9 
\end{tabular}
```

其中参数{c c c}表示共有3列，且每一列都是居中对齐，可以改成l或者r，表示左对齐或者右对齐

每一列的数据需要以&符号隔开，表格每一行的数据需要以\\\\分割

竖直方向的边框：{|c|c|c|}

水平方向的边框：\hline，加在环境中，输入两次可以添加双横线的效果

加入列宽：把c改成p，{ p{2cm} c c }

添加标题：先把表格放到table环境里，增加\caption{}命令指定表格标题，并增加\center命令使表格居中显示

```latex
\begin{table}
\center
\begin{tabular}{ | c | c | c | }

\end{tabular}
\caption{表格标题}
\end{table}
```



# latex资料

[一份不太简短的LaTeX 2ε 介绍](https://github.com/CTeX-org/lshort-zh-cn)

# VScode配置Latex环境

下载LaTeX Workshop插件

view latex打开文档的预览窗口，快捷键是Ctrl+Alt+V 