FROM node:21-alpine3.17 as node_build
WORKDIR /tmp_build

COPY package.json .
COPY yarn.lock .
RUN yarn install --no-progress --frozen-lockfile

COPY webpack.mix.js .
COPY src ./src
RUN yarn prod

FROM crystallang/crystal:1.10-alpine as lucky_build
ENV SKIP_LUCKY_TASK_PRECOMPILATION="1"
RUN apk add yaml-static
WORKDIR /tmp_build
COPY shard.* ./
RUN  shards install --production
COPY . .
COPY --from=node_build /tmp_build/public/mix-manifest.json public/mix-manifest.json
RUN crystal build --static src/start_server.cr
RUN crystal build --static tasks.cr -o run_task

FROM alpine

ARG PUID=1000
ARG PGID=1000

RUN addgroup -g ${PGID} -S lucky && \
    adduser -u ${PUID} -S lucky -G lucky
WORKDIR /home/lucky/app

COPY --chown=lucky:lucky --from=node_build /tmp_build/public public
COPY --chown=lucky:lucky --from=lucky_build /tmp_build/start_server start_server
COPY --chown=lucky:lucky --from=lucky_build /tmp_build/run_task run_task
COPY --chown=lucky:lucky ./script/docker_entrypoint ./

RUN mkdir ./config
RUN chown -R lucky /home/lucky
USER lucky

CMD ["/home/lucky/app/docker_entrypoint"]
