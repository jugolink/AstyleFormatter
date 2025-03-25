# Astyle Right-Click Menu Formatting Tool

This is a tool that adds Windows right-click menu options for the Astyle code formatter, allowing you to easily format single files or entire directories (recursively) with a single click.

## Astyle Version 
- 3.6.7-x64

## Features

- One-click formatting for single files or entire directories (recursive)
- Uses Astyle's automatic .orig backup files
- Supports multiple languages: C/C++/C#/Java/Python/JavaScript, etc.

## Installation

1. Make sure the PowerShell script (`AstyleRightClickFormatter.ps1`) and the Astyle executable (`astyle.exe`) are in the same directory
2. Run `Install_Astyle_RightClick.bat` as administrator

## Usage

### Formatting a Single File
1. Right-click on any supported code file in Windows Explorer
2. Select "Format with Astyle" from the context menu
3. Wait for the formatting to complete
4. The original file will be automatically backed up as `filename.orig`

### Formatting a Directory
1. Right-click on any directory in Windows Explorer
2. Select "Format Directory with Astyle" from the context menu
3. Wait for the formatting to complete
4. All formatted files in the directory will have corresponding `.orig` backups

## Uninstallation

To remove the right-click menu items, run `Uninstall_Astyle_RightClick.bat` as administrator.

## Custom Formatting Configuration

You can customize formatting parameters by editing the `$formatConfigs` hashtable in the PowerShell script for different file extensions.

Default configurations:

- C/C++ files: Allman style, 4-space indentation, class and namespace indentation, bracket and operator formatting, etc.
- C# files: Allman style, 4-space indentation
- Java files: Java style, 4-space indentation
- Python files: Basic formatting (Astyle has limited Python support)
- JavaScript files: Google style, 2-space indentation

### Parameter Details

The formatConfigs in the script contains various formatting parameters. Here's a detailed explanation:

#### Style Parameters

- `--style=allman`: Allman style (BSD style), brackets on separate lines
- `--style=java`: Java style, brackets attached to statements
- `--style=kr`: K&R style (Kernighan & Ritchie style), function brackets attached, others detached
- `--style=stroustrup`: Stroustrup style, similar to K&R but with closing brackets alone on line
- `--style=whitesmith`: Whitesmith style, brackets aligned with statements and indented
- `--style=google`: Google style, based on Java style but with specific indentation rules
- `--style=mozilla`: Mozilla style, based on Linux style but different bracket style for classes and namespaces
- `--style=linux`: Linux style, similar to K&R but with statements indented by half
- `--style=horstmann`: Horstmann style, brackets on same line but indented on the next line

#### Indentation Parameters

- `--indent=spaces=4`: Use 4 spaces for indentation
- `--indent=tab`: Use tabs for indentation
- `--indent-classes`: Indent class definition bodies
- `--indent-switches`: Indent switch statement case blocks
- `--indent-namespaces`: Indent namespace bodies
- `--indent-preproc-block`: Indent preprocessor blocks
- `--indent-preproc-define`: Indent multi-line #define statements

#### Formatting Parameters

- `--pad-oper`: Add spaces around operators (e.g., `a = b` instead of `a=b`)
- `--pad-header`: Add spaces after if, for, etc. (e.g., `if (x)` instead of `if(x)`)
- `--unpad-paren`: Remove unnecessary spaces inside parentheses
- `--add-braces`: Add braces to unbraced statements
- `--align-pointer=name`: Align pointer * close to the variable name (e.g., `int *ptr` instead of `int* ptr`)

#### Mode Parameters

- `--mode=c`: C/C++ mode
- `--mode=java`: Java mode
- `--mode=cs`: C# mode
- `--mode=js`: JavaScript mode

### Common Parameter Combinations

Here are some common parameter combinations you can choose based on personal or team coding style:

#### Google Style (good for web development)
```
--style=google --indent=spaces=2 --pad-oper --pad-header --unpad-paren
```

#### Linux Kernel Style
```
--style=linux --indent=spaces=8 --indent-switches --pad-oper --unpad-paren --pad-header
```

#### Microsoft Style (good for C# development)
```
--style=allman --indent=spaces=4 --indent-classes --indent-switches --indent-namespaces --pad-oper --pad-header --unpad-paren --align-pointer=name --add-braces
```

#### Webkit Style (for browser development)
```
--style=webkit --indent=spaces=4 --pad-oper --pad-header --unpad-paren --align-pointer=name
```

### Adding New File Types

To add support for new file types, simply add a new entry to the `$formatConfigs` hashtable in the script. For example, to add TypeScript support:

```powershell
# Add to the $formatConfigs hashtable
".ts"   = "--style=google --indent=spaces=2 --pad-oper --pad-header --unpad-paren --mode=js";
```

Save the script, and the new configuration will take effect the next time you run it.

## About Backups

- Astyle automatically creates a backup file with the `.orig` extension for each formatted file
- For example, after formatting `example.cpp`, the original file will be backed up as `example.cpp.orig`
- If a backup file already exists, Astyle will not overwrite it

## Frequently Asked Questions

**Q: Why do I need administrator privileges to install?**  
A: Adding right-click menu items requires registry modifications, which need administrator privileges.

**Q: What if I don't like how the formatting looks?**  
A: You can edit the formatting parameters in the script to match your preferences. For example, if you prefer Java-style brackets, change `--style=allman` to `--style=java`.

**Q: How can I prevent Astyle from formatting certain files or code blocks?**  
A: You can add special comments in your code to disable formatting:
- Disable for a code block: Use `/*INDENT-OFF*/` and `/*INDENT-ON*/` comments
- Disable for a single line: Add `/*NOPAD*/` comment at the end of the line

**Q: How do I format other types of files?**  
A: Edit the `$formatConfigs` hashtable in the script to add new file extensions and their corresponding formatting parameters.

**Q: How do I change the indentation size?**  
A: Modify the `--indent=spaces=4` parameter in the configuration for the desired file type, changing the number to your preferred indentation size.

## Astyle Parameter Reference

For more formatting options, refer to the Astyle official documentation:
- Run `astyle --help` to see all available options
- Visit [Astyle official website](http://astyle.sourceforge.net/) for detailed documentation 