#!/usr/bin/env sh

[ "$(ls -A /usr/local/share/ca-certificates)" ] && update-ca-certificates

[ -f /etc/default/webhookd.env ] && . /etc/default/webhookd.env

exec /usr/bin/webhookd "$@"
