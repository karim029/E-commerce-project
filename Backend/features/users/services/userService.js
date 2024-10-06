//* import packages
const User = require('../models/user');
const bcrypt = require('bcrypt');

//* user service class
class UserService {
    //* [method] create user
    //* args: name[String] , password[String]
    //* return: a promise that resolves to the document saved
    //* notes: encrypts the user password and store it in the db

    static async createUser(name,email ,password) {
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = new User({ name, password: hashedPassword, email: email });
        return await user.save();
    }

    //* [method] find user by email
    //* args: email[String] 
    //* return: a promise that resolves to the document found 
    //* notes: uses mongoose built in function to search for a document using the email address

    static async findUserByEmail(email) {
        return await User.findOne({ email });
    }
    //* [method] find user by Id
    //* args: userId[String] 
    //* return: a promise that resolves to the document found 
    //* notes: uses mongoose built in function to search for a document using the userId

    static async findUserById(userId) {
        return await User.findById(userId);
    }

    //* [method] update user data
    //* args: userId[String], updateData [userSchema(name,password,createdAt,updatedAt)] 
    //* return: a promise that resolves to the document to be updated 

    static async updateUser(userId, updateData) {
        return await User.findByIdAndUpdate(userId, updateData, { new: true });
    }

    //* [method] delete user from db
    //* args: userId[String] 
    //* return: a promise that resolves to the document to be deleted 

    static async deleteUser(userId) {
        return await User.findByIdAndDelete(userId);
    }

}

module.exports = UserService;