FROM node:dubnium
RUN \
    apt-get update -qq \
    && apt-get install -qy \
    libelf1 \
    python3 \
    python3-pip \
    python-pip \
    python-dev \
    gconf-service \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    fonts-liberation \
    libappindicator1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    apt-transport-https \
    && apt-get clean

# Install SBT
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk sbt

# Prepare SBT (warm cache)
RUN \
  sbt sbtVersion -Dsbt.rootdir=true && \
  mkdir -p project && \
  echo "sbt.version=1.2.8" > project/build.properties && \
  echo "case object Temp" > Temp.scala && \
  echo "scalaVersion := \"2.12.8\"" > build.sbt && \
  sbt compile -Dsbt.rootdir=true && \
  echo "scalaVersion := \"2.12.9\"" > build.sbt && \
  sbt compile -Dsbt.rootdir=true && \
  echo "scalaVersion := \"2.13.0\"" > build.sbt && \
  sbt compile -Dsbt.rootdir=true && \
  echo "scalaVersion := \"2.13.1\"" > build.sbt && \
  sbt compile -Dsbt.rootdir=true && \
  rm -r project && rm build.sbt && rm Temp.scala && rm -r target

# Install Python 3.7
RUN curl -O https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz
RUN tar -xf Python-3.7.3.tar.xz
RUN cd Python-3.7.3 && ./configure --enable-optimizations && make -j 4 && make altinstall

# Install AWS CLI
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk sbt    
RUN python3.7 -m pip install awscli --upgrade
RUN python3.7 -m pip install aws-sam-cli --upgrade
