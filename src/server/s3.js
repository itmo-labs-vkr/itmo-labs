require('dotenv/config');

const {getSignedUrl} = require('@aws-sdk/s3-request-presigner');
const {GetObjectCommand, ListObjectsCommand, S3Client} = require('@aws-sdk/client-s3');

const credentials = {
    accessKeyId: process.env.ACCESS_KEY_ID,
    secretAccessKey: process.env.SECRET_ACCESS_KEY,
};

const client = new S3Client({
    region: process.env.REGION,
    endpoint: process.env.ENDPOINT,
    credentials,
});

/**
 *
 * @param {string} key s3 file path
 * @param {'string' | 'link'} type should we return raw file or link to file
 * @returns {string | undefined} object from s3 or undefined
 */
const get = async (key, type = 'string') => {
    try {
        const command = new GetObjectCommand({
            Bucket: process.env.BUCKET,
            Key: key,
        });

        const result = await client.send(command);

        if (type === 'string') {
            return result.Body.transformToString();
        }

        return getSignedUrl(client, command);
    } catch {
        return undefined;
    }
};

const folder = async (name) => {
    const Prefix = `${name}/`;
    const command = new ListObjectsCommand({
        Bucket: process.env.BUCKET,
        Prefix,
    });

    const result = await client.send(command);
    const titles = [];
    const files = result.Contents.filter(({Size}) => Boolean(Size)).map((file) => {
        titles.push(file.Key.slice(Prefix.length));

        return file;
    });

    return files.map((file, i) => [titles[i], file]);
};

module.exports = {
    get,
    folder,
};
