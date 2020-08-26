#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cd "$(
    cd "$(dirname "$0")" || exit
    pwd
)" || exit
#====================================================
#   System Request:Debian 9+/Ubuntu 18.04+/Centos 7+
#   Author: wulabing
#   Dscription: V2ray ws+tls onekey Management
#   Version: 1.0
#   email:admin@wulabing.com
#   Official document: www.v2ray.com
#====================================================

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
# Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

# 版本
shell_version="1.1.5.1"
shell_mode="None"
github_branch="master"
version_cmp="/tmp/version_cmp.tmp"
v2ray_conf_dir="/etc/v2ray"
nginx_conf_dir="/etc/nginx/conf/conf.d"
v2ray_conf="${v2ray_conf_dir}/config.json"
nginx_conf="${nginx_conf_dir}/v2ray.conf"
nginx_dir="/etc/nginx"
web_dir="/home/wwwroot"
nginx_openssl_src="/usr/local/src"
v2ray_bin_dir="/usr/bin/v2ray"
v2ray_info_file="$HOME/v2ray_info.inf"
# v2ray_qr_config_file="/usr/local/vmess_qr.json"
nginx_systemd_file="/etc/systemd/system/nginx.service"
v2ray_systemd_file="/etc/systemd/system/v2ray.service"
v2ray_access_log="/var/log/v2ray/access.log"
v2ray_error_log="/var/log/v2ray/error.log"
amce_sh_file="/root/.acme.sh/acme.sh"
ssl_update_file="/usr/bin/ssl_update.sh"
nginx_version="1.18.0"
openssl_version="1.1.1g"
jemalloc_version="5.2.1"
old_config_status="off"
# v2ray_plugin_version="$(wget -qO- "https://github.com/shadowsocks/v2ray-plugin/tags" | grep -E "/shadowsocks/v2ray-plugin/releases/tag/" | head -1 | sed -r 's/.*tag\/v(.+)\">.*/\1/')"

#移动旧版本配置信息 对小于 1.1.0 版本适配
# [[ -f "/etc/v2ray/vmess_qr.json" ]] && mv /etc/v2ray/vmess_qr.json $v2ray_qr_config_file

#简易随机数
random_num=$((RANDOM%12+4))
#生成伪装路径
camouflage="/$(head -n 10 /dev/urandom | md5sum | head -c ${random_num})/"

THREAD=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)

source '/etc/os-release'

#从VERSION中提取发行版系统的英文名称，为了在debian/ubuntu下添加相对应的Nginx apt源
VERSION=$(echo "${VERSION}" | awk -F "[()]" '{print $2}')

judge() {
    if [[ 0 -eq $? ]]; then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}
