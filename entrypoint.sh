#!/bin/sh

if [ -f ".env" ]; then
  echo "source .env"
  source .env
else
  echo "no .env found"
fi

if [[ -f "crontab.txt" && "$RUN_CRONTAB" != "" ]]; then
  echo "==== install crontab ===="
  crontab crontab.txt
  crond -f &
else
  echo "==== no crontab ===="
fi

echo "======== RUN $@ =============="

$@
