FROM nginx

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY build /usr/share/nginx/html
