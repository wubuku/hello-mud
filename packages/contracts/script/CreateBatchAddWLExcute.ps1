$worldAddress = "0x63381030dda22c888f2548436c73146ef835ab9e"
$rpc_url = "https://odyssey.storyrpc.io/"

$startLocation = $PSScriptRoot; 
Set-Location $startLocation


$logPath = $startLocation + "\BatchAddWL\$worldAddress"
if (-Not (Test-Path $logPath)) {
    # 如果不存在，则创建目录
    New-Item -ItemType Directory -Path $logPath
    Write-Host "目录已创建: $logPath"
} 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$logPath\$formattedNow.log"

# 读取钱包地址
$walletAddresses = $null
# 检查 walletaddress.txt 是否存在
$walletAddressesFile = "$startLocation\walletaddress.txt"
if (-not (Test-Path -Path $walletAddressesFile -PathType Leaf)) {
    "文件 $walletAddressesFile 不存在 " | Write-Host  -ForegroundColor Red
    return
} 
else {
    $walletAddresses = Get-Content -Path $walletAddressesFile
}
$resolvedAddresses = @()
# 循环输出 $walletAddresses 中的值
foreach ($address in $walletAddresses) {
    if ($null -ne $address -and $address -ne "") {
        if (-Not $resolvedAddresses.Contains($address)) {
            Write-Host $address
            $resolvedAddresses += $address
        }
    }
}
if ($resolvedAddresses.Count -lt 1) {
    "请至少提供一个加到白名单的钱包地址。" | Write-Host  -ForegroundColor Red
    return
}

# $templateLineKeywords = "address[] memory walletAddresses"

# $templateFileContent = $null
# $templateFile = "$startLocation\BatchAddWLTemplate.s.sol"
# if (-not (Test-Path -Path $templateFile -PathType Leaf)) {
#     "文件 $templateFile 不存在 " | Write-Host  -ForegroundColor Red
#     return
# } 
# else {
#     $templateFileContent = Get-Content -Path $templateFile
# }
# $templateLine = $null
# foreach ($line in $templateFileContent) {
#     if ($line.Contains($templateLineKeywords)) {
#         $templateLine = $line
#         break;
#     }
# }
# if ($null -eq $templateLine) {
#     "没有找到含有关键字:$templateLineKeywords 的模板行" | Write-Host -ForegroundColor Red
#     return
# }

$replaceTo = "address[$($resolvedAddresses.Count)] memory walletAddresses = ["
for ($i = 0; $i -lt $resolvedAddresses.Count; $i++) {
    $replaceTo += "address($($resolvedAddresses[$i]))"
    if ($i -lt $resolvedAddresses.Count - 1) {
        $replaceTo += ","
    }
}
$replaceTo += "];"

$replaceTo | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green


# $pathBatchAddWL = $startLocation + "\BatchAddWL"
# if (-Not (Test-Path $pathBatchAddWL)) {
#     # 如果不存在，则创建目录
#     New-Item -ItemType Directory -Path $pathBatchAddWL
#     "创建目录: $pathBatchAddWL" | Write-Host 
# } 
# $now = Get-Date
# $formattedNow = $now.ToString('yyyyMMddHHmmss')
# $batchAddWLExecuteFile = "$startLocation\BatchAddWLExecute_$formattedNow" + ".s.sol"
# "生成Powershell脚本:$batchAddWLExecuteFile" | Write-Host -ForegroundColor Blue
# $logFile = "$pathBatchAddWL\BatchAddWLExecute_$formattedNow" + ".log"

# foreach ($line in $templateFileContent) {
#     if ($line.Contains($templateLineKeywords)) {        
#         $replaceTo | Tee-Object -FilePath $batchAddWLExecuteFile -Append  
#         $replaceTo | Tee-Object -FilePath $logFile -Append 
#     }
#     # elseif ($line.Contains("import") -and $line.Contains("..")) {
#     #     $import = $line.Replace("..", "../.."); 
#     #     $import | Tee-Object -FilePath $batchAddWLExecuteFile -Append  
#     # }
#     else {
        
#         $line | Tee-Object -FilePath $batchAddWLExecuteFile -Append  
#     }
# }
# Write-Host "文件已保存为 $batchAddWLExecuteFile"

# Write-Host "现在开始执行 $batchAddWLExecuteFile"

# try {
#     $command = "forge script $batchAddWLExecuteFile" + ":BatchCall --sig ""run(address)"" $worldAddress --broadcast --rpc-url $rpcUrl"
#     $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
#     #$executeResult = Invoke-Expression -Command $command
#     Invoke-Expression -Command $command | Tee-Object -FilePath $logFile -Append 
# }
# catch {    
#     "$($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
# }
"查看日志`n:$logFile" | Write-Host -ForegroundColor Blue

"`n将钱包地数组复制到 BatchAddWLExecute.s.sol 中在 script 目录下执行：`n" | Write-Host -ForegroundColor White

"forge script BatchAddWLExecute.s.sol:BatchCall --sig ""run(address)"" $worldAddress --broadcast --rpc-url $rpc_url" | Write-Host -ForegroundColor White


