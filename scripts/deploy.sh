#!/bin/bash

ncftpput -R -v -u "$FTP_USER" -p "$FTP_PASS" $FTP_HOST /var/www/newocr.dev/public_html www/