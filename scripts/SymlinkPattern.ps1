class SymlinkPattern {
  [string] ConfigFilePath() {
    $project_root = (Split-Path $PSScriptRoot -Parent)
    return $project_root + "\config\symlink_pattern.json"
  }

  [string] LoadConfigText() {
    $config_path = $this.ConfigFilePath()
    return Get-Content -Path $config_path -Raw
  }

  [object] LoadConfig() {
    $content = $this.LoadConfigText()
    return ConvertFrom-Json $content
  }

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

  [string] SearchLinkToPath([string]$path) {
    $confs = $this.LoadConfig()
    $file_name = $path | Split-Path -Leaf
    foreach ($conf in $confs.patterns) {
      $match = [regex]::Matches($file_name, $conf.pattern)
      if ($match.Length -gt 0) {
        return $conf.symlink_to
      }
    }
    return $null
  }

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
