
$startLocation = $PSScriptRoot
# test
#$worldAddress = "0x593ad505023ea24371f8f628b251e0667308840f"
#$worldAddress = "0x63381030dda22c888f2548436c73146ef835ab9e"
#$privateKey = "0x0dcf6503b3fa4c2b9f529da422e0d56ed19a08dd6246f22500a756d9fe6d3201"

#product
$worldAddress = "0x776086899eab4ee3953b7c037b2c0a13c7a1deed"
$privateKey = "0x70fc6e2715bfd632dcdbe86657bc9b38e3f48b6d866171ed61ae60f3d42a57e1"

$rpcUrl = "https://odyssey.storyrpc.io/"

# GraphQL API 的 URL
$graphqlUrl = "https://api.goldsky.com/api/public/project_cm3zj9u61wxu901wog58adpjp/subgraphs/game-odyssey-testnet/1.0.2/gn"


$logPath = $startLocation + "\ReplenishPveRosters\$worldAddress"
if (-Not (Test-Path $logPath)) {
    # 如果不存在，则创建目录
    New-Item -ItemType Directory -Path $logPath
    Write-Host "目录已创建: $logPath"
} 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$logPath\$formattedNow.log"

$walletAddresses = cast wallet address --private-key $privateKey
if ($null -eq $walletAddresses -or -not $walletAddresses.Contains("0x")) {
    "不可识别的Private key:$privateKey" | Write-Host -ForegroundColor Red
    return
}
"当前账户地址:$walletAddresses" | Write-Host -ForegroundColor Green



# 目前岛屿所占海域大小
$islandWidth = 10000
$islandHeight = 10000
# $islandWidth = 5000
# $islandHeight = 5000
$u32MaxHalf = 2147483647
$u32Max = $u32MaxHalf * 2
# 在岛屿周边查找环境船队，以岛屿的中心坐标为准做一个矩形，矩形的大小 $islandWidth*$range,$islandHeight*$range
#$range = 0.2
#改为距离岛屿中心点 2000-3000之间的矩形带
$innerDistince = 2000
$outerDistince = 3000

#每个岛屿有多少个环境船队
$environmentQuntityPerIsland = 3

#添加船队时，最大出错次数不能超过$maxErrorTimes
$maxErrorTimes = 5


# 测试！！！！！
# $islandCoordinates = @(
#     @{
#         coordinatesX = 0
#         coordinatesY = 0
#     }
# )


#定义 GraphQL 查询 获取所有岛屿列表
$pageSize = 500
$islandCoordinates = @()
$hasMore = $true
$skip = 0
while ($hasMore) {
    $query = @"
    {
        islands(first: $pageSize, skip: $skip) {
            coordinatesX
            coordinatesY
        }
    }
"@
    # 构建请求体
    $body = @{
        query = $query
    }
    $locations = $null
    #$quntity = $null
    try {
        # 发送请求
        $locations = Invoke-RestMethod -Uri $graphqlUrl -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"
        # 获取当前页的数据
        $currentPageData = $locations.data.islands
        foreach ($location in $currentPageData) {        
            "$($location.coordinatesX),$($location.coordinatesY)" | Write-Host -ForegroundColor Green
        }        
        # 如果返回的数据少于页大小，说明已经是最后一页
        $hasMore = $currentPageData.Length -eq $pageSize        
        # 添加到结果集
        $islandCoordinates += $currentPageData
        # 更新skip
        $skip += $pageSize
        "本页存在 :$($currentPageData.Length) 个岛屿..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Blue
        "已获取 $($islandCoordinates.Count) 个岛屿..." | Write-Host -ForegroundColor Green
        # 如果当前页没有数据，退出环
        if ($currentPageData.Length -eq 0) {
            break
        }
    }
    catch {
        "查询地图失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
        "返回的结果为:$locations" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        return    
    }
}
"总共存在： $($islandCoordinates.Count) 个岛屿..." | Write-Host -ForegroundColor Yellow

