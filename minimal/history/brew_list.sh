#!/bin/bash

# 获取已安装的 Homebrew formula 列表
brew_formula_list=$(brew list --formula)

# 使用双引号包围每个 formula 名
brew_formula_list_quoted=$(echo "$brew_formula_list" | awk '{print "\"" $0 "\""}')

# 将结果写入文件
echo "$brew_formula_list_quoted" > brew_formula_list.txt

# 获取已安装的 Homebrew cask 列表
brew_cask_list=$(brew list --cask)

# 使用双引号包围每个 cask 名
brew_cask_list_quoted=$(echo "$brew_cask_list" | awk '{print "\"" $0 "\""}')

# 将结果写入文件
echo "$brew_cask_list_quoted" > brew_cask_list.txt
