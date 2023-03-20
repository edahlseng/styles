FROM alpine:3.17.2

RUN apk add --update-cache \
	bash \
	findutils \
	clang-extra-tools \
	&& rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
