# stage 1 - build documents
FROM python:3.7-buster as docs

WORKDIR /app

RUN apt-get update && apt-get install -y \
  texlive-latex-recommended \
  texlive-latex-extra \
  texlive-fonts-recommended \
  latexmk

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY . ./
RUN make html && make latexpdf

# stage 2 - build backend
FROM golang:1.13-alpine as backend

WORKDIR /go/src/svdocs
RUN apk add --update --no-cache ca-certificates git
COPY go.mod ./
COPY main.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /go/bin/svdocs

# stage 3 - serve documents
FROM alpine

WORKDIR /root
COPY --from=docs /app/build ./build
COPY --from=backend /go/bin/svdocs .

EXPOSE 3215
ENTRYPOINT [ "./svdocs" ]
