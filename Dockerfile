FROM node:14
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
ENV CONFIG_DIR=/config
ENV DOCKER_ENV=true
COPY tsconfig.json tsconfig.json
COPY src src
RUN npm run build
RUN npm link

RUN apt-get update && apt-get -y install cron
COPY cronsearch /etc/cron.d/cronsearch
RUN chmod 0644 /etc/cron.d/cronsearch
RUN crontab /etc/cron.d/cronsearch
RUN touch /var/log/cron.log

COPY init.sh /
RUN chmod +x /init.sh
EXPOSE 2468
ENTRYPOINT ["/init.sh"]
