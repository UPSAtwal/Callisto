const express = require('express');
const client = require('./db');
const clips = require('./routers/clips');

const PORT = 4096;

const app = express();
app.use(express.json());
app.use('/clips', clips);

app.get('/', (req, res) => {
    res.send('Get on /');
});

app.listen(PORT, () => {
    console.log('Server Started');
});