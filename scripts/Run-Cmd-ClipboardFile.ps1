<#
  .SYNOPSIS
    Launches a program with files from the clipboard.
    �N���b�v�{�[�h�̃t�@�C�����g���ăv���O�������N�����܂��B

  .DESCRIPTION
    Launches a program with files from the clipboard.
    �N���b�v�{�[�h�̃t�@�C�����g���ăv���O�������N�����܂��B

  .PARAMETER Command
    The command to run.
    ���s����R�}���h�B
  
  .PARAMETER Mode
    The mode to run.
    ���s���[�h�B
    all: Run all files at once.
    all: ���ׂẴt�@�C������x�Ɏ��s���܂��B
    each_sequential: Run each file sequentially.
    each_sequential: �e�t�@�C�����������s���܂��B
    each_parallel: Run each file in parallel.
    each_parallel: �e�t�@�C�������Ɏ��s���܂��B

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
