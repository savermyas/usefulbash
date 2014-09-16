#!/usr/bin/env bash
# ------------------------------------------------------------------
# [Author] Dmitry Myasnikov, <saver_is_not@bk.ru>
# Function for sleeping until remote service starts
# ------------------------------------------------------------------


function waitNetworkService() #wait, until port 8080 opens on remote host
{

  usage()
   {
      cat << EOF
Usage: 
. waitNetworkService
waitNetworkService [OPTIONS]

This script waits until some remote service starts. You need to install netcat (nc) package to run it..

OPTIONS:
   --port    	TCP port, which is opened by service, Default - 8080;
   --host    	Host IP address/DNS name;
   --sleeptime  Time between cycles of checking open port in seconds. Default - 1s;
   --timeout    Total timeout to wait. Return with -1 value after waiting;
   --verbose    Additional messages during run. Default - false;
   --version    Print script version;
   --help       Print this message;

EXAMPLES: 
   waitNetworkService --host=mail.ru --port=25
   waitNetworkService --sleeptime=3 --timeout=30 --host=ya.ru --port=80

EOF
   }

   local VERSION=0.9.0
   local SERVICEPORT=8080
   local SLEEPTIME=1
   local SERVICEHOST="localhost"
   local TOTALTIMEOUT=30
   local VERBOSE=false


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
    --port=*)
    SERVICEPORT="${i#*=}"
    shift
    ;;
    --host=*)
    SERVICEHOST="${i#*=}"
    shift
    ;;
    --sleeptime=*)
    SLEEPTIME="${i#*=}"
    shift
    ;;
    --timeout=*)
    TOTALTIMEOUT="${i#*=}"
    shift
    ;;
    --verbose=*)
    VERBOSE="${i#*=}"
    shift
    ;;

esac
done


   #---------------------------------------------
   # Script logic is here
   #---------------------------------------------
  
   if [ "$VERBOSE" = true  ] ; then 
      echo "SERVICEHOST  = $SERVICEHOST"
      echo "SERVICEPORT  = $SERVICEPORT"
      echo "SLEEPTIME    = $SLEEPTIME"
      echo "TOTALTIMEOUT = $TOTALTIMEOUT"
   fi

   local TOTALTIME=0
   PORT_OPEN=$(nc $SERVICEHOST $SERVICEPORT < /dev/null; echo $?)
   while [[ $PORT_OPEN = 1 ]]; do
       
       sleep $SLEEPTIME 
       PORT_OPEN=$(nc $SERVICEHOST $SERVICEPORT < /dev/null; echo $?)
       TOTALTIME=$(expr $TOTALTIME + $SLEEPTIME)
       
       if [ "$VERBOSE" = true  ] ; then 
          echo "Tested port. Time waited - $TOTALTIME of $TOTALTIMEOUT s. Open value is $PORT_OPEN" 
       fi


       if [ "$TOTALTIME" -ge "$TOTALTIMEOUT" ] ; then
      	   if [ "$VERBOSE" = true  ] ; then 
               echo "Can't wait anymore. This service will never start." 
           fi
           return -1
       fi
   done
   return 0
}

