FROM alpine:latest

RUN apk update && \
    apk add --no-cache \
    nano \
    curl \
    wget \
    git \
    unzip \
    bash \
    postgresql18-client

RUN echo '\pset border 2' > /root/.psqlrc && \
    echo '\pset linestyle unicode' >> /root/.psqlrc && \
    echo '\x auto' >> /root/.psqlrc

CMD ["/bin/bash"]

# docker build -t pg18-client .