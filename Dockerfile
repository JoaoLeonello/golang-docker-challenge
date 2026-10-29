FROM golang:1.23-alpine AS builder

WORKDIR /build
COPY go.mod full-cycle-rocks.go ./
# -s -w remove a tabela de símbolos e o DWARF, que não são usados em runtime
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o full-cycle-rocks .

FROM scratch

COPY --from=builder /build/full-cycle-rocks /full-cycle-rocks
ENTRYPOINT ["/full-cycle-rocks"]
