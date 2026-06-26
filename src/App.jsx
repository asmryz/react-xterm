import React, { useState, useRef, useEffect } from 'react'
import Editor from '@monaco-editor/react'
import Terminal from './Terminal'
import './App.css'

export default function App() {
    const [dividerPos, setDividerPos] = useState(50)
    const [isDragging, setIsDragging] = useState(false)
    const [query, setQuery] = useState(
        'SELECT * \nFROM course;\n'
    )
    const terminalRef = useRef(null)
    const [copied, setCopied] = useState(false)

    const handleMouseDown = () => {
        setIsDragging(true)
    }

    const handleMouseUp = () => {
        setIsDragging(false)
    }

    const handleRunQuery = () => {
        if (terminalRef.current && terminalRef.current.sendCommand) {
            const cleanQuery = query.trim()
            if (cleanQuery) {
                if (terminalRef.current.clearTerminal) {
                    terminalRef.current.clearTerminal()
                }
                terminalRef.current.sendCommand(cleanQuery)
            }
        }
    }

    const handleClearQuery = () => {
        setQuery('')
    }

    const handleCopyTerminalOutput = () => {
        if (terminalRef.current && terminalRef.current.getTerminalText) {
            const text = terminalRef.current.getTerminalText()
            if (text) {
                navigator.clipboard.writeText(text)
                    .then(() => {
                        setCopied(true)
                        setTimeout(() => setCopied(false), 2000)
                    })
                    .catch((err) => {
                        console.error('Failed to copy text: ', err)
                    })
            }
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

    const runQueryRef = useRef(handleRunQuery)
    useEffect(() => {
        runQueryRef.current = handleRunQuery
    })

    useEffect(() => {
        const handleKeyDown = (e) => {
            if (e.key === 'F5') {
                e.preventDefault()
                runQueryRef.current()
            }
        }
        window.addEventListener('keydown', handleKeyDown)
        return () => {
            window.removeEventListener('keydown', handleKeyDown)
        }
    }, [])

    useEffect(() => {
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
                <div className="panel-header">
                    <div className="header-title">
                        <svg className="db-icon" viewBox="0 0 24 24" width="16" height="16">
                            <path
                                fill="currentColor"
                                d="M12,3C7.58,3 4,4.79 4,7C4,9.21 7.58,11 12,11C16.42,11 20,9.21 20,7C20,4.79 16.42,3 12,3M4,9V12C4,14.21 7.58,16 12,16C16.42,16 20,14.21 20,12V9C20,11.21 16.42,13 12,13C7.58,13 4,11.21 4,9M4,14V17C4,19.21 7.58,21 12,21C16.42,21 20,19.21 20,17V14C20,16.21 16.42,18 12,18C7.58,18 4,16.21 4,14Z"
                            />
                        </svg>
                        <span>SQL QUERY EDITOR</span>
                    </div>
                    <div className="header-actions">
                        <button className="btn btn-clear" onClick={handleClearQuery}>
                            Clear
                        </button>
                        <button className="btn btn-run" onClick={handleRunQuery}>
                            <span className="play-icon">▶</span> Run Query
                        </button>
                    </div>
                </div>
                <div className="editor-container">
                    <Editor
                        height="100%"
                        language="sql"
                        theme="light"
                        value={query}
                        onChange={(val) => setQuery(val || '')}
                        options={{
                            minimap: { enabled: false },
                            fontSize: 14,
                            fontFamily: 'Menlo, Monaco, "Courier New", monospace',
                            automaticLayout: true,
                            scrollBeyondLastLine: false,
                            tabSize: 2,
                            wordWrap: 'on',
                            lineNumbersMinChars: 3,
                            padding: { top: 12, bottom: 12 }
                        }}
                    />
                </div>
            </div>

            <div className="divider" onMouseDown={handleMouseDown} />

            <div className="right-panel" style={{ width: `${100 - dividerPos}%` }}>
                <div className="panel-header">
                    <div className="header-title">
                        <svg className="terminal-icon" viewBox="0 0 24 24" width="16" height="16">
                            <path
                                fill="currentColor"
                                d="M20,19H4A2,2 0 0,1 2,17V7A2,2 0 0,1 4,5H20A2,2 0 0,1 22,7V17A2,2 0 0,1 20,19M4,7V17H20V7H4M18,10H14V12H18V10M12,10H10V12H12V10M8,10H6V12H8V10Z"
                            />
                        </svg>
                        <span>INTERACTIVE TERMINAL (PSQL)</span>
                    </div>
                    <div className="header-actions">
                        <button className="btn btn-clear" onClick={handleCopyTerminalOutput}>
                            {copied ? '✓ Copied' : 'Copy Output'}
                        </button>
                    </div>
                </div>
                <div className="terminal-content">
                    <Terminal ref={terminalRef} />
                </div>
            </div>
        </div>
    )
}
