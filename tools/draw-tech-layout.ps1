$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$mapPath = Join-Path -Path $scriptDir -ChildPath '..'
$mapPath = Join-Path -Path $mapPath -ChildPath 'map.json'
$map = Get-Content -Raw -Path $mapPath | ConvertFrom-Json

$width = [int]$map.width
$height = [int]$map.height

function New-Grid($w,$h){
  $row = (1..$w | ForEach-Object { 0 })
  $grid = @()
  for($y=0;$y -lt $h;$y++){ $grid += ,($row.Clone()) }
  return ,$grid
}
function Grid-ToCsv($grid){
  ($grid | ForEach-Object { ($_ -join ',') }) -join "`n"
}
function Rect-To-Tiles($x,$y,$w,$h){
  $tx=[int]([math]::Floor($x/32)); $ty=[int]([math]::Floor($y/32));
  $tw=[int]([math]::Ceiling($w/32)); $th=[int]([math]::Ceiling($h/32));
  return @{ x=$tx; y=$ty; w=$tw; h=$th }
}

# Create or get layers
$corridors = $map.layers | Where-Object { $_.type -eq 'tilelayer' -and $_.name -eq 'corridors' }
if(-not $corridors){
  $corridors = [pscustomobject]@{ id=($map.nextlayerid); name='corridors'; type='tilelayer'; width=$width; height=$height; opacity=1; visible=$true; encoding='csv'; data='' }
  $map.nextlayerid = [int]$map.nextlayerid + 1
  $map.layers += $corridors
}
$walls = $map.layers | Where-Object { $_.type -eq 'tilelayer' -and $_.name -eq 'walls' }
if(-not $walls){
  $walls = [pscustomobject]@{ id=($map.nextlayerid); name='walls'; type='tilelayer'; width=$width; height=$height; opacity=1; visible=$true; encoding='csv'; data='' }
  $map.nextlayerid = [int]$map.nextlayerid + 1
  $map.layers += $walls
}
$doors = $map.layers | Where-Object { $_.type -eq 'tilelayer' -and $_.name -eq 'doors' }
if(-not $doors){
  $doors = [pscustomobject]@{ id=($map.nextlayerid); name='doors'; type='tilelayer'; width=$width; height=$height; opacity=1; visible=$true; encoding='csv'; data='' }
  $map.nextlayerid = [int]$map.nextlayerid + 1
  $map.layers += $doors
}

$gCorr = New-Grid $width $height
$gWalls = New-Grid $width $height
$gDoors = New-Grid $width $height

# Draw main corridors (tile 3)
$mainCol = [int]([math]::Floor($width/2))  # central vertical
for($y=0;$y -lt $height;$y++){ $gCorr[$y][$mainCol] = 3 }
$rows = @(5,13,21,27) | Where-Object { $_ -lt $height }
foreach($r in $rows){ for($x=0;$x -lt $width;$x++){ $gCorr[$r][$x] = 3 } }

# Build walls around areas (tile 2) and doors (tile 4)
$areasLayer = $map.layers | Where-Object { $_.type -eq 'objectgroup' -and $_.name -eq 'areas' }
$majorAreas = @()
foreach($obj in $areasLayer.objects){
  $w=[int]$obj.width; $h=[int]$obj.height
  if($w -ge 96 -and $h -ge 64){ $majorAreas += $obj }
}
foreach($obj in $majorAreas){
  $r = Rect-To-Tiles $obj.x $obj.y $obj.width $obj.height
  $x0=$r.x; $y0=$r.y; $x1=[math]::Min($width-1,$r.x+$r.w-1); $y1=[math]::Min($height-1,$r.y+$r.h-1)
  for($x=$x0; $x -le $x1; $x++){ $gWalls[$y0][$x]=2; $gWalls[$y1][$x]=2 }
  for($y=$y0; $y -le $y1; $y++){ $gWalls[$y][$x0]=2; $gWalls[$y][$x1]=2 }
  # door towards main corridor: choose side nearest to mainCol
  $centerX = [int]([math]::Floor(($x0+$x1)/2))
  $centerY = [int]([math]::Floor(($y0+$y1)/2))
  if($centerX -lt $mainCol){ $dx = $x1+1 } else { $dx = $x0-1 }
  $dy = $rows | Sort-Object { [math]::Abs($_ - $centerY) } | Select-Object -First 1
  if($dx -ge 0 -and $dx -lt $width){ $gDoors[$centerY][$dx] = 4 }
  if($dy -ge 0 -and $dy -lt $height){ $gDoors[$dy][$centerX] = 4 }
}

$corridors.data = Grid-ToCsv $gCorr
$walls.data = Grid-ToCsv $gWalls
$doors.data = Grid-ToCsv $gDoors

$out = $map | ConvertTo-Json -Depth 100
Set-Content -Path $mapPath -Value $out -NoNewline
Write-Output 'Drawn tech-themed corridors (tile 3), walls (tile 2), doors (tile 4)'
