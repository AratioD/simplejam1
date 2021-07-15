FROM node:latest

RUN apt-get update -y

CMD [ "npx", "netlify-cms-proxy-server", "-y"]

