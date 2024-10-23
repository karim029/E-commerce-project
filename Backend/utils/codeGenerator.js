const generateOTP = () => {
    return Math.floor(100000 + Math.random() * 9000000);
};

module.exports = {
    generateOTP
};