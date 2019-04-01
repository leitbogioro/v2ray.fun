#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os, urllib2, shutil, ssl

# 判断是否为数字的函数
def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        pass

    try:
        import unicodedata
        unicodedata.numeric(s)
        return True
    except (TypeError, ValueError):
        pass
    return False

# 下载文件
def download_files(f_url, f_name, mode = "wb"):
    context = ssl._create_unverified_context()
    files = f_name
    url = f_url
    f = urllib2.urlopen(url, context=context)
    data = f.read()
    with open(f_name, mode) as code:
        code.write(data)

# 移动文件
def move_files(f_name, t_folder):
    if os.path.exists(f_name):
        shutil.move(f_name, t_folder)
    else:
        print ("Could not found " + f_name)
