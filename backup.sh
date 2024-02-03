#!/bin/sh

# create backup filename
BACKUP_FILE="backup_$(date "+%F-%H%M%S")"

# use sqlite3 to create backup (avoids corruption if db write in progress)
sqlite3 /data/db.sqlite3 ".backup '/tmp/db.sqlite3'"

# tar up backup and encrypt with openssl and encryption key
 7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=32m -ms=on -mhe=on -p$Z_PASSWORD /tmp/$BACKUP_FILE.7z /tmp/db.sqlite3 /data/attachments /data/config.json

# copy 7z to LOCAL_BACKUP_DIR
cp /tmp/${BACKUP_FILE}.7z /${LOCAL_BACKUP_DIR}/${BACKUP_FILE}.7z

# upload encrypted tar to dropbox
/dropbox_uploader.sh -f /config/.dropbox_uploader upload /tmp/${BACKUP_FILE}.7z /${BACKUP_FILE}.7z

# cleanup tmp folder
rm -rf /tmp/*

# delete older backups if variable is set & greater than 0
if [ ! -z $DELETE_AFTER ] && [ $DELETE_AFTER -gt 0 ]
then
  /deleteold.sh
fi
