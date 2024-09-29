//* import packages

const express = require('express');
const UserController = require('../controllers/userController');
const asyncHandler = require('express-async-handler');


//* configure router

const router = express.Router();

router.post('/register', asyncHandler(UserController.register));
router.post('/login', asyncHandler(UserController.login));
router.get('/:id', asyncHandler(UserController.getUser));
router.put('/:id', asyncHandler(UserController.updateUser));
router.delete('/:id', asyncHandler(UserController.deleteUser));

module.exports = router;
