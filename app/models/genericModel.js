const client = require('./client');

const genericModel = {
    async getAll(entity) {
        const query = {
            text: `SELECT * FROM ${entity}`
        };
        if (entity === "member") {
            query.text = `SELECT * FROM "member_role" `
        }
        const result = await client.query(query);
        return result.rows;
    },

    async getOne(entity, id) {

        const mainTextQuery = `SELECT * FROM ${entity}`
        if (entity === "member") {
            mainTextQuery = `SELECT * FROM "member_role" WHERE id = $1`
        }
        const query = {
            text: `${mainTextQuery} WHERE id = $1`,
            values: [id]
        };

        const result = await client.query(query);
        return result.rows[0];
    },

    async createOne(entity, newDatas) {
        // const verify = this.getAll(entity)
        // if (verify){
        const result = await client.query(`SELECT * FROM ${entity}_add($1)`, [newDatas])
        return result.rows[0];
        // }


    },

    async updateOne(entity, updatedDatas) {

        if (entity == "dp") {
            entity = `${entity}${updatedDatas.dp}`
        }
        const result = await client.query(`SELECT * FROM ${entity}_update($1)`, [updatedDatas]);

        return result.rows[0]
    },

    async deleteAll(entity) {
        await client.query(`DELETE FROM ${entity} RESTART IDENTITY`);
        const result = this.getAll(entity)
        if (!result) {
            return "tout va bien"
        }
    },

    async deleteOne(entity, id) {
        console.log(id)
        await client.query(`DELETE FROM ${entity} WHERE id = $1`, [id])
        const result = this.getOne(entity, id);
        if (!result) {
            return "tout va bien"
        }
    }
}

module.exports = genericModel;