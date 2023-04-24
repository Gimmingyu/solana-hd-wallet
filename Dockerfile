FROM golang:1.20-alpine as build
ENV TZ=Asia/Seoul
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

RUN apk update && apk add --no-cache bash cmake gcc git make protoc protobuf-dev

WORKDIR /home

COPY . /home/go/src/finexblock

WORKDIR /home/go/src/finexblock

RUN export GOROOT=/usr/local/go
RUN export GOPATH=$HOME/go
RUN export PATH=$PATH:$GOROOT/bin:/usr/local/bin:$GOPATH/bin

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
RUN go get "google.golang.org/protobuf/types/known/timestamppb"
RUN export PATH=$PATH:$(go env GOPATH)/bin

FROM build as release

WORKDIR /home/go/src/finexblock

RUN go mod download
RUN go mod vendor

RUN make build

FROM release as deploy

WORKDIR /home/go/src/finexblock

ENTRYPOINT ["build/appd"]

EXPOSE 8888 9736 6033 5888 50051 80 443