FROM occitech/magento:php5.5-apache

RUN cd /tmp && curl -O http://www.magentocommerce.com/downloads/assets/1.9.1.1/magento-1.9.1.1.tar.gz && tar xvf magento-1.9.1.1.tar.gz && mv magento/* magento/.htaccess /var/www/htdocs

RUN chown -R www-data:www-data /var/www/htdocs

RUN apt-get update
RUN apt-get install -y mysql-client-5.5
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

COPY ./bin/install-magento /usr/local/bin/install-magento

RUN chmod +x /usr/local/bin/install-magento

COPY ./sampledata/magento-sample-data-1.9.1.0.tgz /opt/
COPY ./bin/install-sampledata-1.9 /usr/local/bin/install-sampledata
RUN chmod +x /usr/local/bin/install-sampledata


# Install Wordpress

RUN docker-php-ext-install mysqli

ENV WORDPRESS_VERSION 4.2.2
ENV WORDPRESS_UPSTREAM_VERSION 4.2.2
ENV WORDPRESS_SHA1 d3a70d0f116e6afea5b850f793a81a97d2115039

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_UPSTREAM_VERSION}.tar.gz \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C /usr/src/ \
  && rm wordpress.tar.gz \
  && chown -R www-data:www-data /usr/src/wordpress

RUN mv /usr/src/wordpress /var/www/htdocs/wp