#使用GraphQL来查询船队（环境船队）的位置

$rosterCoordinates = @()
$currentPageData = $null 
$query = @"
{
    rosters(where: {isEnvironmentOwned: true}) {
        isEnvironmentOwned
        coordinatesX
        coordinatesY
        sequenceNumber
    }
}
"@
# 构建请求体
$body = @{
    query = $query
}
$response = $null
#$quntity = $null
try {    
    # 发送请求
    $response = Invoke-RestMethod -Uri $graphqlUrl -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"        
    # 获取当前页的数据
    $currentPageData = $response.data.rosters
    foreach ($roster in $currentPageData) {        
        #$islandCoordinates += $roster
        "$($roster.coordinatesX),$($roster.coordinatesY)" | Write-Host -ForegroundColor Green
    }    
    # 添加到结果集
    $rosterCoordinates += $currentPageData    
    "已获取 $($rosterCoordinates.Count) 个船队..." | Write-Host -ForegroundColor Yellow
}
catch {
    "查询船队失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$response" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    return    
} 

"目前岛屿所占海域大小为:{$islandWidth,$islandHeight}" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
#"我们认为岛屿周边的环境船队不超过岛屿所占海域面积的$($range*100)%，也就是($($islandWidth*0.2),$($islandHeight*0.2))" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
"我们认为岛屿周边的环境船队分布在距离岛屿中心点 $innerDistince 与 $outerDistince 的区间内。" | Tee-Object -FilePath $logFile -Append  |  Write-Host 

#$widthSpan = $islandWidth * 0.2
#$heightSpan = $islandHeight * 0.2

function Get-Distance {
    param (
        [Parameter(Mandatory = $true)]
        [double]$x1,
        [Parameter(Mandatory = $true)]
        [double]$y1,
        [Parameter(Mandatory = $true)]
        [double]$x2,
        [Parameter(Mandatory = $true)]
        [double]$y2
    )

    $distance = [Math]::Sqrt(([Math]::Pow($x2 - $x1, 2) + [Math]::Pow($y2 - $y1, 2)))
    [long]$result = [long]$distance
    return $result
}

# 定义 Coordinate 类型
class Coordinate {
    [long]$X
    [long]$Y

    Coordinate([long]$x, [long]$y) {
        $this.X = $x
        $this.Y = $y
    }
}

# 定义 Equipment 类型(一个岛屿对应着那几个环境船队)
class Equipment {
    [Coordinate]$Island
    [System.Collections.Generic.List[Coordinate]]$Rosters

    Equipment() {
        $this.Island = [Coordinate]::new(0, 0)
        $this.Rosters = [System.Collections.Generic.List[Coordinate]]::new()
    }
}
# 一个野生船队属于那些岛屿
class RosterMatchIsland {
    [Coordinate]$Roster
    [System.Collections.Generic.List[Coordinate]]$Islands

    RosterMatchIsland() {
        $this.Roster = [Coordinate]::new(0, 0)
        $this.Islands = [System.Collections.Generic.List[Coordinate]]::new()
    }
}

$equipments = @();
$needAddTotal = 0
$rosterMatchIslands = @()

