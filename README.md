# Postfix in a docker container

There are many docker images available for postfix, but I could not fine one which will satisfy my needs. I've been using it for last year or so, so decided to release it publicly.

## Warning

If configured incorrectly, this can become an open relay SMTP server, so hosting it on public interfaces is not advisable.

## Why

If you have devices which can send notifications, but does not support SMTP authentication, or SMTP authentication is broken -- relay SMTP server can help. It will relay via upstream SMTP server. `Received` header will be hidden, so your internal network information won't leak.

## Usage

Modify `docker-compose.yml` with your settings. Then:

```sh
docker compose up -d
```

Configure email client to send email via your local SMTP server.

## SSL

Request SSL certificate from [Let's Encrypt][1] using [lego][2] or any other tool, and save certificate as `cert.pem` and private key as `key.pem` in the root of the repository.

## Thanks

Some ideas where found and sometimes copied from the following projects:

* [Headers check][3] and [mail-in-a-box][4]
* [runit][5]
* [mail-in-a-box][4]

## Bug reports and pull requests

This is open source project. If you find a bug or have a suggestion, please open issue, or submit a pull request.

[1]: https://letsencrypt.org
[2]: https://github.com/go-acme/lego
[3]: https://major.io/2013/04/14/remove-sensitive-information-from-email-headers-with-postfix/
[4]: https://github.com/mail-in-a-box/mailinabox/blob/master/conf/postfix_outgoing_mail_header_filters
[5]: https://github.com/jessfraz/dockerfiles/blob/master/postfix/service/postfix/run
