FROM golang:1.14.2-buster as builder

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=arm
ENV GOARM=7
ENV GO111MODULE=auto

RUN apt update -y \
    && apt install -y git ca-certificates tzdata \
    && update-ca-certificates

RUN useradd -M appuser

RUN git clone https://github.com/nlamirault/speedtest_exporter /go/src/app

WORKDIR ${GOPATH}/src/app

RUN go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/speedtest_exporter

# --------------------------------------------------------------------------------

FROM gcr.io/distroless/base

LABEL summary="Speedtest Exporter - ARM Version" \
      description="ARM Image for the Prometheus speedtest_exporter" \
      name="shrunbr/speedtest-exporter-arm" \
      url="https://github.com/shrunbr/speedtest-exporter-arm" \
      maintainer="<cthulhu@cthu.io>"

COPY --from=builder /go/bin/speedtest_exporter /usr/bin/speedtest_exporter

COPY --from=builder /etc/passwd /etc/passwd

EXPOSE 9112

ENTRYPOINT [ "/usr/bin/speedtest_exporter" ]