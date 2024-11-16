<#
  .SYNOPSIS
    ps1�t�@�C�������s����V���[�g�J�b�g���쐬����B

  .DESCRIPTION
    ps1�t�@�C�������s����V���[�g�J�b�g���쐬����B

  .INPUTS
    None. You cannot pipe objects.

  .OUTPUTS
    None. does not generate any output.

  .EXAMPLE
    PS> .\Create-Shortcut.ps1
#>

$project_root = (Split-Path $PSScriptRoot -Parent)
$out_folder = $project_root + "\shortcuts"

# �t�H���_�����݂��Ȃ��ꍇ�͍쐬����
if (-not (Test-Path -Path $out_folder)) {
  New-Item -ItemType Directory -Path $out_folder | Out-Null
}

$ps1_files = Get-ChildItem -File $PSScriptRoot/*.ps1
foreach ($item in $ps1_files) {

  # �p�����[�^���擾
  $params = Get-Help $item -Parameter *
  $param_str = ""
  foreach ($param in $params) {
    $param_str += " -" + $param.Name
  }
  #Write-Output "param_str: $param_str"

  # �V���[�g�J�b�g�̃p�X���쐬
  $shortcut_path = $out_folder + "\" + $item.BaseName + ".lnk"
  Write-Host $shortcut_path
  $WsShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WsShell.CreateShortcut($shortcut_path)

  # �V���[�g�J�b�g�̃v���p�e�B��ݒ�
  $args_str = "-NoProfile -ExecutionPolicy Unrestricted scripts\" + $item.Name + $param_str
  $Shortcut.TargetPath = "powershell"
  $Shortcut.Arguments = $args_str
  $Shortcut.WorkingDirectory = $project_root
  $Shortcut.Save()
}
exit

