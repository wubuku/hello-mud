import re
import sys
import argparse

def read_coordinates_from_two_files():
    # 从两个单独的文件读取坐标
    with open('./island_coordinats_x.txt', 'r') as f:
        content_x = f.read()
        numbers_x = re.findall(r'\d+', content_x)
        coords_x = [int(num) for num in numbers_x]
    
    with open('./island_coordinats_y.txt', 'r') as f:
        content_y = f.read()
        numbers_y = re.findall(r'\d+', content_y)
        coords_y = [int(num) for num in numbers_y]
        
    return coords_x, coords_y

def read_coordinates_from_single_file():
    # 从单个文件读取x,y坐标对
    coords_x = []
    coords_y = []
    
    with open('./island_coordinatas_x_y.txt', 'r') as f:
        for line in f:
            if 'x:' in line and 'y:' in line:
                # 提取x和y的值
                x_match = re.search(r'x:(\d+)', line)
                y_match = re.search(r'y:(\d+)', line)
                if x_match and y_match:
                    coords_x.append(int(x_match.group(1)))
                    coords_y.append(int(y_match.group(1)))
    
    return coords_x, coords_y

def generate_solidity_arrays(coords_x, coords_y):
    # 生成X坐标数组
    solidity_x = f"    uint32[{len(coords_x)}] memory coordinatesX = [\n"
    for i, x in enumerate(coords_x):
        solidity_x += f"      uint32({x})"
        if i < len(coords_x) - 1:
            solidity_x += ","
        solidity_x += "\n"
    solidity_x += "    ];\n\n"

    # 生成Y坐标数组
    solidity_y = f"    uint32[{len(coords_y)}] memory coordinatesY = [\n"
    for i, y in enumerate(coords_y):
        solidity_y += f"      uint32({y})"
        if i < len(coords_y) - 1:
            solidity_y += ","
        solidity_y += "\n"
    solidity_y += "    ];\n"

    return solidity_x + solidity_y

def main():
    # 设置命令行参数解析
    parser = argparse.ArgumentParser(description='Generate Solidity coordinate arrays from input files.')
    parser.add_argument('source', choices=['single', 'double'],
                      help='Source file format: "single" for one x,y file, "double" for separate x and y files')
    
    try:
        args = parser.parse_args()
    except SystemExit:
        print("\nError: You must specify the source format!")
        print('Usage: python script.py single|double')
        print('  single: Read from island_coordinatas_x_y.txt')
        print('  double: Read from island_coordinats_x.txt and island_coordinats_y.txt')
        sys.exit(1)

    # 根据参数选择读取方式
    if args.source == 'single':
        coords_x, coords_y = read_coordinates_from_single_file()
    else:  # double
        coords_x, coords_y = read_coordinates_from_two_files()

    # 验证数组长度
    if len(coords_x) != len(coords_y):
        print(f"Error: Array length mismatch! X: {len(coords_x)}, Y: {len(coords_y)}")
        return

    # 生成Solidity数组
    solidity_arrays = generate_solidity_arrays(coords_x, coords_y)

    # 保存到文件
    output_file = 'generated_coordinates.sol'
    with open(output_file, 'w') as f:
        f.write(solidity_arrays)

    print(f"Successfully generated {output_file} with {len(coords_x)} coordinate pairs")

if __name__ == "__main__":
    main()

# # 从单个文件读取
# python generate_solidity_coordinates_arrays.py single

# # 从两个文件读取
# python generate_solidity_coordinates_arrays.py double

# # 不提供参数会显示帮助信息
# python generate_solidity_coordinates_arrays.py