# # entrypoint.sh

# #!/bin/bash
# # Docker entrypoint script.

# # Wait until Postgres is ready
# # while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
# # do
# #   echo "$(date) - waiting for database to start"
# #   sleep 2
# # done

# # # Create, migrate, and seed database if it doesn't exist.
# # if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
# #   echo "Database $PGDATABASE does not exist. Creating..."
# #   createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
# #   mix ecto.migrate
# #   mix run priv/repo/seeds.exs
# #   echo "Database $PGDATABASE created."
# # fi

command=$1
if [ -n "$command" ]
then
    echo "Starting $command"
    case $command in
       "server")
            ls
	        iex -S mix
       ;;
    esac
else
    echo "Command parameter cannot be empty. Possible options are fullsync or deltasync or server"
fi