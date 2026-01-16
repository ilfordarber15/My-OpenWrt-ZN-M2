#!/bin/bash
#
# diy-part2.sh - Feeds 安装后执行
# 用于系统定制
#

# 修改默认 IP 地址 (改为 192.168.10.1)
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 修改默认主机名
sed -i 's/OpenWrt/ZN-M2/g' package/base-files/files/bin/config_generate

# 设置默认时区为中国 (CST-8)
sed -i "s/'UTC'/'CST-8'/g" package/base-files/files/bin/config_generate

# 设置默认语言为简体中文
sed -i 's/luci.main.lang=auto/luci.main.lang=zh_Hans/g' feeds/luci/modules/luci-base/root/etc/uci-defaults/30_luci-i18n-base || true

# 修改默认主题为 argon (如果安装了 argon)
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
