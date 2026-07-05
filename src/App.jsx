import React, { useState, useRef, useEffect } from 'react'
import Terminal from './Terminal'
import Query from './Query'
import './App.css'

const initialTasks = [
    {
        id: 1,
        label: 'Q1:',
        text: 'Show all courses sorted cid wise. alonf with all CLOs and CSLO',
        defaultSql: 'SELECT c.cid, c.code, c.title, cl.clo, cl.statment\nFROM course c\nLEFT JOIN clo cl ON c.cid = cl.cid\nORDER BY c.cid;'
    },
    {
        id: 2,
        label: 'Q2:',
        text: 'List all courses with theory hours greater than 2',
        defaultSql: 'SELECT * \nFROM course \nWHERE theory > 2;'
    },
    {
        id: 3,
        label: 'Q3:',
        text: 'Find all CLOs for the course with cid = 1',
        defaultSql: 'SELECT * \nFROM clo \nWHERE cid = 1;'
    },
    {
        id: 4,
        label: 'Q4:',
        text: 'Count the total number of CLOs for each course',
        defaultSql: 'SELECT cid, COUNT(*)\nFROM clo\nGROUP BY cid;'
    },
    {
        id: 5,
        label: 'Q5:',
        text: 'List all courses that do not have any CLOs assigned',
        defaultSql: 'SELECT * \nFROM course c\nWHERE NOT EXISTS (\n  SELECT 1 FROM clo cl WHERE cl.cid = c.cid\n);'
    }
]

export default function App() {
    const [dividerPos, setDividerPos] = useState(35)
    const [isDragging, setIsDragging] = useState(false)
    const [queries, setQueries] = useState(
        initialTasks.map((t) => t.defaultSql)
    )
    const terminalRef = useRef(null)
    const [copied, setCopied] = useState(false)
    const [activeIndex, setActiveIndex] = useState(0)

    const handleMouseDown = () => {
        setIsDragging(true)
    }

    const handleMouseUp = () => {
        setIsDragging(false)
    }

    const handleRunQuery = (index) => {
        if (terminalRef.current && terminalRef.current.sendCommand) {
            const cleanQuery = queries[index].trim()
            if (cleanQuery) {
                if (terminalRef.current.clearTerminal) {
                    terminalRef.current.clearTerminal()
                }
                terminalRef.current.sendCommand(cleanQuery)
            }
        }
    }

    const handleQueryChange = (index, val) => {
        setQueries((prev) => {
            const updated = [...prev]
            updated[index] = val
            return updated
        })
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

    const runQueryRef = useRef(() => handleRunQuery(activeIndex))
    useEffect(() => {
        runQueryRef.current = () => handleRunQuery(activeIndex)
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
                </div>
                <div className="queries-scroll-container">
                    {initialTasks.map((task, index) => (
                        <div
                            key={task.id}
                            onClick={() => setActiveIndex(index)}
                            style={{
                                display: 'flex',
                                flexDirection: 'column',
                                border: activeIndex === index ? '1px solid #3b82f6' : '1px solid #e2e8f0',
                                borderRadius: '8px',
                                overflow: 'hidden',
                                backgroundColor: '#ffffff',
                                boxShadow: activeIndex === index ? '0 4px 12px rgba(59, 130, 246, 0.08)' : '0 1px 3px rgba(0, 0, 0, 0.05)',
                                transition: 'all 0.2s ease'
                            }}
                        >
                            <Query
                                label={task.label}
                                text={task.text}
                                value={queries[index]}
                                onChange={(val) => handleQueryChange(index, val)}
                                onRun={() => handleRunQuery(index)}
                            />
                        </div>
                    ))}
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
