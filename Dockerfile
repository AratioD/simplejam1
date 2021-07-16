FROM node:latest

RUN apt-get update -y

WORKDIR app

COPY . .

CMD [ "npx", "netlify-cms-proxy-server", "-y"]

