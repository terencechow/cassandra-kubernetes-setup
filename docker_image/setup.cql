// Run the below commands to setup the cql tables.
// in production use NetworkToplogyStrategy and use a network aware snitch,
// and define data center names and replication factors for each data center
// ie CREATE KEYSPACE "Excalibur" WITH REPLICATION = {'class' : 'NetworkTopologyStrategy', 'dc1' : 3, 'dc2' : 2};


CREATE KEYSPACE MyCassandaBackend WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'europe-west1' : 6 };

USE MyCassandaBackend;

CREATE TABLE users(
	id uuid,
	name text,
	email text,
	hash text,
	session_key text,
	PRIMARY KEY(id));
