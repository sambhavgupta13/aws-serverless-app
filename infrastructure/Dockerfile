#### UI build Stage
FROM 189731456380.dkr.ecr.us-east-1.amazonaws.com/base-ecr-repository:latest as ui-build


# make the '/usr/src/app' folder the current working directory
WORKDIR /usr/src/app

#copy frontend files and folders to '/frontend' folder
COPY frontend/ ./frontend/

#### Server build Stage
FROM 189731456380.dkr.ecr.us-east-1.amazonaws.com/base-ecr-repository:latest as server-build


# make the '/usr/src/app' folder the current working directory
WORKDIR /root/

# copy 'frontend/dist' folder from 'ui-build' to current working directory
COPY --from=ui-build /usr/src/app/frontend/dist ./frontend/dist

# copy both 'package.json' and 'package-lock.json' to '/server' folder
COPY server/package*.json ./server/

# install backend dependencies
RUN cd server && npm install

#copy server files and folders to '/server' folder
COPY server/ ./server/

EXPOSE 7000

CMD ["node", "./server/index.js"]