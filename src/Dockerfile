FROM node:current-alpine

RUN apk --no-cache add bash
RUN npm install -g json-server

EXPOSE 8000

COPY routes.json db.json /

ADD run.sh /run.sh
ENTRYPOINT ["bash", "/run.sh"]
CMD []
