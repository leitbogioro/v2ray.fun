#! /usr/bin/env python
# -*- coding: utf-8 -*-
import readjson, writejson

if readjson.ConfStreamNetwork == "ws":
    print("“路径”（path）参数指的是当 v2ray 的通信协议设置为 Websocket 并有 Web 服务器和网站后，v2ray 客户端向服务端通信时，隐藏在主网站域名背后的网站目录")
    print("当前路径为：%s") % str(readjson.ConfPath)
    print("请输入新路径（前缀“/”不需要输入，程序会帮你自动填好）：")
    newpath = raw_input()
    if newpath == "":
        newpath = ""
    else:
        newpath = "/"+newpath
    writejson.WritePath(newpath)
else:
    print("您并未使用 Websocket 协议，无需配置path！")
