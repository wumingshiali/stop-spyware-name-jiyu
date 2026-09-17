if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
$targetExe = "StudentMain.exe"
$fakeExePath = "no.exe"  # 强烈建议写绝对路径
$ifeoPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$targetExe"

# 1. 创建子项（如果已存在会自动跳过）
New-Item -Path $ifeoPath -Force | Out-Null

# 2. 在子项下创建 Debugger 值 (REG_SZ)
New-ItemProperty -Path $ifeoPath -Name "Debugger" -Value $fakeExePath -PropertyType String -Force | Out-Null

# 3. 结束原进程（-Name 后面不要加 .exe，加 -Force 强制结束）
Stop-Process -Name "xxx" -Force -ErrorAction SilentlyContinue

Read-Host -Prompt "按下回车键以退出..."