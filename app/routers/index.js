const express = require('express');
const connectionRouter = require('./connectionRouter')
const genericController = require('../controllers/genericController');
const connectionController = require('../controllers/connectionController')

const errorController = require('../controllers/errorController');

const router = express.Router();

router.post('/connection/login', connectionController.login)

/* generic CRUD */


// router.use('/connection', connectionRouter);

router.get('/:entity', genericController.getAll);
router.get('/:entity/:id', genericController.getOne);
router.post('/:entity', genericController.createOne);
router.patch('/:entity/:id', console.log("truc"), genericController.updateOne);
router.delete('/:entity', genericController.deleteAll);
router.delete('/:entity/:id', genericController.deleteOne);
// router.use(errorController.error404);
// router.use(errorController.error500);

module.exports = router;