//* import packages
const User = require('../models/user');
const bcrypt = require('bcrypt');
const {generateToken} = require('../../../utils/tokenUtil');

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
        if (updateData.password) {
            updateData.password = await bcrypt.hash(updateData.password, 10);
        }
        updateData.updatedAt = Date.now();
        return await User.findByIdAndUpdate(userId, updateData, { new: true });
    }

    //* [method] delete user from db
    //* args: userId[String] 
    //* return: a promise that resolves to the document to be deleted 

    static async deleteUser(userId) {
        return await User.findByIdAndDelete(userId);
    }

    //* [method] update user password 
    //* args: userId[String], newPassword[String]
    //* return: a promise that resolves to the document with the updated password 

    static async updatePassword(userId, newPassword) {
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        return await User.findByIdAndUpdate(userId, { password: hashedPassword }, { new: true });
    }

    //* [method] generate a password reset token
    //* args: email[String]
    //* return the generated token
    
    static async generatePasswordResetToken(email) {
        const user = await UserService.findUserByEmail(email);
        if (!user) return null;

        const token = generateToken(user._id);

        user.passwordResetToken = token;
        user.passwordResetExpires = Date.now() + 3600000; //* 1h

        await user.save();
        return token;
    }

    //* [method] find user by reset token
    //* args: token[String]
    //* return the found user 

    static async findUserByResetToken(token) {
        return await User.findOne({
            passwordResetToken: token,
            passwordResetExpires: { $gt: Date.now() },
        });
    }

    //* [method] get all users record (supports pagination)
    //* args: page[Number], limit[Number]
    //* return all users in chunks 

    static async getUsers(page = 1, limit = 10) {
        const skip = (page - 1) * limit;
        return await User.find().skip(skip).limit(limit).select('name email userId createdAt role');
    }
    

}

module.exports = UserService;