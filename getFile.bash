#!/usr/bin/env bash
# ------------------------------------------------------------------
# [Author] Dmitry Myasnikov, <saver_is_not@bk.ru>
# Function for downloading file from anywhere.
# It also won't download file, if it have already been downloaded (By filename and size).
# ------------------------------------------------------------------

if [ !$(declare -F includeOnce) ] ; then
   . includeOnce.bash
fi

includeOnce public/verbosePrint.bash


getFile() #save file from anywhere - svn, web, ftp or nfs share
{

  usage()
   {
      cat << EOF
Usage: 
. getFile
getFile [OPTIONS] URL

This script will get your files from anywhere

OPTIONS:
   --destination  Where to save file. Default - current directory;
   --verbose      Additional messages during run. Default - false;
   --version      Print script version;
   --help         Print this message;

EXAMPLES: 
   getGile http://127.0.0.1/9i45arxiE.gif
   getGile --destination=/home/trash/ http://127.0.0.1/9i45arxiE.gif

EOF
   }

   local DESTINATION_DIR="."
   local VERBOSE=false
   local URL=""

for i in "$@"
do
case $i in
    --help|-h|/?)
    usage
    shift
    return 0;
    ;;
    --version)
    echo $VERSION
    shift
    return 0;
    ;;
    --destination=*)
    DESTINATION_DIR="${i#*=}"
    shift
    ;;
    --url=*)
    URL="${i#*=}"
    shift
    ;;
    --verbose=*)
    VERBOSE="${i#*=}"
    shift
    ;;

esac
done

   DESTINATION_DIR=$(readlink -f $DESTINATION_DIR)
   local FILENAME=${URL##*/}
   local PROTO="$(echo $URL | grep :// | sed -e's,^\(.*://\).*,\1,g')"

   verbosePrint "URL:          $URL"
   verbosePrint "FILENAME:     $FILENAME"
   verbosePrint "PROTO:        $PROTO"
   verbosePrint "DESTINATION:  $DESTINATION_DIR"

   case $PROTO in
        http://|ftp://)
          local NO_FILE=false
   if [ -f  $DESTINATION_DIR/$FILENAME ] #If file is already downloaded - check its size with remote file
   then
       local REMOTE_SIZE=$(wget $URL --spider --server-response -O - 2>&1 | sed -ne '/Content-Length/{s/.*: //;p}')
       local LOCAL_SIZE=$(stat -c%s $DESTINATION_DIR/$FILENAME)
       if [ "$REMOTE_SIZE" != "$LOCAL_SIZE" ] ; then
           NO_FILE=true
           verbosePrint "Existing file $DESTINATION_DIR/$FILENAME size differs. Need to download latest."
       else
           NO_FILE=false
           verbosePrint "We have latest version of $FILENAME in $DESTINATION_DIR "
       fi;
   else
      NO_FILE=true;
      verbosePrint "File not found. Need to download"
   fi

#   verbosePrint "NO_FILE: $NO_FILE ";


   if [ "$NO_FILE" = true ] ; then
      cd $DESTINATION_DIR
      if wget -q $URL; then
         verbosePrint "Succesfully downloaded $DESTINATION_DIR/$FILENAME"
      else
         verbosePrint "Error while downloading $URL"
         return 1
      fi
   fi

#       wget $URL
        ;;
        svn://)
        svn export $1
        ;;
        nfs://)
        #TODO: mount, copy, unmount - don't forget cygwin
   esac
}

