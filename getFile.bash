#!/usr/bin/env bash
# ------------------------------------------------------------------
# [Author] Dmitry Myasnikov, <saver_is_not@bk.ru>
# Function for downloading file to current directory from anywhere
# ------------------------------------------------------------------

getFile() #save file from anywhere - svn, web, ftp or nfs share
{
   proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
   echo $proto
   case $proto in
        http://|ftp://)
        wget $1
        ;;
        svn://)
        svn export $1
        ;;
        nfs://)
        #TODO: mount, copy, unmount - don't forget cygwin
   esac
}

