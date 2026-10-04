FROM cgr.dev/chainguard/go@sha256:4d9e412855426b433e29d0f676a3cca90bc94ba809b67b0edf267186a8cd7774 AS builder

ARG VERSION=dev

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w -X skillguard/cmd.Version=${VERSION}" -o skillguard .

FROM cgr.dev/chainguard/static@sha256:bf639cba19ba56329e6907ac26a7afcdde57a80b6aa66d5100da6883196e6b82

COPY --from=builder /app/skillguard /skillguard

USER nonroot

ENTRYPOINT ["/skillguard"]
