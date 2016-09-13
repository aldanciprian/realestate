#!/bin/bash
#---------------------------------------------------------------#
#								#
# Name: compile.sh						#
#       							#
# Description:							#
#								#
#    The script compiles any PCU code. Currently for 2.1, 2.2,  #
#    2.5 versions, it automaticaly sets the environment based   #
#    on the location of the code				#
#   								#
#    In case of v2.[12] the code id compiled twice; once for 	#
#    apip and once for scrn. (Update 25.05.2012: The resulting  #
#    code binaries seem to be non-realiable, currently!		#
#								#
# Usage:							#
#								#
#    compile.sh [path_to_code [environment_file]]		#
#								#
#---------------------------------------------------------------#
#								#
# Examples:							#
#								#
#    The first argument of the script is the path to the	#
#    code that needs to be compiled. It can be relative 	#
#    or absolute path and it can be the root of source code 	#
#    or the path to a specific component.			#
#    								#
#    Second argument is the location of environment file	#
#    that sets the correct PRODUCT, EXCL_SUBDIRS etc		#
#        							#
#       $ compile.sh `pwd` /bldroot/tools/env_2.1_scrn.sh	#
#								#
#    In some cases the script will be run from the location 	#
#    of the code, whithout any argument:			#
#								#
# 	user@gjdev15:/bldare1/user/v2.5.623>$ compile.sh	#
#								#
#    If only a pecific component needs to be compiled, run	#
#    the script from that component:				#
#								#
# 	user@gjdev15:/bldare1/user/v2.5.623/net>$ compile.sh	#
#								#
#    Optionaly you can call the script from any place, by	#
#    providing, the location of the code as first argument:	#
#								#
#	user@gjdev15:~>$ compile.sh /bldare1/user/v2.1.580	#
#								#
#       							#
#---------------------------------------------------------------#	


# Global variables declaration
#------------------------------
BUILD_SOURCE_DIR=`pwd` # This will be overwritten when argument $1 is given
ENV_FILES_DIR="/bldroot/tools"
ENV21APIP="$ENV_FILES_DIR/env_4.0_apip.sh"
ENV21SCRN="$ENV_FILES_DIR/env_4.0_scrn.sh"
ENV25="$ENV_FILES_DIR/env_2.5.sh"
MP_VERSIONS="v2.[123456]" # Mainline and Platform versions
MP_VERSIONS3="v[3,4].[0123456]" # Mainline and Platform versions
Saber_VERSIONS="v1.[123456]" # Saber versions

# Functions declaration area
#----------------------------

#-------------------------------------------------------------------------
# CompileCode function executes the steps required for compiling the code
#-------------------------------------------------------------------------
function compileCode(){
   ERROR=""
   CRTDIR=`pwd`

   # Set environment based on input parameter
   COMPILE_ENV_FILE=$1 
   echo "Sourcing $COMPILE_ENV_FILE"
   source $COMPILE_ENV_FILE

   # Copy version.$product file to version file
   if [ -f "${SOURCE_HOME_DIR}/version.${PRODUCT}" ]; then
      echo "Copy version.${PRODUCT} to version"
      cp "${SOURCE_HOME_DIR}/version.${PRODUCT}" "${SOURCE_HOME_DIR}/version"
   fi
   
   #if [ -f "${SOURCE_HOME_DIR}/ascii_libs.tgz" ]; then
   #   echo "Untarring ascii_libs.tgz ."
   #   tar -xzf  "${SOURCE_HOME_DIR}/ascii_libs.tgz" --directory="${SOURCE_HOME_DIR}/"  
   #fi

   # Because cmake is using full paths, if the build was previously compiled in a different location
   # some modules contain old paths. We need to clean those modules first.
   CRITICAL_DIR="${SOURCE_HOME_DIR}/pkgs/ws4d/obj_*_$PRODUCT"
   if [ -f "$CRITICAL_DIR/Makefile" ]; then
	CMAKE_BINARY_DIR=`cat "$CRITICAL_DIR/Makefile" | grep "CMAKE_BINARY_DIR =" | awk '{print $3}'`
	if [ "$CMAKE_BINARY_DIR" != "$CRITICAL_DIR" ]; then
	   cd "$CRITICAL_DIR/.."
	   echo "Cleaning $CRITICAL_DIR"
	   make clean
	   cd - >/dev/null
	fi
   fi
   CRITICAL_DIR="${SOURCE_HOME_DIR}/pweb"
   if [ ! -f "$CRITICAL_DIR/javaflex/WebContent/javacon.jar" ]; then
      echo "Removing broken symbolic links in $CRITICAL_DIR"
      find $CRITICAL_DIR -type l | xargs rm -f
   fi
 
   echo "BUILD_SOURCE_DIR:${BUILD_SOURCE_DIR}"
   echo "SOURCE_HOME_DIR:${SOURCE_HOME_DIR}"
   cd "${BUILD_SOURCE_DIR}"
   make -j 1

   # If make fails, run it again sequentially to catch the error at the end of output
   if [ $? != 0 ];
     then

       if [ -d "${SOURCE_HOME_DIR}/ascii/hdmwrapper" ];
         then
            hdmwrapperlib=`find ${SOURCE_HOME_DIR}/ascii/hdmwrapper -name libhdmwrapper.so`
            if [ -z "$hdmwrapperlib"]; then
                echo "Start building libhdmwrapper"
                echo "cd ${SOURCE_HOME_DIR}/ascii/hdmwrapper"
                cd "${SOURCE_HOME_DIR}/ascii/hdmwrapper"
                make
            fi
       fi

       if [ -d "${SOURCE_HOME_DIR}/ascii/masterizer/rdl" ];
         then
            rdlalib=`find ${SOURCE_HOME_DIR}/ascii/masterizer/rdl -name librdla.so`
            if [ -z "$rdlalib"]; then
                echo "Start building librdla"
                echo "cd ${SOURCE_HOME_DIR}/ascii/masterizer/rdl"
                cd "${SOURCE_HOME_DIR}/ascii/masterizer/rdl"
                make
            fi
       fi

       cd "${SOURCE_HOME_DIR}/mkms"
       make

       # If make fails, flag it, so that the script will exit on error
       if [ $? != 0 ];
         then
            ERROR="Compile failed!"
       fi
   fi

   sleep 1

   cd $CRTDIR

   # Set exit code
   if [ "$ERROR" != "" ];
     then
       echo "$ERROR"
       exit 1
   fi

}
#----------------

