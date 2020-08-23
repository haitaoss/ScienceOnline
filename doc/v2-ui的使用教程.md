## 不使用端口，通过路径访问到v2-ui管理界面（需安装nginx）

流程：安装v2-ui -> 启动v2-ui -> 访问v2-ui管理界面 -> 登录 -> 点击面板设置侧边栏 -> 修改面板监听IP(可选)，修改网页根路径 -> 重启v2-ui (`v2-ui restart`)



**访问**：http://域名/路径



![image-20200823124114103](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823124114103.jpg)

修改nginx配置文件

```shell
# 创建nginx配置文件
root@ethical-frogs-2:~# vi /etc/nginx/conf/conf.d/v2ray.conf

# 重启nginx
root@ethical-frogs-2:~# systemctl restart nginx
```

文件内容

```shell
server {
    listen 443 ssl http2;
    listen [::]:443 http2;
    ssl_certificate       /data/v2ray.crt; # 证书文件路径（通过脚本安装的话证书就是这些东西）
    ssl_certificate_key   /data/v2ray.key;
    ssl_protocols         TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers           TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
    server_name www.baidu.com;
    index index.html index.htm;
    root  /home/wwwroot/CamouflageSite; # 伪造站点文件路径
    error_page 400 = /400.html;

    # Config for 0-RTT in TLSv1.3
    ssl_early_data on;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security "max-age=31536000";


    access_log  /var/logs/nginx/web.access.log main;
    error_log   /var/logs/nginx/web.access.log;

    location /manager/ # 通过这个路径访问我们的v2-ui管理界面
    {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:65432; # 端口是v2-ui web项目的端口
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        # Config for 0-RTT in TLSv1.3
        proxy_set_header Early-Data $ssl_early_data;

    }
}
server { # 将http服务重定向为https
    listen 80;
    listen [::]:80;
    server_name www.baidu.com; # 修改成你的域名
    return 301 https://www.baidu.com$request_uri; # 修改成你的域名
}
```

## 使用v2-ui配置ws

![image-20200823124710110](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823124710110.jpg)

## 使用v2-ui配置ws+tls

![image-20200823125221123](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823125221123.jpg)

## 使用v2-ui配置ws+nginx+tls(证书信息放到nginx不放在v2ray中设置)

传输流程：我们安装v2ray的客户端配置v2ray发送信息给 www.baidu.com:443/11618/ -> www.baidu.com这台服务器的nginx监听到了

-> 将请求转发到我们配置的v2ray的inbound中。



通过v2-ui面板创建一个v2ray 的inbound

![image-20200823125529902](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823125529902.jpg)

修改v2ray的配置文件

```shell
# 创建nginx配置文件
root@ethical-frogs-2:~# vi /etc/nginx/conf/conf.d/v2ray.conf

# 重启nginx
root@ethical-frogs-2:~# systemctl restart nginx
```

```shell
# 修改域名、访问路径和端口即可。
server {
    listen 443 ssl http2;
    listen [::]:443 http2;
    ssl_certificate       /data/v2ray.crt; # 证书文件路径（通过脚本安装的话证书就是这些东西）
    ssl_certificate_key   /data/v2ray.key;
    ssl_protocols         TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers           TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
    server_name www.baidu.com; # 监听的名字（这里改成你的域名）
    index index.html index.htm;
    root  /home/wwwroot/CamouflageSite; # 伪造站点文件路径
    error_page 400 = /400.html;

    # Config for 0-RTT in TLSv1.3
    ssl_early_data on;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security "max-age=31536000";


    access_log  /var/logs/nginx/web.access.log main;
    error_log   /var/logs/nginx/web.access.log;

    location /manager/ # 通过这个路径访问我们的v2-ui管理界面
    {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:65432;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        # Config for 0-RTT in TLSv1.3
        proxy_set_header Early-Data $ssl_early_data;

    }

    location /11618/ # 访问这个路径，就会转发到v2ray监听的端口实现 ws + nginx + tls
    {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:11618;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        # Config for 0-RTT in TLSv1.3
        proxy_set_header Early-Data $ssl_early_data;

    }

}
server { # 将http服务重定向为https
    listen 80;
    listen [::]:80;
    server_name www.baidu.com; # 修改成你的域名
    return 301 https://www.baidu.com$request_uri; # 修改成你的域名
}
```

客户端的配置

