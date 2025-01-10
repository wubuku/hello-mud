#!/bin/bash

export RPC_HTTP_URL=https://odyssey.storyrpc.io

export DATABASE_URL=postgres://mud:mud@127.0.0.1:5432/mud

export STORE_ADDRESS=0x776086899eab4ee3953b7c037b2c0a13c7a1deed

export START_BLOCK=1005995

#前端服务暴露的端口
export PORT=8095

# 日志文件
LOG_FILE="task.log"

# 记录日志的函数
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 检查并重启服务的函数
check_and_restart_service() {
    SERVICE_NAME=$1
    COMMAND=$2
    FULL_COMMAND="nohup $COMMAND >> \"${SERVICE_NAME}.log\" 2>&1 &"  # 完整命令

    # 检查服务是否正在运行
    if pgrep -f "$SERVICE_NAME" > /dev/null; then
        log "$SERVICE_NAME is already running. Restarting..."
        # 获取进程ID并杀死进程
        pkill -f "$SERVICE_NAME"
        sleep 2 # 等待进程完全退出
    fi

    # 启动服务
    eval $FULL_COMMAND  # 使用 eval 执行完整命令
    log "$SERVICE_NAME started with command: $FULL_COMMAND"  # 记录执行的完整命令
}

# 运行服务
check_and_restart_service "postgres-decoded-indexer" "npx -y -p @latticexyz/store-indexer postgres-decoded-indexer"
sleep 3 # 等待3秒
check_and_restart_service "postgres-frontend" "npx -y -p @latticexyz/store-indexer postgres-frontend"