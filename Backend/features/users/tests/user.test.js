//? tests for the user api endpoints

//* import packages

const request = require('supertest');
const app = require('../../../app');
const User = require('../models/user');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const bcrypt = require('bcrypt');
const tokenUtil = require('../../../utils/tokenUtil');

dotenv.config();

beforeAll(async () => {
    const url = process.env.MONGO_URL;
    await mongoose.connect(url);
    await User.deleteMany();
});

afterAll(async () => {
    await mongoose.connection.close();
});

describe('User API', () => {

    //* Test for registering a new user
    it('should create a new user', async () => {
        const res = await request(app).post('/users/register').send({
            name: 'Testuser',
            email: 'testuser@example.com',
            password: 'testpassword123',
        });
        expect(res.statusCode).toEqual(201);
        expect(res.body.success).toBe(true);
        expect(res.body.data.name).toBe('Testuser');
        expect(res.body.data.email).toBe('testuser@example.com');
        expect(res.body).toHaveProperty('token');
    });

    //* Test for registering a user with an existing email
    it('should return 400 for registering a user with an existing email', async () => {
        const res = await request(app).post('/users/register').send({
            name: 'Testuser2',
            email: 'testuser@example.com', // Same email as previous test
            password: 'anotherpassword',
        });
        expect(res.statusCode).toEqual(400);
        expect(res.body.success).toBe(false);
        expect(res.body.message).toBe('User with this email already exists.');
    });

    //* Test for logging in with valid credentials
    it('should login a user with valid credentials', async () => {
        const res = await request(app).post('/users/login').send({
            email: 'testuser@example.com',
            password: 'testpassword123',
        });
        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toBe(true);
        expect(res.body).toHaveProperty('token');
    });

    //* Test for logging in with invalid credentials
    it('should return 401 for invalid email or password', async () => {
        const res = await request(app).post('/users/login').send({
            email: 'testuser@example.com',
            password: 'wrongpassword',
        });
        expect(res.statusCode).toEqual(401);
        expect(res.body.success).toBe(false);
        expect(res.body.message).toBe('Invalid email or password.');
    });

    //* Test for finding an existing user
    it('should return user data for an existing user', async () => {
        const user = await User.findOne({ email: 'testuser@example.com' });
        const token = tokenUtil.generateToken(user._id);
        const res = await request(app).get(`/users/${user._id}`).set('Authorization',`Bearer ${token}`);
        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toBe(true);
        expect(res.body.data.email).toBe('testuser@example.com');
    });

    //* Test for finding a non-existing user
    it('should return 404 for non-existing user', async () => {
        const token = tokenUtil.generateToken('66f975d8f532997536f43197');
        const res = await request(app).get('/users/66f975d8f532997536f43197').set('Authorization',`Bearer ${token}`); // Non-existing ID
        expect(res.statusCode).toEqual(404);
        expect(res.body.success).toBe(false);
        expect(res.body.message).toBe('User not found.');
    });

    //* Test for updating an existing user
    it('should update an existing user', async () => {
        const user = await User.findOne({ email: 'testuser@example.com' });
        const token = tokenUtil.generateToken(user._id);
        const res = await request(app)
            .put(`/users/${user._id}`)
            .set('Authorization', `Bearer ${token}`)
            .send({
                name: 'UpdatedTestuser',
                password: 'newpassword123',
            });
        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toBe(true);
        expect(res.body.data.name).toBe('UpdatedTestuser');
    });

    //* Test for deleting an existing user
    it('should delete an existing user', async () => {
        const user = await User.findOne({ email: 'testuser@example.com' });
        const token = tokenUtil.generateToken(user._id);
        const res = await request(app)
            .delete(`/users/${user._id}`)
            .set('Authorization', `Bearer ${token}`);
        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toBe(true);
        expect(res.body.message).toBe('User deleted successfully.');
    });

    //* Test for attempting to delete a non-existing user
    it('should return 404 for non-existing user on delete', async () => {
        const token = tokenUtil.generateToken('66f975d8f532997536f43197');
        const res = await request(app)
            .delete('/users/66f975d8f532997536f43197') // Non-existing ID
            .set('Authorization', `Bearer ${token}`);
        expect(res.statusCode).toEqual(404);
        expect(res.body.success).toBe(false);
    });
});