const express = require('express');
const controller = require('../controllers/clips');

const router = express.Router();

router.get('/key/:key', controller.byKey);

router.get('/all', controller.all);

module.exports = router;