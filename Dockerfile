FROM nethost/alpine:latest

MAINTAINER billgo <cocobill@vip.qq.com>

RUN addgroup -S redis && adduser -S -G redis redis

RUN apk update && apk upgrade && apk add --no-cache 'su-exec>=0.2'

ENV REDIS_VERSION 4.0.2
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-4.0.2.tar.gz
ENV REDIS_DOWNLOAD_SHA b1a0915dbc91b979d06df1977fe594c3fa9b189f1f3d38743a2948c9f7634813

RUN set -ex; \
  \
  apk add --no-cache wget --virtual .build-deps \
    coreutils \
    gcc \
    linux-headers \
    make \
    musl-dev \
  ; \
  \
  wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL"; \
  echo "$REDIS_DOWNLOAD_SHA *redis.tar.gz" | sha256sum -c -; \
  mkdir -p /usr/src/redis; \
  tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1; \
  rm redis.tar.gz; \
  \
  grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' /usr/src/redis/src/server.h; \
  sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' /usr/src/redis/src/server.h; \
  grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' /usr/src/redis/src/server.h; \
  \
  make -C /usr/src/redis -j "$(nproc)"; \
  make -C /usr/src/redis install; \
  \
  rm -r /usr/src/redis; \
  \
  apk del .build-deps

RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]