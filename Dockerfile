#for deploying in prod, it becomes a two step process of generating build files and then hosting them using nginx
###Build Stage using npm run build
FROM node:alpine AS build-stage

WORKDIR /app

COPY package.json .

RUN npm install

#No need to use volumes in prod env since we are not changing files here like in dev env
COPY . .

RUN npm run build

###Build phase end

#this new FROM statement terminates previous build-stage block
#Always use exact versions instead of changing ones like 'latest' in PROD
#FROM nginx also starts nginx so no need to start it explicitly
FROM nginx:1.19.1

COPY --from=build-stage /app/build /usr/share/nginx/html

#After this just build this image and run it with port bindings.. default nginx port is 80