# modify_nginx_port() {
#     if [[ "on" == "$old_config_status" ]]; then
#         port="$(info_extraction '\"port\"')"
#     fi
#     sed -i "/ssl http2;$/c \\\tlisten ${port} ssl http2;" ${nginx_conf}
#     sed -i "3c \\\tlisten [::]:${port} http2;" ${nginx_conf}
#     # judge "V2ray port 修改"
#     # [ -f ${v2ray_qr_config_file} ] && sed -i "/\"port\"/c \\  \"port\": \"${port}\"," ${v2ray_qr_config_file}
#     # echo -e "${OK} ${GreenBG} 端口号:${port} ${Font}"
# }
# modify_nginx_other() {
#     sed -i "/server_name/c \\\tserver_name ${domain};" ${nginx_conf}
#     sed -i "/location/c \\\tlocation ${camouflage}" ${nginx_conf}
#     sed -i "/proxy_pass/c \\\tproxy_pass http://127.0.0.1:${PORT};" ${nginx_conf}
#     sed -i "/return/c \\\treturn 301 https://${domain}\$request_uri;" ${nginx_conf}
#     #sed -i "27i \\\tproxy_intercept_errors on;"  ${nginx_dir}/conf/nginx.conf
# }
is_root() {
    if [ 0 == $UID ]; then
        echo -e "${OK} ${GreenBG} 当前用户是root用户，进入安装流程 ${Font}"
        sleep 3
    else
        echo -e "${Error} ${RedBG} 当前用户不是root用户，请切换到root用户后重新执行脚本 ${Font}"
        exit 1
    fi
}
check_system() {
    if [[ "${ID}" == "centos" && ${VERSION_ID} -ge 7 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Centos ${VERSION_ID} ${VERSION} ${Font}"
        INS="yum"
    elif [[ "${ID}" == "debian" && ${VERSION_ID} -ge 8 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Debian ${VERSION_ID} ${VERSION} ${Font}"
        INS="apt"
        $INS update
        ## 添加 Nginx apt源
    elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}" | cut -d '.' -f1) -ge 16 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Ubuntu ${VERSION_ID} ${UBUNTU_CODENAME} ${Font}"
        INS="apt"
        $INS update
    else
        echo -e "${Error} ${RedBG} 当前系统为 ${ID} ${VERSION_ID} 不在支持的系统列表内，安装中断 ${Font}"
        exit 1
    fi

    $INS install dbus

    systemctl stop firewalld
    systemctl disable firewalld
    echo -e "${OK} ${GreenBG} firewalld 已关闭 ${Font}"

    systemctl stop ufw
    systemctl disable ufw
    echo -e "${OK} ${GreenBG} ufw 已关闭 ${Font}"

    # 日志文件
    mkdir -p /var/logs/nginx
    mkdir -p /var/logs/v2ray

}
chrony_install() {
    ${INS} -y install chrony
    judge "安装 chrony 时间同步服务 "

    timedatectl set-ntp true

    if [[ "${ID}" == "centos" ]]; then
        systemctl enable chronyd && systemctl restart chronyd
    else
        systemctl enable chrony && systemctl restart chrony
    fi

    judge "chronyd 启动 "

    timedatectl set-timezone Asia/Shanghai

    echo -e "${OK} ${GreenBG} 等待时间同步 ${Font}"
    sleep 10

    chronyc sourcestats -v
    chronyc tracking -v
    date
    read -rp "请确认时间是否准确,误差范围±3分钟(Y/N): " chrony_install
    [[ -z ${chrony_install} ]] && chrony_install="Y"
    case $chrony_install in
    [yY][eE][sS] | [yY])
        echo -e "${GreenBG} 继续安装 ${Font}"
        sleep 2
        ;;
    *)
        echo -e "${RedBG} 安装终止 ${Font}"
        exit 2
        ;;
    esac
}
dependency_install() {
    ${INS} install wget git lsof -y

    if [[ "${ID}" == "centos" ]]; then
        ${INS} -y install crontabs
    else
        ${INS} -y install cron
    fi
    judge "安装 crontab"

    if [[ "${ID}" == "centos" ]]; then
        touch /var/spool/cron/root && chmod 600 /var/spool/cron/root
        systemctl start crond && systemctl enable crond
    else
        touch /var/spool/cron/crontabs/root && chmod 600 /var/spool/cron/crontabs/root
        systemctl start cron && systemctl enable cron

    fi
    judge "crontab 自启动配置 "

    ${INS} -y install bc
    judge "安装 bc"

    ${INS} -y install unzip
    judge "安装 unzip"

    ${INS} -y install qrencode
    judge "安装 qrencode"

    ${INS} -y install curl
    judge "安装 curl"
    ${INS} -y install vim

    judge "安装 vim"

    if [[ "${ID}" == "centos" ]]; then
        ${INS} -y groupinstall "Development tools"
    else
        ${INS} -y install build-essential
    fi
    judge "编译工具包 安装"

    if [[ "${ID}" == "centos" ]]; then
        ${INS} -y install pcre pcre-devel zlib-devel epel-release
    else
        ${INS} -y install libpcre3 libpcre3-dev zlib1g-dev dbus
    fi

    #    ${INS} -y install rng-tools
    #    judge "rng-tools 安装"

    ${INS} -y install haveged
    #    judge "haveged 安装"

    #    sed -i -r '/^HRNGDEVICE/d;/#HRNGDEVICE=\/dev\/null/a HRNGDEVICE=/dev/urandom' /etc/default/rng-tools

    if [[ "${ID}" == "centos" ]]; then
        #       systemctl start rngd && systemctl enable rngd
        #       judge "rng-tools 启动"
        systemctl start haveged && systemctl enable haveged
        #       judge "haveged 启动"
    else
        #       systemctl start rng-tools && systemctl enable rng-tools
        #       judge "rng-tools 启动"
        systemctl start haveged && systemctl enable haveged
        #       judge "haveged 启动"
    fi
}
basic_optimization() {
    # 最大文件打开数
    sed -i '/^\*\ *soft\ *nofile\ *[[:digit:]]*/d' /etc/security/limits.conf
    sed -i '/^\*\ *hard\ *nofile\ *[[:digit:]]*/d' /etc/security/limits.conf
    echo '* soft nofile 65536' >>/etc/security/limits.conf
    echo '* hard nofile 65536' >>/etc/security/limits.conf

    # 关闭 Selinux
    if [[ "${ID}" == "centos" ]]; then
        sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
        setenforce 0
    fi

}
nginx_exist_check() {
    if [[ -f "/etc/nginx/sbin/nginx" ]]; then
        echo -e "${OK} ${GreenBG} Nginx已存在，跳过编译安装过程 ${Font}"
        sleep 2
    elif [[ -d "/usr/local/nginx/" ]]; then
        echo -e "${OK} ${GreenBG} 检测到其他套件安装的Nginx，继续安装会造成冲突，请处理后安装${Font}"
        exit 1
    else
        nginx_install
    fi
}
nginx_install() {
    #    if [[ -d "/etc/nginx" ]];then
    #        rm -rf /etc/nginx
    #    fi

    wget -nc --no-check-certificate http://nginx.org/download/nginx-${nginx_version}.tar.gz -P ${nginx_openssl_src}
    judge "Nginx 下载"
    wget -nc --no-check-certificate https://www.openssl.org/source/openssl-${openssl_version}.tar.gz -P ${nginx_openssl_src}
    judge "openssl 下载"
    wget -nc --no-check-certificate https://github.com/jemalloc/jemalloc/releases/download/${jemalloc_version}/jemalloc-${jemalloc_version}.tar.bz2 -P ${nginx_openssl_src}
    judge "jemalloc 下载"

    cd ${nginx_openssl_src} || exit

    [[ -d nginx-"$nginx_version" ]] && rm -rf nginx-"$nginx_version"
    tar -zxvf nginx-"$nginx_version".tar.gz

    [[ -d openssl-"$openssl_version" ]] && rm -rf openssl-"$openssl_version"
    tar -zxvf openssl-"$openssl_version".tar.gz

    [[ -d jemalloc-"${jemalloc_version}" ]] && rm -rf jemalloc-"${jemalloc_version}"
    tar -xvf jemalloc-"${jemalloc_version}".tar.bz2

    [[ -d "$nginx_dir" ]] && rm -rf ${nginx_dir}

    echo -e "${OK} ${GreenBG} 即将开始编译安装 jemalloc ${Font}"
    sleep 2

    cd jemalloc-${jemalloc_version} || exit
    ./configure
    judge "编译检查"
    make -j "${THREAD}" && make install
    judge "jemalloc 编译安装"
    echo '/usr/local/lib' >/etc/ld.so.conf.d/local.conf
    ldconfig

    echo -e "${OK} ${GreenBG} 即将开始编译安装 Nginx, 过程稍久，请耐心等待 ${Font}"
    sleep 4

    cd ../nginx-${nginx_version} || exit

    ./configure --prefix="${nginx_dir}" \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --with-pcre \
        --with-http_realip_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_secure_link_module \
        --with-http_v2_module \
        --with-cc-opt='-O3' \
        --with-ld-opt="-ljemalloc" \
        --with-openssl=../openssl-"$openssl_version"
    judge "编译检查"
    make -j "${THREAD}" && make install
    judge "Nginx 编译安装"

    # 修改基本配置
    sed -i 's/#user  nobody;/user  root;/' ${nginx_dir}/conf/nginx.conf
    sed -i 's/worker_processes  1;/worker_processes  3;/' ${nginx_dir}/conf/nginx.conf
    sed -i 's/    worker_connections  1024;/    worker_connections  4096;/' ${nginx_dir}/conf/nginx.conf
    sed -i '$i include conf.d/*.conf;' ${nginx_dir}/conf/nginx.conf

    # 删除临时文件
    rm -rf ../nginx-"${nginx_version}"
    rm -rf ../openssl-"${openssl_version}"
    rm -rf ../nginx-"${nginx_version}".tar.gz
    rm -rf ../openssl-"${openssl_version}".tar.gz

    # 添加配置文件夹，适配旧版脚本
    mkdir ${nginx_dir}/conf/conf.d
}
# nginx_conf_add() {
#     modify_nginx_port
#     modify_nginx_other
#     judge "Nginx 配置修改"

# }

web_camouflage() {
    ##请注意 这里和LNMP脚本的默认路径冲突，千万不要在安装了LNMP的环境下使用本脚本，否则后果自负
    rm -rf /home/wwwroot
    mkdir -p /home/wwwroot
    cd /home/wwwroot || exit
    git clone https://github.com/haitaoss/CamouflageSite.git
    judge "web 站点伪装"
}
domain_check() {
    read -rp "请输入你的域名信息(eg:www.wulabing.com):" domain
    domain_ip=$(ping "${domain}" -c 1 | sed '1{s/[^(]*(//;s/).*//;q}')
    echo -e "${OK} ${GreenBG} 正在获取 公网ip 信息，请耐心等待 ${Font}"
    local_ip=$(curl https://api-ipv4.ip.sb/ip)
    echo -e "域名dns解析IP：${domain_ip}"
    echo -e "本机IP: ${local_ip}"
    sleep 2
    if [[ $(echo "${local_ip}" | tr '.' '+' | bc) -eq $(echo "${domain_ip}" | tr '.' '+' | bc) ]]; then
        echo -e "${OK} ${GreenBG} 域名dns解析IP 与 本机IP 匹配 ${Font}"
        sleep 2
    else
        echo -e "${Error} ${RedBG} 请确保域名添加了正确的 A 记录，否则将无法正常使用 V2ray ${Font}"
        echo -e "${Error} ${RedBG} 域名dns解析IP 与 本机IP 不匹配 是否继续安装？（y/n）${Font}" && read -r install
        case $install in
        [yY][eE][sS] | [yY])
            echo -e "${GreenBG} 继续安装 ${Font}"
            sleep 2
            ;;
        *)
            echo -e "${RedBG} 安装终止 ${Font}"
            exit 2
            ;;
        esac
    fi
}
ssl_install() {
    if [[ "${ID}" == "centos" ]]; then
        ${INS} install socat nc -y
    else
        ${INS} install socat netcat -y
    fi
    judge "安装 SSL 证书生成脚本依赖"

    curl https://get.acme.sh | sh
    judge "安装 SSL 证书生成脚本"
}
acme() {
    if "$HOME"/.acme.sh/acme.sh --issue -d "${domain}" --standalone -k ec-256 --force --test; then
        echo -e "${OK} ${GreenBG} SSL 证书测试签发成功，开始正式签发 ${Font}"
        rm -rf "$HOME/.acme.sh/${domain}_ecc"
        sleep 2
    else
        echo -e "${Error} ${RedBG} SSL 证书测试签发失败 ${Font}"
        rm -rf "$HOME/.acme.sh/${domain}_ecc"
        exit 1
    fi

    if "$HOME"/.acme.sh/acme.sh --issue -d "${domain}" --standalone -k ec-256 --force; then
        echo -e "${OK} ${GreenBG} SSL 证书生成成功 ${Font}"
        sleep 2
        mkdir /data
        if "$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath /data/v2ray.crt --keypath /data/v2ray.key --ecc --force; then
            echo -e "${OK} ${GreenBG} 证书配置成功 ${Font}"
            sleep 2
        fi
    else
        echo -e "${Error} ${RedBG} SSL 证书生成失败 ${Font}"
        rm -rf "$HOME/.acme.sh/${domain}_ecc"
        exit 1
    fi
}
port_exist_check() {
    if [[ 0 -eq $(lsof -i:"$1" | grep -i -c "listen") ]]; then
        echo -e "${OK} ${GreenBG} $1 端口未被占用 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} 检测到 $1 端口被占用，以下为 $1 端口占用信息 ${Font}"
        lsof -i:"$1"
        echo -e "${OK} ${GreenBG} 5s 后将尝试自动 kill 占用进程 ${Font}"
        sleep 5
        lsof -i:"$1" | awk '{print $2}' | grep -v "PID" | xargs kill -9
        echo -e "${OK} ${GreenBG} kill 完成 ${Font}"
        sleep 1
    fi
}
ssl_judge_and_install() {
    if [[ -f "/data/v2ray.key" || -f "/data/v2ray.crt" ]]; then
        echo "/data 目录下证书文件已存在"
        echo -e "${OK} ${GreenBG} 是否删除 [Y/N]? ${Font}"
        read -r ssl_delete
        case $ssl_delete in
        [yY][eE][sS] | [yY])
            rm -rf /data/*
            echo -e "${OK} ${GreenBG} 已删除 ${Font}"
            ;;
        *) ;;

        esac
    fi

    if [[ -f "/data/v2ray.key" || -f "/data/v2ray.crt" ]]; then
        echo "证书文件已存在"
    elif [[ -f "$HOME/.acme.sh/${domain}_ecc/${domain}.key" && -f "$HOME/.acme.sh/${domain}_ecc/${domain}.cer" ]]; then
        echo "证书文件已存在"
        "$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath /data/v2ray.crt --keypath /data/v2ray.key --ecc
        judge "证书应用"
    else
        ssl_install
        acme
    fi
}
nginx_systemd() {
    cat >$nginx_systemd_file <<EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/etc/nginx/logs/nginx.pid
ExecStartPre=/etc/nginx/sbin/nginx -t
ExecStart=/etc/nginx/sbin/nginx -c ${nginx_dir}/conf/nginx.conf
ExecReload=/etc/nginx/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

    judge "Nginx systemd ServerFile 添加"
    systemctl daemon-reload
}

# tls_type() {
#     if [[ -f "/etc/nginx/sbin/nginx" ]] ; then
#         echo "请选择支持的 TLS 版本（default:3）:"
#         echo "请注意,如果你使用 Quantaumlt X / 路由器 / 旧版 Shadowrocket / 低于 4.18.1 版本的 V2ray core 请选择 兼容模式"
#         echo "1: TLS1.1 TLS1.2 and TLS1.3（兼容模式）"
#         echo "2: TLS1.2 and TLS1.3 (兼容模式)"
#         echo "3: TLS1.3 only"
#         read -rp "请输入：" tls_version
#         [[ -z ${tls_version} ]] && tls_version=3
#         if [[ $tls_version == 3 ]]; then
#             sed -i 's/ssl_protocols.*/ssl_protocols         TLSv1.3;/' $nginx_conf
#             echo -e "${OK} ${GreenBG} 已切换至 TLS1.3 only ${Font}"
#         elif [[ $tls_version == 1 ]]; then
#             sed -i 's/ssl_protocols.*/ssl_protocols         TLSv1.1 TLSv1.2 TLSv1.3;/' $nginx_conf
#             echo -e "${OK} ${GreenBG} 已切换至 TLS1.1 TLS1.2 and TLS1.3 ${Font}"
#         else
#             sed -i 's/ssl_protocols.*/ssl_protocols         TLSv1.2 TLSv1.3;/' $nginx_conf
#             echo -e "${OK} ${GreenBG} 已切换至 TLS1.2 and TLS1.3 ${Font}"
#         fi
#         systemctl restart nginx
#         judge "Nginx 重启"
#     else
#         echo -e "${Error} ${RedBG} Nginx 或 配置文件不存在 或当前安装版本为 h2 ，请正确安装脚本后执行${Font}"
#     fi
# }
start_process_systemd() {
    # systemctl daemon-reload
    # if [[ "$shell_mode" != "h2" ]]; then
        systemctl restart nginx
        judge "Nginx 启动"
    # fi
    # systemctl restart v2ray
    # judge "V2ray 启动"
}

