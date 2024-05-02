FROM tarantool/tarantool:latest

RUN apt-get update && apt-get install -y unzip git cmake protobuf-compiler

RUN tt rocks install expirationd

CMD ["tarantool"]

