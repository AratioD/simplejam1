# Use Alpine Linux as our base image so that we minimize the overall size our final container, and minimize the surface area of packages that could be out of date.
FROM klakegg/hugo:0.83.1

WORKDIR /src

COPY . .

RUN rm -rf Dockerfile

CMD ["server", "-p", "8080"]

#docker run --rm -it -v $(pwd):/src -p 8080:8080 hugo_server_image server -p 8080

# docker run --rm -it -p 8080:8080 my_image_foo_bar:1.0.0
# volume mappaykset on pielessä...