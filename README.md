# webhookd container image

## Documentation

See official documentation at https://github.com/ncarlier/webhookd

By default scripts are located in /scripts inside the container

## Example usage

```sh
podman run -it --rm \
    -v ./scripts:/scripts \
    -v ./htpasswd:/.htpasswd \
    -p 8080:8080 \
    quay.io/xbb/webhookd:latest
```

### CA certificates

If you need to trust any extra CA certificate mount it inside `/usr/local/share/ca-certificates/`, 
the entrypoint for this image will run `update-ca-certificates` on start if that directory is not empty.
