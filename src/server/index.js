const express = require('express');
const cors = require('cors');

const equipment = require('./equipment');

const app = express();

app.use(cors());

app.get('/equipment', async (_, res) => {
    const result = await equipment();

    res.status(200).json(result);
});

app.listen(process.env.PORT, () => {
    console.log(`Server started on port ${process.env.PORT}`);
});
