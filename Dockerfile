FROM clojure:lein-2.8.1

ARG DATOMIC_KEY
ARG EMAIL
ARG VERSION

ENV DATOMIC_KEY=${DATOMIC_KEY}

RUN wget --http-user=${EMAIL} --http-password=${DATOMIC_KEY} https://my.datomic.com/repo/com/datomic/datomic-pro/${VERSION}/datomic-pro-${VERSION}.zip -O /opt/datomic-pro.zip

WORKDIR /opt

RUN unzip datomic-pro.zip -d /opt \
  && rm -f datomic-pro.zip \
  && mv datomic-pro-* ./datomic-pro \
  && rm -rf datomic-pro/lib/console

WORKDIR /opt/datomic-pro

ADD configs/datomic/transactor.properties ./config/transactor.properties

EXPOSE 4334 4335 4336

CMD ["bash", "-c", "./bin/transactor -Ddatomic.txTimeoutMsec=60000 config/transactor.properties"]
