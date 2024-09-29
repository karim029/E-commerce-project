//? tests for the user api endpoints

//* import packages

const request = require('supertest');
const app = require('../../../app');
const User = require('../models/user');
const mongoose = require('mongoose');
const dotenv = require('dotenv');

dotenv.config();

beforeAll(async () => {
    const url = process.env.MONGO_URL;
    await mongoose.connect(url);
});

afterAll(async () => {
    await mongoose.connection.close();
});

describe('User API', () => {
    
    //* test for registering a new user
    it('should create a new user', async () => {
        const res = await request(app).post('/users/register').send({
            name: 'Testuser',
            password: 'testpassword123',
        });
        expect(res.statusCode).toEqual(201);
        expect(res.body.success).toBe(true);

    });

    //* test for registering a user with the same name
    it('should return 400 for registering a user with an existing name', async () => {
        const res = await request(app).post('/users/register').send({
            name: 'Testuser',
            password: 'differentpassword',
        });
        expect(res.statusCode).toEqual(400);
        expect(res.body.success).toBe(false);

    });

    //* test for loging in with an existing user
    it('should login a user', async () => {
        const res = await request(app).post('/users/login').send({
            name: 'Testuser',
            password: 'testpassword123',
        });
        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toBe(true);
    });

    //* test for finding a non existing user
     it('should return 404 for non-existing user', async () => {
    const res = await request(app).get('/users/66f975d8f532997536f43197'); //* non existing ID

    expect(res.statusCode).toEqual(404);
     });
    
     //* Test for updating an existing user
    it('should update an existing user', async () => {
        const user = await User.findOne({ name: 'Testuser' }); 
        const res = await request(app)
            .put(`/users/${user._id}`) 
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
        const user = await User.findOne({ name: 'UpdatedTestuser' });
        const res = await request(app).delete(`/users/${user._id}`); 

        expect(res.statusCode).toEqual(200);
        expect(res.body.success).toBe(true);
        expect(res.body.message).toBe('User deleted successfully.');
    });

     //* Test for attempting to delete a non-existing user
    it('should return 404 for non-existing user on delete', async () => {
        const res = await request(app).delete('/users/66f975d8f532997536f43197'); //* non-existing ID
        expect(res.statusCode).toEqual(404);
    });
    
});
