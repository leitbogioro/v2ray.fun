#! /usr/bin/env python
# -*- coding: utf-8 -*-
import readjson, writejson, os, re
from utils import (download_files, move_files)

rules = readjson.ConfRouting[u"settings"][u"rules"]
ad_rules_file = "/usr/bin/v2ray/h2y.dat"
cronfile = open('/etc/crontab', 'r')

if rules[1][u"outboundTag"] == "direct":
    if_open_ad_function = "自动维护功能： 未开启"
else:
    if_open_ad_function = "自动维护功能： 开启"

print("")
print(if_open_ad_function)

print("")
print("1. 开启自动维护服务（包含：每周自动重启 v2ray 服务、更新广告过滤规则、清理访问日志）")
print("2. 关闭")
print("3. 供使用旧版本广告过滤规则的用户升级到新的自动维护服务（含开启自动维护服务）")

def substitute_ad_files_and_upgrade_ad_tactics():
    download_files(f_url = "https://raw.githubusercontent.com/ToutyRater/V2Ray-SiteDAT/master/geofiles/h2y.dat", f_name = "h2y.dat")
    if os.path.exists(ad_rules_file):
        os.remove(ad_rules_file)
        move_files("h2y.dat", "/usr/bin/v2ray/")
        writejson.WriteAD("on")
        if re.search(r'/v2ray.fun/autoupad.sh', cronfile.read()):
            os.system("bash /usr/local/v2ray.fun/autoupad.sh")
            print ("设置成功！")
        else:
            os.system("sed -i '$i\\\\30 4    * * 0   root    bash /usr/local/v2ray.fun/autoupad.sh' /etc/crontab")
            os.system("bash /usr/local/v2ray.fun/autoupad.sh")
            print ("设置成功！")
    else:
        move_files("h2y.dat", "/usr/bin/v2ray/")
        writejson.WriteAD("on")
        
def disable_ad_filter():
    writejson.WriteAD("off")
    if re.search(r'/v2ray.fun/autoupad.sh', cronfile.read()):
        os.system("sed -i -e '/autoupad.sh/d; /v2ray.fun/d' /etc/crontab")
        print ("设置成功！")
    else:
        print ("设置成功！")

choice = raw_input("请选择： ")

if choice == "1":
    substitute_ad_files_and_upgrade_ad_tactics()
elif choice == "2":
    disable_ad_filter()
elif choice == "3":
    writejson.Del_Old_Ad_Rules()
    substitute_ad_files_and_upgrade_ad_tactics()
