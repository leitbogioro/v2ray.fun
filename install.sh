#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# color
blue='\033[0;34m'
yellow='\033[0;33m'
green='\033[0;32m'
red='\033[0;31m'
plain='\033[0m'

ad_filter="https://git.io/Je2pC"
vf_path="/usr/local/v2ray.fun"

# Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

# If detected Aliyun backdoor agent, Installation will be ended.
agentwatch=`ps aux | grep 'agentwatch'`
aliyunsrv=`ps aux | grep 'aliyun'`
AliYunDun=`ps aux | grep 'AliYunDun'`
AliHids=`ps aux | grep 'AliHids'`
AliYunDunUpdate=`ps aux | grep 'AliYunDunUpdate'`
if [ -d /usr/local/aegis ] || [[ -f /etc/init.d/aegis ]] || [[ ! -n $agentwatch ]] || [[ ! -n $aliyunsrv ]] || [[ ! -n $AliYunDun ]] || [[ ! -n $AliHids ]] || [[ ! -n $AliYunDunUpdate ]]; then
    echo -e "[${red}Error${plain}] 检测到您的系统中存在阿里云的相关监控服务进程，如继续使用，你会尝到被社会主义的铁拳打击的滋味！！！"
    echo "安装程序立即终止"
    echo "可行的解决办法（以下采用一种即可）："
    echo "1. 使用我的脚本，卸载阿里云的监控服务：https://github.com/leitbogioro/Fuck_Aliyun"
    echo "2. 使用我的脚本，重新安装纯净的 Linux 系统：https://github.com/leitbogioro/Tools"
    rm -rf ssrinstall
    exit 1
fi

# 检查系统信息
if [ -f /etc/redhat-release ] && [[ `grep -i 'centos' /etc/redhat-release` ]]; then
    OS='CentOS'
    elif [ ! -z "`cat /etc/issue | grep bian`" ]; then
        OS='Debian'
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ]; then
        OS='Ubuntu'
    else
        echo "你的操作系统不受支持，请选择在 Ubuntu/Debian/CentOS 操作系统上安装！"
        exit 1
fi

# 禁用SELinux
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi

# 输出 centos 系统大版本号
System_CentOS=`rpm -q centos-release | cut -d- -f1`
CentOS_Version=`cat /etc/redhat-release | sed -r 's/.* ([0-9]+)\..*/\1/'`

# Aliyun's depository for CentOS 6
CentOS6_repo(){
    yum install wget curl -y
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
    yum clean all
    yum makecache    
}

# Aliyun's depository for CentOS 7
CentOS7_repo(){
    yum install wget curl -y
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    yum clean all
    yum makecache
}

# Dedicated NodeJS_12.X for CentOS
nodejs12_CentOS(){
    curl --silent --location https://rpm.nodesource.com/setup_12.x | bash -
    yum install -y nodejs
}

# Dedicated python for CentOS 6
py_for_centos="https://git.io/Je2pE"
py_install="python2.7_for_centos6.sh"
install_python_for_CentOS6(){
    yum install wget -y
    if [ -f ${py_install} ]; then
        rm -rf ${py_install}
    fi
    wget -qO ${py_install} ${py_for_centos}
    if ! wget ${py_for_centos}; then
        echo -e "[${red}错误${plain}] ${py_file} 下载失败，请检测你的网络！"
        exit 1
    fi
    chmod +x ${py_install}
    bash ${py_install}
    rm -rf ${py_install}
}

# Dedicated pip resource for CentOS 7
pip_file="get-pip.py"
pip_url="https://bootstrap.pypa.io/get-pip.py"
install_python_for_CentOS7(){
    yum install curl python -y
    curl ${pip_url} -o ${pip_file}
    if ! curl ${pip_url} -o ${pip_file}; then
        echo -e "[${red}错误${plain}] ${pip_file} 下载失败，请检测你的网络！"
        exit 1
    fi
    python ${pip_file}
    rm -rf ${pip_file}
}

# Python QRCode depends
py_qrcode(){
    pip install pillow
    pip install qrcode
}

