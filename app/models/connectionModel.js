const client = require('./client');

const connectionModel = {
    async login(login) {
        const result = await client.query(`SELECT * FROM "member_role" WHERE "login" = $1`, [login])

        // if (result.rowCount == 0) {
        //     return null
        // }
        return result.rows[0]
    }
};

module.exports = connectionModel;