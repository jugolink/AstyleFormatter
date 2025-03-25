#=============================================================================
# Astyle Right-Click Menu Formatting Tool
# Features:
# 1. One-click formatting for single files or directories (recursive)
# 2. Uses Astyle's automatic .orig backup files
# 3. Clean .orig backup files option
# Supported languages: C/C++/C#/Java/Python, etc.
#=============================================================================

# Parameter handling
param (
    [string]$Format,
    [switch]$Register,
    [switch]$Unregister,
    [switch]$Clean
)

#=============================================================================
# Configuration Parameters
#=============================================================================
# Astyle path, using the parent directory of the scripts directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$astylePath = Join-Path -Path (Split-Path -Parent $scriptPath) -ChildPath "astyle.exe"

# Supported file extensions and their formatting parameters
$formatConfigs = @{
    # C/C++ files
    ".c"    = "--style=allman --indent=spaces=4 --indent-classes --indent-switches --indent-namespaces --indent-preproc-block --indent-preproc-define --pad-oper --pad-header --unpad-paren --align-pointer=name --add-braces --mode=c";
    ".cpp"  = "--style=allman --indent=spaces=4 --indent-classes --indent-switches --indent-namespaces --indent-preproc-block --indent-preproc-define --pad-oper --pad-header --unpad-paren --align-pointer=name --add-braces --mode=c";
    ".h"    = "--style=allman --indent=spaces=4 --indent-classes --indent-switches --indent-namespaces --indent-preproc-block --indent-preproc-define --pad-oper --pad-header --unpad-paren --align-pointer=name --add-braces --mode=c";
    ".hpp"  = "--style=allman --indent=spaces=4 --indent-classes --indent-switches --indent-namespaces --indent-preproc-block --indent-preproc-define --pad-oper --pad-header --unpad-paren --align-pointer=name --add-braces --mode=c";
    
    # C# files
    ".cs"   = "--style=allman --indent=spaces=4 --indent-classes --indent-switches --indent-namespaces --pad-oper --pad-header --unpad-paren --align-pointer=name --add-braces --mode=cs";
    
    # Java files
    ".java" = "--style=java --indent=spaces=4 --indent-classes --indent-switches --pad-oper --pad-header --unpad-paren --add-braces --mode=java";
    
    # Python files (Astyle has limited Python support, but can do basic formatting)
    ".py"   = "--style=allman --indent=spaces=4 --pad-oper --pad-header --unpad-paren";

    # JavaScript files
    ".js"   = "--style=google --indent=spaces=2 --pad-oper --pad-header --unpad-paren --mode=js";
}

#=============================================================================
# Functional Methods
#=============================================================================

# Format a single file
function Format-SingleFile {
    param (
        [string]$FilePath
    )
    
    $extension = [System.IO.Path]::GetExtension($FilePath).ToLower()
    
    # Check if this extension is supported
    if ($formatConfigs.ContainsKey($extension)) {
        $formatParams = $formatConfigs[$extension]
        
        # Execute formatting
        $cmd = "& '$astylePath' $formatParams '$FilePath'"
        Write-Host "Formatting file: $FilePath" -ForegroundColor Yellow
        Write-Host "Using parameters: $formatParams" -ForegroundColor Gray
        Invoke-Expression $cmd
        
        return $true
    } else {
        Write-Host "Unsupported file type: $extension, skipping file: $FilePath" -ForegroundColor Yellow
        Write-Host "Supported extensions: $($formatConfigs.Keys -join ', ')" -ForegroundColor Gray
        return $false
    }
}

# Recursively format files in a directory
function Format-Directory {
    param (
        [string]$DirectoryPath
    )
    
    Write-Host "Processing directory: $DirectoryPath" -ForegroundColor Cyan
    Write-Host "Searching for supported code files..." -ForegroundColor Yellow
    
    $files = Get-ChildItem -Path $DirectoryPath -Recurse -File
    $formattedCount = 0
    $totalCount = 0
    $skippedFiles = @()
    
    foreach ($file in $files) {
        $extension = $file.Extension.ToLower()
        if ($formatConfigs.ContainsKey($extension)) {
            $totalCount++
            $result = Format-SingleFile -FilePath $file.FullName
            if ($result) {
                $formattedCount++
            } else {
                $skippedFiles += $file.Name
            }
        }
    }
    
    Write-Host "`nDirectory formatting complete: $DirectoryPath" -ForegroundColor Green
    Write-Host "Summary:" -ForegroundColor Cyan
    Write-Host "- Total files found: $totalCount" -ForegroundColor White
    Write-Host "- Successfully formatted: $formattedCount" -ForegroundColor Green
    if ($totalCount -gt $formattedCount) {
        Write-Host "- Skipped/Failed: $($totalCount - $formattedCount)" -ForegroundColor Yellow
        if ($skippedFiles.Count -gt 0) {
            Write-Host "`nSkipped files:" -ForegroundColor Yellow
            foreach ($file in $skippedFiles) {
                Write-Host "- $file" -ForegroundColor Gray
            }
        }
    }
}

