#! /usr/bin/env python
# -*- coding: utf-8 -*-
# Change alterID
import readjson
import writejson
from utils import is_number

print "当前AlterID为：{}".format(str(readjson.ConfAlterId))
alterID = raw_input("请输入新的alterID: ")

if (is_number(alterID)):
    writejson.WriteAlterId(alterID)
else:
    print("输入错误，请检查是否为数字")
