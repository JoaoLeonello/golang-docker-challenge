FROM golang:1.16-alpine as BUILDER

RUN mkdir /build
ADD full-cycle-rocks.go /build/
WORKDIR /build
RUN go mod init full-cycle-rocks
RUN CGO_ENABLED=0 GOOS=linux go build -a -o full-cycle-rocks .

##### Stage 2 #####
FROM scratch

WORKDIR /app
COPY --from=BUILDER /build/full-cycle-rocks .
ENTRYPOINT ["./full-cycle-rocks"]