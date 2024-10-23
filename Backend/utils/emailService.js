const dotenv = require('dotenv');
const nodeMailer = require('nodemailer');
dotenv.config();

const sendEmail = async (toUser, emailSubject, body) => {
    try {
        const transporter = nodeMailer.createTransport({
            service: 'Gmail',
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
        });

        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: toUser,
            subject: emailSubject,
            text: body,
        };

        await transporter.sendMail(mailOptions);
    } catch (error) {
        console.error("Error sending email:", error.message);
    }
}

module.exports = {
    sendEmail
};