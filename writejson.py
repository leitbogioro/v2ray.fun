#! /usr/bin/env python
# -*- coding: utf-8 -*-
import os, json, readjson

json_path = "/etc/v2ray/config.json"

# 打开配置文件
jsonfile = file(json_path)
config = json.load(jsonfile)

# 写入配置文件
def Write():
    myjsondump = json.dumps(config, indent=1)
    openjsonfile = file(json_path, "w+")
    openjsonfile.writelines(myjsondump)
    openjsonfile.close()

# 使能动态端口
def EnDynPort(en):
    if en == 1:
        config[u"inbound"][u"settings"].update(
            {u"detour": {u"to": "dynamicPort"}})
        dyn_port = file("/usr/local/v2ray.fun/json_template/dyn_port.json")
        srtp = json.load(dyn_port)
        config[u"inboundDetour"] = srtp
        config[u"inboundDetour"][0][u"settings"][u"default"][u"alterId"] = int(
            readjson.ConfAlterId)
    else:
        config[u"inboundDetour"] = []
        if "detour" in config[u"inbound"][u"settings"]:
            del config[u"inbound"][u"settings"][u"detour"]
    Write()

# 设置动态端口范围
def UpdateDynPort(min_port, max_port):
    config[u"inboundDetour"][0][u"port"] = str(min_port) + '-' + str(max_port)
    Write()

# 更改UUID
def WriteUUID(myuuid):
    config[u"inbound"][u"settings"][u"clients"][0][u"id"] = str(myuuid)
    Write()

# change alter ID
def WriteAlterId(alterId):
    config[u"inbound"][u"settings"][u"clients"][0][u"alterId"] = int(alterId)
    Write()

# 更改端口
def WritePort(myport):
    config[u"inbound"][u"port"] = int(myport)
    Write()

# 更改加密方式
def WriteSecurity(mysecurity):
    config[u"inbound"][u"settings"][u"clients"][0][u"security"] = str(
        mysecurity)
    Write()

# 更改底层传输设置
def WriteStreamNetwork(network, para):
    security_backup = config[u"inbound"][u"streamSettings"][u"security"]
    tls_settings_backup = config[u"inbound"][u"streamSettings"][u"tlsSettings"]
    if (network == "tcp" and para == "none"):
        streamfile = file("/usr/local/v2ray.fun/json_template/tcp.json")
        tcp = json.load(streamfile)
        config[u"inbound"][u"streamSettings"] = tcp

    if (network == "tcp" and para != "none"):
        streamfile = file("/usr/local/v2ray.fun/json_template/http.json")
        http = json.load(streamfile)
        http[u"tcpSettings"][u"header"][u"request"][u"headers"][u"Host"] = para
        config[u"inbound"][u"streamSettings"] = http

    if (network == "ws"):
        streamfile = file("/usr/local/v2ray.fun/json_template/ws.json")
        ws = json.load(streamfile)
        config[u"inbound"][u"streamSettings"] = ws
        config[u"inbound"][u"streamSettings"][u"wsSettings"][u"headers"][u"host"] = para

    if (network == "mkcp" and para == "none"):
        streamfile = file("/usr/local/v2ray.fun/json_template/kcp.json")
        kcp = json.load(streamfile)
        config[u"inbound"][u"streamSettings"] = kcp

    if (network == "mkcp" and para == "kcp utp"):
        streamfile = file("/usr/local/v2ray.fun/json_template/kcp_utp.json")
        utp = json.load(streamfile)
        config[u"inbound"][u"streamSettings"] = utp

    if (network == "mkcp" and para == "kcp srtp"):
        streamfile = file("/usr/local/v2ray.fun/json_template/kcp_srtp.json")
        srtp = json.load(streamfile)
        config[u"inbound"][u"streamSettings"] = srtp

    if (network == "mkcp" and para == "kcp wechat-video"):
        streamfile = file("/usr/local/v2ray.fun/json_template/kcp_wechat.json")
        wechat = json.load(streamfile)
        config[u"inbound"][u"streamSettings"] = wechat

    config[u"inbound"][u"streamSettings"][u"security"] = security_backup
    config[u"inbound"][u"streamSettings"][u"tlsSettings"] = tls_settings_backup
    Write()

# 更改TLS设置
def WriteTLS(action, domain):
    if action == "on":
        crt_file = "/root/.acme.sh/" + domain + "_ecc" + "/fullchain.cer"
        key_file = "/root/.acme.sh/" + domain + "_ecc" + "/" + domain + ".key"
        config[u"inbound"][u"streamSettings"][u"security"] = "tls"
        tls_file = file("/usr/local/v2ray.fun/json_template/tlssettings.json")
        tls_settings = json.load(tls_file)
        tls_settings[u"certificates"][0][u"certificateFile"] = crt_file
        tls_settings[u"certificates"][0][u"keyFile"] = key_file
        config[u"inbound"][u"streamSettings"][u"tlsSettings"] = tls_settings
        domainfile = file("/usr/local/v2ray.fun/mydomain", "w+")
        domainfile.writelines(str(domain))
        domainfile.close()
        Write()
    elif action == "off":
        config[u"inbound"][u"streamSettings"][u"security"] = ""
        config[u"inbound"][u"streamSettings"][u"tlsSettings"] = {}
        Write()

# 更改广告拦截功能
# Upgrade_Ad_Filters
def WriteAD(action):
    if action == "on":
        config[u"routing"][u"settings"][u"rules"][1][u"outboundTag"] = "blocked"
    else:
        config[u"routing"][u"settings"][u"rules"][1][u"outboundTag"] = "direct"
    Write()
    
# 供老用户迁移至新的广告过滤策略
# Delete_Previous_Advertise_Filter_Tactic
def Del_Old_Ad_Rules():
    json_lines = len(open(json_path,'rU').readlines())
    if json_lines > 1000:
        del config[u"routing"][u"settings"][u"rules"][1]
        Write()
        ad_on_file = file("ad_on.json")
        ad_on = json.load(ad_on_file)
        config[u"routing"][u"settings"][u"rules"].append(ad_on)
        Write()
        print ("新的广告过滤策略优化已完成！")
    else:
        print ("你已经采用了最新的广告过滤策略！")