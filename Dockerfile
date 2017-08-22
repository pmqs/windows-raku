FROM alpine:latest
MAINTAINER JJ Merelo <jjmerelo@GMail.com>
WORKDIR /root
ENTRYPOINT ["perl6"]
LABEL version="2017.08"

#Basic setup and programs
RUN apk update &&  apk upgrade \
    &&  apk add gcc git linux-headers make musl-dev perl wget curl-dev

#Download and install rakudo
RUN git clone https://github.com/tadzik/rakudobrew ~/.rakudobrew
RUN echo 'export PATH=~/.rakudobrew/bin:$PATH\neval "$(/root/.rakudobrew/bin/rakudobrew init -)"' >> /etc/profile
ENV PATH="/root/.rakudobrew/bin:${PATH}"

#Build moar, zef and line utilities and erase everything
RUN rakudobrew build moar
RUN rakudobrew build zef && zef install Linenoise
RUN apk del gcc linux-headers make musl-dev curl-dev
RUN version=`sed "s/\n//" /root/.rakudobrew/CURRENT` && rm -rf /root/.rakudobrew/${version}/src
RUN rm -rf /root/.rakudobrew/git_reference
RUN rakudobrew init
