FROM node:latest

RUN apt-get update -y

WORKDIR /src

CMD [ "npx", "netlify-cms-proxy-server", "-y"]

