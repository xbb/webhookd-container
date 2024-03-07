FROM golang:1.21 AS builder

RUN git clone --single-branch --depth 1 \
        --recurse-submodules --shallow-submodules \
        -b v1.19.0 https://github.com/ncarlier/webhookd && \
    cd webhookd && \
    make

FROM alpine:3.19

ARG EXTRA_PACKAGES="jq curl bash moreutils ca-certificates"
RUN apk upgrade --no-cache && \
    [ -n "${EXTRA_PACKAGES}" ] && apk add --no-cache gcompat ${EXTRA_PACKAGES} || true

COPY --from=builder /go/webhookd/release/webhookd /usr/bin/webhookd
COPY --from=builder /go/webhookd/scripts /scripts
COPY --from=builder /go/webhookd/etc/default/webhookd.env /etc/default/webhookd.env
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

VOLUME /scripts

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
