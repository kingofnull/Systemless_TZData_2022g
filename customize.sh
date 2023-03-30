#!/sbin/sh

ui_print   "***************************************"
ui_print   "*  _____ _________    _  _____  _     *"    
ui_print   "* |_   _|__  /  _ \  / \|_   _|/ \    *"   
ui_print   "*   | |   / /| | | |/ _ \ | | / _ \   *"  
ui_print   "*   | |  / /_| |_| / ___ \| |/ ___ \  *"
ui_print   "*   |_| /____|____/_/   \_\_/_/   \_\ *"
ui_print   "* ~Systemless TZdata Updater 2022g~   *"
ui_print   "*          ~By: KingOfNull~           *"
ui_print   "*                                     *"
ui_print   "***************************************"

ui_print " "
ui_print "  Let's detect what is the version of your Android"
ui_print " "

# Variables
BOOTMODE=0
DEVFND=0
SDK_VER=1
SDK_VER_MAX=33
# SDK check
  if [ $API -ge $SDK_VER ] && [ $API -lt $SDK_VER_MAX ]; then
    ui_print "SDK$API detected. It is supported."
    DEVFND=1
  fi
# Abort if no match
if [ $DEVFND == 0 ]; then
  abort "Android is newer than Android 13 or modified build.prop! Aborting."
fi

    
backupAndReplace(){
	local REPLACEMENT_DIR=$1
	local DES_DIR=$2
	local BACKUP_DIR=$DES_DIR/backup_$RANDOM
    
    ui_print "Make a backuped replacment from `$REPLACEMENT_DIR` to `$DES_DIR` ..." 
    
    if [ ! -d $DES_DIR ]; then
        ui_print "Directory $DES_DIR DOES NOT exists. Opration canceled !" 
        return 1
    fi
    
    ui_print "Making backup ..."
    mkdir $BACKUP_DIR
    ui_print "Copying replacment files ..."
    cp -afr $DES_DIR/* $BACKUP_DIR/
	cp -afr $REPLACEMENT_DIR/* $DES_DIR/
}

REF_API=$API


if [ $API -ge 30 ]; then 
  REF_API=30
fi

if [ $API -le 28 ]; then 
  REF_API=28
fi

SOURCES_DIR=$MODPATH/system/tzdata_sources
REF_DIR=$SOURCES_DIR/$REF_API

ui_print "Trying to backup and install SDK$API ..."

backupAndReplace $REF_DIR $MODPATH/system/usr/share/zoneinfo/
backupAndReplace $REF_DIR $MODPATH/data/misc/zoneinfo/
backupAndReplace $REF_DIR $MODPATH/data/misc/zoneinfo/tzdata/
backupAndReplace $REF_DIR $MODPATH/system/apex/com.android.tzdata/etc/tz/

# rm -rf $SOURCES_DIR/
