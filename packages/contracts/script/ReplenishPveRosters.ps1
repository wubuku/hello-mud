$startLocation = $PSScriptRoot

# $dataFile = "$startLocation\data.json"
# if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
#     "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
#     return
# }
# $ComeFromFile = Get-Content -Raw -Path $dataFile
# $dataInfo = $ComeFromFile | ConvertFrom-Json


$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\environment_roster_rebirth_$formattedNow.log"

# 目前岛屿所占海域大小
$islandWidth = 10000
$islandHeight = 10000
# $islandWidth = 5000
# $islandHeight = 5000
$u32MaxHalf = 2147483647
# 在岛屿周边查找环境船队，以岛屿的中心坐标为准做一个矩形，矩形的大小 $islandWidth*$range,$islandHeight*$range
#$range = 0.2
#改为距离岛屿中心点 2000-3000之间的矩形带
$innerDistince = 2000
$outerDistince = 3000

#每个岛屿有多少个环境船队
$environmentQuntityPerIsland = 3

#添加船队时，最大出错次数不能超过$maxErrorTimes
$maxErrorTimes = 5



# GraphQL API 的 URL
$graphqlUrl = "https://api.goldsky.com/api/public/project_cm2zy4z44jz7v01zje54g17b1/subgraphs/infinite-seas-odyssey-testnet/1.0.0/gn"

