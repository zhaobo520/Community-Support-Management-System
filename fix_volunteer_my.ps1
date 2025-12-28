# 修复 volunteer_my.jsp 第251行
$file = "src/main/webapp/WEB-INF/views/task/volunteer_my.jsp"
$content = Get-Content $file -Raw -Encoding UTF8

# 修复被破坏的EL表达式
$pattern = [regex]::Escape('${task.priority == ''URGENT'' ? ''???? : task.priority == ''HIGH'' ? ''??????'' : ''}')
$replacement = '${task.priority == ''URGENT'' ? ''紧急'' : task.priority == ''HIGH'' ? ''高优先级'' : ''普通''}'

$content = $content -replace [regex]::Escape("'???? : task.priority == 'HIGH' ? '??????'"), "'紧急' : task.priority == 'HIGH' ? '高优先级' : '普通'"

# 保存文件
[System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)

Write-Host "volunteer_my.jsp 已修复"
