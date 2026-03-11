import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import fs from 'fs';
import path from 'path';

const tlsKeyPath = path.resolve('./TLS/server.key');
const tlsCertPath = path.resolve('./TLS/server.crt');
const hasDevTls = fs.existsSync(tlsKeyPath) && fs.existsSync(tlsCertPath);

export default defineConfig({
  plugins: [react()],
  server: {
    port: 9055,
    host: true,
    https: hasDevTls
      ? {
          key: fs.readFileSync(tlsKeyPath),
          cert: fs.readFileSync(tlsCertPath)
        }
      : undefined,
    proxy: {
      '/terminal-ws': {
        target: 'https://localhost:3001',
        ws: true,
        changeOrigin: true,
        secure: false
      }
    }
  },
  build: {
    outDir: 'dist',
    rollupOptions: {
      input: {
        main: './index.html'
      }
    }
  },
  optimizeDeps: {
    include: ['react', 'react-dom', 'xterm', 'xterm-addon-fit', 'xterm-addon-web-links']
  }
});
