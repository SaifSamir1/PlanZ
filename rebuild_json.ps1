# Get the first 396 lines from

 backup (known clean base)
$cleanLines = Get-Content "d:\projects\PlanZ\assets\translations\en.json.backup" -TotalCount 396

# Output to the main file
$cleanLines | Out-File "d:\projects\PlanZ\assets\translations\en.json" -Encoding utf8 -NoNewline

Write-Output "Created clean base file with 396 lines"
