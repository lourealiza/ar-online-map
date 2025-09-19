$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$path = Join-Path -Path $scriptDir -ChildPath '..'
$path = Join-Path -Path $path -ChildPath 'map.json'
$json = Get-Content -Raw -Path $path | ConvertFrom-Json
$floor = $json.layers | Where-Object { $_.name -eq 'floor' -and $_.type -eq 'tilelayer' }
if (-not $floor) { throw 'floor layer not found' }
$w = [int]$floor.width
$h = [int]$floor.height
$row = ((1..($w-1) | ForEach-Object { '1' }) -join ',') + ',1'
$data = ((1..$h | ForEach-Object { $row }) -join '\n')
$floor.data = $data
$out = $json | ConvertTo-Json -Depth 100
Set-Content -Path $path -Value $out -NoNewline
Write-Output "Filled floor layer ${w}x${h} with tile 1"
