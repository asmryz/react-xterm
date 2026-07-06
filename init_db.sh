#!/bin/bash
export PGPASSWORD=Aa20195@1

echo "Creating database 'evaluation'..."
docker run --rm --add-host=host.docker.internal:host-gateway -e PGPASSWORD=Aa20195@1 pg18-client psql -h host.docker.internal -U postgres -d postgres -c "CREATE DATABASE evaluation;" 2>/dev/null || echo "Database 'evaluation' already exists or could not be created."

echo "Applying schema from schema.sql..."
docker run --rm --add-host=host.docker.internal:host-gateway -i -e PGPASSWORD=Aa20195@1 pg18-client psql -h host.docker.internal -U postgres -d evaluation < schema.sql

echo "Database initialization complete!"