# Write v2ray process to CentOS6's system service
vSvc_Path="/etc/init.d/v2ray"
write_service_to_CentOS6(){
    wget -qO v2ray.st https://git.io/Je2pB
    if [ -f /etc/init.d/v2ray ]; then
        rm -rf ${vSvc_Path}
    fi
    mv v2ray.st ${vSvc_Path}
    chmod a+x ${vSvc_Path}
    chkconfig v2ray on
}

# Generate_random_num
random_range(){
    local begin=$1
    local end=$2
    num=$((RANDOM % ($end - $begin) + $begin))
    return ${num}
}

# Main depends
if [[ ${OS} == 'CentOS' ]] && [[ ${CentOS_Version} -eq "7" ]]; then
    CentOS7_repo
    yum install epel-release wget curl vixie-cron crontabs socat unzip git ntp ntpdate lrzsz -y
    nodejs12_CentOS
    npm install -g qrcode
    install_python_for_CentOS7
    py_qrcode
elif [[ ${OS} == 'CentOS' ]] && [[ ${CentOS_Version} -eq "6" ]]; then
    CentOS6_repo
    yum install epel-release wget curl vixie-cron crontabs socat unzip git ntp ntpdate lrzsz -y
    nodejs12_CentOS
    npm install -g qrcode
    install_python_for_CentOS6
    py_qrcode
elif [[ ${OS} == 'CentOS' ]] && [[ ${CentOS_Version} -le "5" ]]; then
    echo "您的系统版本是（${System_CentOS} ${CentOS_Version}），此系统不受支持，v2ray.fun 安装程序即将退出！"
    exit 1
else
    curl -sL https://deb.nodesource.com/setup_12.x | bash -
	apt-get update
	apt-get install wget curl unzip cron git ntp ntpdate python socat lrzsz nodejs -y
    npm install -g qrcode
fi

# 安装 acme.sh 以自动获取SSL证书
curl  https://get.acme.sh | sh

# 克隆V2ray.fun项目
cd /usr/local/
if [ -f ${vf_path} ]; then
    rm -rf v2ray.fun
fi
git clone https://github.com/leitbogioro/v2ray.fun

# 安装V2ray主程序
install_v2ray(){
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh
    bash install-release.sh
    bash install-dat-release.sh
}
install_v2ray
# bash <(curl -L -s https://install.direct/go.sh)
if [[ ${OS} == 'CentOS' ]] && [[ ${CentOS_Version} -eq "6" ]]; then
    write_service_to_CentOS6
fi

# 配置V2ray初始环境
ln -sf ${vf_path}/v2ray /usr/local/bin
chmod +x /usr/bin/v2ray
chmod +x /usr/local/bin/v2ray
rm -rf /etc/v2ray/config.json
cp ${vf_path}/json_template/server.json /etc/v2ray/config.json
random_range 10000 65535
let PORT=${num}
UUID=$(cat /proc/sys/kernel/random/uuid)
sed -i "s/UUID_is_here/${UUID}/g" /etc/v2ray/config.json
sed -i "s/port_is_here/${PORT}/g" /etc/v2ray/config.json
python ${vf_path}/genclient.py
python ${vf_path}/openport.py
chmod +x ${vf_path}/*.py ${vf_path}/*.sh ${vf_path}/mydomain

#配置自动更新广告过滤功能服务
ad_filter_supplement(){
    cd /usr/bin/v2ray
    wget -qO h2y.dat ${ad_filter}
}
ad_filter_supplement

# 删除旧的配置广告策略自动升级的自动任务
if [[ `grep -i "autoupad.sh" /etc/crontab` ]]; then
    sed -i 'autoupad.sh' /etc/crontab
fi
if [[ ! `grep -i "v2ray.fun/maintain.sh" /etc/crontab` ]]; then
    sed -i '$i 30 4    * * 0   root    bash /usr/local/v2ray.fun/maintain.sh' /etc/crontab
fi
/etc/init.d/cron restart

service v2ray restart

# auto open port after start
# append a new line
cat /etc/rc.local | grep openport.py
if [[ $? -ne 0 ]]; then
cat>>/etc/rc.local<<EOF
python ${vf_path}/openport.py
EOF
chmod a+x /etc/rc.local
fi

clear

echo -e "${green}[完成] ${plain}v2ray.fun 安装成功！"
echo "输入 v2ray 回车即可使用"
