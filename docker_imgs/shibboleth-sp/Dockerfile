#docker shibboleth-sp 
FROM ubuntu:16.04

RUN apt-get update 

RUN apt-get install -y \
    ntp \
    sudo \
    curl \
    zip 

RUN curl -O http://pkg.switch.ch/switchaai/SWITCHaai-swdistrib.asc

RUN gpg --with-fingerprint SWITCHaai-swdistrib.asc 
    
RUN apt-key add SWITCHaai-swdistrib.asc

RUN echo "deb http://pkg.switch.ch/switchaai/ubuntu xenial main" \
    > /etc/apt/sources.list.d/switchaai.list

RUN apt-get update && apt-get install shibboleth -y
 
RUN apt-get update && apt-get install supervisor -y

COPY shib.conf /etc/supervisor/conf.d/shib.conf

COPY shibboleth2.xml /etc/shibboleth/shibboleth2.xml

#RUN echo "#!/bin/bash\nbash -c \"$@\" \nservice shibd start -F\n" > /startup.sh
#RUN chmod a+x /startup.sh 

#ENTRYPOINT ["/startup.sh"]
#CMD service shibd start -F 
#CMD bash

RUN mkdir -p '/var/run/shibboleth' \
    && chown -Rh _shibd '/var/run/shibboleth' '/var/log/shibboleth'

COPY keygen.sh /etc/shibboleth/keygen.sh

RUN chmod u+x /etc/shibboleth/keygen.sh 

RUN /etc/shibboleth/keygen.sh -h example.com -y 2017 -e bob -b 

CMD /usr/sbin/shibd -f -F -c /etc/shibboleth/shibboleth2.xml \
-p /var/run/shibboleth/shibd.pid -w 30