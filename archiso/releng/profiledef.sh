#!/usr/bin/env bash
# shellcheck disable=SC2034

source '/usr/share/archiso/configs/releng/profiledef.sh'

iso_name="dotarchlinux"
iso_label="DOT_ARCH_$(date +%Y%m)"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '3' '-b' '1M')