![image-20200823130214721](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823130214721.jpg)

![image-20200823130429423](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823130429423.jpg)

![image-20200823130616669](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823130616669.jpg)

修改之后的样子

![image-20200823130751181](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823130751181.jpg)



## 使用v2-ui配置ws+nginx+tls+cdn（vps永不被墙）

我用的是cloudflare提供的免费cdn服务。

[需要明确一点，cloudflare免费的cdn服务只允许使用下面这几个端口。](https://support.cloudflare.com/hc/zh-cn/articles/200169156-识别与-Cloudflare-的代理兼容的网络端口)

```shell
Cloudflare 默认代理发往下列 HTTP/HTTPS 端口的流量。

# Cloudflare 支持的 HTTP 端口：80、8080、8880、2052、2082、2086、2095
# Cloudflare 支持的 HTTPS 端口：443、2053、2083、2087、2096、8443
```

步骤：通过v2-ui管理面板创建一个ws模式的inbound -> 修改nginx配置文件(我这里使用8443为例) -> 重启nginx -> 开启cdn

==传输流程==：v2ray客户端(比如手机电脑) -> 通过dns解析得到的ip（因为我们开启了cdn，所以这个ip是cdn提供的）-> 发送数据给解析到的服务器（也就是cloudflare提供的免费ip） -> cdn收到数据后在转发给我们的vps -> vps上的nginx监听到数据 -> nginx根据规则转发给v2ray

**永不被墙的原因**：因为我们数据是发送给cloudflare提供的ip，所以gfw如果检测到了我们的ip也只是封掉cloudflare提供的免费ip，我们的vps自始至终都没有暴露给gfw。

**建议**：因为这是cloudflare提供的免费cdn服务，所以速度肯定不咋地。平时不建议开启cdn，到了一些敏感的时间可以开启cdn度过一段日子（5月到6月国内封禁力度很大）

![image-20200823131738005](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823131738005.jpg)

nginx配置

```shell
root@ethical-frogs-2:~# vi /etc/nginx/conf/conf.d/v2ray_8443.conf 
root@ethical-frogs-2:~# systemctl restart nginx

# 查看nginx是否监听了8443
root@ethical-frogs-2:~# netstat -lntp | grep 8443
```



```shell
server {
    listen 8443 ssl http2; # 只要是cloudflare cdn 支持的端口就行
    listen [::]:8443 http2;
    ssl_certificate       /data/v2ray.crt; # 证书文件路径（通过脚本安装的话证书就是这些东西）
    ssl_certificate_key   /data/v2ray.key;
    ssl_protocols         TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers           TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
    server_name www.baidu.com; # 改成你的域名
    index index.html index.htm;
    root  /home/wwwroot/CamouflageSite; # 伪造站点文件路径
    error_page 400 = /400.html;

    # Config for 0-RTT in TLSv1.3
    ssl_early_data on;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security "max-age=31536000";


    access_log  /var/logs/nginx/web.access.log main;
    error_log   /var/logs/nginx/web.access.log;


    location /11615/ # 访问这个路径，就会转发到v2ray监听的端口实现 ws + nginx + tls
    {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:11615;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        # Config for 0-RTT in TLSv1.3
        proxy_set_header Early-Data $ssl_early_data;

    }

}
server { # 将http服务重定向为https
    listen 8443;
    listen [::]:8443;
    server_name www.baidu.com; # 修改成你的域名
    return 301 https://www.baidu.com:$server_port/$request_uri; # 修改成你的域名
}
```

客户端的配置

![image-20200823133300518](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823133300518.jpg)

![image-20200823133653610](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823133653610.jpg)

开启cdn

![image-20200823134044971](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823134044971.jpg)

![image-20200823134117282](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823134117282.jpg)

![image-20200823134425827](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823134425827.jpg)

![image-20200823134638718](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823134638718.jpg)

# cloudflare 免费cdn支持的端口

[详细说明](https://support.cloudflare.com/hc/zh-cn/articles/200169156-识别与-Cloudflare-的代理兼容的网络端口)

```shell
Cloudflare 默认代理发往下列 HTTP/HTTPS 端口的流量。

# Cloudflare 支持的 HTTP 端口：80、8080、8880、2052、2082、2086、2095
# Cloudflare 支持的 HTTPS 端口：443、2053、2083、2087、2096、8443
```



