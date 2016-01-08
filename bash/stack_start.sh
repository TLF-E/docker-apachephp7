#!/usr/bin/env bash
service cron start > /var/log/cron.log
apache2ctl -D FOREGROUND
