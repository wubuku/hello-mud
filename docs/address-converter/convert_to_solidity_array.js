const fs = require('fs');
const { ethers } = require('ethers');

function convertToSolidityArray(inputFile, outputFile) {
    // 读取地址文件
    const content = fs.readFileSync(inputFile, 'utf8');
    const addresses = content.split('\n').filter(line => line.trim());
    
    // 生成Solidity代码
    let output = `address[] memory walletAddresses = new address[](${addresses.length});\n`;
    
    addresses.forEach((addr, index) => {
        // 使用ethers.js的getAddress来确保checksum格式正确
        const checksumAddr = ethers.utils.getAddress(addr.trim());
        output += `walletAddresses[${index}] = address(${checksumAddr});\n`;
    });
    
    // 写入文件
    fs.writeFileSync(outputFile, output);
    console.log(`Successfully converted ${addresses.length} addresses`);
}

// 执行转换
convertToSolidityArray(
    '../valid_addresses.txt',
    'output.sol'
);