FROM nginx:alpine
COPY ./static-site /usr/share/nginx/html
EXPOSE 80
