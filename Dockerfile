FROM golang:1.17 AS builder

RUN git clone --single-branch --depth 1 \
        --recurse-submodules --shallow-submodules \
        -b v1.15.0 https://github.com/ncarlier/webhookd && \
    cd webhookd && \
    make

FROM public.ecr.aws/docker/library/alpine:3.16

ARG EXTRA_PACKAGES="jq curl bash moreutils"
RUN apk upgrade --no-cache && \
    [ -n "${EXTRA_PACKAGES}" ] && apk add --no-cache ${EXTRA_PACKAGES} || true

COPY --from=builder /go/webhookd/release/webhookd /usr/bin/webhookd
COPY --from=builder /go/webhookd/scripts /scripts
COPY --from=builder /go/webhookd/etc/default/webhookd.env /etc/default/webhookd.env
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

VOLUME /scripts

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
