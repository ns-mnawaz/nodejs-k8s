# Install pm2
FROM keymetrics/pm2:latest-alpine

# create and set app directory
RUN mkdir -p /app/
# Set the workdir
WORKDIR /app

# Copy the package.json to workdir
COPY package.json .
COPY ecosystem.config.js .

Run npm cache clean -f
# Run npm install - install the npm dependencies
RUN npm install

# Copy application source
COPY . .

# Expose application ports - (443 - for front end)
EXPOSE 8000


# Start the application
CMD [ "pm2-runtime", "start", "ecosystem.config.js" ]
