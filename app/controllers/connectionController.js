const connectionModel = require('../models/connectionModel');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const connectionController = {
    async login(request, response, next) {
        try {
            console.log(request.body)
            const { login, password } = request.body
            //je vérifie que le login existe dans la bdd
            const data = await connectionModel.login(login);
            console.log("minie pass", password)

            // le login existe je vérifie le mot de passe
            if (data) {
                bcrypt.compare(password, data.pwd, function (err, result) {
                    console.log(result)
                    if (result) {
                        // le mot de passe correspond, je crée le token

                        const generateAccessToken = (data) => {
                            return jwt.sign(data, process.env.ACCESS_PRIVATE_TOKEN, { expiresIn: '1800s' });
                        }
                        const accessToken = generateAccessToken(data)
                        // j'envoie le token en front et les vérifications de droits se feront dans un middleware en front
                        console.log(accessToken, data);
                        response.json({ accessToken, data })
                    } else {
                        console.log("pas le bon mdp")
                        response.status(401).send('invalid credentials')
                    }




                });
            } else {
                console.log("perdu")
                response.status(401).send('invalid credentials')
                return;
            }
        } catch (error) {
            next(error)

        }


    },
};

module.exports = connectionController;