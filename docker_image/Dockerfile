FROM cassandra:3.7
COPY custom-entrypoint.sh /
RUN mkdir /scripts && \
  mkdir -p /cassandra_data/data && \
  apt-get -qq update && \
  DEBIAN_FRONTEND=noninteractive apt-get -yq install dnsutils && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  chmod +x /custom-entrypoint.sh
  # && \
  # mv /cassandra.yaml /etc/cassandra/ && \
  # rm -rf
  #       /var/lib/apt/lists/* \
  #       /var/cache/debconf/* \
  #       common-licenses \
  #       ~/.bashrc \
  #       /lib/lsb \
  #       /lib/udev \
  #       /usr/share/doc/ \
  #       /usr/share/doc-base/ \
  #       /usr/share/man/ \
  #       /tmp/*
VOLUME ["/cassandra_data/data"]
EXPOSE 7000 7001 7199 9042
ADD setup.cql /scripts/setup.cql
ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["cassandra", "-f"]
