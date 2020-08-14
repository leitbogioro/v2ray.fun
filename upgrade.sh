#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

ad_filter="https://git.io/Je2pC"
vf_path="/usr/local/v2ray.fun"

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
	yum install curl wget vixie-cron crontabs unzip git ntp ntpdate lrzsz python socat nodejs -y
    npm install -g qrcode
else
    curl -sL https://deb.nodesource.com/setup_8.x | bash -
	apt-get update
	apt-get install curl cron unzip git ntp wget ntpdate python socat lrzsz nodejs -y
    npm install -g qrcode
fi

# 重装V2ray.fun
rm -rf ${vf_path}
cd /usr/local/
git clone https://github.com/leitbogioro/v2ray.fun
cd ${vf_path}/
ad_filter_supplement(){
    rm -rf /usr/bin/v2ray/h2y.dat
    cd /usr/bin/v2ray
    wget -qO h2y.dat ${ad_filter}
}
ad_filter_supplement
chmod +x ${vf_path}/*.py

# 重装操作菜单
rm -rf /usr/local/bin/v2ray
ln -sf ${vf_path}/v2ray /usr/local/bin/
chmod +x /usr/local/bin/v2ray

# 更新Vray主程序
install_v2ray(){
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh
    bash install-release.sh
    bash install-dat-release.sh
}
install_v2ray
# bash <(curl -L -s https://install.direct/go.sh)

# 删除旧的配置广告策略自动升级的自动任务
if [[ `grep -i "autoupad.sh" /etc/crontab` ]]; then
    sed -i 'autoupad.sh' /etc/crontab
fi
if [[ ! `grep -i "v2ray.fun/maintain.sh" /etc/crontab` ]]; then
    sed -i '$i 30 4    * * 0   root    bash ${vf_path}/maintain.sh' /etc/crontab
fi
/etc/init.d/cron restart

# 初始化环境
python ${vf_path}/openport.py
service v2ray restart

cat /etc/rc.local | grep openport.py
if [[ $? -ne 0 ]]; then
cat>>/etc/rc.local<<EOF
python ${vf_path}/openport.py
EOF
chmod a+x /etc/rc.local
fi

clear
echo "脚本已更新！"
