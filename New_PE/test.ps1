# 获取指定文件夹中的所有 .v 文件
$files = Get-ChildItem -Path "D:\document\GitHub\PE_module\New_PE" -Filter *.v -Recurse

# 初始化总行数
$totalLines = 0

# 循环处理每个 .v 文件
foreach ($file in $files) {
    # 获取文件的行数
    $lines = Get-Content $file | Measure-Object -Line
    $fileLines = $lines.Lines

    # 累加到总行数
    $totalLines += $fileLines
}

# 打印总行数到控制台
Write-Host "总代码行数: $totalLines"
