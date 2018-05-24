#!/bin/bash
#
# get_usbr.sh
# This script get usbr data from the USBR webservice. 
# It makes the data availible for DB postin instapost.

#====================================================
# Initialize and check if script should run
#====================================================

. ~/.env_vars

OFFICE=common
FN=usbr
SCRIPT_NAME="get_usbr"

SOURCE=$DA_HOME

FN_SOURCE=$SOURCE/$OFFICE/$FN
SCRIPT_DIR=${FN_SOURCE}/script
CNTL_LIB_DIR=$SOURCE/common/lib

export OFFICE FN

START=`date -u +%y%m%d%H%M%S`
OUTPUT=$SOURCE/control/output/instapost
LOOKBACK=3
RUNOFFICE=all

#====================================================
# Load the standard da functions library
#====================================================
. ${CNTL_LIB_DIR}/da_functions.sh


#====================================================
# Check if feed is activated (flag file on)
#====================================================
feed_status $OFFICE $FN "${SCRIPT_NAME}.sh" >/dev/null 2>/dev/null
if [ "$?" -ne "0" ]
then
  echo $OFFICE $FN not configured to run on this server
  echo exit
fi

#====================================================
# Parse Command Line Arguments
#====================================================
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -o|--office)
    RUNOFFICE="$2"
    shift # past argument
    ;;
    -l|--lookback)
    LOOKBACK="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

echo OFFICE TO RUN  = "${RUNOFFICE}"
echo LOOKBACK [DAYS] = "${LOOKBACK}"

#====================================================
# Get a lock for this process.  If existing lock is two hours old, the owning
# process is probably dead, so continue on as if the lock were ours.
#====================================================
LOCK_DIR=${FN_SOURCE}/data/${RUNOFFICE}.lock
${CNTL_LIB_DIR}/lock_dir $LOCK_DIR 1
if [ $? -ne 0 ]; then
  exit
fi
log_message "Lock File" "Created."

#====================================================
# Initialize, archive old log file, start new one
#====================================================
new_log
# Start timer
Start_Time=`date -u +%H:%M:%S`
log_message "Script" "Start"

# Set backup file suffix timestamp and remove previous temporary files
STAMP=`date -u +%Y%m%d`
rm -f ${FN_SOURCE}/temp/*

#====================================================
# Get data
#====================================================
cd $SCRIPT_DIR


if [ "$RUNOFFICE" = "all" ] || [ "$RUNOFFICE" = "nwdp" ]; then
  ./usbr_to_yaml nwdp.conf -l $LOOKBACK -d > ../temp/${RUNOFFICE}_${FN}_${STAMP}.yaml
fi

if [ "$RUNOFFICE" = "all" ] || [ "$RUNOFFICE" = "nww" ]; then
  ./usbr_to_yaml nww.conf -l $LOOKBACK -d > ../temp/${RUNOFFICE}_${FN}_${STAMP}.yaml
fi

if [ "$RUNOFFICE" = "all" ] || [ "$RUNOFFICE" = "nws" ]; then
  ./usbr_to_yaml nws.conf -l $LOOKBACK -d > ../temp/${RUNOFFICE}_${FN}_${STAMP}.yaml
fi

if [ "$RUNOFFICE" = "all" ] || [ "$RUNOFFICE" = "nwp" ]; then
  ./usbr_to_yaml nwp.conf -l $LOOKBACK -d > ../temp/${RUNOFFICE}_${FN}_${STAMP}.yaml
fi


mv ../temp/${RUNOFFICE}_${FN}_${STAMP}.yaml ${OUTPUT}


#====================================================
# Cleanup and log success
#====================================================
FINISH=`date -u +%y%m%d%H%M%S`
End_Time=`date -u +%H:%M:%S`
# Get elapsed seconds by sending in starting HH:MM:SS and ending HH:MM:SS
log_message "Script Finish" "Start time = ${Start_Time} and End Time = ${End_Time}"
seconds=`ElapsedSeconds ${Start_Time} ${End_Time}`
log_message "Script Finish" "Elapsed seconds -> ${seconds}"
# Get the number of minutes and seconds from a total number of seconds
minsecs=`MinutesSeconds ${seconds}`
log_message "Script Finish" "Elapsed time -> ${minsecs}"

#====================================================
# Remove lock file
#====================================================
rmdir $LOCK_DIR
log_message "Lock File" "Removed."
echo "Lock File Removed."

