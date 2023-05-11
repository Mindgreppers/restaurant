FROM adminmindgrep/gs_service:latest AS appbuild
RUN mkdir /workspace/development/app && sudo  npm install -g @mindgrep/godspeed
WORKDIR /workspace/development/app
COPY --chown=node:node . .
RUN  npm install && godspeed prisma-push && godspeed build

FROM node:16.14.2-slim
RUN apt update && apt install cmake vim g++ -y && mkdir -p /usr/src/app && chown -R node:node /usr/src/app && rm -rf /var/cache/apt/* && rm -rf /var/log/apt
RUN mkdir -p /workspace/development/app && chown -R node:node /workspace
USER node
WORKDIR /workspace/development/app
COPY --chown=node:node --from=appbuild /workspace/development/gs_service .
RUN npm uninstall @hanazuki/node-jsonnet && npm install @hanazuki/node-jsonnet
CMD npm run start
