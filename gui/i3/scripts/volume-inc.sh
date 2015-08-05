#!/bin/sh
amixer sset Master 5%+
pkill i3blocks --signal SIGRTMIN+10
