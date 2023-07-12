const redis = require('../db');

async function byKey(req, res) {
    const { key } = req.params;
    res.send(await redis.get(key));
}

async function all(req, res) {
    const ret = await redis.keys('*');
    let vals = [];

    for (const key of ret) {
        vals.push(await redis.get(key));
    }
    res.send(vals);
}

module.exports = {
    byKey,
    all
}