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

## SSL

Generate [Postfix SMTP server EDH parameters][5] for improved security against pre-computation attacks:

```sh
openssl dhparam -out dh512.tmp 512 && mv dh512.tmp dh512.pem
openssl dhparam -out dh2048.tmp 2048 && mv dh2048.tmp dh2048.pem
```

Request SSL certificate from [Let's Encrypt][1] using [acme.sh][2] or any other tool, and save certificate as `cert.pem` and private key as `key.pem` in the root of the repository.

## Thanks

Some ideas where found and sometimes copied from the following projects:

* [Headers check][3] and [mail-in-a-box][4]
* [EDH parameters][5]
* [runit][6]
* [mail-in-a-box][4]

## Bug reports and pull requests

This is open source project. If you find a bug or have a suggestion, please open issue, or submit a pull request.


[1]: https://letsencrypt.org
[2]: https://github.com/Neilpang/acme.sh
[3]: https://major.io/2013/04/14/remove-sensitive-information-from-email-headers-with-postfix/
[4]: https://github.com/mail-in-a-box/mailinabox/blob/master/conf/postfix_outgoing_mail_header_filters
[5]: http://www.postfix.org/FORWARD_SECRECY_README.html
[6]: https://github.com/jessfraz/dockerfiles/blob/master/postfix/service/postfix/run
