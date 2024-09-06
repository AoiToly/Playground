[官方文档](https://learn.microsoft.com/zh-cn/powershell/scripting/how-to-use-docs?view=powershell-7.3)

## 注释

```powershell
<#
.Description
This script performs a series of network connection tests.
#>
```

## 相对路径格式

PowerShell 使用以下字符序列来指定相对路径。

- `.` () - 当前位置
- `..` () - 当前位置的父级
- `\` () - 当前位置的根

以下示例基于当前设置为 `C:\Windows`的工作目录。

- 相对路径 `.\System` 解析为 `C:\Windows\System`
- 相对路径 `..\Program Files` 解析为 `C:\Program Files`
- 相对路径 `\Program Files` 解析为 `C:\Program Files`
- 相对路径 `System` 解析为 `C:\Windows\System`

## 使用文件和文件夹

### 列出某个文件夹内的所有文件和文件夹

可以使用 `Get-ChildItem` 直接获取文件夹中的所有项。 添加可选的 **Force** 参数以显示隐藏项或系统项。 例如，该命令直接显示 PowerShell 驱动器 `C:` 的内容。

```powershell
Get-ChildItem -Path C:\ -Force
```

此命令只列出直接包含的项，非常类似于在 `cmd.exe` 中使用 `dir` 命令或在 UNIX shell 中使用 `ls`。 为了显示子文件夹中的项，需要指定 Recurse 参数。 下面的命令列出了 `C:` 驱动器上的所有内容：

```powershell
Get-ChildItem -Path C:\ -Force -Recurse
```

`Get-ChildItem` 可以使用 Path 、Filter 、Include 和 Exclude 参数来筛选项，但这些通常只以名称为依据。 使用 `Where-Object`，还可以执行基于项的其他属性的复杂筛选。

下面的命令用于查找上次于 2005 年 10 月 1 日之后修改，并且不小于 1 兆字节，也不大于 10 兆字节的 Program Files 文件夹中的所有可执行文件：

```powershell
Get-ChildItem -Path $env:ProgramFiles -Recurse -Include *.exe |
    Where-Object -FilterScript {
        ($_.LastWriteTime -gt '2005-10-01') -and ($_.Length -ge 1mb) -and ($_.Length -le 10mb)
    }
```

### 复制文件和文件夹

复制通过 `Copy-Item` 完成。 下面的命令将 `C:\boot.ini` 备份到 `C:\boot.bak`：

```powershell
Copy-Item -Path C:\boot.ini -Destination C:\boot.bak
```

如果目标文件已存在，则复制尝试失败。 若要覆盖预先存在的目标，请使用 Force 参数 ：

```powershell
Copy-Item -Path C:\boot.ini -Destination C:\boot.bak -Force
```

即使当目标为只读时，该命令也有效。

复制文件夹的操作方式与此相同。 以下命令以递归方式将文件夹 `C:\temp\test1` 复制到新文件夹 `C:\temp\DeleteMe`：

```powershell
Copy-Item C:\temp\test1 -Recurse C:\temp\DeleteMe
```

还可以复制选定的项。 下面的命令将 `C:\data` 中任意位置包含的所有 `.txt` 文件都复制到 `C:\temp\text`：

```powershell
Copy-Item -Filter *.txt -Path c:\data -Recurse -Destination C:\temp\text
```

你仍然可以使用其他工具执行文件系统复制。 XCOPY、ROBOCOPY 和 COM 对象（如 Scripting.FileSystemObject）都适用于 PowerShell。 例如，可以使用 Windows 脚本宿主 Scripting.FileSystem COM 类将 `C:\boot.ini` 备份到 `C:\boot.bak`：

```powershell
(New-Object -ComObject Scripting.FileSystemObject).CopyFile('C:\boot.ini', 'C:\boot.bak')
```

### 创建文件和文件夹

创建新项的操作方式在所有 PowerShell 提供程序上都是一样的。 如果某个 PowerShell 提供程序具有多个类型的项（例如，用于区分目录和文件的 FileSystem PowerShell 提供程序），则需要指定项类型。

以下命令新建文件夹 `C:\temp\New Folder`：

```powershell
New-Item -Path 'C:\temp\New Folder' -ItemType Directory
```

以下命令新建空的文件 `C:\temp\New Folder\file.txt`

```powershell
New-Item -Path 'C:\temp\New Folder\file.txt' -ItemType File
```

- **结合使用 Force 开关与 `New-Item` 命令来创建文件夹时，如果文件夹已存在，则不会 覆盖或替换此文件夹。 它会直接返回现有的文件夹对象。 不过，如果对已存在的文件使用 `New-Item -Force`，该文件会被覆盖。**

### 删除某个文件夹内的所有文件和文件夹

可以使用 `Remove-Item` 来删除包含的项，但如果项包含其他任何内容，系统就会提示你确认是否要删除。 例如，如果尝试删除包含其他项的文件夹 `C:\temp\DeleteMe`，在删除此文件夹前，PowerShell 会提示你确认是否要删除：

```
Remove-Item -Path C:\temp\DeleteMe

Confirm
The item at C:\temp\DeleteMe has children and the Recurse parameter wasn't
specified. If you continue, all children will be removed with the item. Are you
sure you want to continue?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
(default is "Y"):
```

如果不希望系统针对每个包含的项都提示你，则指定 Recurse 参数：

```powershell
Remove-Item -Path C:\temp\DeleteMe -Recurse
```

## 文件删除

懒得整理，查接口文档[Remove-Item (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/remove-item?view=powershell-7.3)

## 使用bat文件执行PowerShell指令

参考资料：[通过bat运行powershell 脚本_bat启动powershell_wangteng13的博客-CSDN博客](https://blog.csdn.net/wangteng13/article/details/109157273)

powershell 的脚本一般为ps1后缀，直接双击是无法运行，一般是结合bat文件来配合运行。

```
# %temp%\test.ps1 为实际脚本目录
powershell -executionpolicy remotesigned -file "%temp%\test.ps1"
```


这样实际在用的时候，还有个问题就是，需要把2个文件都拷贝过去，这样才能使用。针对这个问题，可以通过在bat里写好脚本，之后通过bat生成ps1脚本，并运行实际代码

```
echo $computer="%cname%" > "%temp%\test.ps1"
for /f "delims=:" %%i in ('findstr /n "^:JoinDomain$" "%~f0"') do (
	more +%%i "%~f0" >> "%temp%\test.ps1"
)
powershell -executionpolicy remotesigned -file "%temp%\test.ps1"
pause
:JoinDomain
::这块直接填写对应的ps1脚本内容即可。
```

