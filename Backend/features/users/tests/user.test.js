//? tests for the user api endpoints

//* import modules and functions
const request = require('supertest');
const app = require('../../../app');
const User = require('../models/user');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const tokenUtil = require('../../../utils/tokenUtil');
const bcrypt = require('bcrypt');
const { sendEmail } = require('../../../utils/emailService');

jest.mock('../../../utils/emailService');
dotenv.config();

let testUser; 
let userToBeDeletedId;
let adminUser;

beforeAll(async () => {
    const url = process.env.MONGO_URL;
    await mongoose.connect(url);
    await User.deleteMany();

    testUser = await User.create({
        name: 'Testuser',
        email: 'testuser@example.com',
        password: 'testpassword123',
        role: 'admin',
    });

    await testUser.save();

    const users = [
        { name: 'Testuser2', email: 'testuser3@example.com', password: 'testpassword456' },
        { name: 'Testuser3', email: 'testuser4@example.com', password: 'testpassword789' },
        { name: 'Testuser4', email: 'testuser5@example.com', password: 'testpassword101' },
        { name: 'Testuser5', email: 'testuser6@example.com', password: 'testpassword112' },
    ];

    for (const user of users) {
        await User.create(user);
    }

    
});

afterAll(async () => {
    await User.deleteMany(); 
    await mongoose.connection.close();
});

describe('User API', () => {
    
    describe('Authentication', () => {
        //* Test for registering a new user
        it('should create a new user', async () => {
            const res = await request(app).post('/users/register').send({
                name: 'Testuser2',
                email: 'testuser2@example.com',
                password: 'testpassword456',
            });
            expect(res.statusCode).toEqual(201);
            expect(res.body.success).toBe(true);
            expect(res.body.data.name).toBe('Testuser2');
            expect(res.body.data.email).toBe('testuser2@example.com');
            expect(res.body).toHaveProperty('token');
            userToBeDeletedId = res.body.data._id;
        });
        //* Test for registering a user with an existing email
        it('should return 400 for registering a user with an existing email', async () => {
            const res = await request(app).post('/users/register').send({
                name: 'Testuser2',
                email: 'testuser2@example.com', 
                password: 'anotherpassword',
            });
            expect(res.statusCode).toEqual(400);
            expect(res.body.success).toBe(false);
            expect(res.body.message).toBe('User with this email already exists.');
        });

        //* Test for logging in with valid credentials
        it('should login a user with valid credentials', async () => {
            const res = await request(app).post('/users/login').send({
                email: 'testuser2@example.com',
                password: 'testpassword456',
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
    });

    
    describe('Password Reset', () => {
        //* Test for requesting a password reset
        let resetToken;


        it('should generate a password reset token and mock email sending', async () => {
            
            //* email mock implementation
            sendEmail.mockResolvedValueOnce();

            const res = await request(app).post('/users/request-password-reset').send({
                email: 'testuser2@example.com',
            });

            expect(res.statusCode).toEqual(200);
            expect(res.body.success).toBe(true);
            expect(res.body.message).toBe('Password reset token generated.');
            expect(res.body).toHaveProperty('token'); 

            resetToken = res.body.token;
            
            //* ensuring that the sendEmail function was called
            expect(sendEmail).toHaveBeenCalledTimes(1);
            expect(sendEmail).toHaveBeenCalledWith(
                'testuser2@example.com',
                expect.any(String), // email subject
                expect.any(String)  // email body
            );
        });

        //* Test for attempting to reset password with an invalid token
        it('should return 400 for invalid or expired token', async () => {
            const res = await request(app).post('/users/reset-password/invalid-token').send({
                newPassword: 'newpassword123',
            });
            expect(res.statusCode).toEqual(400);
            expect(res.body.success).toBe(false);
            expect(res.body.message).toBe('Invalid or expired token.');
        });

        //* Test for resetting the password with a valid token
        it('should reset the password successfully', async () => {

            const res = await request(app).post(`/users/reset-password/${resetToken}`).send({
                newPassword: 'newpassword1235678',
            });

            expect(res.statusCode).toEqual(200);
            expect(res.body.success).toBe(true);
            expect(res.body.message).toBe('Password reset successful.');

            //* Verify that the password was updated
            const updatedUser = await User.findById(userToBeDeletedId);
            const isMatch = await bcrypt.compare('newpassword1235678', updatedUser.password);
            expect(isMatch).toBe(true);
        });
    });

    describe('User Management', () => {
        //* Test for getting all users [REQUIRE ADMIN ROLE]
        it('should return all users', async () => {
            const token = tokenUtil.generateToken(testUser._id);
            const res = await request(app).get(`/users/`).set('Authorization', `Bearer ${token}`);
            expect(res.statusCode).toEqual(200);
            expect(res.body).toHaveProperty('success', true);
            expect(res.body).toHaveProperty('data');
            expect(Array.isArray(res.body.data)).toBe(true);

        });

        //* Test for trying to return all users by non-admin
        it('should return 403 for non-admin user trying to get all users', async () => {
            const token = tokenUtil.generateToken(userToBeDeletedId); //* Non-admin token
            const res = await request(app)
            .get('/users')
            .set('Authorization', `Bearer ${token}`);
            expect(res.statusCode).toEqual(403);
            expect(res.body.message).toBe('Access denied.');
    });
        //* Test for finding an existing user
        it('should return user data for an existing user', async () => {
            const token = tokenUtil.generateToken(testUser._id);
            const res = await request(app).get(`/users/${testUser._id}`).set('Authorization', `Bearer ${token}`);
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
            const token = tokenUtil.generateToken(testUser._id);
            const res = await request(app)
                .put(`/users/${testUser._id}`)
                .set('Authorization', `Bearer ${token}`)
                .send({
                    name: 'UpdatedTestuser',
                    password: 'newUpdatedpassword123',
                });
            expect(res.statusCode).toEqual(200);
            expect(res.body.success).toBe(true);
            expect(res.body.data.name).toBe('UpdatedTestuser');
        });
            //* Test for attempting to delete a non-existing user [REQUIRE ADMIN ROLE]
        it('should return 404 for non-existing user on delete with admin privilege', async () => {
            const token = tokenUtil.generateToken(testUser._id);
            const res = await request(app)
                .delete('/users/66f975d8f532997536f43197') //* Non-existing ID
                .set('Authorization', `Bearer ${token}`);
            expect(res.statusCode).toEqual(404);
            expect(res.body.success).toBe(false);
        });

        //* Test for non-admin trying to delete a user
        it('should return 403 for non-admin user trying to delete a user', async () => {
            const token = tokenUtil.generateToken(userToBeDeletedId); //* Non-admin token
            const res = await request(app)
                .delete(`/users/${testUser._id}`)
                .set('Authorization', `Bearer ${token}`);
            expect(res.statusCode).toEqual(403);
            expect(res.body.message).toBe('Access denied.');
    });

        //* Test for deleting an existing user with an admin user [REQUIRE ADMIN ROLE]
        it('should delete an existing user with admin privilege', async () => {
            const token = tokenUtil.generateToken(testUser._id);
            const res = await request(app)
                .delete(`/users/${userToBeDeletedId}`)
                .set('Authorization', `Bearer ${token}`);
            expect(res.statusCode).toEqual(200);
            expect(res.body.success).toBe(true);
            expect(res.body.message).toBe('User deleted successfully.');
        });
    });

});
