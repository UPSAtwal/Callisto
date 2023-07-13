const redis = require('redis');

const client = redis.createClient({});

client.connect();

module.exports = client;
//will handle proper authentication later on