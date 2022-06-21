# php-base

A simple dockerfile that adds most PHP extensions to run a Symfony application 2.3 -> 3.4.

The project path in the container is `/var/www` with the public folder `/var/www/web`

Runs a `appuser` / UID: `1000`


```shell
docker build . -t gcr.io/skil-196709/github.com/skilnet/php-base:8.1.7.0-fpm
docker push gcr.io/skil-196709/github.com/skilnet/php-base:8.1.7.0-fpm
```
