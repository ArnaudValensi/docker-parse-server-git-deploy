FROM node:latest

RUN apt-get update && apt-get install -y \
  openssh-server

# Uncomment if you want to enable password login
#RUN echo 'root:myPasswordHere' | chpasswd
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

ENV PARSE_HOME /parse
ENV PARSE_CLOUD /parse/parse-cloud

ADD start.sh ${PARSE_HOME}/start.sh
ADD index.js ${PARSE_HOME}/index.js
ADD package.json ${PARSE_HOME}/package.json

COPY parse-cloud $PARSE_CLOUD

RUN chmod +x ${PARSE_HOME}/start.sh

WORKDIR $PARSE_HOME
RUN npm install

## ENV
#ENV APP_ID myAppId
#ENV MASTER_KEY myMasterKey
#ENV DATABASE_URI mongodb://localhost:27017/dev
#ENV CLOUD_HOME ${PARSE_CLOUD}/parse-cloud
#ENV PARSE_MOUNT /parse
#ENV COLLECTION_PREFIX
#ENV CLIENT_KEY
#ENV REST_API_KEY
#ENV DOTNET_KEY
#ENV JAVASCRIPT_KEY
#ENV DOTNET_KEY
#ENV FILE_KEY
#ENV FACEBOOK_APP_IDS "xx,xxx"

ENV PARSE_PORT 1337

EXPOSE $PARSE_PORT

VOLUME $PARSE_CLOUD
ENV NODE_PATH .

CMD ["sh", "-c", "${PARSE_HOME}/start.sh"]
