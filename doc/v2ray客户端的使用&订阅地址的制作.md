# 推荐

[这个仓库非常的棒，里面有自建v2ray 和 ss的教程以及软件的下载链接、使用方式。](https://github.com/bannedbook/fanqiang)

# mac的详细使用

注：windows使用很简单，这里就不做演示了。

## 下载地址

[v2rayU](https://github.com/yanue/V2rayU/releases)

## 使用

### 添加一个节点

[服务器设置和从粘贴板导入可以查看这个文档，最简单的就是从粘贴板导入。](https://github.com/bannedbook/fanqiang/wiki/v2ray%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7)

![image-20200730165852241](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730165852241.jpg)



### 修改为全局模式

**注意**：因为我的订阅地址是放在github上的，所以更新订阅的时候，需要梯子。所以必须开启全局模式才管用。windows版本的v2rayu 客户端好像不需要，如果windows 的客户端也无法成功更新订阅，像我一样设置成全局模式即可。

**下面是不设置全局模式的效果**

![image-20200730170839448](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730170839448.jpg)

![image-20200730171030025](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730171030025.jpg)

![image-20200730171120658](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730171120658.jpg)

### 设置全局模式、再试试更新订阅。

![image-20200730171433720](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730171433720.jpg)

![image-20200730171743008](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730171743008.jpg)



# 制作自己的订阅地址

==注意：将我们的vmess连接进行base64加密并不是必须的。==

## 复制节点的信息

![image-20200730172122500](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730172122500.jpg)

![image-20200730172233423](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730172233423.jpg)

```shell
# 源url
vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIjcuMjXkv4TnvZfmlq8yIiwNCiAgImFkZCI6ICIxOTMuNTMuMTI2LjE4MyIsDQogICJwb3J0IjogIjM1MDM1IiwNCiAgImlkIjogImMyZTQ4ZDc4LWRhNTMtNGE0MS05YTRmLTA1NDEwZmE3ODllNCIsDQogICJhaWQiOiAiMjMzIiwNCiAgIm5ldCI6ICJ0Y3AiLA0KICAidHlwZSI6ICJub25lIiwNCiAgImhvc3QiOiAiIiwNCiAgInBhdGgiOiAiIiwNCiAgInRscyI6ICIiDQp9

# 对url进行base64编码
dm1lc3M6Ly9ldzBLSUNBaWRpSTZJQ0l5SWl3TkNpQWdJbkJ6SWpvZ0lqY3VNalhrdjRUbnZaZm1scTh5SWl3TkNpQWdJbUZrWkNJNklDSXhPVE11TlRNdU1USTJMakU0TXlJc0RRb2dJQ0p3YjNKMElqb2dJak0xTURNMUlpd05DaUFnSW1sa0lqb2dJbU15WlRRNFpEYzRMV1JoTlRNdE5HRTBNUzA1WVRSbUxUQTFOREV3Wm1FM09EbGxOQ0lzRFFvZ0lDSmhhV1FpT2lBaU1qTXpJaXdOQ2lBZ0ltNWxkQ0k2SUNKMFkzQWlMQTBLSUNBaWRIbHdaU0k2SUNKdWIyNWxJaXdOQ2lBZ0ltaHZjM1FpT2lBaUlpd05DaUFnSW5CaGRHZ2lPaUFpSWl3TkNpQWdJblJzY3lJNklDSWlEUXA5

```



## 放在公网服务器上

**这里为了解决成本，我选用github来分享订阅地址**

创建github 仓库

![image-20200730172458319](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730172458319.jpg)

![image-20200730172644924](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730172644924.jpg)

随便创建一个文件，文件内容就是我们刚才编码后的结果。

![image-20200730172804158](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730172804158.jpg)

![image-20200730173021530](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730173021530.jpg)

## 打开创建好的文件，获取订阅地址

![image-20200730173135530](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730173135530.jpg)

![image-20200730173334255](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730173334255.jpg)



## 使用v2ray 测试是否能成功订阅。

![image-20200730173804901](https://gitee.com/haitaoss/PicBed/raw/master/science/image-20200730173804901.jpg)

