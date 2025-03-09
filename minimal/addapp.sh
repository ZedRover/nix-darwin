#!/bin/zsh

# 配置文件路径
CONFIG_FILE="modules/apps.nix"

# 检查配置文件是否存在
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "配置文件 $CONFIG_FILE 不存在!"
  exit 1
fi

# 向指定的列表添加软件
add_to_list() {
  local list_name=$1
  local app=$2
  local list_start="### START ${list_name^^} ###"
  local list_end="### END ${list_name^^} ###"
  
  # 确保添加的位置
  sed -i "/$list_start/,/$list_end/ {
    /$list_end/i\\
    \"$app\"
  }" "$CONFIG_FILE"
  
  echo "$app 已成功添加到 $list_name!"
  
  # 添加完软件后自动排序
  sort_list "$list_name"
}

# 排序指定列表
sort_list() {
  local list_name=$1
  local list_start="### START ${list_name^^} ###"
  local list_end="### END ${list_name^^} ###"
  
  # 提取当前列表，并排序
  local sorted_list=$(sed -n "/$list_start/,/$list_end/p" "$CONFIG_FILE" | grep -Eo '"[^"]+"' | sort)
  
  # 更新配置文件中的列表
  sed -i "/$list_start/,/$list_end/{
    /$list_end/c\\
  $list_start\\
  $sorted_list\\
  $list_end
  }" "$CONFIG_FILE"
  
  echo "$list_name 列表已按字母排序！"
}

# 主逻辑处理
case "$1" in
  addapp)
    case "$2" in
      c|b|f)
        if [[ -n "$3" ]]; then
          # 判断是哪个列表，并调用对应函数
          case "$2" in
            c) list="casks" ;;
            b) list="brews" ;;
            f) list="fonts" ;;
          esac
          add_to_list "$list" "$3"
        else
          echo "请提供要添加的软件名！"
        fi
        ;;
      *)
        echo "无效的操作。使用：addapp c|b|f 软件名"
        ;;
    esac
    ;;
  *)
    echo "无效的命令。使用：addapp c|b|f 软件名"
    ;;
esac
