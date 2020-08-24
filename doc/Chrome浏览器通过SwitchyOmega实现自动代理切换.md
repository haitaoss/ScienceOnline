# Chrome浏览器通过SwitchyOmega实现自动代理切换

## 介绍

[原文地址，原文没有图片，这篇文章是我自己操作过后改的的](https://www.itfanr.cc/2019/09/04/autoproxy-by-shadowsocks-and-switchyomega/)

使用科学上网工具v2ray 或者 ShadowSocks **选择pac模式时**。通过浏览器访问网站**不能灵活的切换**是使用代理访问网站还是使用本地链接访问（wifi）。通过Proxy SwitchyOmega 插件可以实现根据访问的网址不同**自动切换使用代理还是本地链接访问网址**。

**因为都有截图，所以几分钟就能学会如何使用，请耐心看完。**



## ShadowSocks

默认情况下，ss在自动模式下有一个PAC文件，记录着一些需要FQ才能访问的站点。不过对于该文件中没有记录的网站，则需要手动的添加进去。在之前的文章 [如何添加URL到shadowsocks的列表让其使用代理访问 | IT范儿](https://www.itfanr.cc/2019/05/13/ss-add-urls-use-proxy/) 中我也介绍了相关的手动添加方法。但是，每次遇到一个新的需FQ的站点都需要这样来操作，也确实繁琐了一些。

关于ss的一些配置，这里就不详细的介绍了。所以在此之前，你应该有一个正常使用的ss客户端。

------

## 安装Proxy SwitchyOmega

### 在线安装

正常情况下，开启了ss就可以直接访问Chrome应用商店来安装了。搜索 “Proxy SwitchyOmega” 安装即可。

这里我也给出了 `Proxy SwitchyOmega` 的地址：

- [Proxy SwitchyOmega - Chrome 网上应用店](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif)

### 离线安装

当然，也可以通过离线的CRX包安装。从 Github 直接下载安装包：

- [Releases · FelisCatus/SwitchyOmega](https://github.com/FelisCatus/SwitchyOmega/releases)

在 Chrome 地址栏输入 `chrome://extensions` 打开扩展程序，拖动 `.crx` 后缀的 `SwitchyOmega` 安装文件到扩展程序中按提示进行安装。

------

## Proxy SwitchyOmega配置

在 `Proxy SwitchyOmega` 安装完成后默认已设置好两个情景模式：`auto switch` 和`proxy`。

我下面的操作是将原来的默认设置删除后并重新添加的（因为之前有一些其他的设置），当然你可以直接按照我下面的方法来修改默认带的这两个模式。

### 新增代理模式

安装完成后会在 Chrome 浏览器右上角显示扩展程序的图标，选择 “选项” 打开 `SwitchyOmega` 选项设置界面，点击 “新建情景模式”，这里我设置名称为 `ss代理`（同默认的proxy模式），情景类型选择 “代理服务器”，之后新增一项 `SOCKS5`的代理信息：



默认情况下，ss的 `SOCKS5` 代理端口为 `1080` 。

完成之后，点击 “应用选项” 保存设置。

![image-20200728215150657](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728215150657.jpg)

![image-20200728215303706](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728215303706.jpg)

![image-20200728215358464](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728215358464.jpg)

![image-20200728215427712](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728215427712.jpg)

### 新增智能切换模式

再次点击 “新建情景模式”，我设置名称为 “智能切换”（同默认的auto switch模式），情景类型选择 “自动切换模式”，点击 “创建”。

在 “规则列表设置” 中，填写：

> 规则列表格式： `AutoProxy`
> 规则列表网址： `https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt`

然后点击 “立即更新情景模式”，之后会在 “规则列表正文” 中显示相应的规则列表。

在上面的 “切换规则” 中，将 “规则列表规则” 前面的框打`√`，后面选择上一步设置的 “ss代理”(同默认的proxy模式) ，下面的 “默认情景模式” 选择 “直接连接” 。点击左侧 “应用选项” 保存设置即可。



这样设置的意思表示：如果网址匹配到规则列表中的网址规则，则会走代理，如果没有匹配到规则及默认的情况下，则会直接访问。

![image-20200728215601809](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728215601809.jpg)

![image-20200728215703366](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728215703366.jpg)

![image-20200728215729282](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728215729282.jpg)

![image-20200728221003081](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728221003081.jpg)

![image-20200728221047038](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728221047038.jpg)



这个规则列表来自这个仓库：https://github.com/gfwlist/gfwlist

### 体验自动代理切换

将ss的代理模式更改为 “自动代理模式”：

1. 设置规则列表使用的情景模式是ss，默认情景模式就是直接连接。
2. 点击 `SwitchyOmega` 图标选择 “智能切换” (同默认的proxy模式) 选项即可。



然后在Chrome浏览器中打开 `google.com` 查看是否能正常访问。

![image-20200728222149232](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728222149232.jpg)

![image-20200728222401151](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728222401151.jpg)

------

## 设置本地Ip不走代理

有时候在本地开发网站项目时，都会通过本地的Ip来访问调试。但某些情况下本地的Ip也会去走SwitchyOmega的代理模式，所以需要将本地的Ip给屏蔽掉。

因为我们自动代理情景模式选用的情景是ss，所以主要在ss这个情景模式设置，在 “不代理地址列表” 中填写本地的Ip地址。

我本机的Ip为 `192.168.8.*`，之后不要忘了 “应用选项” 来保存设置。

![image-20200728223525257](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728223525257.jpg)

![image-20200728223458755](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728223458755.jpg)

------

## 新增自定义站点

因为我们使用的自定义AutoProxy文件是公共的，所以不可能把所有需要的网址全都加进去。那么就需要来自动判断哪些网址需要添加进规则列表中。

比如访问 `https://www.instagram.com/` 网址，可以发现通过默认的 “智能切换” 是不能正常浏览的。

不过，可以看到此时 `SwitchyOmega` 图标右下角多了一个数字 `1`。

依次点击 `SwitchyOmega` 图标 – `1个资源未加载` ，在新的窗口中选择相应的情景模式 `ss代理` 并点击 “添加条件”。

此时，可以看到网站刷新后页面能够正常的访问了。

之后，再次访问网站 `https://www.instagram.com/` 时就会自动使用 `ss代理` 模式来实现科学上网了。

![image-20200728223738524](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728223738524.jpg)

![image-20200728223832160](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728223832160.jpg)

![image-20200728223915489](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728223915489.jpg)

![image-20200728224917237](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728224917237.jpg)

------

## 快速切换

### 场景

通过上面的设置后，在浏览网页时已经可以做到智能化的代理切换了：在规则列表中的走代理，其他的直接访问。没在规则列表中的手动添加一下即可。

不过，时间长了之后我们也会感觉到厌烦。如果将浏览网站的需求剥离到最简单：

**一个网址，要么是正常浏览模式，要么是翻墙浏览模式。**

所以，我们只需要在这两种模式之前切换就好了嘛，搞那么复杂干什么呢？

`SwitchyOmega` 中也已经为我们添加了这样的选项 – “快速切换” 模式。

在 “快速切换” 模式下，可以通过两种方式来切换情景模式：

1. 通过点击 `SwitchyOmega` 的图标来循环切换
2. 通过快捷键 `Alt+Shift+O` 来循环切换

### 设置

要启用 “快速切换” 模式，点击：

“选项” – “界面” –（最下方）“快速切换”，勾选即可启用

在 “循环切换以下情景模式” 中，加入 “直接连接” 和 “ss代理”（同默认的auto switch模式） 两项：



最后，点击左侧的 ”应用选项“ 保存设置。

![image-20200728224357641](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728224357641.jpg)

### 使用

在 ”快速切换“ 模式下，`SwitchyOmega` 图标点击就不会像之前一样弹出 `代理列表菜单` 了，而是在 “直连” 和 “代理” 之间循环切换。

如果需要打开 `SwitchyOmega` 的选项，可以**右击**该图标 – 选择 “选项”。

如果需要暂时停用 “快速切换” 模式，也可以**右击**该图标 – 将 “启用快速切换” 前面的 `√` 去掉即可。

这样在浏览网站时，如果 “直连” 无法访问，点击一下图标或者快捷键就可以使用代理了。

不过，在一段时间的体验后个人感觉这种方式其实没有上面的 “自动切换模式” 来的方便。

![image-20200728224526509](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728224526509.jpg)

------

## 虚拟情景模式

### 如何理解

默认情况下，我们在一个情景模式中只能添加一个代理服务器。如果你有多个代理服务器可用，那么就需要添加多个代理情景模式。

假如我有A、B、C三个代理。默认情况下，在 “自动切换模式” 下我选择的是A代理和直连。突然有一天，A代理挂掉了，连不上了，这时我就需要在 “自动切换模式” 中手动将B代理或者C代理设置为默认的代理服务器。

而 “虚拟情景模式” 就是==针对于这种多个代理==的情况而言的。你可以把它看成 “代理工具的集合” ，可以快速的使用其中一个代理来进行连接。而如果其中一个代理挂掉，又可以快速的切换到另一个代理来使用。

### 如何设置

#### 添加多个代理

在开始设置之前，我们先添加多个代理。比如我这里添加了一个 ”B代理“ 和一个 ”C代理“ 。

#### 新增虚情景模式

点击 “新增情景模式” – 设置名称（我这里设置为 “虚拟代理”） – 选择 “虚情景模式” – 创建。

在 ”虚情景模式“ 的 ”目标“ 中，选择所有的 ”代理“ 模式其中的一项，表示默认使用的代理：



最后，别忘了点击左侧的 ”应用选项“ 保存设置。

![image-20200728224737200](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728224737200.jpg)

#### 使用虚情景代理

选择 “自动代理模式” ：我这里是 “智能切换” 模式（同默认的auto switch模式）。

将 “规则列表规则” 后面的情景模式更改为我们新设置的 “虚拟情景模式” 代理。



最后，点击左侧的 ”应用选项“ 保存设置。

![image-20200728224822894](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728224822894.jpg)

#### 测试

打开 `google.com` 页面，依旧选择 “智能切换” （同默认的auto switch模式）代理。



只是这时可以看到新增的 “虚拟代理” 选项后面多了一个下拉框，可以让我们在多个代理之间选择其中一个来使用。

**先关闭急速切换模式**

![image-20200728225209501](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728225209501.jpg)

![image-20200728225135721](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728225135721.jpg)

## 导出、导入配置文件

导出我们的配置 

![image-20200728225544877](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728225544877.jpg)

来到一个从没有配置过的switch

![image-20200728225721273](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728225721273.jpg)

导入我们的备份文件

![image-20200728225824105](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728225824105.jpg)

效果

![image-20200728225836949](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200728225836949.jpg)



## 这是我导出的配置文件

https://gitee.com/haitaoss/PicBed/raw/master/2020/08/OmegaOptions.bak

![image-20200819171120840](https://gitee.com/haitaoss/PicBed/raw/master/2020/08/image-20200819171120840.jpg)
