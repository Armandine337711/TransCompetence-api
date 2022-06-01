const express = require('express');

const connectionController = require('../controllers/connectionController');

const router = express.Router();

router.get('/login', connectionController.login);

module.export = router;