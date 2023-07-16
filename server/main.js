const express = require('express');
const clips = require('./routers/clips');
const client = require('./routers/client');

const PORT = 4096;

const app = express();
app.use(express.json());
app.use('/clips', clips);
app.use('/clients/', client);

app.get('/', (req, res) => {
    res.send('Get on /');
});

app.listen(PORT, () => {
    console.log('Server Started');
});