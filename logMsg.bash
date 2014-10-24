#!/usr/bin/env bash

# ------------------------------------------------------------------
# [Author] Dmitry Myasnikov, <saver_is_not@bk.ru>
# Library of function for printing something by log levels with highlighting
# Code examples ware taken from here:
# http://swaeku.github.io/blog/2013/09/14/format-and-print-logs-in-bash-shell-scripts/
# http://www.goodmami.org/2011/07/simple-logging-in-bash-scripts/
# and optimized for taking the best of these examples
#
# USAGE:
# notifyMsg "It is too late to go home"
# debugMsg "DEBUG: null value"
# ------------------------------------------------------------------

exec 3>&2 # logging stream (file descriptor 3) defaults to STDERR

#set global variables for different log levels with color numbers

ERROR_LEVEL=31
WARNING_LEVEL=33
INFO_LEVEL=35
DEBUG_LEVEL=37
NOTIFY_LEVEL=10

LOG_LEVEL=$WARNING_LEVEL # default to show warnings

printMsg() { logMsg $NOTIFY_LEVEL "$1"; } # Always prints
errorMsg() { logMsg $ERROR_LEVEL "$1"; }
warnMsg() { logMsg $WARNING_LEVEL "$1"; }
infoMsg() { logMsg $INFO_LEVEL "$1"; } # "info" is already a command
debugMsg() { logMsg $DEBUG_LEVEL "$1"; }

logMsg() {
    local level=${1?}    #if no parameters, then fail
    if [ $LOG_LEVEL -ge $level ]; then
        # Expand escaped characters, wrap at 70 chars, indent wrapped lines
    if [ -t 2 ]
        then
        local code= line="[$(date '+%F %T')] $2"
        echo -e "\e[${level}m${line}\e[0m" | fold -w70 -s | sed '2~1s/^/  /'
      else
        echo "$line"
      fi >&3
    fi
}