#!/usr/bin/env bash
# ------------------------------------------------------------------
# [Author] Dmitry Myasnikov, <saver_is_not@bk.ru>
# Function for printing something if VERBOSE is true 
# USAGE:
# verbosePrint "lol"
# ------------------------------------------------------------------

verbosePrint() 
{
   if [ "$VERBOSE" = true  ] ; then
      echo $1
   fi
}

