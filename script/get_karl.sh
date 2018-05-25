#!/bin/bash
#
# get_usbr.sh
# This script get usbr data from the USBR webservice. 
# It makes the data availible for DB postin instapost.

#====================================================
# Initialize and check if script should run
#====================================================

export RUNOFFICE=all
export LOOKBACK=2

if [ "$RUNOFFICE" = "all" ] || [ "$RUNOFFICE" = "nwdp" ]; then
  ./usbr_to_json nwdp.conf -l $LOOKBACK -d > ../temp/${RUNOFFICE}_${FN}_${START}.json
fi

if [ "$RUNOFFICE" = "all" ] || [ "$RUNOFFICE" = "nww" ]; then
  ./usbr_to_json nww.conf -l $LOOKBACK -d >> ../temp/${RUNOFFICE}_${FN}_${START}.json
fi

if [ "$RUNOFFICE" = "all" ] || [ "$RUNOFFICE" = "nws" ]; then
  ./usbr_to_json nws.conf -l $LOOKBACK -d >> ../temp/${RUNOFFICE}_${FN}_${START}.json
fi

if [ "$RUNOFFICE" = "all" ] || [ "$RUNOFFICE" = "nwp" ]; then
  ./usbr_to_json nwp.conf -l $LOOKBACK -d >> ../temp/${RUNOFFICE}_${FN}_${START}.json
fi




