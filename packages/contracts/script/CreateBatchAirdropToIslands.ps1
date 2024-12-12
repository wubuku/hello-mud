$worldAddress = "0x63381030dda22c888f2548436c73146ef835ab9e"
$rpc_url = "https://odyssey.storyrpc.io/"

$startLocation = $PSScriptRoot; 
Set-Location $startLocation


$logPath = $startLocation + "\BatchAirdropToIslands\$worldAddress"
if (-Not (Test-Path $logPath)) {
    # 如果不存在，则创建目录
    New-Item -ItemType Directory -Path $logPath
    Write-Host "目录已创建: $logPath"
} 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$logPath\$formattedNow.log"

# 读取玩家信息
$jsonContent = $null
# 检查 walletaddress.txt 是否存在
$playersInfoFile = "$startLocation\message.txt"
if (-not (Test-Path -Path $playersInfoFile -PathType Leaf)) {
    "文件 $playersInfoFile 不存在 " | Write-Host  -ForegroundColor Red
    return
} 
else {
    $jsonContent = Get-Content -Path $playersInfoFile
}


# 由于文件内容不是完整的 JSON，需要添加外层括号
$jsonContent = "{" + $jsonContent + "}"
$walletAddresses = @();
# 将 JSON 转换为 PowerShell 对象
try {
    $data = $jsonContent | ConvertFrom-Json
    $players = $data.players
    
    # 验证是否成功获取到玩家数组
    Write-Host "Successfully parsed $($players.Count) players"
    
    # 可以遍历玩家数组
    foreach ($player in $players) {
        # 示例：输出每个玩家的信息
        Write-Host "ID: $($player.id), Name: $($player.name), Owner: $($player.owner)"
        $walletAddresses += $player.owner;
    }
}
catch {
    Write-Host "Error parsing JSON: $_" -ForegroundColor Red
}


$resolvedAddresses = @()
# 循环输出 $walletAddresses 中的值
foreach ($address in $walletAddresses) {
    if ($null -ne $address -and $address -ne "") {
        if (-Not $resolvedAddresses.Contains($address)) {
            Write-Host $address
            $resolvedAddresses += $address
            if ($resolvedAddresses.Length -ge 400) {
                break
            }
        }
    }
}
if ($resolvedAddresses.Count -lt 1) {
    "请至少提供一个钱包地址。" | Write-Host  -ForegroundColor Red
    return
}

# $replaceTo = "address[$($resolvedAddresses.Count)] memory walletAddresses = ["
# for ($i = 0; $i -lt $resolvedAddresses.Count; $i++) {
#     $replaceTo += "address($($resolvedAddresses[$i]))"
#     if ($i -lt $resolvedAddresses.Count - 1) {
#         $replaceTo += ","
#     }
# }
# $replaceTo += "];"

$replaceTo = ""# "address[$($resolvedAddresses.Count)] memory walletAddresses = ["
for ($i = 0; $i -lt $resolvedAddresses.Count; $i++) {
    $replaceTo += $resolvedAddresses[$i]
    if ($i -lt $resolvedAddresses.Count - 1) {
        $replaceTo += "`r`n"
    }
}
#$replaceTo += "];"

$replaceTo | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green


"查看日志`n:$logFile" | Write-Host -ForegroundColor Blue

"`n将钱包地数组复制到 BatchAirDropToIslands.s.sol 中在 script 目录下执行：`n" | Write-Host -ForegroundColor White

"forge script BatchAirDropToIslands.s.sol:BatchCall --sig ""run(address)"" $worldAddress --broadcast --rpc-url $rpc_url" | Write-Host -ForegroundColor White


