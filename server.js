import 'dotenv/config';
import express from 'express';
import http from 'http';
import https from 'https';
import { WebSocketServer, WebSocket } from 'ws';
import os from 'os';
import pty from 'node-pty';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

import { db } from './db.js';

// Ensure the schema is updated with the new columns and unique constraints
(async () => {
    const runMigration = async (queryStr) => {
        try {
            await db.query(queryStr);
        } catch (err) {
            // Ignore constraint already exists (42710) and relation/index already exists (42P07)
            if (err.code !== '42710' && err.code !== '42P07') {
                console.error("Migration query failed:", queryStr.trim(), err);
            }
        }
    };

    try {
        await runMigration(`ALTER TABLE result ADD COLUMN IF NOT EXISTS status VARCHAR(50);`);
        await runMigration(`ALTER TABLE result ADD COLUMN IF NOT EXISTS qid INT REFERENCES query(qid) ON DELETE CASCADE;`);
        await runMigration(`ALTER TABLE result ADD CONSTRAINT unique_attempt_query UNIQUE (attid, qid);`);
        await runMigration(`ALTER TABLE attempt ADD CONSTRAINT unique_attempt_cid_regno UNIQUE (cid, regno);`);
        console.log("Database schema migrations applied successfully.");
    } catch (err) {
        console.error("Error running database schema migration:", err);
    }
})();

function getAllowedOrigins() {
    const configured = process.env.ALLOWED_ORIGINS;
    if (configured) {
        return configured
            .split(',')
            .map((origin) => origin.trim())
            .filter(Boolean);
    }

    return [];
}

function createHttpOrHttpsServer(app) {
    const tlsKeyPath = process.env.TLS_KEY_PATH;
    const tlsCertPath = process.env.TLS_CERT_PATH;
    const tlsCaPath = process.env.TLS_CA_PATH;

    if (!tlsKeyPath || !tlsCertPath) {
        return { server: http.createServer(app), secure: false };
    }

    const tlsOptions = {
        key: fs.readFileSync(path.resolve(tlsKeyPath)),
        cert: fs.readFileSync(path.resolve(tlsCertPath))
    };

    if (tlsCaPath) {
        tlsOptions.ca = fs.readFileSync(path.resolve(tlsCaPath));
    }

    return {
        server: https.createServer(tlsOptions, app),
        secure: true
    };
}

const app = express();
const { server, secure } = createHttpOrHttpsServer(app);
const allowedOrigins = getAllowedOrigins();
const allowNoOrigin = process.env.ALLOW_NO_ORIGIN === 'true';

const isOriginAllowed = (origin) => {
    if (!origin) {
        return allowNoOrigin;
    }

    if (allowedOrigins.includes(origin)) {
        return true;
    }

    // Default dev policy: allow browser origins from Vite dev server port.
    if (!process.env.ALLOWED_ORIGINS) {
        try {
            const parsedOrigin = new URL(origin);
            return (
                (parsedOrigin.protocol === 'http:' || parsedOrigin.protocol === 'https:') &&
                parsedOrigin.port === '9055'
            );
        } catch {
            return false;
        }
    }

    return false;
};

// Configure WebSocket server with strict origin validation.
const wss = new WebSocketServer({
    server,
    verifyClient: (info) => {
        const origin = info.origin || info.req.headers.origin;
        return isOriginAllowed(origin);
    }
});

// Serve static files from dist after build
app.use(express.static(path.join(__dirname, 'dist')));

// Mirror allowed origins for HTTP endpoints.
app.use((req, res, next) => {
    const origin = req.headers.origin;
    if (isOriginAllowed(origin)) {
        res.header('Access-Control-Allow-Origin', origin);
    }
    res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');

    if (req.method === 'OPTIONS') {
        return res.sendStatus(204);
    }

    next();
});

const activeTests = {};

app.use(express.json());

