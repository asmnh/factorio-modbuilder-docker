FROM alpine:latest

RUN apk add --no-cache ca-certificates

RUN apk add --no-cache python3 && \
    apk add --no-cache zip && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

ENV MOD_NAME=test_mod
ENV MOD_VERSION=0.1.0
ENV BUILD_ZIP=

RUN mkdir /code /build /target
WORKDIR /build
ADD src /build/
VOLUME /code /target
RUN chmod +x /build/build.sh
CMD /build/build.sh