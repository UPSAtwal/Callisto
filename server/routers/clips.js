const express = require('express');
const controller = require('../controllers/clips');

const router = express.Router();

// router.get('/key/:key', controller.byKey);
router.get('/all', controller.all);
router.get('/push', controller.push)
module.exports = router;