#!/bin/sh

if [ -f ".env" ]; then
  echo "source .env"
  source .env
else
  echo "no .env found"
fi

echo "======== RUN $@ =============="

$@
