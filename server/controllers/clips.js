const redis = require('../db');
const authenticate = require('../auth');

async function all(req, res) {
    const { pass } = req.body;
    if (authenticate(pass)) {
        const vals = await redis.lRange('clips', 0, -1);
        res.send(vals);
    } else {
        res.sendStatus(403);
    }
}

async function push(req, res) {
    const { text, pass } = req.body;
    if (authenticate(pass)) {
        try {
            await redis.rPush('clips', text);
            res.sendStatus(200);
        } catch (err) {
            console.log(err);
            res.sendStatus(400);
        }
    } else {
        res.sendStatus(403);
    }
}

module.exports = {
    all,
    push
}