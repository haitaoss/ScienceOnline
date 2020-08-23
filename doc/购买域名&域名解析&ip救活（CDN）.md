# 购买域名

## 免费的域名（可用一年）（推荐）

[网址](https://my.freenom.com/clientarea.php)

![image-20200823153800590](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823153800590.jpg)

![image-20200823153946763](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823153946763.jpg)

![image-20200823154039884](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823154039884.jpg)

![image-20200823154131606](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823154131606.jpg)

![image-20200823154205893](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823154205893.jpg)

![image-20200823154326481](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823154326481.jpg)

![image-20200823154708561](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823154708561.jpg)

![image-20200823154800952](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823154800952.jpg)

![image-20200823154827740](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823154827740.jpg)



## 付费域名（最便宜的0.99美元一年）

[网址](https://www.namesilo.com/)

没钱买域名了，就不测试了。真的想使用付费域名。百度一下就会有教程了。

![image-20200823155003510](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823155003510.jpg)

![image-20200823155150067](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823155150067.jpg)



# DNS解析

我们使用cloudflare作为dns服务提供商。官网地址： https://www.cloudflare.com/

## freenom的域名解析

https://www.cloudflare.com/

https://my.freenom.com/clientarea.php

![image-20200823155529370](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823155529370.jpg)

![image-20200823155623430](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823155623430.jpg)

![image-20200823155802674](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823155802674.jpg)

![image-20200823155826522](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823155826522.jpg)

![image-20200823160205866](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823160205866.jpg)

![image-20200823160340837](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823160340837.jpg)

![image-20200823160429935](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823160429935.jpg)

![image-20200823160514641](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823160514641.jpg)

![image-20200823160614776](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823160614776.jpg)

![image-20200823160715532](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823160715532.jpg)

![image-20200823160804512](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823160804512.jpg)

![image-20200823160822339](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823160822339.jpg)

![image-20200823160943656](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823160943656.jpg)

![image-20200823161054885](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823161054885.jpg)



## namesilo的域名解析

https://www.cloudflare.com/

https://www.namesilo.com/

![image-20200823161636497](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823161636497.jpg)

![image-20200823161850213](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823161850213.jpg)



# IP救活（CDN）

1. 在 DNS 选项卡那边添加一个 A 记录的域名解析，假设你的域名是 233blog.com，并且想要使用 www.233blog.com 作为翻墙的域名
   那么在 DNS 那里配置，Name 写 www，IPv4 address 写你的 VPS IP，**务必把云朵点灰**，然后选择 Add Record 来添加解析记录即可(如果你已经添加域名解析，**请务必把云朵点灰**，即是 DNS only)
2. 设置 Crypto 和 开启中转。确保 Cloudflare 的 Crypto 选项卡的 SSL 为 Full**并且请确保 SSL 选项卡有显示 Universal SSL Status Active Certificate 这样的字眼，如果你的 SSL 选项卡没有显示这个，不要急，只是在申请证书，24 小时内可以搞定。然后在 DNS 选项卡那里，把刚才点灰的那个云朵图标，点亮它，一定要点亮一定要点亮一定要点亮**云朵图标务必为橙色状态，即是 DNS and HTTP proxy(CDN)
3. ==核心==就是一开始使用Cloudflare解析域名的时候不要使用cdn（**云朵点灰、ssl选择关闭**），因为我们搭建v2ray服务端的时候需要绑定域名，绑定的域名要能解析到你的vps。v2ray服务端搭建好之后，我们就可以在Cloudflare设置了（**云朵点橙色、ssl选择full**）。
4. 平时使用没必要开启cdn（就是云朵点灰、ssl/tls选择close），在敏感时期或者vps被封了之后在开启就行了。因为免费的cdn速度真的不行。



![image-20200819165333083](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200819165333083.jpg)

![image-20200823162234948](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823162234948.jpg)

