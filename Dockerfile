# Pull base image.
FROM java:8-jdk

ENV ES_VERSION=5.6.0
ENV ES_DIR=/usr/share

#ADD https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ES_VERSION/elasticsearch-$ES_VERSION.tar.gz /tmp/es.tgz
COPY ./elasticsearch-$ES_VERSION.tar.gz /tmp/es.tgz
RUN cd $ES_DIR && \  
  tar xvf /tmp/es.tgz   && \
  rm /tmp/es.tgz

RUN mv $ES_DIR/elasticsearch-$ES_VERSION $ES_DIR/elasticsearch

ENV ES_HOME=$ES_DIR/elasticsearch \
    OPTS=-Dnetwork.host=_non_loopback_ \
    DEFAULT_ES_USER=elsearch

#RUN $ES_HOME/bin/plugin install mobz/elasticsearch-head

COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

WORKDIR $ES_HOME

RUN groupadd elsearch
RUN useradd elsearch -g elsearch -p elasticsearch
RUN chown -R elsearch:elsearch  $ES_HOME

#RUN echo "network.host: 0.0.0.0" >> $ES_HOME/config/elasticsearch.yml
#RUN echo "index.query.bool.max_clause_count: 16384" >> $ES_HOME/config/elasticsearch.yml
#RUN echo "index.max_result_window: 2147483647" >> $ES_HOME/config/elasticsearch.yml

# setting max memory  for es 
ENV MAX_MAP_COUNT 262144


EXPOSE 9200 9300

USER elsearch 

ENTRYPOINT ["/usr/share/elasticsearch/bin/elasticsearch" ] 
