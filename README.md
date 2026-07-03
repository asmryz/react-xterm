# react-xterm

This is a minimal Vite + React demo that wraps xterm.js in a React component.

Quick start:

```bash
sudo apt update
sudo apt install -y mkcert libnss3-tools
mkcert -install
```

1. Install dependencies

```bash
npm install
```

2. Run development server

```bash
npm run dev
```

```bash
\pset border 2
\pset linestyle unicode
\x auto
``` 

3. Open the printed URL (usually http://localhost:5173)

What you'll find:

- `src/Terminal.jsx` — a small React wrapper around xterm.js using the Fit addon.

Notes:

- This is intentionally minimal. If you have an existing non-React terminal implementation to convert, share the files and I'll migrate specific behaviors into the `Terminal` component.
