#!/usr/bin/env bash

# ------------------------------------------------------------------
# [Author] Dmitry Myasnikov, <saver_is_not@bk.ru>
# TODO: Write your credentials and brief description here
# Function template
# Arguments parsing satisfies POSIX convention of accepting long options:
# http://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html
# ------------------------------------------------------------------

# Add includes, if you need
#. $HOME/.bash_functions/logMsg.bash

templateFunction() #please, give the function and the file the same names
{

shopt -s extglob         # enables pattern lists like +(...|...)

#TODO: please, do not remove parameters, just add your own
local PARAMETERS=( 
"CONFIG_FILE"
)

for j in ${PARAMETERS[@]}; do
   local ${j}=""
done

#TODO: assign default values to your parameters
local VERSION=1.0 #increase version from release to release
CONFIG_FILE="$HOME/.config/my_functions/${FUNCNAME[1]}.cfg"

#TODO: this function prins help, please fill it properly
usage()
{
   cat << EOF
      
${FUNCNAME[1]} version $VERSION
This fuction allows you to create your own awesome code with comfortable reusing

Usage: 
${FUNCNAME[1]} [OPTIONS] 

Description and requirements

OPTIONS:
  --config_file		Config file path. Default - ~/.config/bash_functions/${FUNCNAME[1]}.cfg;
  --version		Print script version;
  --help		Print this message;

EXAMPLES:
  ${FUNCNAME[1]} --help
  ${FUNCNAME[1]} --log_level=\$INFO_LEVEL

EOF
}

#=======Handle parameters string=============
local ALLOWED_PARAMETERS="${PARAMETERS[@]}"
ALLOWED_PARAMETERS="${ALLOWED_PARAMETERS// /|}" #form a string of allowed parameters with delimiter "|"
ALLOWED_PARAMETERS="+(${ALLOWED_PARAMETERS})" 

for i in "$@"
do
   local PARAM_VALUE="${i#--}"
   local PARAM_SUFFIX="${i#*=}"
   local PARAM_PREFIX="${PARAM_VALUE%=$PARAM_SUFFIX}"
   PARAM_NAME="${PARAM_PREFIX^^}"
case "$PARAM_NAME" in
    HELP|-h|/?)
      usage
      shift
      return 0;
    ;;
    VERSION)
      echo $VERSION
      shift
      return 0;
    ;;
    ${ALLOWED_PARAMETERS})
      local ${PARAM_NAME}=$PARAM_SUFFIX
      shift
    ;;
    *) #all other parameters
    echo "Unknown error while processing options. Try --help key."
    return 1;
    ;;
esac
done

# MAIN SCRIPT LOGIC
if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform        
    echo "Mac OS detected"
else if [ "$(uname -o)" == "Cygwin" ]; then
    # Do something under Windows NT platform
    echo "Cygwin detected"
fi
fi

# Add your code here

}

templateFunction "$@" #remove it, if your file is only for import
