# placeholder
#  docker network create crit-net && \
#  docker run -d --name crit-db --network crit-net \
#    -e POSTGRES_USER=crit -e POSTGRES_PASSWORD=critpass -e POSTGRES_DB=crit_prod \
#    -v crit-pgdata:/var/lib/postgresql/data \
#    postgres:17-alpine && \
#  openssl rand -base64 64 | tr -d '\n' > ~/.crit-secret && \
#  docker run -d --name crit-web --network crit-net \
#    -e DATABASE_URL=ecto://crit:critpass@crit-db:5432/crit_prod \
#    -e SECRET_KEY_BASE="$(cat ~/.crit-secret)" \
#    -e SELFHOSTED=true \
#    -e PHX_HOST=localhost -e PHX_SERVER=true \
#    -e LOCAL_REGISTRATION_ENABLED=true \
#    -e START_GITHUB_STARS=false -e START_CHANGELOG=false \
#    -e ERL_AFLAGS="-kernel logger_level warning" \
#    -p 4000:4000 \
#    ghcr.io/tomasz-tomczyk/crit-web:latest
#
