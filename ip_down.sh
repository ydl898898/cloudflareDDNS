#!/bin/bash
##版本：V2.1.2
	#新功能，支持ip地址全自动下载，更新优选完毕后推送至TG，再也不怕脚本没有成功运行了。
	#使用脚本需要安装jq和timeout，新增openwrt专用cf_RE.sh文件，运行cf_RE.sh即可在openwrt安装jq和timeout两个扩展。
	#其他linux请自行安装jq和timeout。
	#主程序为ip_down.sh。

###################################################################################################
export LANG=zh_CN.UTF-8
###################################################################################################
# 定义下载链接和保存路径
download_url="https://zip.baipiao.eu.org/"
save_path="/root/txt.zip"
extracted_folder="/root/txt"  # 解压后的文件夹路径
###################################################################################################

# 定义最大尝试次数
max_attempts=10
current_attempt=1
###################################################################################################

# 循环尝试下载
while [ $current_attempt -le $max_attempts ]
do
    # 下载文件
    wget "${download_url}" -O $save_path

    # 检查是否下载成功
    if [ $? -eq 0 ]; then
        break
    else
        echo "Download attempt $current_attempt failed."
        current_attempt=$((current_attempt+1))
    fi
done
###################################################################################################

# 检查是否下载成功
if [ $current_attempt -gt $max_attempts ]; then
    echo "Failed to download the file after $max_attempts attempts."
else
    # 删除原来的txt文件夹内容
    rm -rf $extracted_folder/*

    # 解压文件
    unzip $save_path -d $extracted_folder

    # 删除压缩包
    rm $save_path

    echo "File downloaded and unzipped successfully."
###################################################################################################
 # 合并文件为ip.txt
    # 合并所有含有-1-443.txt的文本文件到一个新文件中
    merged_file="/root/CloudflareST/merged_ip.txt"
    cat $extracted_folder/*-1-443.txt > $merged_file
###################################################################################################	
# 移动到ip.txt到程序总目录

    # 将合并后的文件移动到/root/CloudflareST/ip.txt并覆盖原文件
    mv -f "$merged_file" "/root/ddns/ip.txt"
    echo "Merged text files containing '-1-443.txt' moved and renamed as 'ip.txt' in /root/ddns."
fi
source ip.sh
