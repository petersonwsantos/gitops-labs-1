FROM node

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY .  .

ARG API_PORT
ARG API_DB

ENV PORT=6000
ENV DB="postgres://stone:stone@db/stone"

EXPOSE 6000

CMD ["npm", "start"]