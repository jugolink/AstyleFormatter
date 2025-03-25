# Astyle 右键菜单格式化工具

这是一个为 Astyle 代码格式化工具添加 Windows 右键菜单选项的工具，让您可以一键格式化单个文件或整个目录（递归）。

## 功能特点

- 一键格式化单个文件或整个目录（递归）
- 使用 Astyle 的自动 .orig 备份文件功能
- 支持多种编程语言：C/C++/C#/Java/Python/JavaScript 等

## 安装说明

1. 确保 PowerShell 脚本（`AstyleRightClickFormatter.ps1`）和 Astyle 可执行文件（`astyle.exe`）在同一目录下
2. 以管理员身份运行 `Install_Astyle_RightClick.bat`

## 使用方法

### 格式化单个文件
1. 在 Windows 资源管理器中右键点击任何支持的代码文件
2. 从右键菜单中选择 "Format with Astyle"
3. 等待格式化完成
4. 原始文件会自动备份为 `filename.orig`

### 格式化目录
1. 在 Windows 资源管理器中右键点击任何目录
2. 从右键菜单中选择 "Format with Astyle"
3. 等待格式化完成
4. 目录中所有被格式化的文件都会有对应的 `.orig` 备份

### 清理备份文件
1. 在 Windows 资源管理器中右键点击任何目录
2. 从右键菜单中选择 "Clean Astyle Backup Files"
3. 等待清理完成
4. 该目录及其子目录下的所有 .orig 备份文件将被删除

## 卸载方法

要移除右键菜单项，以管理员身份运行 `Uninstall_Astyle_RightClick.bat`。

## 自定义格式化配置

您可以通过编辑 PowerShell 脚本中的 `$formatConfigs` 哈希表来自定义不同文件扩展名的格式化参数。

默认配置：

- C/C++ 文件：Allman 风格，4空格缩进，类和命名空间缩进，括号和运算符格式化等
- C# 文件：Allman 风格，4空格缩进
- Java 文件：Java 风格，4空格缩进
- Python 文件：基本格式化（Astyle 对 Python 的支持有限）
- JavaScript 文件：Google 风格，2空格缩进

### 参数详情

脚本中的 formatConfigs 包含各种格式化参数。以下是详细说明：

#### 样式参数

- `--style=allman`：Allman 风格（BSD 风格），括号单独一行
- `--style=java`：Java 风格，括号紧贴语句
- `--style=kr`：K&R 风格（Kernighan & Ritchie 风格），函数括号紧贴，其他括号分离
- `--style=stroustrup`：Stroustrup 风格，类似 K&R 但结束括号单独一行
- `--style=whitesmith`：Whitesmith 风格，括号与语句对齐并缩进
- `--style=google`：Google 风格，基于 Java 风格但具有特定的缩进规则
- `--style=mozilla`：Mozilla 风格，基于 Linux 风格但类和命名空间的括号样式不同
- `--style=linux`：Linux 风格，类似 K&R 但语句缩进一半
- `--style=horstmann`：Horstmann 风格，括号在同一行但下一行缩进

#### 缩进参数

- `--indent=spaces=4`：使用4个空格进行缩进
- `--indent=tab`：使用制表符进行缩进
- `--indent-classes`：缩进类定义体
- `--indent-switches`：缩进 switch 语句的 case 块
- `--indent-namespaces`：缩进命名空间体
- `--indent-preproc-block`：缩进预处理器块
- `--indent-preproc-define`：缩进多行 #define 语句

#### 格式化参数

- `--pad-oper`：在运算符周围添加空格（例如：`a = b` 而不是 `a=b`）
- `--pad-header`：在 if、for 等后添加空格（例如：`if (x)` 而不是 `if(x)`）
- `--unpad-paren`：移除括号内不必要的空格
- `--add-braces`：为未加括号的语句添加括号
- `--align-pointer=name`：将指针 * 靠近变量名（例如：`int *ptr` 而不是 `int* ptr`）

#### 模式参数

- `--mode=c`：C/C++ 模式
- `--mode=java`：Java 模式
- `--mode=cs`：C# 模式
- `--mode=js`：JavaScript 模式

### 常用参数组合

以下是一些根据个人或团队编码风格可以选择的常用参数组合：

#### Google 风格（适合 Web 开发）
```
--style=google --indent=spaces=2 --pad-oper --pad-header --unpad-paren
```

#### Linux 内核风格
```
--style=linux --indent=spaces=8 --indent-switches --pad-oper --unpad-paren --pad-header
```

#### Microsoft 风格（适合 C# 开发）
```
--style=allman --indent=spaces=4 --indent-classes --indent-switches --indent-namespaces --pad-oper --pad-header --unpad-paren --align-pointer=name --add-braces
```

#### Webkit 风格（适合浏览器开发）
```
--style=webkit --indent=spaces=4 --pad-oper --pad-header --unpad-paren --align-pointer=name
```

### 添加新的文件类型

要添加对新文件类型的支持，只需在脚本的 `$formatConfigs` 哈希表中添加新条目。例如，添加 TypeScript 支持：

```powershell
# 添加到 $formatConfigs 哈希表
".ts"   = "--style=google --indent=spaces=2 --pad-oper --pad-header --unpad-paren --mode=js";
```

保存脚本后，新配置将在下次运行时生效。

## 关于备份

- Astyle 会自动为每个格式化的文件创建一个带有 `.orig` 扩展名的备份文件
- 例如，格式化 `example.cpp` 后，原始文件将备份为 `example.cpp.orig`
- 如果备份文件已存在，Astyle 不会覆盖它

## 常见问题

**问：为什么安装需要管理员权限？**  
答：添加右键菜单项需要修改注册表，这需要管理员权限。

**问：如果我不喜欢格式化后的效果怎么办？**  
答：您可以编辑脚本中的格式化参数以匹配您的偏好。例如，如果您更喜欢 Java 风格的括号，可以将 `--style=allman` 改为 `--style=java`。

**问：如何防止 Astyle 格式化某些文件或代码块？**  
答：您可以在代码中添加特殊注释来禁用格式化：
- 禁用代码块：使用 `/*INDENT-OFF*/` 和 `/*INDENT-ON*/` 注释
- 禁用单行：在行尾添加 `/*NOPAD*/` 注释

**问：如何格式化其他类型的文件？**  
答：编辑脚本中的 `$formatConfigs` 哈希表，添加新的文件扩展名和对应的格式化参数。

**问：如何更改缩进大小？**  
答：修改所需文件类型配置中的 `--indent=spaces=4` 参数，将数字改为您喜欢的缩进大小。

## Astyle 参数参考

更多格式化选项，请参考 Astyle 官方文档：
- 运行 `astyle --help` 查看所有可用选项
- 访问 [Astyle 官方网站](http://astyle.sourceforge.net/) 获取详细文档 