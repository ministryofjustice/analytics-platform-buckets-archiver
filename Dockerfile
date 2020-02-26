FROM alpine:3.11.3

WORKDIR /usr/local/buckets-archiver

# Install awscli and jq
RUN apk add --no-cache python3 jq ca-certificates bash && \
    pip3 install -U pip && \
    pip3 install awscli

# create a user to run as
RUN addgroup -g 1000 -S archiver && \
    adduser -u 1000 -S archiver -G archiver

USER archiver

ADD buckets-archiver .

ENTRYPOINT [ "./buckets-archiver" ]
CMD ["help"]
