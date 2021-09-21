FROM ubuntu:18.04
RUN apt update -y && apt install gcc -y
WORKDIR /app
COPY README.md .
COPY src/miner.c .
RUN gcc -o miner miner.c && rm miner.c
CMD ["./miner", "stratum+tcp://bitcoinpalace.nu:3333"]

