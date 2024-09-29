//* import packages
const UserService = require('../services/userService');
const bcrypt = require('bcrypt');


class UserController {
    //* [Method] controller method to register user and handle validation
    //* [201] created
    //* [400] bad request
    //* [500] internal server error
    

    static async register(req, res) {
        const { name, password } = req.body;
        if (!name || !password) {
            return res.status(400), json({ success: false, message: 'Name and Password are required' });
        }
        try {
            const newUser = await UserService.createUser(name, password);
            res.status(201).json({ success: true, message: 'User created successfully.', data: newUser });
        } catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    }

    //* [Method] controller method to login user and handle password comparason
    //* [200] ok
    //* [401] unauthorized
    //* [500] internal server error

    static async login(req, res) {
        const { name, password } = req.body;
        
        try {
            const user = await UserService.findUserByName(name);
            const isMatch = await bcrypt.compare(password, user.password);
            if (!user || !isMatch) {
                return res.status(401).json({ success: false, message: 'Invalid name or password.' });
            }
            res.status(200).json({ success: true, message: 'Login successful.', data: user });
        } catch (error) {
             res.status(500).json({ success: false, message: error.message });

        }
    }

    
    //* [Method] controller method to find user by id
    //* [404] not found
    //* [500] internal server error

    static async findUser(req, res) {
        const userId = req.params.id;
        try {
            const user = await UserService.findUserById(userId);
            if (!user) {
                return res.status(404).json({ success: false, message: 'User not found.' });
            }
            res.json({ success: true,message:'User found.' ,data: user });

        } catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    }

    //* [Method] controller method to update user credentials using its id from the url
    //* [404] not found
    //* [500] internal server error


    static async updateUser(req, res) {
        const { name, password } = req.body;
        const userId = req.params.id;
        try {
            const updatedUser = await UserService.updateUser(userId, { name, password });
            if (!updatedUser) {
                return res.status(404).json({ success: false, message: 'User not found.' });
            }
            res.json({ success: true, data: updatedUser });

        } catch (error) {
            res.status(500).json({ success: false, message: error.message });

        }
    }

    static async deleteUser(req, res) {
        try {
            const userId = req.params.id;
            const deletedUser = await UserService.deleteUser(userId);
            if (!deletedUser) {
                return res.status(404).json({ success: false, message: 'User not found.' });
            }
            res.json({ success: true, message: 'User deleted successfully.' });

        } catch (error) {
            res.status(500).json({ success: false, message: error.message });           
        }
    }
}

module.exports = UserController;

