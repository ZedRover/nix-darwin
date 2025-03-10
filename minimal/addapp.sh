#!/bin/bash

# 配置文件路径
CONFIG_FILE="${HOME}/tools/nix-world/nix-darwin-kickstarter/minimal/modules/apps.nix"

# 检查配置文件是否存在
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "配置文件 $CONFIG_FILE 不存在!"
  exit 1
fi

# 向指定的列表添加软件
add_to_list() {
  local list_name=$1
  local app=$2
  local list_start="### START $(echo "$list_name" | tr '[:lower:]' '[:upper:]') ###"
  local list_end="### END $(echo "$list_name" | tr '[:lower:]' '[:upper:]') ###"

  # 检查应用是否已存在
  if grep -q "\"$app\"" "$CONFIG_FILE"; then
    echo "$app 已存在于 $list_name，无需添加。"
    return
  fi

  # 插入软件到 END 之前
  awk -v start="$list_start" -v end="$list_end" -v app="\"$app\"" '
    $0 ~ start {found=1} 
    found && $0 ~ end {print app} 
    {print}
  ' "$CONFIG_FILE" > tmp_config.nix && mv tmp_config.nix "$CONFIG_FILE"

  echo "$app 已成功添加到 $list_name!"

  # 自动排序并格式化
  sort_list "$list_name"
}

# 排序指定的列表
sort_list() {
  local list_name=$1
  local list_start="### START $(echo "$list_name" | tr '[:lower:]' '[:upper:]') ###"
  local list_end="### END $(echo "$list_name" | tr '[:lower:]' '[:upper:]') ###"

  awk -v start="$list_start" -v end="$list_end" '
    $0 ~ start {print; found=1; next}
    found && $0 ~ end {
      found=0
      asort(apps)
      for (i=1; i<=length(apps); i++) print apps[i]
      print
      next
    }
    found {apps[length(apps)+1] = $0; next}
    {print}
  ' "$CONFIG_FILE" > tmp_config.nix && mv tmp_config.nix "$CONFIG_FILE"

  echo "$list_name 列表已按字母排序！"

  # 运行 `nixfmt` 进行格式化
  nixfmt "$CONFIG_FILE"

  echo "格式化完成：$CONFIG_FILE"
}

# 解析输入参数
case "$1" in
  c|b|f)
    if [[ -n "$2" ]]; then
      case "$1" in
        c) list="casks" ;;
        b) list="brews" ;;
        f) list="fonts" ;;
      esac
      add_to_list "$list" "$2"
    else
      echo "请提供要添加的软件名！"
    fi
    ;;
  *)
    echo "无效的操作。使用： ./addapp.sh c|b|f 软件名"
    ;;
esac