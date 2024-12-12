<#
  .SYNOPSIS
    シンボリックリンク検索し削除する。

  .DESCRIPTION
    シンボリックリンク検索し削除する。

  .INPUTS
    None. You cannot pipe objects.

  .OUTPUTS
    None. does not generate any output.

  .PARAMETER Path
    検索するPath。

  .EXAMPLE
    PS> .\Remove-Symlink.ps1 -Path "C:\example\path"
#>

param(
  [string]$Path
)

if (-Not (Test-Path -Path $Path)) {
  Write-Error "指定されたパスが存在しません: $Path"
  exit
}

Get-ChildItem -Path $Path -Recurse -Force | Where-Object { $_.Attributes -band [System.IO.FileAttributes]::ReparsePoint } | ForEach-Object {
  $yes_no = Read-Host "Remove-Item -Path "  $_.FullName  " -Force. Please enter Yes or No(y/n):"
  if ($yes_no -eq "Yes" -or $yes_no -eq "yes" -or $yes_no -eq "y") {
    $_.Delete()
  }
}