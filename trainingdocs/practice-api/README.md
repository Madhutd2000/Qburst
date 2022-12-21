# aws-training-api

## Set up and execution

### Prerequisite
    - Postgress Database
        - Create Database and Role
        - Create USER table
        - Add dummy values in USER table

### Environment variables

- DB_HOST=`localhost`
- DB_PORT=`5432`
- DB_NAME=`test`
- DB_USER=`test`
- DB_PASSWORD=`test`

### Deployment instructions

- Node version: `12.20.1`
- Build command: `npm install`
- Start command: `node app.js`
- Port exposed: `4001`
- Deployment verification: `curl http://localhost:4001/status`
