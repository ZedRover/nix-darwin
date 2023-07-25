#!/bin/bash

while read p; do
  if grep -q "$p" nix_packages.txt; then
    echo $p >> can_install.txt
  else
    echo "\"$p\"" >> cannot_install.txt
  fi
done <brew_formula_list.txt