################################# 测试哪种加密算法适合自己 ##################################


# 优先选用支持AEAD的加密算法，AE -> 对称加密，AD -> 验证
lscpu | grep aes # 检查cpu是否支持aes指令集
openssl speed -evp aes-256-gcm
openssl speed -evp chacha20-poly1305 # 对aes和chacha进行测速，每秒处理的数据越多越快
# openssl 1.1.0版本才开始支持chacha
# mbedTLS支持chacha，但在arm平台上的aes性能不如openssl
# armv8才开始支持aes指令集
# aes-256-gcm在A10芯片上表现非常不好，aes-128-gcm足够用了
# V2ray使用的是openssl，而ss-libev使用的是mbedTLS


# 总结：若服务端与客户端cpu都支持aes指令集，推荐V2ray + aes-128-gcm；否则推荐V2ray/ss + chacha20-poly1305

################################# 测试当前网络最快的dns厂商 ##################################
ping 114.114.114.114 -c 4;ping 119.29.29.29 -c 4;ping 223.6.6.6 -c 4;ping 180.76.76.76 -c 4;ping 101.226.4.6 -c 4;ping 8.8.8.8 -c 4

# centos7 x64系统


################################# 关闭防火墙 ##################################
echo "关闭防火墙"
systemctl stop firewalld && systemctl disable firewalld


echo "关闭SeLinux,,,centos"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config


################################# 时间同步 ##################################
echo "时间同步.... centos"
yum update -y && yum makecache -y && yum upgrade -y && rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && yum install ntp ntpdate -y && service ntpd stop && ntpdate us.pool.ntp.org && service ntpd start  && systemctl enable ntpd # 开机自启




################################# 查看端口是否被占用 ##################################
netstat -lntp | grep 8080


# https://github.com/acmesh-official/acme.sh/wiki/dnsapi
################################# 获取和安装证书 ##################################

# 通过token的方式，不需要开启web服务，我们直接访问到dns厂商进行校验
curl https://get.acme.sh | sh &&\
export CF_Key="c431962c6f88014885d0b9d3d5e96a7e2977d" &&\
export CF_Email="baidu@aliyun.com" &&\
acme.sh --issue --dns dns_cf -d baidu.tk -d *.baidu.tk
alias acme.sh=~/.acme.sh/acme.sh &&\
echo 'alias acme.sh=~/.acme.sh/acme.sh' >>/etc/profile &&\
acme.sh --issue --dns dns_cf -d baidu.tk -d *.baidu.tk -k ec-256 &&\
acme.sh --installcert -d baidu.tk -d *.baidu.tk \
--fullchainpath /tls/baidu.tk.crt \
--keypath /tls/baidu.tk.key \
--ecc &&\
acme.sh --upgrade --auto-upgrade # 定期自动更新




# 需要开启web服务，dns厂商要访问当前机器生成的文件，校验证书。
# 可以安装nginx，将nginx.conf 默认的静态文件路径，改到下面的路径中。
echo "# 定时更新证书,#校验我们提供的域名是不是自己的（需要开启web服务让机构能校验，路径是nginx资源访问路径）"
curl https://get.acme.sh | sh &&\
alias acme.sh=~/.acme.sh/acme.sh &&\
echo 'alias acme.sh=~/.acme.sh/acme.sh' >>/etc/profile &&\
echo "00 00 * * * root /root/.acme.sh/acme.sh --cron --home /root/.acme.sh &>/var/log/acme.sh.logs">> /var/spool/cron/root &&\
mkdir -p /data &&\
chmod 777 -R  /usr/share/nginx/html &&\
systemctl start nginx &&\
acme.sh --issue --force -d baidu.tk -d *.baidu.tk  -w /usr/share/nginx/html &&\
acme.sh --install-cert -d baidu.tk -d *.baidu.tk \
--key-file /data/baidu.tk.key \
--fullchain-file /data/baidu.tk.cer \
--reloadcmd  "service nginx force-reload"

# ----------------------------------------------------------------------------
# 替换域名的步骤
# 删除之前的证书文件
rm -rf /data

# 停止nginx
systemctl stop nginx

# 生成证书
"$HOME"/.acme.sh/acme.sh --issue -d "bwg.haitaoss.ml" --standalone -k ec-256 --force

mkdir /data

"$HOME"/.acme.sh/acme.sh --installcert -d "bwg.haitaoss.ml" --fullchainpath /data/v2ray.crt --keypath /data/v2ray.key --ecc --force

# 启动nginx
systemctl start nginx

# 修改nginx的配置文件
vim /etc/nginx/conf/conf.d/v2ray.conf

# ----------------------------------------------------------------------------
