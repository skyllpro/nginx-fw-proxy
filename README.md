# nginx-forward-proxy

## What is this?

The 'nginx-foward-proxy' is a so simple HTTP proxy server using the nginx.
You can easily build a HTTP proxy server using this.

## Try this container

### Requirement packages

- Docker

### How to use

```
$ sudo docker build -t alpine-nginx .
$ sudo docker run -d -p 8000:5678 --name nginx-fw-proxy -v ${PWD}/nginx.conf:/usr/local/nginx/conf/nginx.conf --restart=always alpine-nginx
$ curl -x http://127.0.0.1:8000 https://www.google.co.jp
```

## LICENSE

Apache 2.0
