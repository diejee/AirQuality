FROM nginx:alpine
RUN apk add --no-cache curl
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir /files

COPY entrypoint.conf locations.include /files/

# COPY .htpasswd /etc/nginx/conf.d/.htpasswd

COPY *.sh /
RUN chmod 777 /*.sh
ENTRYPOINT /start.sh
