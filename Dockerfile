FROM alpine:3.14

ENV PLAN9=/usr/lib/9base

RUN apk add 9base --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
RUN apk add --update --no-cache curl lighttpd shadow discount && rm -rf /var/cache/apk/*
RUN curl http://werc.cat-v.org/download/werc-1.5.0.tar.gz | tar xzf - && mkdir -p /var/www/ && mv ../werc-*/ /var/www/werc
RUN cp -r /var/www/werc/sites/default.cat-v.org /var/www/werc/sites/localhost
RUN echo '# Hello World!' > /var/www/werc/sites/localhost/index.md
RUN sed -i 's/fltr_cache md2html\.awk/markdown/' /var/www/werc/etc/initrc
COPY etc/lighttpd/* /etc/lighttpd/
COPY start.sh /usr/local/bin/

RUN cp /usr/lib/9base/bin/rc /bin/rc
RUN cp /usr/lib/9base/bin/awk /bin/awk
ENV PATH="${PATH}:/usr/lib/9base/bin"

EXPOSE 80

VOLUME /var/www/werc/sites
VOLUME /var/www/localhost/htdocs
VOLUME /etc/lighttpd

RUN usermod -u 1000 lighttpd
RUN chown -R lighttpd:root /var/www

CMD [ "start.sh"]
