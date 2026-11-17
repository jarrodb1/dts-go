# DTS Go kit - one-line installer. Run in PowerShell:  irm https://go.diligenttech.net/get.ps1 | iex
# Downloads DTS-GoKit.zip from https://go.diligenttech.net, checks its SHA-256, unpacks it to
# C:\ProgramData\DTS\GoKit\DTS-GoKit and opens the Go menu (Go.cmd asks for administrator rights).
# Built 2026-11-17. Windows PowerShell 5.1 or later. Holds no secrets.
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
$want = 'd6d7948b7c33f6ca9e4859266d8b9d06a6eec13dcdd7eb4885f31176fb6c6cef'
$dir = Join-Path $env:ProgramData 'DTS\GoKit'
New-Item -ItemType Directory -Path $dir -Force | Out-Null
$zip = Join-Path $dir 'DTS-GoKit.zip'
Write-Host 'Downloading the DTS Go kit...'
Invoke-WebRequest -Uri 'https://go.diligenttech.net/DTS-GoKit.zip' -OutFile $zip -UseBasicParsing
$have = (Get-FileHash -Path $zip -Algorithm SHA256).Hash.ToLower()
if ($have -ne $want) { Remove-Item $zip -Force; throw ('Download check failed (SHA-256 ' + $have + ', expected ' + $want + ') - nothing was run.') }
$kit = Join-Path $dir 'DTS-GoKit'
if (Test-Path $kit) { Get-ChildItem -Path $kit -File | Remove-Item -Force }
Expand-Archive -Path $zip -DestinationPath $dir -Force
Write-Host ('DTS Go kit ready in ' + $kit + ' (SHA-256 checked). Opening the menu...')
Start-Process -FilePath (Join-Path $kit 'Go.cmd')
