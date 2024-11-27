import re
from eth_utils import to_checksum_address, is_checksum_address

def to_valid_checksum(address):
    try:
        return to_checksum_address(address)
    except ValueError:
        return None

def is_valid_eth_address(address):
    # 检查是否是有效的以太坊地址格式
    # 1. 以 0x 开头
    # 2. 后面跟着40个十六进制字符
    # 3. 符合 EIP-55 校验和标准
    pattern = r'^0x[0-9a-fA-F]{40}$'
    if not re.match(pattern, address):
        return False
    try:
        return is_checksum_address(address)
    except ValueError:
        return False

def extract_eth_addresses(input_file, output_file):
    eth_pattern = r'0x[0-9a-fA-F]{40}'
    valid_addresses = set()
    
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
        potential_addresses = re.findall(eth_pattern, content)
        
        for address in potential_addresses:
            # 转换为正确的校验和格式并验证
            checksum_address = to_valid_checksum(address)
            if checksum_address and is_valid_eth_address(checksum_address):
                valid_addresses.add(checksum_address)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        for address in sorted(valid_addresses):
            f.write(address + '\n')
    
    return len(valid_addresses)

# 使用脚本
input_file = './11:27-1kwallet.md'  # 替换为你的输入文件路径
output_file = 'valid_addresses.txt'     # 替换为你想要的输出文件路径

count = extract_eth_addresses(input_file, output_file)
print(f"已提取 {count} 个有效的以太坊地址到 {output_file}")