import pg from 'pg';
const { Pool } = pg;

export const db = new Pool({
    user: process.env.DB_USER || 'postgres',
    host: process.env.DB_HOST || 'localhost',
    database: process.env.DB_NAME || 'evaluation',
    password: process.env.DB_PASSWORD || 'Aa20195@1',
    port: parseInt(process.env.DB_PORT || '5432', 10),
});


