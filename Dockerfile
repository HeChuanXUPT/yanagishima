FROM openjdk:11.0.5-jdk

MAINTAINER tinyshrimp@163.com

COPY . /tmp/yanagishima

ENV VERSION 22.0
ENV YANAGISHIMA_HOME /opt/yanagishima
ENV YANAGISHIMA_OPTS -Xmx3G
ENV TMP_PATH /tmp/yanagishima

# install node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs build-essential

# deply yanagishima
RUN cd $TMP_PATH && git checkout -b 22.0 refs/tags/22.0 -f

RUN cd $TMP_PATH/web && npm install node-sass popper.js

RUN cd $TMP_PATH && ./gradlew distZip && \
    cd build/distributions && \
    unzip yanagishima-$VERSION.zip && \
    rm -rf yanagishima-$VERSION.zip && \
    mv yanagishima-$VERSION /opt/ && \
    cd /opt && mv yanagishima-$VERSION yanagishima && \
    cd $YANAGISHIMA_HOME && \
    sed -i 's/"$@" &/"$@"/g' bin/yanagishima-start.sh && \
    rm -rf /tmp/yanagishima

WORKDIR /opt/yanagishima

CMD bin/yanagishima-start.sh
