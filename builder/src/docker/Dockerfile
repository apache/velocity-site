FROM ubuntu:18.04

MAINTAINER Claude Brisson

RUN apt-get update
RUN apt-get -y install python2.7 python-pip subversion
RUN apt-get -y install git libyaml-libyaml-perl libtimedate-perl libwww-perl xsltproc
RUN apt-get clean

# latest 2.6.x is 2.6.11, but it seems to break codehilite
RUN pip install Markdown==2.6.7

# install the pygments version we know works well with our markdown version
RUN pip install Pygments==2.2.0

WORKDIR /home/builder

COPY build.sh .
RUN svn checkout https://svn.apache.org/repos/infra/websites/cms
RUN sed -ri 's|#!/usr/local/bin/python|#!/usr/bin/python|' cms/build/markdownd.py

CMD /home/builder/build.sh

