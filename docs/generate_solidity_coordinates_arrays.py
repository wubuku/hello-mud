import re

def read_coordinates(filename):
    with open(filename, 'r') as f:
        content = f.read()
        # 使用正则表达式匹配所有数字
        numbers = re.findall(r'\d+', content)
        return [int(num) for num in numbers]

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
    # 读取坐标文件
    coords_x = read_coordinates('./island_coordinats_x.txt')
    coords_y = read_coordinates('./island_coordinats_y.txt')

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
