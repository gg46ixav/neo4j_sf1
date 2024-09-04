#!/bin/bash
cypher-shell -a bolt://localhost:7689 --format plain < /var/lib/neo4j/scripts/init.cypher
