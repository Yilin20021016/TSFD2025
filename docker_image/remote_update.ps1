# remote_update.ps1

# ==== 參數設定區 ====
$remoteUser = "ncume_web"                       # 遠端帳號
$remoteHost = "140.115.68.3"              # 遠端IP或主機名
$privateKey = "$env:USERPROFILE\.ssh\id_rsa" # SSH 私鑰路徑
$projectDir = "~/TSFD2025"      # 遠端 Git 專案目錄
$containerName = "TSFD2025"             # Docker container 名稱
$password = "ncume_web"

# ==== 遠端要執行的命令 ====
$remoteCommand = @"
cd $projectDir
git pull
echo $password | sudo -S docker restart $containerName
"@
$remoteCommand = $remoteCommand -replace "`r", ""
# ==== 建立 SSH 命令 ====
$sshCommand = @(
    "ssh",
    "-i", "`"$privateKey`"",
    "-o", "StrictHostKeyChecking=no",
    "$remoteUser@$remoteHost",
    "`"$remoteCommand`""
) -join ' '

# ==== 執行 SSH ====
Write-Host "Connecting to $remoteHost and updating project..."
Invoke-Expression $sshCommand
