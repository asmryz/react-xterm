import React, { useEffect, useRef, forwardRef, useImperativeHandle } from 'react'
import { Terminal as XTerm } from 'xterm'
import { FitAddon } from 'xterm-addon-fit'
import { WebLinksAddon } from 'xterm-addon-web-links'
import 'xterm/css/xterm.css'

const RECONNECT_DELAY_MS = 3000

function getTerminalWebSocketUrl() {
  // Allow explicit override via Vite env for reverse proxies/custom endpoints.
  const configuredUrl = import.meta.env.VITE_TERMINAL_WS_URL
  if (configuredUrl) {
    return configuredUrl
  }

  if (import.meta.env.DEV) {
    const protocol = window.location.protocol === 'https:' ? 'wss' : 'ws'
    return `${protocol}://${window.location.host}/terminal-ws`
  }

  const forceSecureWs = import.meta.env.VITE_TERMINAL_WS_SECURE === 'true'
  const isHttpsPage = window.location.protocol === 'https:'
  const protocol = isHttpsPage || forceSecureWs ? 'wss' : 'ws'
  return `${protocol}://${window.location.hostname}:3001`
}

const Terminal = forwardRef((props, ref) => {
  const terminalRef = useRef(null)
  const termInstanceRef = useRef(null)
  const wsRef = useRef(null)
  const [status, setStatus] = React.useState('connecting')
  const [error, setError] = React.useState(null)

  // Expose methods to parent component
  useImperativeHandle(ref, () => ({
    sendCommand: (command) => {
      if (!wsRef.current || wsRef.current.readyState !== WebSocket.OPEN) {
        console.error('WebSocket is not open')
        return
      }
      try {
        wsRef.current.send(JSON.stringify({ 
          type: 'input', 
          data: command + '\n' 
        }))
        console.log('Command sent:', command)
      } catch (err) {
        console.error('Error sending command:', err)
      }
    },
    getTerminalText: () => {
      if (!termInstanceRef.current) return ''
      const term = termInstanceRef.current
      const buffer = term.buffer.active
      let text = ''
      for (let i = 0; i < buffer.length; i++) {
        const line = buffer.getLine(i)
        if (line) {
          text += line.translateToString(true) + '\n'
        }
      }
      return text.trim()
    },
    clearTerminal: () => {
      if (termInstanceRef.current) {
        termInstanceRef.current.clear()
      }
      if (wsRef.current && wsRef.current.readyState === WebSocket.OPEN) {
        try {
          wsRef.current.send(JSON.stringify({ 
            type: 'input', 
            data: '\x0c' 
          }))
        } catch (err) {
          console.error('Error sending clear command:', err)
        }
      }
    }
  }))

  useEffect(() => {
    const term = new XTerm({
      cursorBlink: true,
      theme: {
        background: '#0f1724',
        foreground: '#e6eef6'
      },
      fontSize: 14,
      fontFamily: 'Menlo, Monaco, "Courier New", monospace'
    })
    termInstanceRef.current = term

    const fitAddon = new FitAddon()
    const webLinks = new WebLinksAddon()
    
    term.loadAddon(fitAddon)
    term.loadAddon(webLinks)

    // Open terminal in the container
    term.open(terminalRef.current)
    fitAddon.fit()

    // Watch for container resize (e.g., when divider is dragged)
    let resizeTimeout
    const resizeObserver = new ResizeObserver(() => {
      clearTimeout(resizeTimeout)
      resizeTimeout = setTimeout(() => {
        try {
          fitAddon.fit()
          // Send new dimensions to server
          sendResize()
        } catch (err) {
          console.error('Error fitting terminal:', err)
        }
      }, 50)
    })

    if (terminalRef.current) {
      resizeObserver.observe(terminalRef.current)
    }

    const wsUrl = getTerminalWebSocketUrl()
    let reconnectTimer = null
    let isDisposed = false

    const sendResize = () => {
      if (!wsRef.current || wsRef.current.readyState !== WebSocket.OPEN) {
        return
      }

      wsRef.current.send(JSON.stringify({
        type: 'resize',
        cols: term.cols,
        rows: term.rows
      }))
    }

    const connect = () => {
      if (isDisposed) {
        return
      }

      const socket = new WebSocket(wsUrl)
      wsRef.current = socket
      setStatus('connecting')

      socket.addEventListener('open', () => {
        if (isDisposed) {
          socket.close()
          return
        }

        setStatus('connected')
        setError(null)
        term.clear()
        sendResize()
      })

      socket.addEventListener('message', (ev) => {
        try {
          const msg = JSON.parse(ev.data)
          if (msg.type === 'output') {
            term.write(msg.data)
          }
        } catch (err) {
          console.error('Failed to parse message:', err)
          term.write(ev.data)
        }
      })

      socket.addEventListener('error', (event) => {
        console.error('WebSocket error:', event)
        setError('Failed to connect to terminal server')
        setStatus('error')
      })

      socket.addEventListener('close', () => {
        if (isDisposed) {
          return
        }

        setStatus('disconnected')
        term.write('\r\n\nConnection closed. Attempting to reconnect...\r\n')

        reconnectTimer = setTimeout(() => {
          connect()
        }, RECONNECT_DELAY_MS)
      })
    }

    connect()

    // Handle terminal input
    term.onData(data => {
      if (wsRef.current && wsRef.current.readyState === WebSocket.OPEN) {
        wsRef.current.send(JSON.stringify({ type: 'input', data }))
      }
    })

    // Handle window resize
    const handleResize = () => {
      fitAddon.fit()
      sendResize()
    }

    window.addEventListener('resize', handleResize)

    // Do initial fit
    handleResize()

    // Cleanup
    return () => {
      isDisposed = true
      window.removeEventListener('resize', handleResize)
      clearTimeout(resizeTimeout)
      clearTimeout(reconnectTimer)
      resizeObserver.disconnect()
      if (wsRef.current) {
        wsRef.current.close()
      }
      term.dispose()
      termInstanceRef.current = null
    }
  }, [])

  return (
    <div className="terminal-wrapper">
      <div className="terminal-container" ref={terminalRef} />
    </div>
  )
})

Terminal.displayName = 'Terminal'

export default Terminal