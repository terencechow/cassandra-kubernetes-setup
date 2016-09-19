#!/bin/bash
#
# Configure Cassandra seed nodes.

my_ip=$(hostname --ip-address)

CASSANDRA_SEEDS=$(host $PEER_DISCOVERY_SERVICE | \
    grep -v "not found" | \
    grep -v $my_ip | \
    sort | \
    head -2 | xargs | \
    awk '{print $4}')

if [ ! -z "$CASSANDRA_SEEDS" ]; then
    export CASSANDRA_SEEDS
fi

if [ ! -z "$CASSANDRA_LISTEN_ADDRESS" ]; then
    export CASSANDRA_LISTEN_ADDRESS="$my_ip"
fi
if [ ! -z "$CASSANDRA_BROADCAST_ADDRESS" ]; then
    export CASSANDRA_BROADCAST_ADDRESS="$my_ip"
fi
if [ ! -z "$CASSANDRA_BROADCAST_RPC_ADDRESS" ]; then
    export CASSANDRA_BROADCAST_RPC_ADDRESS="$my_ip"
fi

set -e
CASSANDRA_YAML=etc/cassandra/cassandra.yaml
CASSANDRA_RPC_ADDRESS="${CASSANDRA_RPC_ADDRESS:-0.0.0.0}"
CASSANDRA_NUM_TOKENS="${CASSANDRA_NUM_TOKENS:-32}"
CASSANDRA_CLUSTER_NAME="${CASSANDRA_CLUSTER_NAME:='Test Cluster'}"
CASSANDRA_LISTEN_ADDRESS=${CASSANDRA_LISTEN_ADDRESS}
CASSANDRA_BROADCAST_ADDRESS=${CASSANDRA_BROADCAST_ADDRESS}
CASSANDRA_BROADCAST_RPC_ADDRESS=${CASSANDRA_BROADCAST_RPC_ADDRESS}

for yaml in \
  broadcast_address \
	broadcast_rpc_address \
	cluster_name \
	listen_address \
	num_tokens \
	rpc_address \
  seeds \
; do
  var="CASSANDRA_${yaml^^}"
	val="${!var}"
	if [ "$val" ]; then
    echo "updating ${yaml} with ${val}"
		sed -ri 's/^(# )?([ ]*- )?('"$yaml"':).*/\2\3 '"$val"'/' "$CASSANDRA_YAML"
    # sed -Ei "" 's/^(# )?([ ]*- )?('"$yaml"':).*/\2\3 '"$val"'/' "$CASSANDRA_YAML"
	fi
done


CASSANDRA_RACKDC_PROPERTIES=etc/cassandra/cassandra-rackdc.properties
CASSANDRA_DC=${CASSANDRA_DC}
CASSANDRA_RACK=${CASSANDRA_RACK}
CASSANDRA_DC_SUFFIX=${CASSANDRA_DC_SUFFIX}
CASSANDRA_PREFER_LOCAL=${CASSANDRA_PREFER_LOCAL}

for yaml in \
  dc \
	rack \
	dc_suffix \
  prefer_local \
; do
  var="CASSANDRA_${yaml^^}"
	val="${!var}"
	if [ "$val" ]; then
    echo "updating ${key} with ${val}"
		# sed -Ei "" "s/^(#)?( )?(${key}=.*)/${key}=${sub}/" "$CASSANDRA_RACKDC_PROPERTIES"
    sed -ri "s/^(#)?( )?(${yaml}=.*)/${yaml}=${val}/" "$CASSANDRA_RACKDC_PROPERTIES"
	fi
done

/docker-entrypoint.sh "$@"
