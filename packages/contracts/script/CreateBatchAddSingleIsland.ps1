$startLocation = $PSScriptRoot; 

# $privateKey = "0x0dcf6503b3fa4c2b9f529da422e0d56ed19a08dd6246f22500a756d9fe6d3201"
$rpc_url = "https://odyssey.storyrpc.io/"
$worldAddress = "0x8c913c14c115bf63f4a270bd8b8c017951249476"

# 该脚本用来生成 BatchAddSingleIsland.s.sol 中所使用的 X 坐标和 Y 坐标数组

#释放的块序号
$seqNo = 6

$logPath = $startLocation + "\BatchAddIslands\$worldAddress"
if (-Not (Test-Path $logPath)) {
    # 如果不存在，则创建目录
    New-Item -ItemType Directory -Path $logPath
    Write-Host "目录已创建: $logPath"
} 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$logPath\$formattedNow" + "_$seqNo.log"

"开辟第: $seqNo 块区域..." | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow

$u32Max = 4294967295
$u32MaxHalf = 2147483647

#最终坐标在初始坐标上的随机波动范围
$rand_rate_x = 0.2
$rand_rate_y = 0.2

$original_x = $u32MaxHalf
$original_y = $u32MaxHalf



$island_width = 10000
$island_height = 10000


$block_width = 90000
$block_height = 90000

if ($block_width -lt $island_width -or $block_height -lt $island_height) {
    "分配区域的尺寸不能小于岛屿的尺寸" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
}


#分配的区域可以放多少 行 小岛
$line = [Int32][Math]::Floor($block_height / $island_height)
#分配的区域可以放多少 列 小岛
$column = [Int32][Math]::Floor($block_width / $island_width)

#岛与岛之间纵向空隙总和
$vertical_gap = $block_height % $island_height
#岛与岛之间横向空隙总和
$horizontal_gap = $block_width % $island_width

#行与行之间的空隙，这里采用了直接除以多少行的做法，还可以采用除以($line-1)和除以($line+1)的做法。
#直接除以行数，那么在第一行后才累加空隙，最后一行后防止剩余空隙
$per_vertical_gap = [Int32][Math]::Floor($vertical_gap / $line)
$per_horizontal_gap = [Int32][Math]::Floor($horizontal_gap / $column)

"每块区域大小(宽: $block_width ,高: $block_height ),岛屿大小(宽: $island_width ,高: $island_height), 可以分配岛屿个数: $($line*$column) ,其中横向可以摆放 $column 列,纵向可以摆放 $line 行,列之间空隙 $per_vertical_gap ,行之间空隙 $per_horizontal_gap" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green


$horizontal_number = [Int32][Math]::Floor($u32Max / $block_width) 
if ($horizontal_number % 2 -eq 1) {
    $horizontal_number = $horizontal_number - 1
}
$vertical_number = [Int32][Math]::Floor($u32Max / $block_height) 
if ($vertical_number % 2 -eq 1) {
    $vertical_number = $vertical_number - 1
}

"一共存在 " + $horizontal_number * $vertical_number + " 个区" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue


#最多能有多少圈？
$maxLoop = $horizontal_number
if ($horizontal_number -ge $vertical_number) { 
    $maxLoop = $vertical_number 
}