#循环每个岛屿-$u32MaxHalf
$islandRosterMatched = 0
foreach ($islandCoordinate in $islandCoordinates) {
    "岛屿坐标：($($islandCoordinate.coordinatesX),$($islandCoordinate.coordinatesY))" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    #"岛屿坐标：($($islandCoordinate.x-$u32MaxHalf),$($islandCoordinate.y-$u32MaxHalf))" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    #查询这个区域内有没有环境船队
    $inRange = 0
    $equipment = [Equipment]::new()
    $equipment.Island.X = $islandCoordinate.coordinatesX
    $equipment.Island.Y = $islandCoordinate.coordinatesY
    #循环所有的环境船队，看那个船队属于哪个岛屿    
    foreach ($rosterCoordinate in $rosterCoordinates) {
        #$pointBetweenRectangles = IsPointInAnnulus -px $rosterCoordinate.coordinatesX -py $rosterCoordinate.coordinatesY -left $left -bottom $bottom -right $right -top $top -outerLeft $outerLeft -outerBottom $outerBottom -outerRight $outerRight -outerTop $outerTop
        $distance = Get-Distance -x1 $rosterCoordinate.coordinatesX -y1 $rosterCoordinate.coordinatesY -x2 $islandCoordinate.coordinatesX -y2 $islandCoordinate.coordinatesY
        if ($distance -ge $innerDistince -and $distance -le $outerDistince) {
            $islandRosterMatched++
            "   坐标为($($rosterCoordinate.coordinatesX),$($rosterCoordinate.coordinatesY)) 的船队处于岛屿范围之内,距离为 $distance." | Tee-Object -FilePath $logFile -Append  
            #"   坐标为($($rosterCoordinate.coordinatesX-$u32MaxHalf),$($rosterCoordinate.coordinatesY-$u32MaxHalf)) 的船队处于岛屿范围之内,距离为 $distance." | Tee-Object -FilePath $logFile -Append  
            $roster = [Coordinate]::new($rosterCoordinate.coordinatesX, $rosterCoordinate.coordinatesY)
            $equipment.Rosters.Add($roster)
            $inRange = $inRange + 1;
            $find = $false
            $rosterMatchIslandM = $null
            foreach ($rosterMatchIsland in $rosterMatchIslands) {
                if ($rosterMatchIsland.Roster.X -eq $rosterCoordinate.coordinatesX -and $rosterMatchIsland.Roster.Y -eq $rosterCoordinate.coordinatesY) {
                    $find = $true
                    $rosterMatchIslandM = $rosterMatchIsland
                    "   坐标为($($rosterCoordinate.coordinatesX),$($rosterCoordinate.coordinatesY)) 的船队已经匹配了岛屿：" | Tee-Object -FilePath $logFile -Append |  Write-Host -ForegroundColor Blue
                    foreach ($ilCoordinate in $rosterMatchIsland.Islands) {
                        "        ($($ilCoordinate.X),$($ilCoordinate.Y))" | Tee-Object -FilePath $logFile -Append |  Write-Host -ForegroundColor Blue
                    }
                }
            }
            if (-not $find) {                
                $rosterMatchIslandM = [RosterMatchIsland]::new()
                $rosterMatchIslandM.Roster.X = $rosterCoordinate.coordinatesX
                $rosterMatchIslandM.Roster.Y = $rosterCoordinate.coordinatesY
                $rosterMatchIslands += $rosterMatchIslandM
            }
            $island = [Coordinate]::new($islandCoordinate.x, $islandCoordinate.y)
            $rosterMatchIslandM.Islands.Add($island)
        }
    }
    if ($inRange -eq 0) {
        "   周边没有环境船队." | Tee-Object -FilePath $logFile -Append  
    }
    if ($inRange -lt $environmentQuntityPerIsland) {
        $equipments += $equipment
        $needAddTotal = $needAddTotal + ($environmentQuntityPerIsland - $inRange)
    }
}
"环境船队总数量:$($rosterCoordinates.Count),岛屿和环境船队匹配总次数:$islandRosterMatched。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow -NoNewline
#其实这里相当也不能说明正好匹配，说不定有的环境船队不属于任何岛屿，并且有的环境船队属于两个岛屿呢。
if ($rosterCoordinates.Count -lt $islandRosterMatched) {
    "说明（很有可能）有的环境船队属于多个岛屿。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow 
}
if ($rosterCoordinates.Count -gt $islandRosterMatched) {
    "说明（很有可能）有的环境船队不属于任何岛屿。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow 
}

#我们来看一下是否有的环境船队没有找��所依靠的岛屿