app.post('/api/test/validate-id', async (req, res) => {
    const { testId } = req.body;
    if (!testId) {
        return res.status(400).json({ error: 'Test ID is required' });
    }
    try {
        const queryStr = 'SELECT * FROM conduct WHERE LOWER(code) = LOWER($1) LIMIT 1';
        const result = await db.query(queryStr, [testId.trim()]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'TestId not Found' });
        }
        return res.json({ success: true });
    } catch (err) {
        console.error('Error validating test ID:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.post('/api/test/validate-reg', async (req, res) => {
    const { testId, regNo } = req.body;
    if (!testId || !regNo) {
        return res.status(400).json({ error: 'Test ID and Registration Number are required' });
    }
    try {
        const testRes = await db.query('SELECT 1 FROM conduct WHERE LOWER(code) = LOWER($1) LIMIT 1', [testId.trim()]);
        if (testRes.rows.length === 0) {
            return res.status(404).json({ error: 'TestId not Found' });
        }
        const studentRes = await db.query('SELECT * FROM student WHERE LOWER(regno) = LOWER($1) LIMIT 1', [regNo.trim()]);
        if (studentRes.rows.length === 0) {
            return res.status(404).json({ error: 'RegNo not Found' });
        }
        return res.json({ success: true, studentName: studentRes.rows[0].sname });
    } catch (err) {
        console.error('Error validating reg no:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.get('/api/test/status', async (req, res) => {
    const { testId, regNo } = req.query;
    if (!testId || !regNo) {
        return res.status(400).json({ error: 'Test ID and Registration Number are required' });
    }
    try {
        const studentRes = await db.query('SELECT sname FROM student WHERE LOWER(regno) = LOWER($1) LIMIT 1', [regNo.trim()]);
        if (studentRes.rows.length === 0) {
            return res.status(404).json({ error: 'RegNo not Found' });
        }
        const studentName = studentRes.rows[0].sname;
        const isEnabled = !!activeTests[testId.trim().toLowerCase()];
        return res.json({
            isEnabled,
            studentName
        });
    } catch (err) {
        console.error('Error checking test status:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.post('/api/admin/toggle', async (req, res) => {
    const { testId, isEnabled } = req.body;
    if (!testId) {
        return res.status(400).json({ error: 'Test ID is required' });
    }
    try {
        const testRes = await db.query('SELECT 1 FROM conduct WHERE LOWER(code) = LOWER($1) LIMIT 1', [testId.trim()]);
        if (testRes.rows.length === 0) {
            return res.status(404).json({ error: 'TestId not Found' });
        }
        activeTests[testId.trim().toLowerCase()] = !!isEnabled;
        return res.json({ success: true, testId, isEnabled: !!isEnabled });
    } catch (err) {
        console.error('Error toggling test:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.get('/api/admin/tests', async (req, res) => {
    try {
        const result = await db.query('SELECT DISTINCT code FROM conduct');
        const tests = {};
        result.rows.forEach(row => {
            tests[row.code] = {
                isEnabled: !!activeTests[row.code.toLowerCase()]
            };
        });
        return res.json(tests);
    } catch (err) {
        console.error('Error fetching admin tests:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.get('/api/test/queries', async (req, res) => {
    const { testId } = req.query;
    if (!testId) {
        return res.status(400).json({ error: 'Test ID is required' });
    }
    try {
        const testRes = await db.query('SELECT testid FROM conduct WHERE LOWER(code) = LOWER($1) LIMIT 1', [testId.trim()]);
        if (testRes.rows.length === 0) {
            return res.status(404).json({ error: 'TestId not Found' });
        }
        const testIdVal = testRes.rows[0].testid;

        const queryRes = await db.query('SELECT qid, query FROM query WHERE testid = $1 ORDER BY qid', [testIdVal]);
        const tasks = queryRes.rows.map((row, index) => ({
            id: row.qid,
            label: `#${index + 1}:`,
            text: row.query,
            defaultSql: ""
        }));

        return res.json(tasks);
    } catch (err) {
        console.error('Error fetching queries:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.post('/api/test/start', async (req, res) => {
    const { testId, regNo } = req.body;
    if (!testId || !regNo) {
        return res.status(400).json({ error: 'Test ID and Registration Number are required' });
    }
    try {
        const conductRes = await db.query('SELECT cid FROM conduct WHERE LOWER(code) = LOWER($1) LIMIT 1', [testId.trim()]);
        if (conductRes.rows.length === 0) {
            return res.status(404).json({ error: 'Test session not found' });
        }
        const cid = conductRes.rows[0].cid;

        const studentRes = await db.query('SELECT 1 FROM student WHERE LOWER(regno) = LOWER($1) LIMIT 1', [regNo.trim()]);
        if (studentRes.rows.length === 0) {
            return res.status(404).json({ error: 'Student registration not found' });
        }

        // Check if an attempt for this student in this conduct session already exists
        const existingAttempt = await db.query(
            'SELECT attid FROM attempt WHERE cid = $1 AND LOWER(regno) = LOWER($2) LIMIT 1',
            [cid, regNo.trim()]
        );
        if (existingAttempt.rows.length > 0) {
            const attid = existingAttempt.rows[0].attid;
            return res.json({ success: true, attid });
        }

        const attemptRes = await db.query(
            'INSERT INTO attempt (cid, regno, query) VALUES ($1, $2, $3) RETURNING attid',
            [cid, regNo.trim(), '']
        );
        const attid = attemptRes.rows[0].attid;

        await db.query(
            'INSERT INTO result (attid, status) VALUES ($1, $2)',
            [attid, 'STARTED']
        );

        return res.json({ success: true, attid });
    } catch (err) {
        console.error('Error starting test attempt:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.post('/api/test/save-result', async (req, res) => {
    const { attid, qid, query, marks } = req.body;
    if (!attid || !qid) {
        return res.status(400).json({ error: 'attid and qid are required' });
    }
    try {
        const queryStr = `
            INSERT INTO result (attid, qid, query, marks, status)
            VALUES ($1, $2, $3, $4, 'EXECUTED')
            ON CONFLICT (attid, qid)
            DO UPDATE SET query = EXCLUDED.query, marks = EXCLUDED.marks, status = EXCLUDED.status
            RETURNING *;
        `;
        const result = await db.query(queryStr, [
            attid,
            qid,
            query || '',
            marks !== undefined ? marks : 0
        ]);
        return res.json({ success: true, result: result.rows[0] });
    } catch (err) {
        console.error('Error saving result:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.get('/api/test/results', async (req, res) => {
    const { attid } = req.query;
    if (!attid) {
        return res.status(400).json({ error: 'attid is required' });
    }
    try {
        const resultRes = await db.query(
            "SELECT r.query, q.qid, q.query as question_text FROM result r LEFT JOIN query q ON r.qid = q.qid WHERE r.attid = $1 AND r.status = 'EXECUTED' ORDER BY q.qid",
            [attid]
        );
        return res.json(resultRes.rows);
    } catch (err) {
        console.error('Error fetching test results:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});


wss.on('connection', (ws) => {
    console.log('Client connected');

    // Create terminal with larger initial size - spawns a pg18-client container
    const ptyProcess = pty.spawn('docker', ['run', '-it', '--rm', '--add-host=host.docker.internal:host-gateway', '-e', 'PGPASSWORD=Po@995886', 'pg18-client', 'psql', '-h', 'host.docker.internal', '-U', 'postgres', '-d', 'spj', '-P', 'pager=off'], {
        name: 'xterm-256color',
        cols: 120,
        rows: 40,
        cwd: process.env.HOME,
        env: {
            ...process.env,
            TERM: 'xterm-256color',
            PGPASSWORD: 'Po@995886'
        }
    });

    // Handle incoming data from client
    ws.on('message', (data) => {
        try {
            const message = JSON.parse(data);

            if (message.type === 'input') {
                ptyProcess.write(message.data);
            } else if (message.type === 'resize') {
                ptyProcess.resize(message.cols, message.rows);
            }
        } catch (err) {
            console.error('Error processing message:', err);
        }
    });

    // Send terminal output to client
    ptyProcess.onData((data) => {
        if (ws.readyState === WebSocket.OPEN) {
            try {
                ws.send(JSON.stringify({ type: 'output', data }));
            } catch (err) {
                console.error('Error sending data:', err);
            }
        }
    });

    // Clean up on close
    ws.on('close', () => {
        try {
            ptyProcess.kill();
            console.log('Client disconnected');
        } catch (err) {
            console.error('Error closing pty:', err);
        }
    });
});

const port = process.env.PORT || 3001;
server.listen(port, '0.0.0.0', () => {
    const wsScheme = secure ? 'wss' : 'ws';
    console.log(`Terminal server running on port ${port} (${wsScheme})`);
    if (!secure) {
        console.warn('TLS is not configured. Set TLS_KEY_PATH and TLS_CERT_PATH to enable secure WebSocket (wss).');
    }
});