FROM alpine:3.12

LABEL \
    maintainer="github@compuix.com" \
    version="2021.01.02" \
    description="SMTP relay server for local subnets."

RUN set -xe \
    && addgroup -g 587 postfix && adduser -D -H -h /etc/postfix -g postfix -u 587 -G postfix postfix \
    && addgroup -g 465 postdrop && adduser -D -H -h /var/mail/domains -g postdrop -u 465 -G postdrop vmail \
    && apk add --no-cache bash ca-certificates libsasl cyrus-sasl-plain cyrus-sasl-login postfix tzdata \
    && ln -sfn /usr/share/zoneinfo/America/New_York /etc/localtime \
    && touch /var/log/maillog \
    && postalias /etc/postfix/aliases \
    && sed -i -r -e 's/^#submission/submission/' /etc/postfix/master.cf \
    && chown root:root /var/spool/postfix /var/spool/postfix/pid

COPY ["header_checks", "/staging/header_checks"]
COPY ["run_postfix", "/"]

RUN	chmod +x /run_postfix

EXPOSE 25/tcp 587/tcp

STOPSIGNAL SIGKILL

ENTRYPOINT ["/run_postfix"]
