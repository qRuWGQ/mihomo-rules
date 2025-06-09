#!/bin/bash
set -uo pipefail

mkdir -p ./tmp
mkdir -p ./rules

# 获取所有顶级键
keys=$(./yq e 'keys | .[]' "${RULES_DOWNLOAD_FILE}")

# 遍历每个键
for key in $keys; do
  # 获取URL、format和behavior
  url=$(./yq e ".${key}.url" "${RULES_DOWNLOAD_FILE}")
  format=$(./yq e ".${key}.format" "${RULES_DOWNLOAD_FILE}")
  behavior=$(./yq e ".${key}.behavior" "${RULES_DOWNLOAD_FILE}")
  
  # 设置文件名和后缀
  filename="${key}.${format}"
  
  # 下载文件
  wget -c -O "./tmp/${filename}" "${url}"
    
  # 检查下载是否成功
  if [ $? -eq 0 ]; then
    ./mihomo-linux-amd64-v${MIHOMO_VERSION} convert-ruleset ${behavior} ${format} ./tmp/${filename} ./rules/${key}.mrs
  fi
done

rm -fr ./tmp