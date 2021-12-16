FROM ghcr.io/losfair/blueboat-mds:v0.1.1-alpha.9

FROM ghcr.io/losfair/blueboat:v0.2.8-alpha.9

WORKDIR /root
COPY --from=0 /usr/bin/blueboat-mds /usr/bin/
RUN apt update && apt install -y wget xxd
RUN wget -O /usr/bin/minio https://dl.min.io/server/minio/release/linux-amd64/minio && chmod +x /usr/bin/minio \
  && wget https://s3.us-west-1.amazonaws.com/build-res.s3.univalent.net/foundationdb-clients_6.3.22-1_amd64.deb \
  && wget https://s3.us-west-1.amazonaws.com/build-res.s3.univalent.net/foundationdb-server_6.3.22-1_amd64.deb \
  && dpkg -i ./foundationdb-clients_6.3.22-1_amd64.deb ./foundationdb-server_6.3.22-1_amd64.deb \
  && rm ./foundationdb-clients_6.3.22-1_amd64.deb ./foundationdb-server_6.3.22-1_amd64.deb
COPY ./entrypoint.sh ./start_blueboat.sh ./mds.yaml ./fdbinit.sh /
ENTRYPOINT ["/entrypoint.sh"]
