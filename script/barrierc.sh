#!/usr/bin/env bash
killall barrierc ;
/bin/barrierc --no-tray --daemon  --log ~/barrierc.log 192.168.0.109;
