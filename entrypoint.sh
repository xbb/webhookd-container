#!/usr/bin/env sh

[ -f /etc/default/webhookd.env ] && . /etc/default/webhookd.env

exec /usr/bin/webhookd
