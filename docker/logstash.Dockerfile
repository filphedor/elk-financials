FROM ubuntu:18.04

USER root

RUN apt-get update && apt-get -y install \
    gnupg2 \
    wget \
    unzip \
    openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 449 dockeruser && \
    useradd -r -m -u 449 -g dockeruser dockeruser

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

RUN apt-get install -y apt-transport-https

RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

RUN apt-get update && apt-get -y install logstash

COPY ./pipelines.yml  /etc/logstash/pipelines.yml

COPY .  /etc/logstash/conf.d

USER logstash

ENTRYPOINT [ "/usr/share/logstash/bin/logstash", "--path.settings=/etc/logstash" ]