foreach ($rosterCoordinate in $rosterCoordinates) {
    $find = $false
    foreach ($rosterMatchIsland in $rosterMatchIslands) {
        if ($rosterMatchIsland.Roster.X -eq $rosterCoordinate.coordinatesX -and $rosterMatchIsland.Roster.Y -eq $rosterCoordinate.coordinatesY) {
            $find = $true
            break
        }
    }
    if ($false -eq $find) {
        "坐标为($($rosterCoordinate.coordinatesX),$($rosterCoordinate.coordinatesY)) 的船队不属于任何岛屿范围之内。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red     
    }
}

#输出同时在多个岛屿范围内的环境船队
foreach ($rosterMatchIsland in $rosterMatchIslands) {
    if ($rosterMatchIsland.Islands.Count -gt 1) {
        "坐标为($($rosterMatchIsland.Roster.X),$($rosterMatchIsland.Roster.Y)) 的船队同时在以下岛屿范围之内：" | Tee-Object -FilePath $logFile -Append |  Write-Host -ForegroundColor Blue
        foreach ($ilCoordinate in $rosterMatchIsland.Islands) {
            "   ($($ilCoordinate.X),$($ilCoordinate.Y))" | Tee-Object -FilePath $logFile -Append |  Write-Host -ForegroundColor Blue
        }
    }
}

if ($needAddTotal -lt 1) {
    "不需要补充环境船队" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
    return;
}
"需要补充 $needAddTotal 个环境船队..." | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow

#从 Mud Table 中获取环境船队的最大编号，
#【这个不准确其实是未损毁的环境船队的最大编号】，注意得到 rosterCoordinates 的过滤条件，应该检查其 status 
[long]$maxSequnceNumberFromTable = 0
foreach ($roster in $rosterCoordinates) {
    if ([long]$roster.sequenceNumber -gt $maxSequnceNumberFromTable) {
        $maxSequnceNumberFromTable = [long]$roster.sequenceNumber
    }
}

# 计算两个坐标之间的距离
function GetDistanceBetweenPoints {
    param (
        [Coordinate]$point1,
        [Coordinate]$point2
    )

    $dx = $point2.X - $point1.X
    $dy = $point2.Y - $point1.Y

    return [math]::Sqrt(($dx * $dx) + ($dy * $dy))
}

# 随机生成符合条件的坐标点
function GenerateRandomCoordinate {
    param (
        [Coordinate]$point1,
        [System.Collections.Generic.List[Coordinate]]$existingPoints
    )
    do {
        # 随机生成坐标点2
        $angle = Get-Random -Minimum 0 -Maximum 360
        $distance = Get-Random -Minimum 2000 -Maximum 3000
        $a = [long]($point1.X + $distance * [math]::Cos([math]::PI * $angle / 180))
        $b = [long]($point1.Y + $distance * [math]::Sin([math]::PI * $angle / 180))
        
        # 确保坐标为正数
        if ($a -lt 0 -or $b -lt 0) {
            continue
        }
        
        $point2 = [Coordinate]::new($a, $b)

        # 检查与列表中所有点的距离是否大于500
        $isValid = $true
        if ($existingPoints.Count -gt 0) {
            foreach ($existingPoint in $existingPoints) {
                $distance = GetDistanceBetweenPoints -point1 $point2 -point2 $existingPoint
                if ($distance -le 500) {
                    $isValid = $false
                    break
                }
            }
        }
    } while (-not $isValid)

    return $point2
}



$errorTimes = 0

$ship_resource_quantity = 15
$ship_base_resource_quantity = 3
$base_experience = 0

#已经补充了几只环境船队？
$roster_id_sequence_number = 1

