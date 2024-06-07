#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate



# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 添加额外插件

# xunlei
# git clone --depth 1 --branch v3.11.2-32 https://github.com/0x676e67/thunder.git package/xunlei
git clone --depth 1 https://github.com/animegasan/luci-app-quickstart package/luci-app-quickstart


# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/emortal/default-settings/files/99-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/${orig_version}-R${date_version} by Freedy/g" package/emortal/default-settings/files/99-default-settings



#  调整 xunlei 到 服务 菜单
#  sed -i 's/nas/services/g' package/xunlei/openwrt/luci-app-xunlei/luasrc/controller/xunlei.lua
#  sed -i 's/nas/services/g' package/xunlei/openwrt/luci-app-xunlei/luasrc/view/xunlei/xunlei_status.htm
#  sed -i 's/nas/services/g' package/xunlei/openwrt/luci-app-xunlei/luasrc/view/xunlei/xunlei_log.htm

./scripts/feeds update -a
./scripts/feeds install -a
