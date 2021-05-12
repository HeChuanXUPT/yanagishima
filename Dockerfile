FROM openjdk:11.0.5-jdk

MAINTAINER tinyshrimp@163.com

COPY . /tmp/yanagishima

ENV YANAGISHIMA_HOME /opt/yanagishima
ENV TMP_PATH /tmp/yanagishima

# install node
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs build-essential

# deply yanagishima
RUN cd $TMP_PATH/web && npm install node-sass popper.js

RUN cd $TMP_PATH && ./gradlew build -x test && \
    cd build/distributions && \
    unzip -d /opt yanagishima.zip && \
    rm -rf $TMP_PATH

WORKDIR $YANAGISHIMA_HOME

CMD bin/yanagishima-run.sh
