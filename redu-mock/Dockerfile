# Use uma imagem oficial do Ruby como base
FROM ruby:3.0.3

# Instale as dependências do sistema necessárias para o seu aplicativo
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libpq-dev \
        nodejs

# Configure a pasta de trabalho para o aplicativo
WORKDIR /app

# Copie o arquivo Gemfile e o Gemfile.lock para a imagem
COPY Gemfile Gemfile.lock ./

# Instale as gems do Ruby necessárias para o aplicativo
RUN bundle install --jobs 4 --retry 3

# Copie o restante do aplicativo para a imagem
COPY . .

# Configure as variáveis de ambiente necessárias para o aplicativo
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

# Compile os assets
RUN bundle exec rake assets:precompile

# Inicie o servidor Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]