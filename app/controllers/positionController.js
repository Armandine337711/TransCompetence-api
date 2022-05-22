const positionModel = require('../models/positionModel');
const positionController = {
    async getAll(request, response, next) {
        try {
            const data = await positionModel.getAll();

            if (data) {
                response.json({ data });
            } else {
                next();
            }
        } catch (error) {
            next(error);
        }
    }
};

module.exports = positionController;