# 定义 GraphQL 查询 获取所有的岛屿列表
$query = @"
{
   islands {
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
$quntity = $null
$islandCoordinates = @()
try {
    
    # 发送请求
    $locations = Invoke-RestMethod -Uri $graphqlUrl -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"
    foreach ($location in $locations.data.islands) {        
        $islandCoordinates += $location
        "$($location.coordinatesX),$($location.coordinatesY)" | Write-Host -ForegroundColor Green
    }
    $quntity = $locations.data.islands.Length;
    "地图存在 :$quntity 个岛屿..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Blue
}
catch {
    "查询地图失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$locations" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    return    
}
if ($null -eq $quntity) {
    "无法获取岛屿数量。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Red
    return
}

# 如果环境船队也从链上查找的话效率太低了，所以使用链下服务接口吧。


$getAllEnviornmentRostersResult = $null
$rosterCoordinates = @()
#从Indexer获得的所有的【未损毁的】环境船队
$rosterIdsFromIndexer = @()
try {
    $getAllEnviornmentRostersUrl = $serverUrl + "/api/rosterExtends/getAllEnvironmentRosters"
    #按说应该使用 status=ne(3),但是powershell会报错所以先用status=0吧，毕竟野船队目前不动
    #$getAllEnviornmentRostersUrl = $serverUrl + "/api/Rosters?environmentOwned=true&status=0"
    #$command = "curl -X GET '" + $getAllEnviornmentRostersUrl + "' -H 'accept: application/json'"
    $command = "Invoke-WebRequest -Uri '" + $getAllEnviornmentRostersUrl + "' -Method Get -ContentType 'application/json'"
    # $getAllIslandResult = curl -X GET $getAllIslandUrl -H "accept: application/json"   
    $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    $getAllEnviornmentRostersResult = Invoke-Expression -Command $command 
    if ($getAllEnviornmentRostersResult.StatusCode -ne 200) {
        "请求失败，状态码: $($getAllEnviornmentRostersResult.StatusCode),返回信息:$($getAllEnviornmentRostersResult.Content)" | Write-Host  -ForegroundColor Red
        return
    }
    $getAllEnviornmentRostersResultObj = $getAllEnviornmentRostersResult.Content | ConvertFrom-Json
    "目前一共有 $($getAllEnviornmentRostersResultObj.Count) 个活着的环境船队..." | Tee-Object -FilePath $logFile -Append  |  Write-Host  -ForegroundColor Yellow   
    foreach ($roster in $getAllEnviornmentRostersResultObj) {
        $rosterCoordinates += $roster
        $rosterIdsFromIndexer += $roster
        #"coordinates:($($roster.x),$($roster.y))" |  Write-Host 
        #"coordinates:($($roster.updatedCoordinates.x-$u32MaxHalf),$($roster.updatedCoordinates.y-$u32MaxHalf))" |  Write-Host 
    }
}
catch {
    "获取环境船队列表失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$getAllEnviornmentRostersResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
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
    "岛屿坐标：($($islandCoordinate.x),$($islandCoordinate.y))" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    #"岛屿坐标：($($islandCoordinate.x-$u32MaxHalf),$($islandCoordinate.y-$u32MaxHalf))" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    #查询这个区域内有没有环境船队
    $inRange = 0
    $equipment = [Equipment]::new()
    $equipment.Island.X = $islandCoordinate.x
    $equipment.Island.Y = $islandCoordinate.y
    #循环所有的环境船队，看那个船队属于哪个岛屿
    foreach ($rosterCoordinate in $rosterCoordinates) {
        #$pointBetweenRectangles = IsPointInAnnulus -px $rosterCoordinate.x -py $rosterCoordinate.y -left $left -bottom $bottom -right $right -top $top -outerLeft $outerLeft -outerBottom $outerBottom -outerRight $outerRight -outerTop $outerTop
        $distance = Get-Distance -x1 $rosterCoordinate.x -y1 $rosterCoordinate.y -x2 $islandCoordinate.x -y2 $islandCoordinate.y
        if ($distance -ge $innerDistince -and $distance -le $outerDistince) {
            $islandRosterMatched++
            "   坐标为($($rosterCoordinate.x),$($rosterCoordinate.y)) 的船队处于岛屿范围之内,距离为 $distance." | Tee-Object -FilePath $logFile -Append  
            #"   坐标为($($rosterCoordinate.x-$u32MaxHalf),$($rosterCoordinate.y-$u32MaxHalf)) 的船队处于岛屿范围之内,距离为 $distance." | Tee-Object -FilePath $logFile -Append  
            $roster = [Coordinate]::new($rosterCoordinate.x, $rosterCoordinate.y)
            $equipment.Rosters.Add($roster)
            $inRange = $inRange + 1;
            $find = $false
            $rosterMatchIslandM = $null
            foreach ($rosterMatchIsland in $rosterMatchIslands) {
                if ($rosterMatchIsland.Roster.X -eq $rosterCoordinate.x -and $rosterMatchIsland.Roster.Y -eq $rosterCoordinate.y) {
                    $find = $true
                    $rosterMatchIslandM = $rosterMatchIsland
                    "   坐标为($($rosterCoordinate.x),$($rosterCoordinate.y)) 的船队已经匹配了岛屿：" | Tee-Object -FilePath $logFile -Append |  Write-Host -ForegroundColor Blue
                    foreach ($ilCoordinate in $rosterMatchIsland.Islands) {
                        "        ($($ilCoordinate.X),$($ilCoordinate.Y))" | Tee-Object -FilePath $logFile -Append |  Write-Host -ForegroundColor Blue
                    }
                }
            }
            if (-not $find) {                
                $rosterMatchIslandM = [RosterMatchIsland]::new()
                $rosterMatchIslandM.Roster.X = $rosterCoordinate.x
                $rosterMatchIslandM.Roster.Y = $rosterCoordinate.y
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
"环境船队总数量:$($rosterCoordinates.Count)，岛屿和环境船队匹配总次数:$islandRosterMatched。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow -NoNewline
#其实这里相当也不能说明正好匹配，说不定有的环境船队不属于任何岛屿，并且有的环境船队属于两个岛屿呢。
if ($rosterCoordinates.Count -lt $islandRosterMatched) {
    "说明（很有可能）有的环境船队属于多个岛屿。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow 
}
if ($rosterCoordinates.Count -gt $islandRosterMatched) {
    "说明（很有可能）有的环境船队不属于任何岛屿。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow 
}

#我们来看一下是否有的环境船队没有找到所依靠的岛屿

foreach ($rosterCoordinate in $rosterCoordinates) {
    $find = $false
    foreach ($rosterMatchIsland in $rosterMatchIslands) {
        if ($rosterMatchIsland.Roster.X -eq $rosterCoordinate.x -and $rosterMatchIsland.Roster.Y -eq $rosterCoordinate.y) {
            $find = $true
            break
        }
    }
    if ($false -eq $find) {
        "坐标为($($rosterCoordinate.x),$($rosterCoordinate.y)) 的船队不属于任何岛屿范围之内。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red     
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


#下面开始查询环境船队的最大编号
if ($null -eq $dataInfo.main.EnvironmentPlayId) {
    "没有找到环境用户信息。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    return
}

#从Indexer中获取环境船队的最大编号，
#【这个不准确其实是未损毁的环境船队的最大编号】
$maxSequnceNumberFromIndexer = 0
foreach ($rosterId in $rosterIdsFromIndexer) {
    if ($dataInfo.main.EnvironmentPlayId -eq $rosterId.playerId -and $rosterId.sequenceNumber -gt $maxSequnceNumberFromIndexer) {
        $maxSequnceNumberFromIndexer = $rosterId.sequenceNumber
    }
}

try {
    $getRosterTableResult = sui client object $dataInfo.main.RosterTable --json
    if (-not ('System.Object[]' -eq $getRosterTableResult.GetType())) {
        "查询 RosterTable 信息时返回： $getRosterTableResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        return
    }
    $rosterTable = $getRosterTableResult | ConvertFrom-Json
    $dynamicFiledsId = $rosterTable.content.fields.table.fields.id.id;
}
catch {
    "查询 RosterTable 失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$getMapResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    return    
}
if ($null -eq $dynamicFiledsId) {
    "没有得到 RosterTable 动态字段 Id。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Red
    return;
}

$nextCursor = $null
$hasNextPage = $true
$limit = 100
$rosterIdsFromFullNode = @()
try {
    while ($hasNextPage) {
        $command = ($null -eq $nextCursor)?
        'curl -X POST -H "Content-Type: application/json" -d ''{"jsonrpc":"2.0","id":1,"method":"suix_getDynamicFields","params":["' + $dynamicFiledsId + '",null,' + $limit + ']}'' ' + $node
        :'curl -X POST -H "Content-Type: application/json" -d ''{"jsonrpc":"2.0","id":1,"method":"suix_getDynamicFields","params":["' + $dynamicFiledsId + '","' + $nextCursor + '",' + $limit + ']}'' ' + $node
        $command | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
        $result = Invoke-Expression -Command $command 
        $resultObj = $result | ConvertFrom-Json
        if ($null -ne $resultObj.error) {
            "suix_getDynamicFields error:" + $resultObj.error.message | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Red
            break;
        }
        foreach ($data in $resultObj.result.data) {
            if ($data.name.value.player_id -eq $dataInfo.main.EnvironmentPlayId) {
                $rosterIdsFromFullNode += $data.name.value
                #"($($data.name.value.player_id),$($data.name.value.sequence_number))" |  Write-Host -ForegroundColor White 
            }
        }
        $hasNextPage = $resultObj.result.hasNextPage
        $nextCursor = $resultObj.result.nextCursor;
    }
}
catch {
    "查询 RosterTable 详细信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    return    
}
"从 Full Node 一共得到了 $($rosterIdsFromFullNode.Count) 个环境船队。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
# if ($rosterIdsFromFullNode.Count -ne $rosterIdsFromIndexer.Count) {
"两种方式得到环境船队数量,从节点 FullNode 处得到（包括已经被消灭）： $($rosterIdsFromFullNode.Count)，从 Indexer 处得到（目前仍然存活的）：$($rosterIdsFromIndexer.Count)" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
# }

$maxSequnceNumberInFullNode = 0
foreach ($rosterId in $rosterIdsFromFullNode) {
    if ($rosterId.sequence_number -gt $maxSequnceNumberInFullNode) {
        $maxSequnceNumberInFullNode = $rosterId.sequence_number
    }
}

"从 FullNode 和 Indexer 得到的环境船队最大编号分别是： 来自Full Node： $maxSequnceNumberInFullNode , 来自Indexer： $maxSequnceNumberFromIndexer" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
"两者可以不同，但是必须 maxSequnceNumberFromIndexer<=maxSequnceNumberInFullNode,因为最大序列号的环境船队可能被消灭，而 maxSequnceNumberFromIndexer 中不包含被消灭的环境船队" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
if ($maxSequnceNumberFromIndexer -gt $maxSequnceNumberInFullNode) {
    "maxSequnceNumberFromIndexer 不能大于 maxSequnceNumberInFullNode" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Red
    return 
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
        $point2 = [Coordinate]::new($a, $b)

        # 检查与列表中所有点的距离是否大于500
        $isValid = $true
        if ($existingPoints.Count -gt 0) {
            foreach ($existingPoint in $existingPoints) {
                $distance = GetDistanceBetweenPoints -point1 $point2 -point2 $existingPoint
                if ( $distance -le 500) {
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
$clock = '0x6'

#已经补充了几只环境船队？
$roster_id_sequence_number = 1


#最大序列号应该以 maxSequnceNumberInFullNode 为准，因为最大序列号的环境船队可能被消灭，而maxSequnceNumberFromIndexer 中不包含被消灭的环境船队
$LastRosterIdSequenceNumber = $maxSequnceNumberInFullNode + 1

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
        $rosterId = ""
        $createEnvironmentRosterResult = ""
        try {
            $command = "sui client call --package $($dataInfo.main.PackageId) --module roster_aggregate --function create_environment_roster --args  $($dataInfo.main.EnvironmentPlayId) $LastRosterIdSequenceNumber $($dataInfo.main.Publisher) $($randomPoint.X) $($randomPoint.Y) $ship_resource_quantity $ship_base_resource_quantity $base_experience $clock $($dataInfo.main.RosterTable) --gas-budget 42000000 --json"
            $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
            $createEnvironmentRosterResult = Invoke-Expression -Command $command
            $LastRosterIdSequenceNumber++ #只要执行过就加1
            if (-not ('System.Object[]' -eq $createEnvironmentRosterResult.GetType())) {
                "创建环境船队时返回信息 $createEnvironmentRosterResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
                $errorTimes++
                if ($errorTimes -ge $maxErrorTimes) {
                    "创建环境船队出错次数:$errorTimes,已经达到上限:$maxErrorTimes,退出..." | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
                    #$islandEnvironmentRosterInfo | ConvertTo-Json | Tee-Object -FilePath $environmentRosterJsonFile | Write-Host -ForegroundColor White
                    return
                }
                continue
            }
            $createEnvironmentRosterResultObj = $createEnvironmentRosterResult | ConvertFrom-Json
            foreach ($object in $createEnvironmentRosterResultObj.objectChanges) {
                if ($object.objectType -like "*::roster::Roster") {
                    $rosterId = $object.objectId
                    "创建环境船队成功， Roster Id: $rosterId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
                    break
                }
            }
            "船队RosterId={$($dataInfo.main.EnvironmentPlayId),$LastRosterIdSequenceNumber}" | Write-Host -ForegroundColor Blue
            "已经补充 $($roster_id_sequence_number) 只环境船队" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
            $roster_id_sequence_number++;
            $equipment.Rosters.Add($randomPoint)
        }
        catch {
            "创建环境船队失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
            "返回的结果为:$createEnvironmentRosterResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
            $errorTimes++
            if ($errorTimes -ge $maxErrorTimes) {
                "创建环境船队出错次数:$errorTimes,已经达到上限:$maxErrorTimes,退出..." | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
                #$islandEnvironmentRosterInfo | ConvertTo-Json | Tee-Object -FilePath $environmentRosterJsonFile | Write-Host -ForegroundColor White
                return
            }
            continue    
        }
    }
}

"全部补充完毕!" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue
#$islandEnvironmentRosterInfo | ConvertTo-Json | Tee-Object -FilePath $environmentRosterJsonFile | Write-Host -ForegroundColor White
"该脚本执行后相关的日志请参考: $logFile" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue




