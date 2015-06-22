#!/bin/sh
amixer sset Master toggle
pkill i3blocks --signal SIGRTMIN+10
