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

wss.on('connection', (ws) => {
    console.log('Client connected');

    // Create terminal with larger initial size - spawns a pg18-client container
    const ptyProcess = pty.spawn('docker', ['run', '-it', '--rm', '--add-host=host.docker.internal:host-gateway', '-e', 'PGPASSWORD=Aa20195@1', 'pg18-client', 'psql', '-h', 'host.docker.internal', '-U', 'postgres', '-d', 'obe', '-P', 'pager=off'], {
        name: 'xterm-256color',
        cols: 120,
        rows: 40,
        cwd: process.env.HOME,
        env: {
            ...process.env,
            TERM: 'xterm-256color',
            PGPASSWORD: 'Aa20195@1'
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