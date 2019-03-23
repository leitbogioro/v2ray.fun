#! /usr/bin/env python
# -*- coding: utf-8 -*-
import readjson, writejson, os, re
from utils import (download_files, move_files)

rules = readjson.ConfRouting[u"settings"][u"rules"]
ad_rules_file = "/usr/bin/v2ray/h2y.dat"

if rules[1][u"outboundTag"] == "direct":
    if_open_ad_function = "广告拦截功能： 未开启"
else:
    if_open_ad_function = "广告拦截功能： 开启"

print("")
print(if_open_ad_function)

print("")
print("1. 开启")
print("2. 关闭")
print("3. 更新广告过滤策略")
print("4. 供老用户迁移至新的广告过滤策略")

def substitute_ad_files_and_upgrade_ad_tactics():
    download_files(f_url = "https://raw.githubusercontent.com/ToutyRater/V2Ray-SiteDAT/master/geofiles/h2y.dat", f_name = "h2y.dat")
    if os.path.exists(ad_rules_file):
        os.remove(ad_rules_file)
        move_files("h2y.dat", "/usr/bin/v2ray/")
        writejson.WriteAD("on")
    else:
        move_files("h2y.dat", "/usr/bin/v2ray/")
        writejson.WriteAD("on")

choice = raw_input("请选择： ")

if choice == "1":
    writejson.WriteAD("on")
elif choice == "2":
    writejson.WriteAD("off")
elif choice == "3":
    substitute_ad_files_and_upgrade_ad_tactics()
elif choice == "4":
    writejson.Del_Old_Ad_Rules()
    substitute_ad_files_and_upgrade_ad_tactics
