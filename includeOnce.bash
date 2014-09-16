#!/usr/bin/env bash
# ------------------------------------------------------------------
# [Author] Dmitry Myasnikov, <saver_is_not@bk.ru>
# Function for including function once in complex bash script
# USAGE:
# includeOnce filename
# ------------------------------------------------------------------

includeOnce() 
{
   local s=$1
   if [ !$(declare -F ${s%.*}) ] ; then
       . $s
   fi
}

