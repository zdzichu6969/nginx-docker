# Pull base image.
FROM debian:jessie

# Install Nginx.
RUN \
  echo "System update..." && \
  apt update -yqqq: && \
  echo "Dependencies install" && \
  apt-get install dpkg-dev build-essential zlib1g-dev \
  libpcre3 libpcre3-dev unzip curl libcurl4-openssl-dev libossp-uuid-dev \
  nano curl git autotools-dev debhelper dh-systemd libexpat-dev libgd-dev \
  libgeoip-dev libluajit-5.1-dev liblua5.1-0-dev libmhash-dev libpam0g-dev \
  libperl-dev libxslt1-dev po-debconf libssl-dev python init-system-helpers -yqqq && \
  rm -rf ngi* && \

  echo "Build..." && \
  curl http://repo.linuxiarz.pl/NGINX-1.10.1-custom.tar.gz | tar xz && \
  cd nginx*; dpkg-buildpackage -b >> /dev/null && \
  cd .. ; dpkg -i nginx-common_1.*.deb nginx_1.*.deb nginx-extras_1.*.deb nginx-doc_1.*.deb && \

  chown -R www-data:www-data /var/www/html

# Define mountable directories.
VOLUME ["/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443
