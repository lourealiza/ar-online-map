$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$mapPath = Join-Path -Path $scriptDir -ChildPath '..'
$mapPath = Join-Path -Path $mapPath -ChildPath 'map.json'
$map = Get-Content -Raw -Path $mapPath | ConvertFrom-Json

# 1) Embed external TSX tileset into map.json (WorkAdventure requires embedded tilesets)
for($i=0; $i -lt $map.tilesets.Count; $i++){
  $ts = $map.tilesets[$i]
  if($ts.PSObject.Properties.Name -contains 'source'){
    $embedded = [pscustomobject]@{
      firstgid    = 1
      columns     = 8
      image       = 'tilesets/example-tiles.png'
      imageheight = 256
      imagewidth  = 256
      margin      = 0
      name        = 'example'
      spacing     = 0
      tilecount   = 64
      tileheight  = 32
      tilewidth   = 32
    }
    $map.tilesets[$i] = $embedded
  }
}

# 2) Ensure floorLayer (objectgroup) exists
if(-not ($map.layers | Where-Object { $_.type -eq 'objectgroup' -and $_.name -eq 'floorLayer' })){
  $floorLayer = [pscustomobject]@{
    id       = [int]$map.nextlayerid
    name     = 'floorLayer'
    type     = 'objectgroup'
    visible  = $true
    opacity  = 1
    objects  = @()
  }
  $map.layers += $floorLayer
  $map.nextlayerid = [int]$map.nextlayerid + 1
}

# 3) Ensure start (objectgroup) with at least one point exists
$startLayer = $map.layers | Where-Object { $_.type -eq 'objectgroup' -and $_.name -eq 'start' }
if(-not $startLayer){
  $startLayer = [pscustomobject]@{
    id       = [int]$map.nextlayerid
    name     = 'start'
    type     = 'objectgroup'
    visible  = $true
    opacity  = 1
    objects  = @()
  }
  $map.layers += $startLayer
  $map.nextlayerid = [int]$map.nextlayerid + 1
}
if(-not $startLayer.objects -or $startLayer.objects.Count -eq 0){
  $spawn = [pscustomobject]@{
    id      = [int]$map.nextobjectid
    name    = 'spawn'
    type    = 'point'
    point   = $true
    x       = 160
    y       = 128
    visible = $true
  }
  $startLayer.objects += $spawn
  $map.nextobjectid = [int]$map.nextobjectid + 1
}

$out = $map | ConvertTo-Json -Depth 100
Set-Content -Path $mapPath -Value $out -NoNewline
Write-Output 'Updated map for WA compatibility: embedded tileset, floorLayer, start layer.'

