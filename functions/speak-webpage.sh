#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: speak-webpage <URL>"
  exit 1
fi

URL="$1"

echo "Fetching and processing webpage..."
TEXT=$(curl -Ls "$URL" | lynx -stdin -dump -nolist | iconv -f utf-8 -t utf-8 -c)

echo "Speaking..."
say -v Agnes "$TEXT"
