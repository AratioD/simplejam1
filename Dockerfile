FROM node:latest

# Update debian packages
RUN apt-get update -y
# Download wget
RUN apt-get install wget -y

#Define wanted hugo version
ENV HUGO=0.85.0

#Download tarbal
RUN wget https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_extended_${HUGO}_Linux-64bit.deb

# Install Hugo server
RUN dpkg -i hugo_extended_${HUGO}_Linux-64bit.deb

# Remove unnecessary HUGO
RUN rm hugo_extended_${HUGO}_Linux-64bit.deb

# Set of a working directory
WORKDIR /app

# Copy all stuff from your machine to workdirc
COPY . ./app

#NPM install all packages.
RUN npm install

#Run hugo server.
RUN hugo server -D --debug

# Run and install netlify-cms-proxy-server
RUN npx netlify-cms-proxy-server -y
