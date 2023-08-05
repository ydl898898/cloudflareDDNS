#!/bin/bash
##版本：V2.1.2
	#新功能，支持ip地址全自动下载，更新优选完毕后推送至TG，再也不怕脚本没有成功运行了。
	#使用脚本需要安装jq和timeout，新增openwrt专用cf_RE.sh文件，运行cf_RE.sh即可在openwrt安装jq和timeout两个扩展。
	#其他linux请自行安装jq和timeout。
	#主程序为ip_down.sh。

###################################################################################################
export LANG=zh_CN.UTF-8
###################################################################################################
##运行模式ipv4 or ipv6 默认为：ipv4
#指定工作模式为ipv4还是ipv6。如果为ipv6，请在文件夹下添加ipv6.txt
#ipv6.txt在CloudflareST工具包里，下载地址：https://github.com/XIU2/CloudflareSpeedTest/releases
IP_ADDR=ipv4
###################################################################################################
echo
echo '你的IP地址是'$(curl 4.ipw.cn)',请确认为本机未经过代理的地址'
echo '在路上：https://www.youtube.com/channel/UC4g8abtv5Mi7z8TRW3YOdBA'
echo 'Github：https://github.com/ydl898898/cloudflareDDNS.git'
###################################################################################################
##cloudflare配置
#cloudflare账号邮箱
x_email=xxxxxx@163.com
#填写需要DDNS的完整域名
#支持多域名:域名需要填写在括号中，每个域名之间用“空格”相隔。
#例如：（cdn.test.com） 或者 （cdn1.test.com cdn2.test.com cdn3.test.com）
hostname=(ddns1.xxxxxxx.link ddns2.xxxxxxx.link ddns3.xxxxxxx.link ddns4.xxxxxxx.link ddns5.xxxxxxx.link ddns6.xxxxxxx.link)
#区域ID
zone_id=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#Global API Key(获取你的API令牌，你的API密钥就是你的登陆密码）
api_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
###################################################################################################
##openwrt科学上网插件配置
#优选节点时是否自动停止科学上网服务 true=自动停止 false=不停止 默认为 true
pause=true
#填写openwrt使用的是哪个科学上网客户端，填写对应的“数字”  默认为 1  客户端为passwall
# 1=passwall 2=passwall2 3=ShadowSocksR Plus+ 4=clash 5=openclash 6=bypass
clien=5
###################################################################################################
##CloudflareST配置
#测速地址  
CFST_URL=https://cs.xxxxxxx.link
#测速线程数量；越多测速越快，性能弱的设备 (如路由器) 请勿太高；(默认 200 最多 1000 )
CFST_N=200
# 指定测速端口；延迟测速/下载测速时使用的端口；(默认 443 端口)
CFST_TP=443
#下载测速数量；延迟测速并排序后，从最低延迟起下载测速的数量；(默认 10 个)
CFST_DN=10
#平均延迟上限；只输出低于指定平均延迟的 IP，可与其他上限/下限搭配；(默认9999 ms 这里推荐配置250 ms)
CFST_TL=250
#平均延迟下限；只输出高于指定平均延迟的 IP，可与其他上限/下限搭配、过滤假墙 IP；(默认 0 ms 这里推荐配置40)
CFST_TLL=40
#下载速度下限；只输出高于指定下载速度的 IP，凑够指定数量 [-dn] 才会停止测速；(默认 0.00 MB/s 这里推荐5.00MB/s)
CFST_SL=3
#####################################################################################################
##TG推送设置
#（填写即为开启推送，未填写则为不开启）
#TG机器人token 例如：123456789:ABCDEFG...
telegramBotToken=
#用户ID或频道、群ID 例如：123456789
telegramBotUserId=
#####################################################################################################
source cf_ddns
