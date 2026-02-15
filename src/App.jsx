import React, { useState, useRef } from 'react'
import Terminal from './Terminal'
import './App.css'

export default function App() {
  const [dividerPos, setDividerPos] = useState(50)
  const [isDragging, setIsDragging] = useState(false)
  const terminalRef = useRef(null)

  const handleMouseDown = () => {
    setIsDragging(true)
  }

  const handleMouseUp = () => {
    setIsDragging(false)
  }

  const handleCommandClick = (command) => {
    if (terminalRef.current && terminalRef.current.sendCommand) {
      terminalRef.current.sendCommand(command)
    }
  }

  const handleMouseMove = (e) => {
    if (!isDragging) return

    const container = document.querySelector('.app-container')
    if (!container) return

    const rect = container.getBoundingClientRect()
    const newPos = ((e.clientX - rect.left) / rect.width) * 100
    
    // Constrain between 20% and 80%
    if (newPos >= 20 && newPos <= 80) {
      setDividerPos(newPos)
    }
  }

  React.useEffect(() => {
    if (isDragging) {
      document.addEventListener('mousemove', handleMouseMove)
      document.addEventListener('mouseup', handleMouseUp)
      return () => {
        document.removeEventListener('mousemove', handleMouseMove)
        document.removeEventListener('mouseup', handleMouseUp)
      }
    }
  }, [isDragging])

  return (
    <div className="app-container">
      <div className="left-panel" style={{ width: `${dividerPos}%` }}>
        <div className="panel-content">
          <h3>Commands</h3>
          <a 
            href="#" 
            className="command-link"
            onClick={(e) => {
              e.preventDefault()
              handleCommandClick('ls')
            }}
          >
            ls
          </a>
        </div>
      </div>

      <div className="divider" onMouseDown={handleMouseDown} />

      <div className="right-panel" style={{ width: `${100 - dividerPos}%` }}>
        <Terminal ref={terminalRef} />
      </div>
    </div>
  )
}
