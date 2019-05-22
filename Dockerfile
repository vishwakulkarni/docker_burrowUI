FROM node:8-alpine as builder

RUN mkdir -p /app
WORKDIR /app
#for git (no need to mention why)
RUN apk add --no-cache git
#for gcc executable(because Brrow need to run)
RUN apk add --no-cache git curl gcc libc-dev

RUN cd /app && git clone https://github.com/GeneralMills/BurrowUI.git


RUN cd /app/BurrowUI && npm install 
RUN cd /app/BurrowUI && npm install -g @angular/cli@6.1.1

RUN cd /app/BurrowUI && ng build --prod

FROM node:8-alpine

RUN mkdir -p /app/server /app/dist
WORKDIR /app

#for git (no need to mention why)
RUN apk add --no-cache git
#for gcc executable(because Brrow need to run)
RUN apk add --no-cache git curl gcc libc-dev

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

COPY --from=builder /app/BurrowUI/server.js /app/BurrowUI/package.json /app/
COPY --from=builder /app/BurrowUI/server /app/server
COPY --from=builder /app/BurrowUI/dist /app/dist
COPY ./setup.py /app
#ENV BURROW_URL="localhost"
RUN env
RUN python3 setup.py
RUN npm install --production

EXPOSE 3000

CMD python3 setup.py && node server

