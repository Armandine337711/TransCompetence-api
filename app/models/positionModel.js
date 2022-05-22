const client = require('./client');

const positionModel = {
    async getAll() {
        const query = {
            text: `SELECT * FROM "position"`
        };
        const result = await client.query(query);
        return result.rows;
    },
};

module.exports = positionModel;