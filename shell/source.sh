#!/bin/bash

# 检查用户是否为root
if [ "$(id -u)" != "0" ]; then
    echo "该脚本必须以root身份运行。"
    exit 1
fi

# 备份现有的sources.list
cp /etc/apt/sources.list /etc/apt/sources.list.backup

# 更新为官方Debian镜像源的函数
update_sources() {
    # 检查网络连接是否正常
    if ! ping -c 1 deb.debian.org &> /dev/null; then
        echo "无法连接到官方Debian镜像源。请检查您的网络连接。"
        exit 1
    fi

    # 检查官方Debian源是否可用
    if ! curl -s --head https://deb.debian.org/debian/ | head -n 1 | grep "200 OK" > /dev/null; then
        echo "官方Debian镜像源不可用。请稍后再试或选择其他镜像源。"
        exit 1
    fi

    cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ bullseye main contrib non-free
deb-src https://deb.debian.org/debian/ bullseye main contrib non-free

deb https://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb-src https://deb.debian.org/debian/ bullseye-updates main contrib non-free

deb https://deb.debian.org/debian/ bullseye-backports main contrib non-free
deb-src https://deb.debian.org/debian/ bullseye-backports main contrib non-free

deb https://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb-src https://deb.debian.org/debian-security/ bullseye-security main contrib non-free
EOF
    echo "Debian源已成功更新为官方镜像。"
}

# 更新为清华镜像的函数
update_tsinghua_mirrors_sources() {
    # 检查清华镜像源是否可用
    if ! curl -s --head https://mirrors.tuna.tsinghua.edu.cn/debian/ | head -n 1 | grep "200 OK" > /dev/null; then
        echo "清华镜像源不可用。请稍后再试或选择其他镜像源。"
        exit 1
    fi

    cat > /etc/apt/sources.list << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bullseye-security main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bullseye-security main contrib non-free
EOF
    echo "Debian源已成功更新为使用清华镜像。"
}

# 更新为中科大镜像的函数
update_ustc_mirrors_sources() {
    # 检查中科大镜像源是否可用
    if ! curl -s --head https://mirrors.ustc.edu.cn/debian/ | head -n 1 | grep "200 OK" > /dev/null; then
        echo "中科大镜像源不可用。请稍后再试或选择其他镜像源。"
        exit 1
    fi

    cat > /etc/apt/sources.list << EOF
deb https://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free

deb https://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free

deb https://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free

deb https://mirrors.ustc.edu.cn/debian-security/ bullseye-security main contrib non-free
deb-src https://mirrors.ustc.edu.cn/debian-security/ bullseye-security main contrib non-free
EOF
    echo "Debian源已成功更新为使用中科大镜像。"
}

# 更新为腾讯云镜像的函数
update_tencent_mirrors_sources() {
    # 检查腾讯云镜像源是否可用
    if ! curl -s --head https://mirrors.cloud.tencent.com/debian/ | head -n 1 | grep "200 OK" > /dev/null; then
        echo "腾讯云镜像源不可用。请稍后再试或选择其他镜像源。"
        exit 1
    fi

    cat > /etc/apt/sources.list << EOF
deb https://mirrors.cloud.tencent.com/debian/ bullseye main contrib non-free
deb-src https://mirrors.cloud.tencent.com/debian/ bullseye main contrib non-free

deb https://mirrors.cloud.tencent.com/debian/ bullseye-updates main contrib non-free
deb-src https://mirrors.cloud.tencent.com/debian/ bullseye-updates main contrib non-free

deb https://mirrors.cloud.tencent.com/debian/ bullseye-backports main contrib non-free
deb-src https://mirrors.cloud.tencent.com/debian/ bullseye-backports main contrib non-free

deb https://mirrors.cloud.tencent.com/debian-security/ bullseye-security main contrib non-free
deb-src https://mirrors.cloud.tencent.com/debian-security/ bullseye-security main contrib non-free
EOF
    echo "Debian源已成功更新为使用腾讯云镜像。"
}

# 更新为阿里云镜像的函数
update_aliyun_mirrors_sources() {
    # 检查阿里云镜像源是否可用
    if ! curl -s --head https://mirrors.aliyun.com/debian/ | head -n 1 | grep "200 OK" > /dev/null; then
        echo "阿里云镜像源不可用。请稍后再试或选择其他镜像源。"
        exit 1
    fi

    cat > /etc/apt/sources.list << EOF
deb https://mirrors.aliyun.com/debian/ bullseye main contrib non-free
deb-src https://mirrors.aliyun.com/debian/ bullseye main contrib non-free

deb https://mirrors.aliyun.com/debian/ bullseye-updates main contrib non-free
deb-src https://mirrors.aliyun.com/debian/ bullseye-updates main contrib non-free

deb https://mirrors.aliyun.com/debian/ bullseye-backports main contrib non-free
deb-src https://mirrors.aliyun.com/debian/ bullseye-backports main contrib non-free

deb https://mirrors.aliyun.com/debian-security/ bullseye-security main contrib non-free
deb-src https://mirrors.aliyun.com/debian-security/ bullseye-security main contrib non-free
EOF
    echo "Debian源已成功更新为使用阿里云镜像。"
}

echo "请选择一个选项："
echo "0: 退出"
echo "1: 使用官方Debian镜像源"
echo "2: 使用清华镜像源"
echo "3: 使用中科大镜像源"
echo "4: 使用腾讯云镜像源"
echo "5: 使用阿里云镜像源"
read -p "请输入您的选择：" choice

# 检查用户输入并相应地更新源列表
case "$choice" in
    0)
        echo "退出，未更改源。"
        exit 0
        ;;
    1)
        update_sources
        ;;
    2)
        update_tsinghua_mirrors_sources
        ;;
    3)
        update_ustc_mirrors_sources
        ;;
    4)
        update_tencent_mirrors_sources
        ;;
    5)
        update_aliyun_mirrors_sources
        ;;
    *)
        echo "无效的选项，请选择0、1、2、3、4或5。"
        exit 1
        ;;
esac
