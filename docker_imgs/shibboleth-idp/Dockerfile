FROM ubuntu:16.04

LABEL idp.java.version="8.0.131" \
      idp.jetty.version="9.3.20.v20170531" \
      idp.version="3.3.1"

ENV JETTY_HOME=/opt/jetty-home \
    JETTY_BASE=/opt/shib-jetty-base \
    JETTY_MAX_HEAP=2048m \
    JETTY_BROWSER_SSL_KEYSTORE_PASSWORD=password \
    JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD=password \
    PATH=$PATH:$JRE_HOME/bin

RUN apt-get update -y  \
    && apt-get -y install wget tar \
    && apt-get -y clean all

RUN set -x; \
    java_version=8.0.131; \
    zulu_version=8.21.0.1; \
    java_hash=1931ed3beedee0b16fb7fd37e069b162; \
    jetty_version=9.3.20.v20170531; \
    jetty_hash=86143a285c90a02577fa1738b50a5e8b7a7d6a2a; \
    idp_version=3.3.1; \
    idp_hash=8bd852dcdc7e6729ee645c0374a3c476b152fa24506fb86ffec33dfd190e607c; \
    dta_hash=2f547074b06952b94c35631398f36746820a7697; \

    useradd jetty -U -s /bin/false \

# Download Java, verify the hash, and install \
    && cd / \
    && wget http://cdn.azul.com/zulu/bin/zulu$zulu_version-jdk$java_version-linux_x64.tar.gz \
    && echo "$java_hash  zulu$zulu_version-jdk$java_version-linux_x64.tar.gz" | md5sum -c - \
    && tar -zxvf zulu$zulu_version-jdk$java_version-linux_x64.tar.gz -C /opt \
    && rm zulu$zulu_version-jdk$java_version-linux_x64.tar.gz \
    && ln -s /opt/zulu$zulu_version-jdk$java_version-linux_x64/jre/ /opt/jre-home \

# Download Jetty, verify the hash, and install, initialize a new base \
    && cd / \
    && wget http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/$jetty_version/jetty-distribution-$jetty_version.tar.gz \
    && echo "$jetty_hash  jetty-distribution-$jetty_version.tar.gz" | sha1sum -c - \
    && tar -zxvf jetty-distribution-$jetty_version.tar.gz -C /opt \
    && rm jetty-distribution-$jetty_version.tar.gz \
    && ln -s /opt/jetty-distribution-$jetty_version/ /opt/jetty-home \

# Config Jetty \
    && cd / \
    && cp /opt/jetty-home/bin/jetty.sh /etc/init.d/jetty \
    && mkdir -p /opt/shib-jetty-base/modules /opt/shib-jetty-base/lib/ext /opt/shib-jetty-base/resources \
    && cd /opt/shib-jetty-base \
    && touch start.ini \
    && /opt/jre-home/bin/java -jar ../jetty-home/start.jar --add-to-startd=http,https,deploy,ext,annotations,jstl \

# Download Shibboleth IdP, verify the hash, and install \
    && cd / \
    && wget https://shibboleth.net/downloads/identity-provider/$idp_version/shibboleth-identity-provider-$idp_version.tar.gz \
    && echo "$idp_hash  shibboleth-identity-provider-$idp_version.tar.gz" | sha256sum -c - \
    && tar -zxvf  shibboleth-identity-provider-$idp_version.tar.gz -C /opt \
    && rm /shibboleth-identity-provider-$idp_version.tar.gz \
    && ln -s /opt/shibboleth-identity-provider-$idp_version/ /opt/shibboleth-idp \

# Download the library to allow SOAP Endpoints, verify the hash, and place \
    && cd / \
    && wget https://build.shibboleth.net/nexus/content/repositories/releases/net/shibboleth/utilities/jetty9/jetty9-dta-ssl/1.0.0/jetty9-dta-ssl-1.0.0.jar \
    && echo "$dta_hash  jetty9-dta-ssl-1.0.0.jar" | sha1sum -c - \
    && mv jetty9-dta-ssl-1.0.0.jar /opt/shib-jetty-base/lib/ext/ \

# Setting owner ownership and permissions on new items in this command
    && chown -R root:jetty /opt \
    && chmod -R 640 /opt \
    && chmod 750 /opt/jre-home/bin/java

COPY bin/ /usr/local/bin/
COPY opt/shib-jetty-base/ /opt/shib-jetty-base/
COPY opt/shibboleth-idp/ /opt/shibboleth-idp/

# Setting owner ownership and permissions on new items from the COPY command
RUN mkdir /opt/shib-jetty-base/logs \
    && chown -R root:jetty /opt/shib-jetty-base \
    && chmod -R 640 /opt/shib-jetty-base \
    && chmod -R 750 /opt/shibboleth-idp/bin \
    && chmod 750 /usr/local/bin/run-jetty.sh /usr/local/bin/init-idp.sh

# Opening 4443 (browser TLS), 8443 (mutual auth TLS)
EXPOSE 4443 8443

CMD ["run-jetty.sh"]
