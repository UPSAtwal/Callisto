const redis = require('../db');
const authenticate = require('../auth');
const needle = require('needle');

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
            const addr = await redis.sMembers('clients');
            //todo make request to clients
            for (const ip of addr) {
                try {
                    await needle.post(addr + '/', { text: text }, { json: true });
                } catch {
                    console.log(`Unreachable at ${ip}`);
                }
            }
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