$pveRosterPlayerId = $u32Max
[long]$LastRosterIdSequenceNumber = $maxSequnceNumberFromTable + 1
#  cast send $worldAddress "app__rosterCreateEnvironmentRoster(uint256,uint32,uint32,uint32,uint32,uint32,uint32)" playerId sequenceNumber coordinatesX coordinatesY shipResourceQuantity shipBaseResourceQuantity baseExperience --rpc-url "$rpcUrl" --private-key $privateKey --json
"本次造船队将从序列号 $LastRosterIdSequenceNumber 开始" | Write-Host -ForegroundColor Green
foreach ($equipment in $equipments) {
    $needToAdd = $environmentQuntityPerIsland - $equipment.Rosters.Count
    "岛屿: $($equipment.Island.X),$($equipment.Island.Y) 周围需要补充 $needToAdd 个环境船队...." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Blue
    
    for ($i = 0; $i -lt $needToAdd; $i++) {
        $randomPoint = GenerateRandomCoordinate -point1 $equipment.Island -existingPoints $equipment.Rosters
        "在($($randomPoint.X), $($randomPoint.Y))处添加环境船队" | Tee-Object -FilePath $logFile -Append  |  Write-Host
        "   距岛屿距离:" + [long](GetDistanceBetweenPoints -point1 $equipment.Island -point2 $randomPoint) | Tee-Object -FilePath $logFile -Append  |  Write-Host
        if ($equipment.Rosters.Count -gt 0) {
            "   距离其它已有船队距离如下：" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
            foreach ($roster in $equipment.Rosters) {
                $rosterDistance = [long](GetDistanceBetweenPoints -point1 $roster -point2 $randomPoint)
                "($($roster.X), $($roster.Y)) 距离 $rosterDistance" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
            }
        }
        #$rosterId = ""
        $createEnvironmentRosterResult = ""
        try {
            $command = "cast send $worldAddress ""app__rosterCreateEnvironmentRoster(uint256, uint32, uint32, uint32, uint32, uint32, uint32)"" $pveRosterPlayerId $LastRosterIdSequenceNumber $($randomPoint.X) $($randomPoint.Y) $ship_resource_quantity $ship_base_resource_quantity $base_experience --rpc-url ""$rpcUrl"" --private-key $privateKey --json"
            $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
            $createEnvironmentRosterResult = Invoke-Expression -Command "$command 2>&1"
            $LastRosterIdSequenceNumber++ #只要执行过就加1
            $createEnvironmentRosterResultObj = $createEnvironmentRosterResult | ConvertFrom-Json
            
            # 检查是否包含错误信息
            if ($createEnvironmentRosterResult -match "error" -or $createEnvironmentRosterResult -match "failed") {
                throw "Cast command failed: $createEnvironmentRosterResult"
            }
    
            $createEnvironmentRosterResultObj = $createEnvironmentRosterResult | ConvertFrom-Json
            if (-not $createEnvironmentRosterResultObj.status) {
                throw "Transaction failed: $createEnvironmentRosterResult"
            }    
            "创建环境船队成功， 交易哈希: $($createEnvironmentRosterResultObj.transactionHash),blockNumber:$($createEnvironmentRosterResultObj.blockNumber)`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
            "船队RosterId={$pveRosterPlayerId,$LastRosterIdSequenceNumber}" | Write-Host -ForegroundColor Blue
            "已经补充 $($roster_id_sequence_number) 只环境船队" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
            $roster_id_sequence_number++;
            $equipment.Rosters.Add($randomPoint)
        }
        catch {
            $errorMessage = if ($_.Exception.Message) { $_.Exception.Message } else { $_ }
            "创建环境船队失败: $errorMessage `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
            "完整错误信息: $createEnvironmentRosterResult" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    
            $errorTimes++
            if ($errorTimes -ge $maxErrorTimes) {
                "创建环境船队出错次数:$errorTimes,已经达到上限:$maxErrorTimes,退出..." | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
                return
            }
            continue   
        }
    }
}

"全部补充完毕!" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue
#$islandEnvironmentRosterInfo | ConvertTo-Json | Tee-Object -FilePath $environmentRosterJsonFile | Write-Host -ForegroundColor White
"该脚本执行后相关的日志请参考: $logFile" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue




