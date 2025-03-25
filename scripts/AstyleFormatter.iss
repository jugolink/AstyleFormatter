#define MyAppName "AstyleFormatter"
#define MyAppVersion "1.0.0"
#define MyAppVersionFull "1.0.0"
#define MyAppPublisher "Evek"
#define MyAppExeName "astyle-3.6.7-x64.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId in installers for other applications.
AppId={{A8B5E3D1-9C4F-4B2D-8E1A-7F3B2D1C4E5F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
VersionInfoVersion={#MyAppVersionFull}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription=Code formatter based on Astyle
VersionInfoCopyright=Copyright (C) 2024 {#MyAppPublisher}
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersionFull}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=..\scripts\Output
OutputBaseFilename=AstyleFormatter_{#MyAppVersion}_Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "chinesesimp"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Files]
Source: "..\astyle.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "AstyleRightClickFormatter.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "..\README_Astyle_Formatter.md"; DestDir: "{app}\"; Flags: ignoreversion
Source: "..\README_Astyle_Formatter_CN.md"; DestDir: "{app}\"; Flags: ignoreversion

[Registry]
; Register for files
Root: HKCR; Subkey: "*\shell\AstyleFormat"; ValueType: string; ValueName: ""; ValueData: "Format with Astyle"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\AstyleFormat"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\AstyleFormat\command"; ValueType: string; ValueName: ""; ValueData: "powershell.exe -ExecutionPolicy Bypass -File ""{app}\scripts\AstyleRightClickFormatter.ps1"" -Format ""%1"""; Flags: uninsdeletekey

; Register for directories
Root: HKCR; Subkey: "Directory\shell\AstyleFormat"; ValueType: string; ValueName: ""; ValueData: "Format with Astyle"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\AstyleFormat"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\AstyleFormat\command"; ValueType: string; ValueName: ""; ValueData: "powershell.exe -ExecutionPolicy Bypass -File ""{app}\scripts\AstyleRightClickFormatter.ps1"" -Format ""%1"""; Flags: uninsdeletekey

; Register cleanup option for directories
Root: HKCR; Subkey: "Directory\shell\AstyleClean"; ValueType: string; ValueName: ""; ValueData: "Clean Astyle Backup Files"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\AstyleClean"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\AstyleClean\command"; ValueType: string; ValueName: ""; ValueData: "powershell.exe -ExecutionPolicy Bypass -File ""{app}\scripts\AstyleRightClickFormatter.ps1"" -Clean -Format ""%1"""; Flags: uninsdeletekey

[UninstallDelete]
Type: filesandordirs; Name: "{app}\scripts"

[Code]
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
begin
  Result := True;
  // Check if running with administrator privileges
  if not IsAdminLoggedOn then
  begin
    if MsgBox('This installer requires administrator privileges. Do you want to restart with admin rights?', 
      mbConfirmation, MB_YESNO) = IDYES then
    begin
      ShellExec('runas', ExpandConstant('{srcexe}'), '', '', SW_SHOW, ewNoWait, ResultCode);
      Result := False;
    end
    else
      Result := False;
  end;
end; 