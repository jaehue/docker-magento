FROM occitech/magento:php5.5-apache

RUN apt-get update && apt-get install -y mysql-client-5.5 libxml2-dev
RUN docker-php-ext-install soap mysqli

VOLUME /var/www/htdocs/media
VOLUME /var/www/htdocs/wp/wp-content/uploads

# Install Magento
COPY ./files/magento-1.9.1.1.tar.gz /opt/
COPY ./files/magento-sample-data-1.9.1.0.tgz /opt/
COPY ./bin/install-magento /usr/local/bin/install-magento
COPY ./bin/install-sampledata-1.9 /usr/local/bin/install-sampledata
RUN chmod +x /usr/local/bin/install-magento
RUN chmod +x /usr/local/bin/install-sampledata
RUN tar -xzf /opt/magento-1.9.1.1.tar.gz -C /usr/src/ \
  && find /usr/src/magento -maxdepth 1 -mindepth 1 -not -name media -print0 | xargs -0 mv -t /var/www/htdocs \
  && mv /usr/src/magento/media/* /var/www/htdocs/media/ \  
  && chown -R www-data:www-data /var/www/htdocs \
  && rm -rf /usr/src/magento

# Install Wordpress
COPY ./files/wordpress-4.2.2.tar.gz /opt/
RUN tar -xzf /opt/wordpress-4.2.2.tar.gz -C /usr/src/ \
  && find /usr/src/wordpress -maxdepth 1 -mindepth 1 -not -name wp-content -print0 | xargs -0 mv -t /var/www/htdocs/wp \
  && mv /usr/src/wordpress/wp-content/* /var/www/htdocs/wp/wp-content/  \
  && rm -rf /usr/src/wordpress
