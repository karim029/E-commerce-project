# User Management API

This is a User Management API built using Node.js, Express, and MongoDB with Mongoose for managing users. It supports the following features:

- **User Registration**
- **User Login**
- **Get User by ID**
- **Update User**
- **Delete User**
- **Authentication with JWT Tokens**
- **Pagination for User Listing**

## Table of Contents

- [Installation](#installation)
- [Environment Variables](#environment-variables)
- [API Endpoints](#api-endpoints)
  - [User Registration](#user-registration)
  - [User Login](#user-login)
  - [Get User by ID](#get-user-by-id)
  - [Update User](#update-user)
  - [Delete User](#delete-user)
  - [Get All Users with Pagination](#get-all-users-with-pagination)
- [Middleware](#middleware)
- [Test Suite](#test-suite)
- [Folder Structure](#folder-structure)

## Installation

1. Clone this repository:

   ```bash
   git clone <repository_url>
   cd user-management-api
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Ensure that you have MongoDB running locally or provide a remote MongoDB URI in the `.env` file.

4. Start the application:
   ```bash
   npm start
   ```

## Environment Variables

The API uses environment variables stored in a `.env` file. You need to create this file in the root directory of the project. Here are the required variables:

```bash
MONGO_URL=mongodb://localhost:27017/usermanagementapi
JWT_SECRET=your_jwt_secret
PORT=5000
```

- **MONGO_URL**: MongoDB connection string.
- **JWT_SECRET**: Secret for signing JWT tokens.
- **PORT**: Port for running the server.

## API Endpoints

### 1. User Registration

- **URL**: `/users/register`
- **Method**: `POST`
- **Description**: Creates a new user account.

#### Request Body:

```json
{
  "name": "User Name",
  "email": "user@example.com",
  "password": "password123"
}
```

#### Response:

- **Status**: `201 Created`
- **Body**:

  ```json
  {
    "success": true,
    "token": "JWT_TOKEN",
    "data": {
      "_id": "user_id",
      "name": "User Name",
      "email": "user@example.com"
    }
  }
  ```

- **Error Responses**:
  - `400`: If the email is already registered.

---

### 2. User Login

- **URL**: `/users/login`
- **Method**: `POST`
- **Description**: Logs in a user and provides a JWT token.

#### Request Body:

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Response:

- **Status**: `200 OK`
- **Body**:

  ```json
  {
    "success": true,
    "token": "JWT_TOKEN"
  }
  ```

- **Error Responses**:
  - `401`: If the email or password is incorrect.

---

### 3. Get User by ID

- **URL**: `/users/:id`
- **Method**: `GET`
- **Description**: Returns user data for the provided user ID. This endpoint is protected by JWT authentication.

#### Headers:

```http
Authorization: Bearer <JWT_TOKEN>
```

#### Response:

- **Status**: `200 OK`
- **Body**:

  ```json
  {
    "success": true,
    "data": {
      "_id": "user_id",
      "name": "User Name",
      "email": "user@example.com"
    }
  }
  ```

- **Error Responses**:
  - `404`: If the user is not found.
  - `401`: If the token is invalid or missing.

---

### 4. Update User

- **URL**: `/users/:id`
- **Method**: `PUT`
- **Description**: Updates user information. This endpoint is protected by JWT authentication.

#### Request Body:

```json
{
  "name": "Updated User",
  "password": "newpassword123"
}
```

#### Headers:

```http
Authorization: Bearer <JWT_TOKEN>
```

#### Response:

- **Status**: `200 OK`
- **Body**:

  ```json
  {
    "success": true,
    "data": {
      "_id": "user_id",
      "name": "Updated User"
    }
  }
  ```

- **Error Responses**:
  - `404`: If the user is not found.
  - `401`: If the token is invalid or missing.

---

### 5. Delete User

- **URL**: `/users/:id`
- **Method**: `DELETE`
- **Description**: Deletes the user account. This endpoint is protected by JWT authentication.

#### Headers:

```http
Authorization: Bearer <JWT_TOKEN>
```

#### Response:

- **Status**: `200 OK`
- **Body**:

  ```json
  {
    "success": true,
    "message": "User deleted successfully."
  }
  ```

- **Error Responses**:
  - `404`: If the user is not found.
  - `401`: If the token is invalid or missing.

---

### 6. Get All Users with Pagination

- **URL**: `/users`
- **Method**: `GET`
- **Description**: Returns a paginated list of users. This endpoint is protected by JWT authentication.

#### Query Parameters:

- `page` (optional): Page number for pagination (default is 1).
- `limit` (optional): Number of users per page (default is 10).

#### Headers:

```http
Authorization: Bearer <JWT_TOKEN>
```

#### Response:

- **Status**: `200 OK`
- **Body**:

  ```json
  {
    "success": true,
    "data": [
      {
        "_id": "user_id",
        "name": "User Name",
        "email": "user@example.com"
      },
      // more user objects...
    ],
    "total": total_users_count,
    "currentPage": current_page,
    "totalPages": total_pages_count
  }
  ```

- **Error Responses**:
  - `401`: If the token is invalid or missing.

---

## Middleware

- **`authMiddleware`**: This middleware is used to protect routes that require the user to be logged in (e.g., fetching, updating, or deleting user data). It checks for a valid JWT token in the `Authorization` header.
  - If the token is valid, it proceeds with the request.
  - If the token is missing or invalid, it returns a `401 Unauthorized` response.

## Test Suite

We have written tests using **Jest** and **Supertest** to ensure the reliability of the user API.

- **Test commands**:

  ```bash
  npm test
  ```

- **Tests covered**:
  - User registration (valid and invalid cases).
  - User login (valid and invalid cases).
  - Get user by ID (valid and invalid cases).
  - Update user (valid and invalid cases).
  - Delete user (valid and invalid cases).
  - Pagination for user listing.

The test suite is located in `tests/user.test.js`.

## Folder Structure

Here's the basic folder structure for this project:

```
|-- controllers
|   |-- userController.js   // Handles request logic
|
|-- models
|   |-- userModel.js        // Mongoose schema for user
|
|-- routes
|   |-- userRoutes.js       // Defines API routes for user management
|
|-- services
|   |-- userService.js      // Contains the business logic for user actions
|
|-- middlewares
|   |-- authMiddleware.js   // JWT authentication middleware
|
|-- tests
|   |-- user.test.js        // Unit and integration tests
|
|-- utils
|   |-- hashPassword.js     // Utility function for hashing passwords
|   |-- tokenUtils.js       // Utility for JWT token generation and verification
|
|-- .env                    // Environment variables
|-- app.js                  // Main Express application
|-- server.js               // Server entry point
|-- package.json
```

### Explanation:

- **Controllers**: This layer handles the request and response logic.
- **Models**: Mongoose schema definitions for users.
- **Services**: Contains business logic such as hashing passwords, validating users, and handling database interactions.
- **Middlewares**: Handles authentication and other shared logic across routes.
- **Utils**: Contains reusable utility functions like password hashing and JWT handling.

---

## Future Enhancements

- **Password Reset**: Implement a feature to allow users to reset their password via email.
- **Roles and Permissions**: Add roles such as admin and standard user with different access permissions.
- **Improved Pagination**: Enhance pagination to support sorting and filtering options.
