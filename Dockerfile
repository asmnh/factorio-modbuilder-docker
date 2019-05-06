FROM python:3.6

ENV MOD_NAME=test_mod
ENV MOD_VERSION=0.1.0

RUN mkdir /code /build /target
WORKDIR /build
ADD src /build/
VOLUME /code /target
RUN chmod +x /build/build.sh
CMD /build/build.sh