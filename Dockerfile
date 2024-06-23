## build stage
FROM golang:1.20.0-bullseye as deploy-builder

WORKDIR /app

# module file copy
COPY go.mod go.sum ./
RUN go mod download

# application code copy
COPY . . 

RUN go build -trimpath -ldflags "-w -s" -o app

## deploy stage
FROM debian:buillseye-slim as deploy

RUN apt-get update

COPY --from=deploy-builder /app/app .

CMD ["./app"]

## dev stage
FROM golang:1.20.0 as dev
WORKDIR /app
RUN go install github.com/air-verse/air@latest
CMD ["air", "-c", "air.toml"]


