//* import packages

const express = require('express');
const UserController = require('../controllers/userController');
const asyncHandler = require('express-async-handler');
const authMiddleware = require('../../../middleware/authentication/authMiddleware');

//* configure router

const router = express.Router();
//? Registration route
router.post('/register', asyncHandler(UserController.register));

//? Login route
router.post('/login', asyncHandler(UserController.login));

//? Authenticated routes
router.get('/:id',authMiddleware, asyncHandler(UserController.findUser));
router.put('/:id',authMiddleware, asyncHandler(UserController.updateUser));
router.delete('/:id',authMiddleware, asyncHandler(UserController.deleteUser));

module.exports = router;
