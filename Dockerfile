FROM alpine:3.22.0

LABEL \
    maintainer="github@compuix.com" \
    version="2025.05.31" \
    description="SMTP relay server for local subnets."

#checkov:skip=CKV_DOCKER_3: "Ensure that a user for the container has been created"
# Let's Encrypt Certiciates - https://letsencrypt.org/certificates/

RUN set -xe \
    && addgroup -g 587 postfix && adduser -D -H -h /etc/postfix -g postfix -u 587 -G postfix postfix \
    && addgroup -g 465 postdrop && adduser -D -H -h /var/mail/domains -g postdrop -u 465 -G postdrop vmail \
    && apk add --no-cache bash ca-certificates libsasl cyrus-sasl-login postfix tzdata openssl \
    && ln -sfn /usr/share/zoneinfo/America/New_York /etc/localtime \
    && touch /var/log/maillog \
    && postalias /etc/postfix/aliases \
    && sed -i -r -e 's/^#submission/submission/' /etc/postfix/master.cf \
    && chown root:root /var/spool/postfix /var/spool/postfix/pid \
    && wget -q -P /usr/local/share/ca-certificates/ \
    https://letsencrypt.org/certs/2024/e5.pem \
    https://letsencrypt.org/certs/2024/e5-cross.pem \
    https://letsencrypt.org/certs/2024/e6.pem \
    https://letsencrypt.org/certs/2024/e6-cross.pem \
    https://letsencrypt.org/certs/2024/r10.pem \
    https://letsencrypt.org/certs/2024/r11.pem \
    && update-ca-certificates

COPY ["header_checks", "/staging/header_checks"]
COPY ["run_postfix", "healthcheck", "/"]

RUN	chmod +x /run_postfix /healthcheck

EXPOSE 25/tcp 587/tcp

STOPSIGNAL SIGKILL

ENTRYPOINT ["/run_postfix"]

HEALTHCHECK --start-period=10s --interval=60s --timeout=30s --retries=3 CMD [ "/healthcheck" ]