# Validate input parameter
#--------------------------

# Get location of environment file
# If not provided, environment files will be used based on version in the path
if [ "$2" != "" ];
  then
    COMPILE_ENV_FILE=$2
    # Set path to input argument
    BUILD_SOURCE_DIR=$1
elif [ "$1" != "" ];
  then
    if [ $1 = $ENV21APIP -o $1 = $ENV21SCRN -o $1 = $ENV25 ];
      then
        COMPILE_ENV_FILE=$1
    else
        BUILD_SOURCE_DIR=$1
    fi
fi



# Calculate absolute path
case ${BUILD_SOURCE_DIR} in
     /*) BUILD_SOURCE_ABS_DIR=${BUILD_SOURCE_DIR} ;;
      *) BUILD_SOURCE_ABS_DIR="`pwd`/${BUILD_SOURCE_DIR}";;
esac
# Check if $BUILD_SOURCE_DIR is the root of source code and switch to mkms if so
SOURCE_HOME_DIR=`basename $BUILD_SOURCE_DIR | egrep "v[0-9]+\.[0-9]+\.[0-9]+"`
if [ "$SOURCE_HOME_DIR" != "" ]
  then
    BUILD_SOURCE_DIR="`dirname ${BUILD_SOURCE_DIR}`/`basename ${BUILD_SOURCE_DIR}`/mkms"
    
    # Set source home dir
    SOURCE_HOME_DIR=$BUILD_SOURCE_ABS_DIR
else
    SOURCE_HOME_DIR=`echo $BUILD_SOURCE_ABS_DIR | sed -e "s|\(.*/v[0-9]*\.[0-9]*\.[0-9]*[^/]*\).*|\1|g"`
fi
# Check if input directory exists
if [ ! -d "${BUILD_SOURCE_DIR}" ] ;
  then
    echo "Source directory (${BUILD_SOURCE_DIR}) is not valid"
    exit 1
fi
# Check if input directory contains makefile 
if [ ! -f "${BUILD_SOURCE_DIR}/makefile" ] ;
  then
    if [ ! -f "${BUILD_SOURCE_DIR}/mkms/makefile" ];
      then
        echo "Directory ${BUILD_SOURCE_DIR} does not contain makefile!"
        exit 1
    else
        BUILD_SOURCE_DIR="`dirname ${BUILD_SOURCE_DIR}`/`basename ${BUILD_SOURCE_DIR}`/mkms"

        # Set source home dir
        SOURCE_HOME_DIR=$BUILD_SOURCE_ABS_DIR
    fi	
fi

# Check if environment file is provided
if [ "$COMPILE_ENV_FILE" != "" ];
  then
    compileCode $COMPILE_ENV_FILE
else
    # Check version and set correct environment
    crr_mask=`echo ${BUILD_SOURCE_DIR}|sed -e "s|/|\n|g"|egrep "v[0-9]+\.[0-9]+\.[0-9]+"`
    case $crr_mask in
             ${MP_VERSIONS}.*) # Cutsheet
                compileCode $ENV21APIP

                # Continous forms
                compileCode $ENV21SCRN
		;;

             ${MP_VERSIONS3}.*) # Cutsheet
                compileCode $ENV21APIP

                # Continous forms
                compileCode $ENV21SCRN
		;;

             ${Saber_VERSIONS}.*)
                # Continous forms
                compileCode $ENV21SCRN
		;;

             v2.5.*) # Eldora
                source $ENV25
                $ENV_FILES_DIR/setUpMakefiles.sh $BUILD_SOURCE_ABS_DIR 
                compileCode $ENV25
                ;;
        *) echo "Unknown version! Don't know which environment to apply! ...exiting"
           exit 1;;
    esac
fi
