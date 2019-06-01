#! /usr/bin/env python
# -*- coding: utf-8 -*-
import readjson, writejson, uuid
from utils import is_valid_uuid

print("当前UUID为：%s") % str(readjson.ConfUUID)
print("是否要随机生成一个新的UUID (Y/n)：")
genUUID = raw_input()

def writeuuid(newuuid):
    writejson.WriteUUID(newuuid)
    print "新的UUID为：{}".format(newuuid)

if genUUID == "y" or genUUID == '':
    newuuid = uuid.uuid4()
    writeuuid(newuuid)
elif genUUID == "n":
    print("请输入UUID")
    newuuid = raw_input()
    if newuuid == "" or is_valid_uuid(newuuid) == False:
        print("uuid 输入错误")
        print("")
        newuuid = uuid.uuid4()
        writeuuid(newuuid)
    else:
        writeuuid(newuuid)
else:
    print("输入不正确，请输入 y 或 n")
