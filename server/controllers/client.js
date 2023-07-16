const redis = require('../db');
const authenticate = require('../auth');

async function push(req, res) {
    const { pass, addr } = req.body;
    if (authenticate(pass)) {
        redis.sAdd('clients', addr);
        res.sendStatus(200);
    } else {
        res.sendStatus(403);
    }
}

async function remove(req, res) {
    const { pass, addr } = req.body;
    if (authenticate(pass)) {
        redis.sRem('clients', addr);
        res.sendStatus(200);
    } else {
        res.sendStatus(403);
    }
}

module.exports = {
    push,
    remove
}