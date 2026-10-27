
FROM nginx:latest

COPY application/ /usr/share/nginx/html/

EXPOSE 80
