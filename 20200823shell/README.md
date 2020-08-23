# 脚本是摘自这几位大佬的

- https://github.com/wulabing/V2Ray_ws-tls_bash_onekey
- https://github.com/sprov065/v2-ui
- https://github.com/chiakge/Linux-NetSpeed



# 说明

==一定要看/doc/v2-ui的使用教程.md，看完就基本v2-ui了== 

 [文档地址](https://github.com/haitaoss/ScienceOnline/blob/master/doc/v2-ui的使用教程.md)

- v2ray.conf ： nginx自主添加的配置文件
- nginx.conf ： nginx默认的配置文件
- config_template.json ： v2-ui的模板文件，默认的模板文件没有log、和dns这里我加上了。

# 使用

- 不想使用tls：直接安装1和2即可

- 如果要使用tls ：0，1，2 依次执行即可。（需要提前给vps绑定一个域名）
- 我这里使用的操作系统是centos7 64



```shell
[root@guest ~]# wget https://raw.githubusercontent.com/haitaoss/ScienceOnline/master/20200823shell/install.sh && bash ./install.sh
```

![image-20200823172406406](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823172406406.png)

![image-20200823172334090](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823172334090.jpg)

![image-20200823172915912](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823172915912.jpg)

执行完之后，再次运行脚本,然后选择1

```shell
[root@guest ~]# bash install.sh 
```

![image-20200823173641952](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823173641952.jpg)

执行完之后，再次运行脚本,然后选择2

```shell
[root@guest ~]# bash install.sh 
```

![image-20200823174536169](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823174536169.jpg)

![image-20200823173958659](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823173958659.jpg)

安装完成后会重启vps，重启之后再次执行install.sh

```shell
[root@guest ~]# bash install.sh 
```

![image-20200823173958659](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823173958659.jpg)

![image-20200823174636460](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823174636460.jpg)

可以再次执行install.sh 然后输入2查看是否加速成功

![image-20200823174800040](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200823174800040.jpg)

