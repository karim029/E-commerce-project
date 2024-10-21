//* import packages

const express = require('express');
const UserController = require('../controllers/userController');
const asyncHandler = require('express-async-handler');
const authMiddleware = require('../../../middleware/authentication/authMiddleware');
const roleMiddleware = require('../../../middleware/roles/rolesMiddleware');

//* configure router
const router = express.Router();

//? Registration route
router.post('/register', asyncHandler(UserController.register));

//? Login route
router.post('/login', asyncHandler(UserController.login));

//? Request Password reset route
router.post('/request-password-reset', asyncHandler(UserController.requestPasswordReset));

//? Reset password route
router.post('/reset-password/:token', asyncHandler(UserController.resetPassword));

//? Authenticated routes
router.get('/:id',authMiddleware, asyncHandler(UserController.findUser));
router.put('/:id',authMiddleware, asyncHandler(UserController.updateUser));
router.delete('/:id',authMiddleware, roleMiddleware('admin'), asyncHandler(UserController.deleteUser));
router.get('/',authMiddleware, roleMiddleware('admin'), asyncHandler(UserController.getUsers));

module.exports = router;
