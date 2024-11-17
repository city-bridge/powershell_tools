<#
  .SYNOPSIS
    Create a junction link to the file in the clipboard.
    クリップボードのファイルにジャンクションリンクを作成します。

  .DESCRIPTION
    Create a junction link to the file in the clipboard.
    クリップボードのファイルにジャンクションリンクを作成します。

  .INPUTS
    None. You cannot pipe objects.

  .OUTPUTS
    None. does not generate any output.

  .EXAMPLE
    PS> .\Run-Cmd-ClipboardFile2.ps1 -Command cat
#>

# Load SymlinkPattern.ps1
. ($PSScriptRoot + "\SymlinkPattern.ps1")

# Get Clipboard files
$files = Get-Clipboard -Format FileDropList -Raw
if ($null -eq $files) {
  Write-Output "No files in clipboard."
  Pause
  exit
}

$sym_pattern = New-Object SymlinkPattern

# Show input files and symlinks
Write-Output "input files"
foreach ($file in $files) {
  Write-Output "  file: $file"
  $link_to_path = $sym_pattern.SearchLinkToPath($file)
  if ($null -eq $link_to_path -or $link_to_path -eq "") {
    Write-Output "  symlink not found."
    Pause
    exit
  }
  Write-Output "  symlink: $link_to_path"
}

$yes_no = Read-Host "Please enter Yes or No(y/n):"
if ($yes_no -eq "Yes" -or $yes_no -eq "yes" -or $yes_no -eq "y") {
  foreach ($file in $files) {
    $result_mes = $sym_pattern.JunctionPath($file)
    Write-Output "  $result_mes"
  }
}
