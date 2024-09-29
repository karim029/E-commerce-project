//* import packages
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const UserRoutes = require('./features/users/routes/userRoutes');
const dotenv = require('dotenv');
const body_parser = require('body-parser');

dotenv.config();

const app = express();
connectDB();

app.use(cors());
app.use(express.json());
app.use(body_parser.json());

//* routes
app.use('/users', userRoutes);

//* Error handling middleware
app.use((err, req, res, next) => {
    res.status(500).json({ success: false, message: err.message });
});

//* Exporting app for use in index.js
module.exports = app;  
