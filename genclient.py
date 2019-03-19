#! /usr/bin/env python
# -*- coding: utf-8 -*-
import os
import json
import readjson
import urllib2
import serverinfo


# 写客户端配置文件函数
def WriteClientJson():
    myJsonDump = json.dumps(clientConfig, indent=1)
    openJsonFile = file("/root/config.json", "w+")
    openJsonFile.writelines(myJsonDump)
    openJsonFile.close()


# 获取本机IP地址
myIP = urllib2.urlopen('http://api.ipify.org').read()
myIP = myIP.strip()

# 加载客户端配置模板
clientJsonFile = file("/usr/local/v2ray.fun/json_template/client.json")
clientConfig = json.load(clientJsonFile)

# 使用服务端配置来修改客户端模板
clientConfig[u"outbound"][u"settings"][u"vnext"][0][u"port"] = int(
    readjson.ConfPort)
clientConfig[u"outbound"][u"settings"][u"vnext"][0][u"users"][0][u"id"] = str(
    readjson.ConfUUID)
clientConfig[u"outbound"][u"settings"][u"vnext"][0][u"users"][0][u"security"] = str(
    readjson.ConfSecurity)
clientConfig[u"outbound"][u"streamSettings"] = readjson.ConfStream
if str(readjson.ConfStreamSecurity) == "":
    clientConfig[u"outbound"][u"settings"][u"vnext"][0][u"address"] = str(myIP)
else:
    domainfile = file("/usr/local/v2ray.fun/mydomain", "r")
    content = domainfile.read()
    clientConfig[u"outbound"][u"settings"][u"vnext"][0][u"address"] = str(
        content)
    domainfile.close()
    clientConfig[u"outbound"][u"streamSettings"][u"security"] = "tls"
    clientConfig[u"outbound"][u"streamSettings"][u"tlsSettings"] = {}

# 写入客户端配置文件
WriteClientJson()
