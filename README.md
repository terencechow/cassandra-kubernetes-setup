This is largely based off the official cassandra repo and [this repo ](https://github.com/vyshane/cassandra-kubernetes).

I just wanted a more custom entrypoint script and to document the whole process.

Starting a Cassandra Cluster on Google Container Engine

1. Go to http://console.cloud.google.com
2. Create project -> `name-of-project`
3. `docker build .`
4. `docker images` -> record image-id-hash
5. `docker tag image-id-hash eu.gcr.io/name-of-project/name-of-my-image:version-number`
6. `gcloud docker push eu.gcr.io/name-of-project/name-of-my-image:version-number`
7. In `cassandra-replication-controller.yml` and `cassandra-daemonset.yml` add
`image:eu.gcr.io/name-of-project/name-of-my-image:version-number` under `containers:`
8. `gcloud container clusters create name-of-cluster -z name-of-zone -m name-of-machine`
9. `gcloud container clusters get-credentials name-of-cluster --zone name-of-zone --project name-of-project`
10. `kubectl create -f cassandra-peers.yml`
11. `kubectl create -f cassandra-service.yml`
<!-- 12. `kubectl create -f cassandra-replication-controller.yml` -->
12. `kubectl create -f cassandra-daemonset.yml`

It will take a couple of minutes for the services to discover each other.

When you create a keyspace, make sure you choose the proper datacenter name.
With GoogleCloudSnitch, the zone name is also the datacenter + rack name.

For example zone europe-west1-b has datacenter: 'europe-west1' and rack: 'b'

If you resize a container and want to maintain a 1 node per replica you will need to alter your keyspace and then run `nodetool repair` on affected nodes. `nodetool remove` can be used to remove downsized nodes that no longer exist.
