# Postfix in a docker container

There are many docker images available for postfix, but I could not fine one which will satisfy my needs. I've been using it for last year or so, so decided to release it publicly.

## Warning

This is open relay server, so do not host it on public interfaces.

## Why

If you have devices which can send notifications, but does not support SMTP authentication, or SMTP authentication is broken -- open relay can help. It will relay via another SMTP server. `Received` header will be hidden, so your internal network information won't leak.

## Usage

Modify `docker-compose.yml` with your settings. Then:

```sh
docker-compose up -d
```

Configure email client to send email via your local SMTP server.

## Thanks

* [Headers check](https://major.io/2013/04/14/remove-sensitive-information-from-email-headers-with-postfix/) and [mail-in-a-box](https://github.com/mail-in-a-box/mailinabox/blob/master/conf/postfix_outgoing_mail_header_filters)
* [DH](http://www.postfix.org/FORWARD_SECRECY_README.html)
* [runit](https://github.com/jessfraz/dockerfiles/blob/master/postfix/service/postfix/run)

## Bug reports and pull requests

This is open source project. If you find a bug or have a suggestion, please open issue, or submit a pull request.
