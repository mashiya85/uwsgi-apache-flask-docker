FROM python:3.9-slim-bullseye

RUN set -x; \
        apt-get update; \
        apt-get install -y apache2 apache2-dev \
                libapache2-mod-wsgi-py3 \
        ; \
        rm -rf /var/lib/apt/lists/*

RUN set -x; \
        pip3 install --upgrade pip; \
        pip3 install flask

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
RUN echo "export LANG=C.UTF-8" >> /etc/apache2/envvars

COPY wsgi.conf /etc/apache2/sites-available/
RUN a2dissite 000-default && a2ensite wsgi

EXPOSE 80
CMD ["apachectl", "-DFOREGROUND"]
