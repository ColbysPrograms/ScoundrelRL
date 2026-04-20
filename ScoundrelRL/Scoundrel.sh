#!/bin/sh
printf '\033c\033]0;%s\a' Scoundrel
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Scoundrel.x86_64" "$@"
