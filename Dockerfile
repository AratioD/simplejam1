FROM node:latest

# Update debian packages
RUN apt-get update -y
# Download wget
RUN apt-get install wget -y

#Define wanted hugo version
HUGO_VERSION="0.85.0"

#Download tarbal
RUN wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb

# Install Hugo server
RUN dpkg -i hugo_extended_${HUGO_VERSION}_Linux-64bit.deb

# Remove unnecessary HUGO
RUN rm hugo_extended_${HUGO_VERSION}_Linux-64bit.deb

# Set of a working directory
WORKDIR /app

# Copy all stuff from your machine to workdirc
COPY . .

#Run hugo server.
RUN hugo server -D

# Run and install netlify-cms-proxy-server
RUN npx netlify-cms-proxy-server -y
## Install npx in ubuntu
#RUN npm i npx -y
#ARG HUGO_VERSION="0.82.1"
#RUN wget --quiet "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
#    tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
#    rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
#    mv hugo /usr/bin
#
#COPY ./ /site
#WORKDIR /site
#RUN hugo
#
##Copy static files to Nginx
#FROM nginx:alpine
#COPY --from=build /site/public /usr/share/nginx/html
#
#WORKDIR /usr/share/nginx/html