FROM golang:1.22-alpine AS build
WORKDIR /app

RUN apk add --no-cache git

RUN git clone https://github.com/cjpjxjx/MyUrls .

# RUN go env -w GO111MODULE=on
# RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go mod download
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o myurls

FROM scratch
WORKDIR /app
COPY --from=build /app/myurls ./
COPY --from=build /app/public ./public
EXPOSE 8080
ENTRYPOINT ["/app/myurls"]