# Clean .orig backup files
function Clean-OrigFiles {
    param (
        [string]$Path
    )
    
    Write-Host "Searching for .orig backup files in: $Path" -ForegroundColor Cyan
    
    if (Test-Path -Path $Path -PathType Leaf) {
        # It's a file, check if it's a .orig file
        if ($Path.EndsWith('.orig', [StringComparison]::OrdinalIgnoreCase)) {
            Remove-Item -Path $Path -Force
            Write-Host "Deleted: $Path" -ForegroundColor Yellow
        }
    } else {
        # It's a directory, search recursively
        $origFiles = Get-ChildItem -Path $Path -Recurse -Filter "*.orig"
        $count = 0
        foreach ($file in $origFiles) {
            Remove-Item -Path $file.FullName -Force
            Write-Host "Deleted: $($file.FullName)" -ForegroundColor Yellow
            $count++
        }
        
        Write-Host "`nCleanup complete:" -ForegroundColor Green
        Write-Host "- Total .orig files deleted: $count" -ForegroundColor White
    }
}

#=============================================================================
# Main Program
#=============================================================================

# Check if Astyle exists
if (-not (Test-Path -Path $astylePath)) {
    Write-Host "Error: Astyle executable not found: $astylePath" -ForegroundColor Red
    Write-Host "Please make sure Astyle Formatter is properly installed." -ForegroundColor Red
    exit 1
}

# Execute operations based on parameters
if ($Register) {
    Write-Host "The registry operations are now handled by the installer." -ForegroundColor Yellow
    Write-Host "Please run the Astyle Formatter installer to set up the context menu." -ForegroundColor Yellow
    exit 0
}

if ($Unregister) {
    Write-Host "The registry operations are now handled by the installer." -ForegroundColor Yellow
    Write-Host "Please uninstall Astyle Formatter to remove the context menu." -ForegroundColor Yellow
    exit 0
}

if ($Clean) {
    # Clean .orig backup files
    if (Test-Path -Path $Format) {
        Clean-OrigFiles -Path $Format
    } else {
        Write-Host "Error: Path does not exist: $Format" -ForegroundColor Red
    }
    
    # Wait for user to press a key to exit
    Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 0
}

if ($Format) {
    # Format specified file or directory
    if (Test-Path -Path $Format) {
        # Format
        if (Test-Path -Path $Format -PathType Leaf) {
            # It's a file
            Write-Host "Processing single file mode" -ForegroundColor Cyan
            $result = Format-SingleFile -FilePath $Format
            if ($result) {
                Write-Host "`nFormatting complete: $Format" -ForegroundColor Green
                Write-Host "Original file has been backed up as: $Format.orig" -ForegroundColor Green
            } else {
                Write-Host "`nFormatting failed or skipped: $Format" -ForegroundColor Red
                Write-Host "Supported file types: $($formatConfigs.Keys -join ', ')" -ForegroundColor Yellow
            }
        } else {
            # It's a directory
            Format-Directory -DirectoryPath $Format
            Write-Host "Original files have been backed up with .orig extension" -ForegroundColor Green
        }
    } else {
        Write-Host "Error: Path does not exist: $Format" -ForegroundColor Red
    }
    
    # Wait for user to press a key to exit
    Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 0
}

# If no parameters specified, display help information
Write-Host "Astyle Right-Click Menu Formatting Tool" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "Usage:" -ForegroundColor White
Write-Host "  Right-click on any file or directory and select 'Format with Astyle'" -ForegroundColor White
Write-Host "  The script will automatically detect if it's a file or directory" -ForegroundColor White
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "Supported file types:" -ForegroundColor Yellow
Write-Host "  $($formatConfigs.Keys -join ', ')" -ForegroundColor White
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "Notes:" -ForegroundColor Yellow
Write-Host "  1. Astyle automatically creates backup files with .orig extension" -ForegroundColor Yellow
Write-Host "  2. Each file type has its own optimized formatting rules" -ForegroundColor Yellow