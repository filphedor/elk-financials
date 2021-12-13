FROM ubuntu:18.04 AS java

USER root

RUN apt-get update && apt-get -y install \
    gnupg2 \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 449 dockeruser && \
    useradd -r -m -u 449 -g dockeruser dockeruser

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

RUN apt-get install -y apt-transport-https

RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

RUN apt-get update && apt-get -y install filebeat

RUN mkdir /home/dockeruser/conf

COPY ./amex.yml  /home/dockeruser/conf/filebeat.yml

ENTRYPOINT [ "filebeat", "-e", "-strict.perms=false", "-c", "/home/dockeruser/conf/filebeat.yml"]
