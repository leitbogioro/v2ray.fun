#! /usr/bin/env python
# -*- coding: utf-8 -*-
import writejson
import readjson
import sys
from utils import is_number


# 主要程序部分
print("是否使能动态端口(y/n)")
ans = raw_input()
if ans == 'y' or ans == '':
    print("使能动态端口")
    writejson.EnDynPort(1)
elif ans == 'n':
    print("禁止动态端口")
    writejson.EnDynPort(0)
    sys.exit()
else:
    print("输入错误，输入y或者n")

print("是否修改端口范围？(Y/n)")
ans = raw_input()
if ans == 'y' or ans == '':
    print("请输入最小端口号")
    min_port = int(raw_input())
    if not is_number(min_port):
        print("请输入数字！")
        sys.exit()
    print("请输入最大端口")
    max_port = int(raw_input())
    if not is_number(max_port):
        print("请输入数字！")
        sys.exit()
    writejson.UpdateDynPort(min_port, max_port)
    main_port = int(readjson.ConfPort)
    while main_port > max_port or main_port < min_port:
        print("当前主端口%d 不在这个%d-%d之内，请修改主端口" % (main_port, min_port, max_port))
        print("请输入新端口：")
        newport = raw_input()
        if (is_number(newport)):
            writejson.WritePort(newport)
            main_port = int(newport)
        else:
            print("输入错误，请检查是否为数字")

elif ans == 'n':
    print("终止修改")
else:
    print("输入错误，输入y或者n")
