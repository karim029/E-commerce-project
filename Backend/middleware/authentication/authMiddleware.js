const tokenUtil = require('../../utils/tokenUtil');

const authMiddleware = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
        return res.status(401).json({ success: false, message: 'Access denied, no token provided.' });
    }
    try {
        const decoded = tokenUtil.verifyToken(token);
        req.userId = decoded.id;
        next();
    } catch (error) {
        res.status(401).json({ success: false, message: 'Invalid token.' });
    }
};

module.exports = authMiddleware;
