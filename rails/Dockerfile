FROM ruby:3.2.3

# Instale dependências do sistema
RUN apt-get update -qq && \
apt-get install -y build-essential libpq-dev nodejs postgresql-client

# Configure o diretório de trabalho
WORKDIR /rails

# RUN rm -f /tmp/pids/server.pid

RUN gem install bundler

RUN gem install rails -v '7.2.0'

# Copie o Gemfile e o Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instale as gems
RUN bundle install

# Copie o restante dos arquivos da aplicação
COPY . .

# Configure o banco de dados e outras variáveis de ambiente
ENV RAILS_ENV=development
ENV RAILS_LOG_TO_STDOUT=true

# Exponha a porta que o Rails usa por padrão
EXPOSE 3000

# Comando para iniciar o servidor Rails
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && rails server -b 0.0.0.0 -p 3000"]