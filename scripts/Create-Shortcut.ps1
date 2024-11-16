<#
  .SYNOPSIS
    ps1ファイルを実行するショートカットを作成する。

  .DESCRIPTION
    ps1ファイルを実行するショートカットを作成する。

  .INPUTS
    None. You cannot pipe objects.

  .OUTPUTS
    None. does not generate any output.

  .EXAMPLE
    PS> .\Create-Shortcut.ps1
#>

$project_root = (Split-Path $PSScriptRoot -Parent)
$out_folder = $project_root + "\shortcuts"

# フォルダが存在しない場合は作成する
if (-not (Test-Path -Path $out_folder)) {
  New-Item -ItemType Directory -Path $out_folder | Out-Null
}

$ps1_files = Get-ChildItem -File $PSScriptRoot/*.ps1
foreach ($item in $ps1_files) {

  # パラメータを取得
  $params = Get-Help $item -Parameter *
  $param_str = ""
  foreach ($param in $params) {
    $param_str += " -" + $param.Name
  }
  #Write-Output "param_str: $param_str"

  # ショートカットのパスを作成
  $shortcut_path = $out_folder + "\" + $item.BaseName + ".lnk"
  Write-Host $shortcut_path
  $WsShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WsShell.CreateShortcut($shortcut_path)

  # ショートカットのプロパティを設定
  $args_str = "-NoProfile -ExecutionPolicy Unrestricted scripts\" + $item.Name + $param_str
  $Shortcut.TargetPath = "powershell"
  $Shortcut.Arguments = $args_str
  $Shortcut.WorkingDirectory = $project_root
  $Shortcut.Save()
}
exit

