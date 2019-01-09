FROM golang:1.11.4-alpine AS builder

RUN apk add --no-cache ca-certificates git make gcc libc-dev
WORKDIR /go/src/github.com/apex/apex

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on

COPY ./go.mod ./go.sum ./
RUN go mod download

COPY ./ ./

RUN make local

FROM alpine AS runtime

RUN apk add --no-cache ca-certificates
COPY --from=builder /go/bin/apex /bin/apex

ENTRYPOINT ["/bin/apex"]
