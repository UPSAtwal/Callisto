const express = require('express');
const controller = require('../controllers/client');

const router = express.Router();

router.post('/push', controller.push);
router.post('/remove', controller.remove);

module.exports = router;