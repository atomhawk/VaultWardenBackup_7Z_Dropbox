FROM shivpatel/bitwarden_rs_dropbox_backup
RUN apk add p7zip

COPY backup.sh /
COPY deleteold.sh /

RUN chmod +x /backup.sh && \
    chmod +x /deleteold.sh
