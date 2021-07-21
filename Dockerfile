FROM ruby:2.6.3
ENV BUNDLER_VERSION=2.0.2


RUN apt-get update
RUN apt-get install -yqq \
      default-libmysqlclient-dev \
      libcurl4-openssl-dev \
      build-essential \
      nodejs \
      bash \
      default-mysql-client \
      libcurl3-dev \
      openssh-client

RUN useradd -m user
RUN mkdir -p /home/user/.ssh
RUN chown -R user:user /home/user/.ssh
RUN echo "Host *.trabe.io\n\tStrictHostKeyChecking no\n" >> /home/user/.ssh/config
USER user
CMD ["/bin/bash"]

RUN gem install bundler -v 2.0.2


WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY . ./

#RUN ["chmod", "+x", "./entrypoints/docker-entrypoint.sh"]
#RUN ["chmod", "+x", "./entrypoints/sidekiq-entrypoint.sh"]

