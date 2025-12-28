$ErrorActionPreference = 'Stop'
$file = "src/main/webapp/WEB-INF/views/task/volunteer_my.jsp"

# Read file
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

# Fix line 251 - replace broken EL expression
$broken = "???? : task.priority == 'HIGH' ? '??????'"
$fixed = "紧急' : task.priority == 'HIGH' ? '高优先级' : '普通"

$content = $content.Replace($broken, $fixed)

# Save file
[System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)

Write-Host "Fixed volunteer_my.jsp"
