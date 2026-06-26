import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import mkcert from 'vite-plugin-mkcert';

export default defineConfig({
  plugins: [
    react(),
    mkcert({
      force: true, // Forces regeneration of the certificate to clear stale cached certs
      hosts: ['localhost', '127.0.0.1'] // Add custom domain names here if you are using any
    })
  ],
  server: {
    port: 9055,
    host: true,
    https: true,
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
