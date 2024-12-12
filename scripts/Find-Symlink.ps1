<#
  .SYNOPSIS
    �V���{���b�N�����N��������B

  .DESCRIPTION
    �V���{���b�N�����N��������B

  .INPUTS
    None. You cannot pipe objects.

  .OUTPUTS
    �V���{���b�N������Path���o�͂��܂��B

  .PARAMETER Path
    ��������Path�B

  .EXAMPLE
    PS> .\Find-Symlink.ps1 -Path "C:\example\path"
#>

param(
  [string]$Path
)

if (-Not (Test-Path -Path $Path)) {
  Write-Error "�w�肳�ꂽ�p�X�����݂��܂���: $Path"
  exit
}

# Recursively search for symbolic links in the specified path
Get-ChildItem -Path $Path -Recurse -Force | Where-Object { $_.Attributes -band [System.IO.FileAttributes]::ReparsePoint } | ForEach-Object {
  Write-Output $_.FullName
}