#!/bin/bash

SERVICE_NAME="ssr"
WORK_DIR="/root/shadowsocksr"
START_CMD="/usr/bin/python3 /root/shadowsocksr/server.py"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

green(){
    echo -e "\033[32m$1\033[0m"
}

red(){
    echo -e "\033[31m$1\033[0m"
}

install_service(){

cat > $SERVICE_FILE <<EOF
[Unit]
Description=ShadowsocksR Service
After=network.target

[Service]
Type=simple
WorkingDirectory=$WORK_DIR
ExecStart=$START_CMD

Restart=always
RestartSec=5
LimitNOFILE=512000

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl restart $SERVICE_NAME

green "SSR 守护安装完成"
}

start_service(){
    systemctl start $SERVICE_NAME
    green "SSR 已启动"
}

stop_service(){
    systemctl stop $SERVICE_NAME
    red "SSR 已停止"
}

restart_service(){
    systemctl restart $SERVICE_NAME
    green "SSR 已重启"
}

status_service(){
    systemctl status $SERVICE_NAME
}

log_service(){
    journalctl -u $SERVICE_NAME -f
}

enable_service(){
    systemctl enable $SERVICE_NAME
    green "已设置开机自启"
}

disable_service(){
    systemctl disable $SERVICE_NAME
    red "已关闭开机自启"
}

uninstall_service(){

systemctl stop $SERVICE_NAME
systemctl disable $SERVICE_NAME

rm -f $SERVICE_FILE

systemctl daemon-reload

red "SSR 守护已卸载"
}

menu(){
    clear
    echo "=============================="
    echo " ShadowsocksR 守护管理脚本"
    echo "=============================="
    echo "1. 安装守护"
    echo "2. 启动 SSR"
    echo "3. 停止 SSR"
    echo "4. 重启 SSR"
    echo "5. 查看状态"
    echo "6. 查看日志"
    echo "7. 开启开机自启"
    echo "8. 关闭开机自启"
    echo "9. 卸载守护"
    echo "0. 退出"
    echo "=============================="
    read -p "请输入选项: " num

    case "$num" in
    1)
    install_service
    ;;
    2)
    start_service
    ;;
    3)
    stop_service
    ;;
    4)
    restart_service
    ;;
    5)
    status_service
    ;;
    6)
    log_service
    ;;
    7)
    enable_service
    ;;
    8)
    disable_service
    ;;
    9)
    uninstall_service
    ;;
    0)
    exit 0
    ;;
    *)
    red "请输入正确选项"
    ;;
    esac
}

menu
