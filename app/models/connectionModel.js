const client = require('./client');

const connectionModel = {
    async login(login) {

        const result = await client.query(`SELECT * FROM "member_role" WHERE "login" = $1`, [login])
        console.log("result", result.rows[0])
        if (result.rowCount == 0) {
            return null
        }
        return result.rows[0]
    }
};

module.exports = connectionModel;