# 包括本圈在内一共多少区
$current = 0 
$next = 0
$loop = 0
for ($i = 1; $i -le $maxLoop ; $i++) {    
    $current = $current + (2 * $i - 1) * 4;
    $next = $current + (2 * ($i + 1) - 1) * 4
    if ($seqNo -le $current) {
        $loop = $i
        "位于第 " + $loop + " 圈" | Tee-Object -FilePath $logFile -Append | Write-Host
        break;
    }
    if ( $seqNo -le $next) {
        $loop = $i + 1
        "位于第 " + $loop + " 圈" | Tee-Object -FilePath $logFile -Append | Write-Host
        break;
    }
}
if ($loop -eq 0) {
    "超范围了" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
}
#$current_loop_block = 4
#$blocks_per_quadrant = 1
$left = 0
$bottom = 0 
if ($loop -eq 1) {
    $before = 0
    if ($seqNo -eq 1) {
        $left = $original_x
        $bottom = $original_y        
    }
    elseif ($seqNo -eq 2) {
        $left = $original_x - $block_width
        $bottom = $original_y     
    }
    elseif ($seqNo -eq 3) {
        $left = $original_x - $block_width
        $bottom = $original_y - $block_height 
    }
    elseif ($seqNo -eq 4) {
        $left = $original_x
        $bottom = $original_y - $block_height 
    }
}
else {
    $before = $current
    $blocks_per_quadrant = 2 * $loop - 1;
    $current_loop_block = $blocks_per_quadrant * 4
    "序号为 $seqNo 的小岛位于第 $loop 圈,本圈之前包括 $before 区,本圈共有 $current_loop_block 个区，每个象限 $blocks_per_quadrant 个" | Tee-Object -FilePath $logFile -Append | Write-Host
    $quadrantNo = 0
    $currentLoopSeqNo = ($seqNo - $before)
    #如果能够整除
    if ($currentLoopSeqNo % $blocks_per_quadrant -eq 0) {
        $quadrantNo = $currentLoopSeqNo / $blocks_per_quadrant
    }
    else {
        $quadrantNo = ([Int32][Math]::Floor($currentLoopSeqNo / $blocks_per_quadrant) + 1)
    }
    "位于第 $quadrantNo 象限" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor DarkGreen  

    #在某个圈的某个象限内的块分成3个部分，前半部分，中间，以及后半部分
    $half_quantity = $loop - 1
    "第 $loop 圈在每个象限内分成 3 个部分，前半部分和后半部分各有 $half_quantity 个块。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow 
    $begin = $before + ($quadrantNo - 1) * $blocks_per_quadrant + 1
    "象限内的起始元素为：$begin" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow 
    $first_half_blocks = @()
    $middle = $begin + $half_quantity 
    $second_half_blocks = @()
    for ($i = 0; $i -lt $half_quantity; $i++) {
        $first_half_blocks += $begin + $i
        $second_half_blocks += $middle + $i + 1
    }
    "象限内的前半部分块的序号为：$first_half_blocks ，中间为为 $middle ，后半部分块的序号为 $second_half_blocks" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green 

    if ($quadrantNo -eq 1) {
        $middle_left = $original_x + ($loop - 1) * $block_width
        $middle_bottom = $original_y + ($loop - 1) * $block_height  
        if ($first_half_blocks -contains $seqNo) {
            $index = $first_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的前半部分，位置索引为:$index" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan 
            $left = $middle_left
            $bottom = $original_y + $index * $block_height        
        }
        elseif ( $middle -eq $seqNo) {
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的中间" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan
            $left = $middle_left
            $bottom = $middle_bottom
        }
        elseif ($second_half_blocks -contains $seqNo) {
            $index = $second_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的后半部分，位置索引为: $index" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan 
            $bottom = $middle_bottom
            $left = $middle_bottom - ($index + 1) * $block_width
        }
        else {
            "有问题！"  | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red 
            Set-Location $startLocation
            return
        }
    }
    elseif ($quadrantNo -eq 2) {
        $middle_left = $original_x - $loop * $block_width
        $middle_bottom = $original_y + ($loop - 1) * $block_height  
        if ($first_half_blocks -contains $seqNo) {
            $index = $first_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的前半部分，位置索引为:$index" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan 
            $left = $original_x - 1 * ($index + 1) * $block_width
            $bottom = $middle_bottom      
        }
        elseif ( $middle -eq $seqNo) {
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的中间" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan
            $left = $middle_left
            $bottom = $middle_bottom
        }
        elseif ($second_half_blocks -contains $seqNo) {
            $index = $second_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的后半部分，位置索引为: $index" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan 
            $left = $middle_left
            $bottom = $middle_bottom - ($index + 1) * $block_height  
        }
        else {
            "有问题！" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red 
            Set-Location $startLocation
            return
        }
    }
    elseif ($quadrantNo -eq 3) {
        $middle_left = $original_x - $loop * $block_width
        $middle_bottom = $original_y - $loop * $block_height  
        if ($first_half_blocks -contains $seqNo) {
            $index = $first_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的前半部分，位置索引为:$index" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan 
            $left = $middle_left
            $bottom = $original_y - 1 * ($index + 1) * $block_height    
        }
        elseif ( $middle -eq $seqNo) {
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的中间" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan
            $left = $middle_left
            $bottom = $middle_bottom
        }
        elseif ($second_half_blocks -contains $seqNo) {
            $index = $second_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的后半部分，位置索引为: $index" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan 
            $left = $middle_left + ($index + 1) * $block_width
            $bottom = $middle_bottom 
        }
        else {
            "有问题！" | Tee-Object -FilePath $logFile -Append  | Write-Host -ForegroundColor Red 
            Set-Location $startLocation
            return
        }
    }
    elseif ($quadrantNo -eq 4) {
        $middle_left = $original_x + ($loop - 1) * $block_width
        $middle_bottom = $original_y - $loop * $block_height  
        if ($first_half_blocks -contains $seqNo) {
            $index = $first_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的前半部分，位置索引为:$index" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan 
            $left = $original_x + ($index) * $block_width
            $bottom = $middle_bottom
        }
        elseif ( $middle -eq $seqNo) {
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的中间" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan
            $left = $middle_left
            $bottom = $middle_bottom
        }
        elseif ($second_half_blocks -contains $seqNo) {
            $index = $second_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的后半部分，位置索引为: $index" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Cyan 
            $left = $middle_left
            $bottom = $middle_bottom + ($index + 1) * $block_height  
        }
        else {
            "有问题！"  | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red 
            Set-Location $startLocation
            return
        }
    }
    else {
        "非法象限: $quadrantNo" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red 
        Set-Location $startLocation
    }
}
"左下角坐标为：($left,$bottom)" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow


Add-Type -TypeDefinition @"
public class CoordinateX{
    public long InitX { get; set; }
    public long InitY { get; set; }
    public long RateX { get; set; }
    public long RateY { get; set; }
    public long RandomX { get; set; }
    public long RandomY { get; set; }
}
"@

$coordinates = @()     
$random = New-Object System.Random  
for ($i = 0; $i -lt $column; $i++) {
    "第 $($i+1) 列中心坐标" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow 
    for ($j = 0; $j -lt $line; $j++) {
        $x = $left + ($i) * ($per_horizontal_gap + $island_width) + $island_width / 2
        $y = $bottom + ($j) * ($per_horizontal_gap + $island_height) + $island_height / 2
        "初始：($x,$y)" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green -NoNewline
        $coordinate = New-Object CoordinateX
        $coordinate.InitX = $x
        $coordinate.InitY = $y
        $a = (-1 * $rand_rate_x * 100)
        $b = ($rand_rate_x * 100 + 1)
        $coordinate.RateX = $random.Next($a, $b)
        $m = (-1 * $rand_rate_y * 100)
        $n = ($rand_rate_y * 100 + 1)
        $coordinate.RateY = $random.Next($m, $n)
        "，分别波动:($($coordinate.RateX/100),$($coordinate.RateY/100)) 后变为" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green -NoNewline
        $coordinate.RandomX = $coordinate.InitX + ($island_width * $coordinate.RateX) / 100
        $coordinate.RandomY = $coordinate.InitY + ($island_height * $coordinate.RateY) / 100
        "($($coordinate.RandomX),$($coordinate.RandomY))" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green 
        $coordinates += $coordinate
    }
    "`n" | Write-Host
}

#"`n开始生成岛屿坐标列表:`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue
#批量添加
$coordinatesXArray = "uint32[$($coordinates.Count)] memory coordinatesX = ["
$coordinatesYArray = "uint32[$($coordinates.Count)] memory coordinatesY = ["
$index = 0
foreach ($coordinate in $coordinates) {
    $coordinatesXArray += "uint32($($coordinate.RandomX))"
    $coordinatesYArray += "uint32($($coordinate.RandomY))"
    if ($index -ne $coordinates.Count - 1) {
        $coordinatesXArray += ","
        $coordinatesYArray += ","
    }
    $index++
}
$coordinatesXArray += "];"
$coordinatesYArray += "];"
"生成岛屿坐标列表如下:`n" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Green
"$coordinatesXArray`n" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
"$coordinatesYArray`n" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
"查看日志:$logFile`n" | Write-Host -ForegroundColor Blue

"将 X 坐标数组和 Y 坐标数组复制到 BatchAddSingleIsland.s.sol 中在 script 目录下执行：`n" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
"forge script BatchAddSingleIsland.s.sol:BatchCall --sig ""run(address)"" $worldAddress --broadcast --rpc-url $rpc_url" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Green
