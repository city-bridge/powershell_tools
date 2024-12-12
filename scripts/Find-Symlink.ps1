<#
  .SYNOPSIS
    シンボリックリンク検索する。

  .DESCRIPTION
    シンボリックリンク検索する。

  .INPUTS
    None. You cannot pipe objects.

  .OUTPUTS
    シンボリックリンのPathを出力します。

  .PARAMETER Path
    検索するPath。

  .EXAMPLE
    PS> .\Find-Symlink.ps1 -Path "C:\example\path"
#>

param(
  [string]$Path
)

if (-Not (Test-Path -Path $Path)) {
  Write-Error "指定されたパスが存在しません: $Path"
  exit
}

# Recursively search for symbolic links in the specified path
Get-ChildItem -Path $Path -Recurse -Force | Where-Object { $_.Attributes -band [System.IO.FileAttributes]::ReparsePoint } | ForEach-Object {
  Write-Output $_.FullName
}