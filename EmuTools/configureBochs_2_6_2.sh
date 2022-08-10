#!/bin/sh

# install gtk: https://blog.csdn.net/qq_39433050/article/details/115239978
sudo apt-get install libgtk2.0-dev  #安装gtk运行环境
sudo apt-get install gnome-devel    #安装gtk开发环境

cd Bochs-REL_2_6_2_FINAL/bochs/
mkdir -p /home/helson/bochs
./configure \
--prefix=/home/helson/bochs \
--enable-debugger \
--enable-x86-debugger \
--enable-disasm \
--enable-iodebug \
--with-x \
--with-x11 
