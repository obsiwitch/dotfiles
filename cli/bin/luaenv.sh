#!/bin/sh

# usage: source luaenv

# user & system rocks trees (exports LUA_PATH, LUA_CPATH & PATH)
eval $(luarocks path)

# pkg rocks tree
version=$(lua -v | grep -Eo '[0-9]+\.[0-9]+')
LUA_PATH="pkgs/share/lua/$version/?.lua;$LUA_PATH"
LUA_PATH="pkgs/share/lua/$version/?/init.lua;$LUA_PATH"
LUA_CPATH="pkgs/lib/lua/$version/?.so;$LUA_CPATH"
