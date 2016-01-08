#!/usr/bin/env bash
apache2ctl -D FOREGROUND
service cron start
