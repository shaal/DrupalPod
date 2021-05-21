#!/usr/bin/env bash

ddev version | awk '/(drud|phpmyadmin)\// {print $2;}' >/tmp/images.txt
for item in $(cat /tmp/images.txt); do
  docker pull $item
done