const genericModel = require("../models/genericModel");
const bcrypt = require('bcrypt');
const connectionModel = require("../models/connectionModel");

const genericController = {
    async home(request, response, next) {
        response.json({ data: 'test' })
    },
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
            console.log("coucou")
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


                const salt = bcrypt.genSaltSync(10);
                const hash = bcrypt.hashSync(newDatas.pwd, salt);
                newDatas.pwd = hash
                console.log(newDatas.pwd)
                const data = await genericModel.createOne(entity, newDatas);
                if (data) {
                    response.json({ data });
                }
            }


        } catch (error) {
            next(error);
        }
    },

    async updateOne(request, response, next) {

        try {
            const { entity, id } = request.params;
            const updatedDatas = request.body;
            console.log(typeOff(updatedDatas.id))
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