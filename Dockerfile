# The base image is created on Debian
FROM ruby:2.4.1
MAINTAINER Daniel Hilgarth <d.hilgarth@sovarto.com>

RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/httpredir.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf

# From OTS instructions
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y ntp libyaml-dev libevent-dev zlib1g zlib1g-dev openssl libssl-dev libxml2 libreadline-gplv2-dev

# Setting up OTS
RUN groupadd -r ots && useradd -r -m -g ots ots
RUN mkdir -p /etc/onetime /var/log/onetime /var/run/onetime /var/lib/onetime 
RUN chown ots /etc/onetime /var/log/onetime /var/run/onetime /var/lib/onetime
ADD . /home/ots/onetime
RUN rm /home/ots/onetime/Dockerfile
RUN rm -rf /home/ots/onetime/.git
RUN rm /home/ots/onetime/docker-compose.yml
RUN cd /home/ots/onetime
RUN gem install bundler
RUN cd /home/ots/onetime && bundle install --frozen --deployment --without=dev
RUN cp -R /home/ots/onetime/etc/* /etc/onetime

EXPOSE 7143 

ENTRYPOINT echo $OTS_DOMAIN | xargs -I domurl sed -ir 's/:domain: $/:domain: domurl/g' /etc/onetime/config \
&& echo $OTS_HOST | xargs -I hosturl sed -ir 's/:host: $/:host: hosturl/g' /etc/onetime/config \
&& echo $OTS_SSL | xargs -I hostssl sed -ir 's/:ssl: $/:ssl: hostssl/g' /etc/onetime/config \
&& echo $REDIS_HOST | xargs -I redishost sed -ir 's/redis:\/\/redis:/redis:\/\/redishost:/g' /etc/onetime/config \
&& dd if=/dev/urandom bs=40 count=1 | openssl sha1 | grep stdin | awk '{print $2}' | xargs -I key sed -ir 's/:secret: $/:secret: key/g' /etc/onetime/config \
&& cd /home/ots/onetime/ \
&& bundle exec thin -e dev -R config.ru -p 7143 start
