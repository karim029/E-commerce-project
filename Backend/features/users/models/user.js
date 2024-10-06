//* import packages
const mongoose = require('mongoose');

//* create user schema

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    role: {
        type: String,
        default: 'user',
        enum: ['user','admin'],
    },
    password: {
        type: String,
        required: true,
    },
    passwordResetToken: {
        type: String,
        default: null
    },
    passwordResetExpires: {
        type: date,
        default: null
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
    updatedAt: {
        type: Date,
        default: Date.now,
    },
});

//* save the schema in the db
const User = mongoose.model('User', userSchema);

module.exports = User;
