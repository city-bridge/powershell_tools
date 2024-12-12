<#
  .SYNOPSIS
    �V���{���b�N�����N�������폜����B

  .DESCRIPTION
    �V���{���b�N�����N�������폜����B

  .INPUTS
    None. You cannot pipe objects.

  .OUTPUTS
    None. does not generate any output.

  .PARAMETER Path
    ��������Path�B

  .EXAMPLE
    PS> .\Remove-Symlink.ps1 -Path "C:\example\path"
#>

param(
  [string]$Path
)

if (-Not (Test-Path -Path $Path)) {
  Write-Error "�w�肳�ꂽ�p�X�����݂��܂���: $Path"
  exit
}

Get-ChildItem -Path $Path -Recurse -Force | Where-Object { $_.Attributes -band [System.IO.FileAttributes]::ReparsePoint } | ForEach-Object {
  $yes_no = Read-Host "Remove-Item -Path "  $_.FullName  " -Force. Please enter Yes or No(y/n):"
  if ($yes_no -eq "Yes" -or $yes_no -eq "yes" -or $yes_no -eq "y") {
    $_.Delete()
  }
}