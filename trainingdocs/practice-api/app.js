require('dotenv').config();
const express = require('express')
const app = express()
const cors = require("cors");
const fileUpload = require('express-fileupload');
const bodyParser = require('body-parser');
const Pool = require('pg').Pool

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
  });
app.use(bodyParser.json());
app.use(cors());
app.use(fileUpload());

/**
 * API for sending image to python and get back the result
 */
app.post('/predict', (req, res, next) => {
    const uploadFile = req.files.file
    const fileName = req.files.file.name
    res.send("This is a demo version")
})

/*Health Check*/
app.get('/status', (req, res, next) => {
    res.send("OK")
})

/* Database Check */
app.get('/database', (req, res, next) => {
    pool.query('SELECT * FROM users ORDER BY id ASC', (error, results) => {
        if (error) {
          throw error
        }
        res.send(results.rows)
      })
})
app.listen(4001, () => console.log('Application listening on port 4001!'))
