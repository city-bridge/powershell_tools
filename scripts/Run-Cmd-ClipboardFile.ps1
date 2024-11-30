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
  
  .PARAMETER Mode
    The mode to run.
    実行モード。
    all: Run all files at once.
    all: すべてのファイルを一度に実行します。
    each_sequential: Run each file sequentially.
    each_sequential: 各ファイルを順次実行します。
    each_parallel: Run each file in parallel.
    each_parallel: 各ファイルを並列に実行します。

  .INPUTS
    None. You cannot pipe objects.

  .OUTPUTS
    None. does not generate any output.

  .EXAMPLE
    PS> .\Run-Cmd-ClipboardFile.ps1 -Command cat
#>
param(
  [string]$Command,
  [ValidateSet("all","each_sequential","each_parallel")]$Mode
)
if ($null -eq $Command -or "" -eq $Command) {
  Get-Help $MyInvocation.MyCommand.Definition
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
  if ($Mode -eq "all") {
    Start-Process -FilePath $Command -ArgumentList $files
  }
  elseif ($Mode -eq "each_sequential") {
    foreach ($file in $files) {
      Start-Process -FilePath $Command -ArgumentList $file -Wait
    }
  }
  elseif ($Mode -eq "each_parallel") {
    foreach ($file in $files) {
      Start-Process -FilePath $Command -ArgumentList $file
    }
  }
  else {
    Write-Output "Invalid mode."
  }
}
