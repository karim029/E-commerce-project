//* import packages
const mongoose = require('mongoose');
const dotenv = require('dotenv');

dotenv.config();
//* create connection to the database

const connectDB = async () => {
    try {
        const connection = await mongoose.connect(process.env.MONGO_URL, 
           
        );
        console.log('MongoDB connected successfully');

    } catch (error) {
        console.error('MongoDB connection failed:', error.message);
        process.exit(1);
    }
}

module.exports = connectDB;
