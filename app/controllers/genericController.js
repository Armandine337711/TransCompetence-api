const genericModel = require("../models/genericModel");
const bcrypt = require('bcrypt');
// const bcryptMiddleware = require("../middlewares/bcryptMiddleware");
// const res = require("express/lib/response");

const genericController = {
    async getAll(request, response, next) {
        try {
            const { entity } = request.params;
            const data = await genericModel.getAll(entity);

            if (data) {
                response.json({ data });
            } else {
                next();
            }
        } catch (error) {
            next(error);
        }
    },

    async getOne(request, response, next) {
        try {
            const { entity, id } = request.params;
            const data = await genericModel.getOne(entity, id);
            if (data) {
                response.json({ data });
            }
        } catch (error) {
            next(error);
        }
    },

    async createOne(request, response, next) {
        try {
            const { entity } = request.params;
            const newDatas = request.body;

            if (entity === 'member') {
                // const hashing = await bcryptMiddleware.hashData(newDatas.pwd, 10)
                // await bcrypt.hash(newDatas.pwd, 15)
                //     .then((hash) => newDatas.pwd = hash)
                //     .catch((error) => res.status(500).json({ error }).send(console.log(error)))
                bcrypt.genSalt(10, function (err, salt) {
                    bcrypt.hash(newDatas.pwd, salt, function (err, hash) {
                        newDatas.pwd = hash
                    });
                });
            }

            const data = await genericModel.createOne(entity, newDatas);
            if (data) {
                response.json({ data });
            }
        } catch (error) {
            next(error);
        }
    },

    async updateOne(request, response, next) {

        try {
            const { entity, id } = request.params;
            const updatedDatas = request.body;
            if (parseInt(id) == parseInt(updatedDatas.id)) {
                const data = await genericModel.updateOne(entity, updatedDatas);
                if (data) {
                    response.json({ data })
                }
            } else {
                next()
            }

        } catch (error) {
            next(error)
        }
    },

    async deleteAll(request, response, next) {
        try {
            const { entity } = request.params;
            await genericModel.deleteAll(entity);
            return 'Suppression effectuée'

        } catch (error) {
            next(error)

        }
    },

    async deleteOne(request, response, next) {
        try {
            const { entity, id } = request.params;
            await genericModel.deleteOne(entity, id);
            return 'suppression effectuée'
        } catch (error) {
            next(error)
        }
    }
};

module.exports = genericController;