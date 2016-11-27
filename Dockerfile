FROM ubuntu:16.04

RUN apt update
RUN apt install -y \
    git \
    curl \
    zsh \
    nano \
    supervisor \
    nginx \
    php7.0 \
    php7.0-fpm \
    php7.0-cli \
    wget

RUN mkdir /run/php/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i "s/user = www-data/user = root/" /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -i "s/group = www-data/group = root/" /etc/php/7.0/fpm/pool.d/www.conf

# Supervisor conf
RUN echo "[supervisord]" >> /etc/supervisor/supervisord.conf
RUN echo "nodaemon = true" >> /etc/supervisor/supervisord.conf
RUN echo "user = root" >> /etc/supervisor/supervisord.conf

RUN echo "[program:php-fpm7.0]" >> /etc/supervisor/supervisord.conf
RUN echo "command = /usr/sbin/php-fpm7.0 -FR" >> /etc/supervisor/supervisord.conf
RUN echo "autostart = true" >> /etc/supervisor/supervisord.conf
RUN echo "autorestart = true" >> /etc/supervisor/supervisord.conf

RUN echo "[program:nginx]" >> /etc/supervisor/supervisord.conf
RUN echo "command = /usr/sbin/nginx" >> /etc/supervisor/supervisord.conf
RUN echo "autostart = true" >> /etc/supervisor/supervisord.conf
RUN echo "autorestart = true" >> /etc/supervisor/supervisord.conf


# Install Zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
RUN sed -i "s/robbyrussell/af-magic/" ~/.zshrc

CMD ["/usr/bin/supervisord"]