const redis = require('../db');

async function all(req, res) {
    const vals = await redis.lRange('clips', 0, -1);
    res.send(await vals);
}

async function push(req, res) {
    const { text } = req.body;
    try {
        await redis.rPush('clips', text);
        res.sendStatus(200);
    } catch (err) {
        console.log(err);
        res.sendStatus(400);
    }
}

module.exports = {
    all,
    push
}