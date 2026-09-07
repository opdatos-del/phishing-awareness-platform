#!/bin/sh
set -eu

chown -R app:app /opt/gophish/data
exec su -s /bin/sh app -c '/opt/gophish/docker/run.sh'
