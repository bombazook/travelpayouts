FROM ruby:2.7
ARG environment
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev lsb-release curl ca-certificates gnupg
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN sh -c 'curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -'
RUN apt-get update -qq && apt-get install -y postgresql-client-13
RUN bundle config --global frozen 1
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install
COPY . .
COPY "dockerfiles/$environment/entrypoint.sh" /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
