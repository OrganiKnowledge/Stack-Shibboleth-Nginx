#nginx img for shibboleth sp support
FROM ubuntu:16.04

#prerequisite
RUN apt-get update && apt-get install -y \
	build-essential \
    zlib1g-dev \
	libpcre3 \
	libpcre3-dev \
	unzip \
	openssl \
    && apt-get clean

RUN apt-get update && apt-get install -y \
	curl\
	tar
#download nginx and modules
ENV NGINX_BUILD_DIR /opt/nginx 
ENV NGINX_LOG_PATH /var/log/nginx
ENV NGINX_LIB_PATH /var/lib/nginx
ENV NGINX_VERSION 1.13.5
ENV HTTP_SHIBBOLETH_VERSION 2.0.1
ENV HEADERS_MORE_VERSION 0.32
ENV OPENSSL_VERSION 1.0.2l

RUN mkdir -p $NGINX_BUILD_DIR

RUN mkdir $NGINX_BUILD_DIR/http-shibboleth \
    && curl -SL https://github.com/nginx-shib/nginx-http-shibboleth/archive/v$HTTP_SHIBBOLETH_VERSION.tar.gz \
    | tar -xzC $NGINX_BUILD_DIR/http-shibboleth --strip 1

RUN mkdir $NGINX_BUILD_DIR/headers-more \
    && curl -SL https://github.com/openresty/headers-more-nginx-module/archive/v$HEADERS_MORE_VERSION.tar.gz \
    | tar -xzC $NGINX_BUILD_DIR/headers-more --strip 1

RUN mkdir $NGINX_BUILD_DIR/openssl \
    && curl -SL https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz \
    | tar -xzC $NGINX_BUILD_DIR/openssl --strip 1

RUN mkdir $NGINX_BUILD_DIR/nginx \
    && curl -SL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
    | tar -xzC $NGINX_BUILD_DIR/nginx --strip 1

#build nginx

WORKDIR $NGINX_BUILD_DIR/nginx

RUN ./configure \
	#third party modules
	--add-module=$NGINX_BUILD_DIR/http-shibboleth \
	--add-module=$NGINX_BUILD_DIR/headers-more \
	#core modules
	--with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' \
	--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' \
	--with-http_stub_status_module \
	--with-http_ssl_module \
	--with-openssl=/$NGINX_BUILD_DIR/openssl \
	--with-http_realip_module \
	--with-pcre-jit \
	--with-ipv6 \
	--prefix=/usr/local \
	--with-http_gzip_static_module \
	#path
	--error-log-path=/var/log/nginx/error.log \
	--conf-path=/etc/nginx/nginx.conf \
	--http-log-path=/var/log/nginx/access.log \
	--lock-path=/var/lock/nginx.lock  \
	--pid-path=/run/nginx.pid \
	#temp path
	--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
	--http-client-body-temp-path=/var/lib/nginx/body \
	--http-scgi-temp-path=/var/lib/nginx/scgi \
	--http-proxy-temp-path=/var/lib/nginx/proxy \
	--http-uwsgi-temp-path=/var/lib/nginx/uwsgi 

RUN make && make install \
    chdir=$NGINX_BUILD_DIR/nginx

RUN mkdir -p {/etc/nginx/{sites-available,sites-enabled}, /var/lib/nginx/body}
 
COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /

CMD /usr/local/sbin/nginx -g 'daemon off;'