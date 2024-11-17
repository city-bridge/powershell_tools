class SymlinkPattern {
  # ConfigFilePath���\�b�h�́A�v���W�F�N�g�̃��[�g�f�B���N�g������ݒ�t�@�C���̃p�X��Ԃ��܂��B
  [string] ConfigFilePath() {
    $project_root = (Split-Path $PSScriptRoot -Parent)
    return $project_root + "\config\symlink_pattern.json"
  }

  # LoadConfigText���\�b�h�́A�ݒ�t�@�C���̓��e���e�L�X�g�Ƃ��ēǂݍ��݂܂��B
  [string] LoadConfigText() {
    $config_path = $this.ConfigFilePath()
    return Get-Content -Path $config_path -Raw
  }

  # LoadConfig���\�b�h�́A�ݒ�t�@�C���̓��e���I�u�W�F�N�g�ɕϊ����ĕԂ��܂��B
  [object] LoadConfig() {
    $content = $this.LoadConfigText()
    return ConvertFrom-Json $content
  }

  # SearchConfig���\�b�h�́A�w�肳�ꂽ�p�X�Ɉ�v����ݒ���������ĕԂ��܂��B
  [object] SearchConfig([string]$path) {
    $confs = $this.LoadConfig()
    $file_name = $path | Split-Path -Leaf
    foreach ($conf in $confs.patterns) {
      $match = [regex]::Matches($file_name, $conf.pattern)
      if ($match.Length -gt 0) {
        return $conf
      }
    }
    return $null
  }

  # SearchLinkToPath���\�b�h�́A�w�肳�ꂽ�p�X�Ɉ�v����V���{���b�N�����N�̃p�X���������ĕԂ��܂��B
  [string] SearchLinkToPath([string]$path) {
    $confs = $this.LoadConfig()
    $file_name = $path | Split-Path -Leaf
    foreach ($conf in $confs.patterns) {
      $match = [regex]::Matches($file_name, $conf.pattern)
      if ($match.Length -gt 0) {
        return $conf.symlink_to
      }

      $parent_name = $path | Split-Path -Parent | Split-Path -Leaf
      $match = [regex]::Matches($parent_name, $conf.pattern)
      if ($match.Length -gt 0) {
        return $conf.symlink_to
      }
    }
    return $null
  }

  # JunctionPath���\�b�h�́A�w�肳�ꂽ�^�[�Q�b�g�p�X�ɑ΂��ăW�����N�V�������쐬���܂��B
  [string] JunctionPath([string]$target) {
    Write-Debug "path: $target"
    $conf = $this.SearchConfig($target)
    if ($null -eq $conf) {
      return "config not found."
    }
    $path = $conf.symlink_to

    if ((Test-Path -Path $path)) {
      [IO.FileSystemInfo]$path_info = Get-Item $path
      if ($path_info.Attributes -like "*ReparsePoint*") {
        if ($conf.delete_and_link) {
          $path_info.Delete()
        }
        else {
          return "already linked $path"
        }
      }
      else {
        return "path already exists $path"
      }
    }
    #New-Item -ItemType SymbolicLink -Path $path -Value $target
    New-Item -ItemType Junction -Path $path -Value $target
    return "ok"
  }
}
