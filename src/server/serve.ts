import express from 'express';
import cors from 'cors';

import config from './config';

const app = express();

app.use(cors());

app.get('/config', async (_, res) => {
    const result = await config();

    res.status(200).json(result);
});

const port = Number(process.env.PORT!);

app.listen(process.env.PORT, () => {
    // eslint-disable-next-line no-console
    console.log(`Server started on port ${port}`);
});
