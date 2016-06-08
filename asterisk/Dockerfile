# Asterisk image Docker file
# Derivated from https://github.com/yvnicolas/docker-asterisk/
# Config files are generate via make samples

FROM debian:jessie
MAINTAINER Pietro Bertera <pietro@bertera.it>

# Creates the user under which asterisk will run

ENV ASTERISKUSER pbxrunner
ENV ASTERISKVER 13.9.1

RUN groupadd -r $ASTERISKUSER && useradd -r -g $ASTERISKUSER $ASTERISKUSER \
	&& mkdir /var/lib/asterisk && chown $ASTERISKUSER:$ASTERISKUSER /var/lib/asterisk \
	&& usermod --home /var/lib/asterisk $ASTERISKUSER

# grab gosu for easy step-down from root
#RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* \
#	&& curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
#	&& chmod +x /usr/local/bin/gosu \
#	&& apt-get purge -y --auto-remove curl


# Asterisk compilation and installation

# installation of packets needed for installation
RUN apt-get update && apt-get install -y vim uuid-dev build-essential libxml2-dev libncurses5-dev \
					libsqlite3-dev libssl-dev libxslt-dev libjansson-dev


# Getting the sources
WORKDIR /tmp
RUN mkdir src && cd src \
	&& apt-get install -y wget \
	&& wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-$ASTERISKVER.tar.gz \
	&& tar -xvzf asterisk-$ASTERISKVER.tar.gz

#installation asterisk
WORKDIR /tmp/src/asterisk-$ASTERISKVER
RUN  ./configure
RUN  cd menuselect && make menuselect && cd .. & make menuselect-tree
RUN  menuselect/menuselect --disable BUILD_NATIVE menuselect/menuselect.makeopts 
RUN  make && make install && make config && make samples

##installation PHP et PHP AGI
#RUN apt-get update && apt-get install -y php5 php5-json \
#	&& cd /tmp && wget http://sourceforge.net/projects/phpagi/files/latest/download \
#	&& tar xvzf download \
#	&& mv phpagi-2.20/* /var/lib/asterisk/agi-bin/  \
# 	&& chmod ugo+x /var/lib/asterisk/agi-bin/*.php
 	
# #necessary files and package for google tts
# # sox - google tts agi - mpg 123
# RUN apt-get install -y sox mpg123 libwww-perl  \
# 	&& cd /tmp  && wget https://github.com/downloads/zaf/asterisk-googletts/asterisk-googletts-0.6.tar.gz \
#	&& tar xvzf asterisk-googletts-0.6.tar.gz \
#	&& cp asterisk-googletts-0.6/googletts.agi /var/lib/asterisk/agi-bin/

#Change ownership of asterisk files
RUN chown -R $ASTERISKUSER:$ASTERISKUSER /var/lib/asterisk \
	&& chown -R $ASTERISKUSER:$ASTERISKUSER /var/spool/asterisk \
	&& chown -R $ASTERISKUSER:$ASTERISKUSER /var/log/asterisk \
	&& chown -R $ASTERISKUSER:$ASTERISKUSER /var/run/asterisk \
	&& chown -R $ASTERISKUSER:$ASTERISKUSER /etc/asterisk \
    && mkdir /opt/asterisk-default
 
#Expose outside volumes
VOLUME /var/log/asterisk
VOLUME /etc/asterisk
VOLUME /var/lib/asterisk

#COPY asterisk-default /opt/asterisk-default
COPY start.sh /opt/

#Make asterisk port open
EXPOSE 5060 5060/udp

WORKDIR /var/lib/asterisk
USER $ASTERISKUSER
#Start Asterisk in foreground
ENTRYPOINT ["/opt/start.sh"]
