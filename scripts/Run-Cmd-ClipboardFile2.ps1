<#
  .SYNOPSIS
    Launches a program with files from the clipboard.
    クリップボードのファイルを使ってプログラムを起動します。

  .DESCRIPTION
    Launches a program with files from the clipboard.
    クリップボードのファイルを使ってプログラムを起動します。

  .PARAMETER Command
    The command to run.
    実行するコマンド。

  .INPUTS
    None. You cannot pipe objects.

  .OUTPUTS
    None. does not generate any output.

  .EXAMPLE
    PS> .\Run-Cmd-ClipboardFile2.ps1 -Command cat
#>
param(
  [string]$Command
)
if ($null -eq $Command -or "" -eq $Command) {
  Get-Help $MyInvocation.MyCommand.Definition
  Pause
  exit
}

Write-Output "cmd: $Command"

$files = Get-Clipboard -Format FileDropList -Raw
if ($null -eq $files) {
  Write-Output "No files in clipboard."
  Pause
  exit
}

Write-Output "input files"
foreach ($file in $files) {
  Write-Output "  file: $file"
}

$yes_no = Read-Host "Please enter Yes or No(y/n):"
if ($yes_no -eq "Yes" -or $yes_no -eq "yes" -or $yes_no -eq "y") {
  foreach ($file in $files) {
    Start-Process -FilePath $Command -ArgumentList $file
  }
}
