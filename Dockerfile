FROM ubuntu:15.04

# variables
ENV logstash_directory="logstash"
ENV logstash_version="logstash-5.0.0"
ENV amazon_es_repo="https://github.com/awslabs/logstash-output-amazon_es.git"
ENV amazon_es_local="$HOME/dev/amazon_es"
ENV jsqs_repo="https://github.com/JamieCressey/logstash-input-jsqs"
ENV jsqs_local="$HOME/dev/jsqs"
ENV project_directory=""
ENV test_file=""

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 curl -sSL https://get.rvm.io | bash -s stable --ruby=jruby-9.1.10.0
RUN apt-get -y install oracle-java8-set-default  ruby-full git
RUN git clone -b 5.2 https://github.com/elastic/logstash.git
WORKDIR /${logstash_directory}

RUN gem install rake
RUN gem install bundler
RUN rake bootstrap
RUN rake test:install-core

# install prune plugin
RUN bin/logstash-plugin install logstash-filter-prune

# install kinesis plugin
RUN bin/logstash-plugin install logstash-input-kinesis

# Install Amazon Elasticsearch logstash plugin
RUN git clone "${amazon_es_repo}" "${amazon_es_local}"
RUN bin/logstash-plugin install logstash-output-amazon_es

# Install jsqs logstash plugin
RUN git clone "${jsqs_repo}" "${jsqs_local}"
RUN bin/logstash-plugin install logstash-input-jsqs

# install rspec
RUN bin/logstash-plugin install --development

# example copy test scripts from local to container
#COPY /pattern /etc/logstash/pattern
#COPY /filter ${project_directory}/filter
#COPY /test ${project_directory}/test
#COPY /${test_file} ${project_directory}

# example execute test. uncomment to run
#CMD ["/logstash/bin/rspec", "/logstash/${project_directory}/${test_file}"]
