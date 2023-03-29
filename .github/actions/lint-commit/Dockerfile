FROM node:19.8.1-alpine3.17

RUN apk add --update-cache \
	git \
	openssh \
	&& rm -rf /var/cache/apk/*

RUN npm install -g @commitlint/cli@8.2.0

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
