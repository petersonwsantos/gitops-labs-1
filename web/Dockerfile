FROM node

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

ENV PORT=5000
ENV API_HOST=http://api:6000

EXPOSE 5000

CMD [ "npm", "start" ]