enable_process_systemd() {
    # systemctl enable v2ray
    # judge "设置 v2ray 开机自启"
    # if [[ "$shell_mode" != "h2" ]]; then
        systemctl enable nginx
        judge "设置 Nginx 开机自启"
    # fi

}

stop_process_systemd() {
    if [[ "$shell_mode" != "h2" ]]; then
        systemctl stop nginx
    fi
    # systemctl stop v2ray
}
nginx_process_disabled() {
    [ -f $nginx_systemd_file ] && systemctl stop nginx && systemctl disable nginx
}
acme_cron_update() {
    # wget -N -P /usr/bin --no-check-certificate "https://raw.githubusercontent.com/wulabing/V2Ray_ws-tls_bash_onekey/dev/ssl_update.sh"
    wget -N -P /usr/bin --no-check-certificate "https://raw.githubusercontent.com/haitaoss/ScienceOnline/master/20200823shell/ssl_update.sh"
    if [[ $(crontab -l | grep -c "ssl_update.sh") -lt 1 ]]; then
      if [[ "${ID}" == "centos" ]]; then
          #        sed -i "/acme.sh/c 0 3 * * 0 \"/root/.acme.sh\"/acme.sh --cron --home \"/root/.acme.sh\" \
          #        &> /dev/null" /var/spool/cron/root
          sed -i "/acme.sh/c 0 3 * * 0 bash ${ssl_update_file}" /var/spool/cron/root
      else
          #        sed -i "/acme.sh/c 0 3 * * 0 \"/root/.acme.sh\"/acme.sh --cron --home \"/root/.acme.sh\" \
          #        &> /dev/null" /var/spool/cron/crontabs/root
          sed -i "/acme.sh/c 0 3 * * 0 bash ${ssl_update_file}" /var/spool/cron/crontabs/root
      fi
    fi
    judge "cron 计划任务更新"
}
nginx_conf_modify() {
    systemctl stop nginx
    cd /etc/nginx/conf
    rm -rf nginx.conf
    wget https://raw.githubusercontent.com/haitaoss/ScienceOnline/master/20200823shell/nginx.conf

    cd /etc/nginx/conf/conf.d
    rm -rf /etc/nginx/conf/conf.d/v2ray.conf
    wget https://raw.githubusercontent.com/haitaoss/ScienceOnline/master/20200823shell/v2ray.conf

    sed -i "/server_name www.baidu.com/c \\\tserver_name ${domain};"/etc/nginx/conf/conf.d/v2ray.conf
    # sed -i "/proxy_pass/c \\\tproxy_pass http://127.0.0.1:65432;" /etc/nginx/conf/conf.d/v2ray.conf
    sed -i "/return/c \\\treturn 301 https://${domain}/\$request_uri;" /etc/nginx/conf/conf.d/v2ray.conf
    cd ~


}
install_v2ray_ws_tls() {
    is_root
    check_system
    chrony_install
    dependency_install
    basic_optimization
    domain_check
    # old_config_exist_check
    # port_alterid_set
    # v2ray_install
    port_exist_check 80
    port_exist_check "${port}"
    nginx_exist_check
    # v2ray_conf_add_tls
    # nginx_conf_add
    web_camouflage
    ssl_judge_and_install
    nginx_conf_modify
    nginx_systemd
    # vmess_qr_config_tls_ws
    # basic_information
    # vmess_link_image_choice
    # tls_type
    # show_information
    start_process_systemd
    enable_process_systemd
    acme_cron_update
}
install_v2ui() {
    judge "手动安装v2-ui 版本"
    cd /root/
    wget "https://raw.githubusercontent.com/haitaoss/ScienceOnline/master/20200823shell/v2-ui-5.4.0-linux.tar.gz"
    mv v2-ui-5.4.0-linux.tar.gz /usr/local/
    cd /usr/local/
    tar zxvf v2-ui-5.4.0-linux.tar.gz
    rm v2-ui-5.4.0-linux.tar.gz -f
    cd v2-ui
    chmod +x v2-ui bin/v2ray-v2-ui bin/v2ctl
    cp -f v2-ui.service /etc/systemd/system/
    systemctl daemon-reload
    systemctl enable v2-ui
    systemctl restart v2-ui

    judge "下载脚本文件"
    curl -o /usr/bin/v2-ui -Ls https://raw.githubusercontent.com/haitaoss/ScienceOnline/master/20200823shell/v2-ui.sh
    chmod +x /usr/bin/v2-ui
    
    echo -e "${green}v2-ui v${last_version}${plain} 安装完成，面板已启动，"
    echo -e ""
    echo -e "如果是全新安装，默认网页端口为 ${green}65432${plain}，用户名和密码默认都是 ${green}admin${plain}"
    echo -e "请自行确保此端口没有被其他程序占用，${yellow}并且确保 65432 端口已放行${plain}"
    echo -e "若想将 65432 修改为其它端口，输入 v2-ui 命令进行修改，同样也要确保你修改的端口也是放行的"
    echo -e ""
    echo -e "如果是更新面板，则按你之前的方式访问面板"
    echo -e "v2-ui 管理脚本使用方法: "
    echo -e "----------------------------------------------"
    echo -e "v2-ui              - 显示管理菜单 (功能更多)"
    echo -e "v2-ui start        - 启动 v2-ui 面板"
    echo -e "v2-ui stop         - 停止 v2-ui 面板"
    echo -e "v2-ui restart      - 重启 v2-ui 面板"
    echo -e "v2-ui status       - 查看 v2-ui 状态"
    echo -e "v2-ui enable       - 设置 v2-ui 开机自启"
    echo -e "v2-ui disable      - 取消 v2-ui 开机自启"
    echo -e "v2-ui log          - 查看 v2-ui 日志"
    echo -e "v2-ui update       - 更新 v2-ui 面板"
    echo -e "v2-ui install      - 安装 v2-ui 面板"
    echo -e "v2-ui uninstall    - 卸载 v2-ui 面板"
    echo -e "----------------------------------------------"

}
install_bbr() {
    wget -N --no-check-certificate "https://raw.githubusercontent.com/haitaoss/ScienceOnline/master/20200823shell/tcp.sh"
    chmod +x tcp.sh
    bash ./tcp.sh
}
uninstall_v2-ui() {
    judge "卸载v2-ui面板"
    systemctl stop v2-ui
    systemctl disable v2-ui
    rm /usr/local/v2-ui/ -rf
    rm /etc/v2-ui/ -rf
    rm /etc/systemd/system/v2-ui.service -f
    systemctl daemon-reload
   
}
bak_v2-ui_database (){
    judge "数据文件已经备份到/root"
    cp /etc/v2-ui/v2-ui.db /root

}
menu() {
    echo -e "\t---authored by haitao---"
    echo -e "\t脚本摘自 https://github.com/wulabing/V2Ray_ws-tls_bash_onekey\n"
    echo -e "\t脚本摘自 https://github.com/sprov065/v2-ui\n"
    echo -e "\t脚本摘自 https://github.com/chiakge/Linux-NetSpeed\n"

    echo -e "—————————————— 安装向导 ——————————————"""
    echo -e "${Green}0.${Font}  安装nginx和安装域名证书（ssl）"
    echo -e "${Green}1.${Font}  安装v2ui(多用户管理面板，还可以简单的查看每个用户的流量)"
    echo -e "${Green}2.${Font}  安装bbr加速(先选择2，然后重启，再次执行脚本在选7)"

    echo -e "—————————————— 日志 ——————————————"""
    echo -e "${Green}3.${Font}  查看v2ray访问日志"
    echo -e "${Green}4.${Font}  查看nginx访问日志"

    echo -e "—————————————— 其他 ——————————————"""
    echo -e "${Green}5.${Font}  卸载v2-ui面板"
    echo -e "${Green}6.${Font}  v2-ui数据文件已经备份"
    echo -e "${Green}7.${Font}  退出 \n"

    read -rp "请输入数字：" menu_num
    case $menu_num in
    0)
        install_v2ray_ws_tls
        ;;
    1)
        install_v2ui
        ;;
    2)
        install_bbr
        ;;
    3)
        tail -20f /var/logs/v2ray/access.log
        ;;
    4)
        tail -20f /var/logs/nginx/web.access.log
        ;;
    5)
        uninstall_v2-ui
        ;;
    6)
        bak_v2-ui_database
        ;;

    7)
        exit 0
        ;;
    *)
        echo -e "${RedBG}请输入正确的数字${Font}"
        ;;
    esac
}

menu
