FROM alpine
RUN apk add nodejs-current npm redis redis-openrc
COPY . .
RUN npm i
RUN chmod +x run.sh
ENTRYPOINT ./run.sh
EXPOSE 4096