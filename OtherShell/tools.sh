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


