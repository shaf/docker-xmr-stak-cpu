#!/bin/ash

set -x

if [ -z "${CORES}" ]; then
export CORES=`grep -c processor /proc/cpuinfo`
fi

if [ -z "${CONF_BRANCH}" ]; then
export CONF_BRANCH=msr
fi

envtpl /app/xmr-stak-cpu.config.tpl -o /app/config.txt --allow-missing --keep-template
envtpl /app/xmr-stak-cpu.cpu.tpl -o /app/cpu.txt --allow-missing --keep-template
envtpl /app/xmr-stak-cpu.pools.tpl -o /app/pools.txt --allow-missing --keep-template

mkdir -p /app/my-conf
cd /app/my-conf
git clone https://github.com/shaf/docker-xmr-stak-conf.git
cd /app/my-conf/docker-xmr-stak-conf
git checkout $CONF_BRANCH
cp -f /app/my-conf/docker-xmr-stak-conf/*.txt /app/

if [ "$1" = 'xmr-stak-cpu' ]; then
    exec /app/xmr-stak --cpu /app/cpu.txt -c /app/config.txt -C /app/pools.txt
fi

exec "$@"
