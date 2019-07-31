#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

ad_filter="https://raw.githubusercontent.com/ToutyRater/V2Ray-SiteDAT/master/geofiles/h2y.dat"

# 检查系统信息
if [ -f /etc/redhat-release ];then
        OS='CentOS'
    elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS='Debian'
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS='Ubuntu'
    else
        echo "Not support OS, Please reinstall OS and retry!"
        exit 1
fi

# 安装依赖
if [[ ${OS} == 'CentOS' ]];then
    curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
	yum install curl wget unzip git ntp ntpdate lrzsz python socat nodejs -y
    npm install -g qrcode
else
    curl -sL https://deb.nodesource.com/setup_8.x | bash -
	apt-get update
	apt-get install curl unzip git ntp wget ntpdate python socat lrzsz nodejs -y
    npm install -g qrcode
fi

# 重装V2ray.fun
rm -rf /usr/local/v2ray.fun
cd /usr/local/
git clone https://github.com/leitbogioro/v2ray.fun
cd /usr/local/v2ray.fun/
ad_filter_supplement(){
    rm -rf /usr/bin/v2ray/h2y.dat
    cd /usr/bin/v2ray
    wget ${ad_filter}
}
ad_filter_supplement
chmod +x *.py

# 重装操作菜单
rm -rf /usr/local/bin/v2ray
ln -sf /usr/local/v2ray.fun/v2ray /usr/local/bin/
chmod +x /usr/local/bin/v2ray

# 更新Vray主程序
bash <(curl -L -s https://install.direct/go.sh)

# 初始化环境
python /usr/local/v2ray.fun/openport.py
service v2ray restart

# 删除旧的配置广告策略自动升级的自动任务
if [[ `grep -i "autoupad.sh" /etc/crontab` ]]; then
    sed -e 'autoupad.sh' /etc/crontab
fi
if [[ ! `grep -i "v2ray.fun/maintain.sh" /etc/crontab` ]]; then
    sed -i '$i 30 4    * * 0   root    bash /usr/local/v2ray.fun/maintain.sh' /etc/crontab
fi

cat /etc/rc.local | grep openport.py
if [[ $? -ne 0 ]]; then
cat>>/etc/rc.local<<EOF
python /usr/local/v2ray.fun/openport.py
EOF
chmod a+x /etc/rc.local
fi

clear
echo "脚本已更新！"
