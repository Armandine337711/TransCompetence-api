const bcrypt = require('bcrypt');


const bcryptMiddleware = {


    hashData: async function (data, salt) {
        console.log("data", data)
        console.log("salt", salt)
        const hashedData = '';
        await bcrypt.hash(data, salt)
            .then((hash) => hashedData = hash)
            .catch((error) => res.status(500).json({ error }).send(console.log(error)))

        return hashedData

    }
}

module.export = bcryptMiddleware
