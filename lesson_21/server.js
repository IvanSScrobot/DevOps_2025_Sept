const express = require('express');
const db = require('./db');

const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
    res.send('Hello, World! Version dsaf');
});


app.get('/health', (req, res) => {
    res.send('Healthy');
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});