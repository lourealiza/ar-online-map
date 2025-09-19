$ErrorActionPreference = 'Stop'
$mapPath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath '..'
$mapPath = Join-Path -Path $mapPath -ChildPath 'map.json'
$map = Get-Content -Raw -Path $mapPath | ConvertFrom-Json

$areas = $map.layers | Where-Object { $_.type -eq 'objectgroup' -and $_.name -eq 'areas' }
$labels = $map.layers | Where-Object { $_.type -eq 'objectgroup' -and $_.name -eq 'labels' }
if (-not $areas) { throw 'areas layer not found' }
if (-not $labels) { throw 'labels layer not found' }

function New-Prop($name, $type, $value){
  return [pscustomobject]@{ name=$name; type=$type; value=$value }
}

$id = [int]$map.nextobjectid

# CEO suite zones
$newAreas = @()
$newAreas += [pscustomobject]@{ id=$id; name='MesaExecutiva1a1'; type='area'; x=1008; y=80; width=64; height=48; visible=$true; properties=@( New-Prop 'jitsiRoom' 'string' 'CEO_Mesa_1a1'; New-Prop 'jitsiWidth' 'int' 900; New-Prop 'jitsiTrigger' 'string' 'onaction' ) }; $id++
$newAreas += [pscustomobject]@{ id=$id; name='ReuniaoConvidado'; type='area'; x=1088; y=80; width=80; height=48; visible=$true; properties=@( New-Prop 'jitsiRoom' 'string' 'CEO_Convidado'; New-Prop 'jitsiWidth' 'int' 900; New-Prop 'jitsiTrigger' 'string' 'onaction' ) }; $id++
$newAreas += [pscustomobject]@{ id=$id; name='SalaConselho'; type='area'; x=960; y=208; width=256; height=160; visible=$true; properties=@( New-Prop 'jitsiRoom' 'string' 'SalaConselho'; New-Prop 'jitsiWidth' 'int' 1000; New-Prop 'jitsiTrigger' 'string' 'onaction' ) }; $id++
$newAreas += [pscustomobject]@{ id=$id; name='WarRoom'; type='area'; x=960; y=384; width=192; height=128; visible=$true; properties=@( New-Prop 'jitsiRoom' 'string' 'WarRoom'; New-Prop 'jitsiWidth' 'int' 900; New-Prop 'jitsiTrigger' 'string' 'onaction' ) }; $id++
$newAreas += [pscustomobject]@{ id=$id; name='EstudioVideo'; type='area'; x=960; y=528; width=192; height=96; visible=$true; properties=@( New-Prop 'openWebsite' 'string' 'https://app.loom.com/'; New-Prop 'openWebsiteTrigger' 'string' 'onaction' ) }; $id++
$newAreas += [pscustomobject]@{ id=$id; name='LoungeCEO'; type='area'; x=1168; y=528; width=96; height=96; visible=$true }; $id++
$newAreas += [pscustomobject]@{ id=$id; name='FocusBooth'; type='area'; x=1184; y=384; width=64; height=96; visible=$true; properties=@( New-Prop 'silent' 'bool' $true ) }; $id++

$areas.objects += $newAreas

# Labels for CEO suite
$newLabels = @()
$newLabels += [pscustomobject]@{ id=$id; name='MesaExecutivaLabel'; type='label'; x=1008; y=72; width=120; height=20; visible=$true; text=@{ text='Mesa Executiva (1:1)'; fontfamily='Arial'; pixelsize=12; wrap=$true; color='#000000' } }; $id++
$newLabels += [pscustomobject]@{ id=$id; name='ReuniaoConvidadoLabel'; type='label'; x=1088; y=72; width=140; height=20; visible=$true; text=@{ text='Reunião c/ Convidado'; fontfamily='Arial'; pixelsize=12; wrap=$true; color='#000000' } }; $id++
$newLabels += [pscustomobject]@{ id=$id; name='SalaConselhoLabel'; type='label'; x=960; y=200; width=200; height=20; visible=$true; text=@{ text='Sala de Conselho'; fontfamily='Arial'; pixelsize=14; wrap=$true; color='#000000' } }; $id++
$newLabels += [pscustomobject]@{ id=$id; name='WarRoomLabel'; type='label'; x=960; y=376; width=160; height=20; visible=$true; text=@{ text='War Room'; fontfamily='Arial'; pixelsize=14; wrap=$true; color='#000000' } }; $id++
$newLabels += [pscustomobject]@{ id=$id; name='EstudioVideoLabel'; type='label'; x=960; y=520; width=160; height=20; visible=$true; text=@{ text='Estúdio de Vídeo'; fontfamily='Arial'; pixelsize=14; wrap=$true; color='#000000' } }; $id++
$newLabels += [pscustomobject]@{ id=$id; name='LoungeCEOLabel'; type='label'; x=1168; y=520; width=160; height=20; visible=$true; text=@{ text='Lounge CEO'; fontfamily='Arial'; pixelsize=14; wrap=$true; color='#000000' } }; $id++
$newLabels += [pscustomobject]@{ id=$id; name='FocusBoothLabel'; type='label'; x=1184; y=376; width=160; height=20; visible=$true; text=@{ text='Focus Booth'; fontfamily='Arial'; pixelsize=12; wrap=$true; color='#000000' } }; $id++

$labels.objects += $newLabels

$map.nextobjectid = $id
$out = $map | ConvertTo-Json -Depth 100
Set-Content -Path $mapPath -Value $out -NoNewline
Write-Output "Added CEO suite zones and labels. nextobjectid=$id"

