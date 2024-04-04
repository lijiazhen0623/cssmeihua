#!/bin/bash

# 输出字体颜色
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[0;33m"
NC="\033[0m"
GREEN_ground="\033[42;37m" # 全局绿色
RED_ground="\033[41;37m"   # 全局红色
Info="${GREEN}[信息]${NC}"
Error="${RED}[错误]${NC}"
Tip="${YELLOW}[提示]${NC}"

cop_info(){
clear
echo -e "${GREEN}######################################
#            ${RED}DDNS 一键脚本           ${GREEN}#
#             作者: ${YELLOW}末晨             ${GREEN}#
######################################${NC}"
echo
}

# 检查是否为root用户
check_root(){
    if [[ $(whoami) != "root" ]]; then
        echo -e "${Error}请以root身份执行该脚本！"
        exit 1
    fi
}

# 开始安装DDNS
install_ddns(){
    if [ ! -f "/usr/bin/ddns" ]; then
        curl -o /usr/bin/ddns https://raw.githubusercontent.com/mocchen/cssmeihua/mochen/shell/ddns-test4.sh && chmod +x /usr/bin/ddns
    fi
    mkdir -p /etc/DDNS
    cat <<'EOF' > /etc/DDNS/DDNS
#!/bin/bash

# 引入环境变量文件
source /etc/DDNS/.config

# 更新IPv4 DNS记录
curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$Zone_id/dns_records/$DNS_IDv4" \
     -H "X-Auth-Email: $Email" \
     -H "X-Auth-Key: $Api_key" \
     -H "Content-Type: application/json" \
     --data "{\"type\":\"A\",\"name\":\"$Domain\",\"content\":\"$Public_IPv4\"}" >/dev/null 2>&1

# 更新IPv6 DNS记录
curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$Zone_id/dns_records/$DNS_IDv6" \
     -H "X-Auth-Email: $Email" \
     -H "X-Auth-Key: $Api_key" \
     -H "Content-Type: application/json" \
     --data "{\"type\":\"AAAA\",\"name\":\"$Domain\",\"content\":\"$Public_IPv6\"}" >/dev/null 2>&1

# 发送Telegram通知
if [[ -n "$Telegram_Bot_Token" && -n "$Telegram_Chat_ID" ]]; then
    send_telegram_notification
fi
EOF

    cat <<'EOF' > /etc/DDNS/.config
Domain="your_domain.com"		# 你要解析的域名
Email="your_email@gmail.com"     # 你在Cloudflare注册的邮箱
Api_key="your_api_key"  # 你的Cloudflare API密钥

# Telegram Bot Token 和 Chat ID
Telegram_Bot_Token=""
Telegram_Chat_ID=""

# 获取根域名
Root_domain=$(echo "$Domain" | cut -d'.' -f2-)

# 获取公网IP地址
regex_pattern='^(eth|ens|eno|esp|enp)[0-9]+'

InterFace=($(ip link show | awk -F': ' '{print $2}' | grep -E "$regex_pattern" | sed "s/@.*//g"))

Public_IPv4=""
Public_IPv6=""

for i in "${InterFace[@]}"; do
    ipv4=$(curl -s4m8 --interface "$i" api64.ipify.org -k | sed '/^\(2a09\|104\.28\)/d')
    ipv6=$(curl -s6m8 --interface "$i" api64.ipify.org -k | sed '/^\(2a09\|104\.28\)/d')
    
    # 检查是否获取到IP地址
    if [[ -n "$ipv4" ]]; then
        Public_IPv4="$ipv4"
    fi
    
    if [[ -n "$ipv6" ]]; then
        Public_IPv6="$ipv6"
    fi
done

# 使用Cloudflare API获取根域名的区域ID
Zone_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$Root_domain" \
     -H "X-Auth-Email: $Email" \
     -H "X-Auth-Key: $Api_key" \
     -H "Content-Type: application/json" \
     | grep -Po '(?<="id":")[^"]*')

# 获取IPv4 DNS记录ID
DNS_IDv4=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$Zone_id/dns_records?type=A&name=$Domain" \
     -H "X-Auth-Email: $Email" \
     -H "X-Auth-Key: $Api_key" \
     -H "Content-Type: application/json" \
     | grep -Po '(?<="id":")[^"]*' | head -1)

# 获取IPv6 DNS记录ID
DNS_IDv6=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$Zone_id/dns_records?type=AAAA&name=$Domain" \
     -H "X-Auth-Email: $Email" \
     -H "X-Auth-Key: $Api_key" \
     -H "Content-Type: application/json" \
     | grep -Po '(?<="id":")[^"]*' | head -1)

# 发送Telegram通知
send_telegram_notification(){
    curl -s -X POST "https://api.telegram.org/bot$Telegram_Bot_Token/sendMessage" \
        -d "chat_id=$Telegram_Chat_ID" \
        -d "text=DDNS 更新：$Domain 的 IP 地址已更新为 $Public_IPv4 (IPv4) 和 $Public_IPv6 (IPv6)。"
}
EOF
    echo -e "${Info}DDNS 安装完成!”
    echo

# 检查是否需要发送Telegram通知
check_send_telegram_notification(){
    if [[ -n "$Old_IPv4" && "$Old_IPv4" != "$Public_IPv4" ]] || [[ -n "$Old_IPv6" && "$Old_IPv6" != "$Public_IPv6" ]]; then
        send_telegram_notification
    fi
}

# 获取之前的IP地址
get_previous_ip(){
    if [[ -f "/etc/DDNS/previous_ip" ]]; then
        Old_IPv4=$(sed -n '1p' /etc/DDNS/previous_ip)
        Old_IPv6=$(sed -n '2p' /etc/DDNS/previous_ip)
    fi
}

# 更新之前的IP地址
update_previous_ip(){
    echo "$Public_IPv4" >/etc/DDNS/previous_ip
    echo "$Public_IPv6" >>/etc/DDNS/previous_ip
}

# 检查是否需要配置 Telegram 设置
check_telegram_settings(){
    if [[ -f "/etc/DDNS/.config" ]]; then
        source /etc/DDNS/.config
        if [[ -n "$Telegram_Bot_Token" && -n "$Telegram_Chat_ID" ]]; then
            skip_telegram_settings=true
        fi
    fi
}

# 设置Cloudflare Api
set_cloudflare_api(){
    echo -e "${Tip}开始配置CloudFlare API..."
    echo

    echo -e "${Tip}请输入您的Cloudflare邮箱"
    read -rp "邮箱: " EMail
    if [ -z "$EMail" ]; then
        echo -e "${Error}未输入邮箱，无法执行操作！"
        exit 1
    else
        Email="$EMail"
    fi
    echo -e "${Info}你的邮箱：${RED_ground}${Email}${NC}"
    echo

    echo -e "${Tip}请输入您的Cloudflare API密钥"
    read -rp "密钥: " Api_Key
    if [ -z "$Api_Key" ]; then
        echo -e "${Error}未输入密钥，无法执行操作！"
        exit 1
    else
        Api_key="$Api_Key"
    fi
    echo -e "${Info}你的密钥：${RED_ground}${Api_key}${NC}"
    echo

    sed -i 's/^#\?Email=".*"/Email="'"${Email}"'"/g' /etc/DDNS/.config
    sed -i 's/^#\?Api_key=".*"/Api_key="'"${Api_key}"'"/g' /etc/DDNS/.config
}

# 设置解析的域名
set_domain(){
    echo -e "${Tip}请输入您解析的域名"
    read -rp "域名: " DOmain
    if [ -z "$DOmain" ]; then
        echo -e "${Error}未输入域名，无法执行操作！"
        exit 1
    else
        Domain="$DOmain"
    fi
    echo -e "${Info}你的域名：${RED_ground}${Domain}${NC}"
    echo

    sed -i 's/^#\?Domain=".*"/Domain="'"${Domain}"'"/g' /etc/DDNS/.config
}

# 运行DDNS服务
run_ddns(){
    service='[Unit]
Description=ddns
After=network.target

[Service]
Type=simple
WorkingDirectory=/etc/DDNS
ExecStart=bash DDNS

[Install]
WantedBy=multi-user.target'

    timer='[Unit]
Description=ddns timer

[Timer]
OnUnitActiveSec=60s
Unit=ddns.service

[Install]
WantedBy=multi-user.target'

    if [ ! -f "/etc/systemd/system/ddns.service" ] || [ ! -f "/etc/systemd/system/ddns.timer" ]; then
        echo -e "${Info}创建ddns定时任务..."
        echo "$service" >/etc/systemd/system/ddns.service
        echo "$timer" >/etc/systemd/system/ddns.timer
        echo -e "${Info}ddns定时任务已创建，每1分钟执行一次！"
        systemctl enable --now ddns.service >/dev/null 2>&1
        systemctl enable --now ddns.timer >/dev/null 2>&1
    else
        echo -e "${Tip}服务和定时器单元文件已存在，无需再次创建！"
    fi
}

# 重启DDNS服务
restart_ddns(){
    systemctl restart ddns.service >/dev/null 2>&1
    systemctl restart ddns.timer >/dev/null 2>&1
}

# 设置Telegram参数
set_telegram_settings(){
    echo -e "${Tip}开始配置Telegram通知设置..."
    echo

    echo -e "${Tip}请输入您的Telegram Bot Token"
    read -p "Token: " Token
    if [ -z "$Token" ]; then
        echo -e "${Error}未输入Token，无法执行操作！"
        exit 1
    else
        Telegram_Bot_Token="$Token"
    fi
    echo -e "${Info}你的Token：${RED_ground}${Telegram_Bot_Token}${NC}"
    echo

    echo -e "${Tip}请输入您的Telegram Chat ID"
    read -p "Chat ID: " Chat_ID
    if [ -z "$Chat_ID" ]; then
        echo -e "${Error}未输入Chat ID，无法执行操作！"
        exit 1
    else
        Telegram_Chat_ID="$Chat_ID"
    fi
    echo -e "${Info}你的Chat ID：${RED_ground}${Telegram_Chat_ID}${NC}"
    echo

    sed -i 's/^#\?Telegram_Bot_Token=".*"/Telegram_Bot_Token="'"${Telegram_Bot_Token}"'"/g' /etc/DDNS/.config
    sed -i 's/^#\?Telegram_Chat_ID=".*"/Telegram_Chat_ID="'"${Telegram_Chat_ID}"'"/g' /etc/DDNS/.config
}

# 检查是否需要配置 Telegram 设置
check_telegram_settings

if [[ ! $skip_telegram_settings ]]; then
    echo -e "${Tip}是否要配置 Telegram 通知设置？[Y/n]"
    read -p "选择 默认为 Y" choice
    if [[ $choice =~ ^[Nn]$ ]]; then
        echo -e "${Tip}已跳过 Telegram 通知设置"
    else
        set_telegram_settings
    fi
fi

# 检查是否安装DDNS
check_ddns_install(){
    if [ ! -f "/etc/DDNS/.config" ]; then
        cop_info
        echo -e "${Tip}DDNS 未安装，现在开始安装..."
        echo
        install_ddns
        set_cloudflare_api
        set_domain
        run_ddns
        echo -e "${Info}执行 ${GREEN}ddns${NC} 可呼出菜单！"
    else
        cop_info
        check_ddns_status
        if [[ "$ddns_status" == "running" ]]; then
            echo -e "${Info}DDNS：${GREEN}已安装${NC} 并 ${GREEN}已启动${NC}"
        else
            echo -e "${Tip}DDNS：${GREEN}已安装${NC} 但 ${RED}未启动${NC}"
            echo -e "${Tip}请选择 ${GREEN}4${NC} 重新配置 Cloudflare Api 或 ${GREEN}5${NC} 配置 Telegram 通知"
        fi
    echo
    go_ahead
    fi
}

# 检查 DDNS 状态
check_ddns_status(){
    if [[ -f "/etc/systemd/system/ddns.timer" ]]; then
        STatus=$(systemctl status ddns.timer | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
        if [[ "$STatus" =~ "inactive" ]]; then
            ddns_status="stopped"
        else
            ddns_status="running"
        fi
    else
        ddns_status="uninstalled"
    fi
}

# 运行菜单函数
go_ahead(){
    echo -e "${Tip}是否继续？[Y/n]"
    read -p "选择 默认为 Y: " choice
    if [[ $choice =~ ^[Nn]$ ]]; then
        echo -e "${Info}感谢您的使用！"
        exit 0
    else
        cop_info
        menu
    fi
}

# 菜单函数
menu(){
    echo -e "${GREEN}DDNS 一键脚本${NC}"
    echo -e "请选择您要执行的操作:"
    echo -e " ${GREEN}1.${NC} 安装 DDNS"
    echo -e " ${GREEN}2.${NC} 重新配置 Cloudflare API"
    echo -e " ${GREEN}3.${NC} 重新配置域名"
    echo -e " ${GREEN}4.${NC} 启动 DDNS"
    echo -e " ${GREEN}5.${NC} 重新配置 Telegram 通知"
    echo -e " ${GREEN}6.${NC} 退出"
    echo
    read -p "选择 [1-6]: " choice
    case $choice in
        1) cop_info
           install_ddns
           set_cloudflare_api
           set_domain
           run_ddns
           echo -e "${Info}执行 ${GREEN}ddns${NC} 可呼出菜单！"
           go_ahead;;
        2) cop_info
           set_cloudflare_api
           go_ahead;;
        3) cop_info
           set_domain
           restart_ddns
           go_ahead;;
        4) cop_info
           restart_ddns
           go_ahead;;
        5) cop_info
           set_telegram_settings
           go_ahead;;
        6) echo -e "${Info}感谢您的使用！"
           exit 0;;
        *) echo -e "${Error}无效的选择，请重试！"
           menu;;
    esac
}

check_root
check_ddns_install
