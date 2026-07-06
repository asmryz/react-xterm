import React, { useState, useRef, useEffect } from 'react'
import Terminal from './Terminal'
import Query from './Query'
import './App.css'



export default function App() {
    // Auth and Step states
    const [step, setStep] = useState('testId') // 'testId' | 'regNo' | 'start' | 'test'
    const [testId, setTestId] = useState('')
    const [regNo, setRegNo] = useState('')
    const [studentName, setStudentName] = useState('')
    const [isEnabled, setIsEnabled] = useState(false)
    const [authError, setAuthError] = useState('')
    const [inputVal, setInputVal] = useState('')
    const [copiedText, setCopiedText] = useState(false)
    const [attemptId, setAttemptId] = useState(null)

    // Admin Controls floating state
    const [adminOpen, setAdminOpen] = useState(false)
    const [adminTests, setAdminTests] = useState({})

    // Panel layout & queries state
    const [dividerPos, setDividerPos] = useState(35)
    const [isDragging, setIsDragging] = useState(false)
    const [tasks, setTasks] = useState([])
    const [queries, setQueries] = useState([])
    const terminalRef = useRef(null)
    const [copied, setCopied] = useState(false)
    const [activeIndex, setActiveIndex] = useState(0)

    const [submissionsOpen, setSubmissionsOpen] = useState(false)
    const [submissions, setSubmissions] = useState([])
    const [loadingSubmissions, setLoadingSubmissions] = useState(false)

    const handleShowSubmissions = async () => {
        if (!attemptId) return
        setSubmissionsOpen(true)
        setLoadingSubmissions(true)
        try {
            const res = await fetch(`/api/test/results?attid=${attemptId}`)
            if (res.ok) {
                const data = await res.json()
                setSubmissions(data)
            }
        } catch (err) {
            console.error('Failed to fetch submissions:', err)
        } finally {
            setLoadingSubmissions(false)
        }
    }

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

                // Capture output after execution and save/update in database
                const qid = tasks[index]?.id
                const attid = attemptId
                if (qid && attid) {
                    setTimeout(async () => {
                        if (terminalRef.current && terminalRef.current.getTerminalText) {
                            const rawText = terminalRef.current.getTerminalText()
                            const cleanedOutput = rawText.replace(/^.*?[=-]#\s?/gm, '')
                            try {
                                await fetch('/api/test/save-result', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json' },
                                    body: JSON.stringify({
                                        attid,
                                        qid,
                                        query: cleanedOutput,
                                        marks: 0
                                    })
                                })
                            } catch (err) {
                                console.error('Error saving query output:', err)
                            }
                        }
                    }, 1000)
                }
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
            if (e.key === 'F9' && step === 'test') {
                e.preventDefault()
                runQueryRef.current()
            }
        }
        window.addEventListener('keydown', handleKeyDown)
        return () => {
            window.removeEventListener('keydown', handleKeyDown)
        }
    }, [step])

    useEffect(() => {
        if (isDragging) {
            document.addEventListener('mousemove', handleMouseMove)
            document.addEventListener('mouseup', handleMouseUp)
            return () => {
                document.removeMouseMoveListener = () => {
                    document.removeEventListener('mousemove', handleMouseMove)
                }
                document.removeEventListener('mousemove', handleMouseMove)
                document.removeEventListener('mouseup', handleMouseUp)
            }
        }
    }, [isDragging])

    // API Handlers for verification
    const handleVerifyTestId = async (e) => {
        if (e) e.preventDefault()
        if (!inputVal.trim()) return
        setAuthError('')
        try {
            const res = await fetch('/api/test/validate-id', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ testId: inputVal.trim() })
            })
            if (res.ok) {
                setTestId(inputVal.trim())
                setInputVal('')
                setStep('regNo')
            } else {
                const data = await res.json()
                setAuthError(data.error || 'TestId not Found')
            }
        } catch (err) {
            setAuthError('Connection Error')
        }
    }

    const handleVerifyRegNo = async (e) => {
        if (e) e.preventDefault()
        if (!inputVal.trim()) return
        setAuthError('')
        try {
            const res = await fetch('/api/test/validate-reg', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ testId, regNo: inputVal.trim() })
            })
            if (res.ok) {
                const data = await res.json()
                setRegNo(inputVal.trim())
                setStudentName(data.studentName)
                setInputVal('')
                setStep('start')
            } else {
                const data = await res.json()
                setAuthError(data.error || 'RegNo not Found')
            }
        } catch (err) {
            setAuthError('Connection Error')
        }
    }

    const checkTestStatus = async () => {
        if (!testId || !regNo) return
        try {
            const res = await fetch(`/api/test/status?testId=${encodeURIComponent(testId)}&regNo=${encodeURIComponent(regNo)}`)
            if (res.ok) {
                const data = await res.json()
                setIsEnabled(data.isEnabled)
                if (data.studentName) {
                    setStudentName(data.studentName)
                }
            }
        } catch (err) {
            console.error('Error checking status:', err)
        }
    }

    // Polling logic when waiting to start
    useEffect(() => {
        if (step === 'start') {
            checkTestStatus()
            const interval = setInterval(checkTestStatus, 2000)
            return () => clearInterval(interval)
        }
    }, [step, testId, regNo])

    const fetchQueries = async (tId) => {
        try {
            const res = await fetch(`/api/test/queries?testId=${encodeURIComponent(tId)}`)
            if (res.ok) {
                const data = await res.json()
                setTasks(data)
                setQueries(data.map(t => t.defaultSql))
            }
        } catch (err) {
            console.error('Error fetching queries:', err)
        }
    }

    const handleStartTest = async () => {
        try {
            setAuthError('')
            const res = await fetch('/api/test/start', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ testId, regNo })
            })
            if (res.ok) {
                const data = await res.json()
                setAttemptId(data.attid)
                setStep('test')
            } else {
                const data = await res.json()
                setAuthError(data.error || 'Failed to start test.')
            }
        } catch (err) {
            setAuthError('Connection Error')
        }
    }

    useEffect(() => {
        if (step === 'test' && testId) {
            fetchQueries(testId)
        }
    }, [step, testId])

    // Admin Control Actions
    const fetchAdminTests = async () => {
        try {
            const res = await fetch('/api/admin/tests')
            if (res.ok) {
                const data = await res.json()
                setAdminTests(data)
            }
        } catch (err) {
            console.error('Error fetching admin tests:', err)
        }
    }

    const handleToggleTest = async (tId, currentEnabled) => {
        try {
            const res = await fetch('/api/admin/toggle', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ testId: tId, isEnabled: !currentEnabled })
            })
            if (res.ok) {
                fetchAdminTests()
                checkTestStatus()
            }
        } catch (err) {
            console.error('Error toggling test:', err)
        }
    }

    const isAdmin = window.location.pathname === '/admin'

    useEffect(() => {
        if (adminOpen || isAdmin) {
            fetchAdminTests()
            const interval = setInterval(fetchAdminTests, 3000)
            return () => clearInterval(interval)
        }
    }, [adminOpen, isAdmin])

    const handleCopyTestText = () => {
        const textToCopy = queries.map((query, index) => {
            const task = tasks[index]
            return `--- ${task.label} ${task.text} ---\n${query}\n`
        }).join('\n')

        const fullText = `Student: ${studentName}\nReg No: ${regNo}\nTest ID: ${testId}\n\n${textToCopy}`

        navigator.clipboard.writeText(fullText)
            .then(() => {
                setCopiedText(true)
                setTimeout(() => setCopiedText(false), 2000)
            })
            .catch((err) => {
                console.error('Failed to copy text: ', err)
            })
    }

    const renderAdminWidget = () => {
        return (
            <div className="admin-widget" style={{ height: adminOpen ? 'auto' : '40px', overflow: 'hidden' }}>
                <div className="admin-widget-header" onClick={() => setAdminOpen(!adminOpen)}>
                    <span>⚙️ Admin Controls</span>
                    <span>{adminOpen ? '▼' : '▲'}</span>
                </div>
                {adminOpen && (
                    <div className="admin-widget-content">
                        {Object.keys(adminTests).length === 0 ? (
                            <div style={{ fontSize: '11px', color: '#6b7280' }}>Loading tests...</div>
                        ) : (
                            Object.entries(adminTests).map(([tId, test]) => (
                                <div key={tId} className="admin-test-row">
                                    <span style={{ fontWeight: '600' }}>{tId}</span>
                                    <button
                                        onClick={() => handleToggleTest(tId, test.isEnabled)}
                                        className={`admin-toggle-btn ${test.isEnabled ? 'active' : ''}`}
                                    >
                                        {test.isEnabled ? 'Enabled' : 'Disabled'}
                                    </button>
                                </div>
                            ))
                        )}
                        <div style={{ fontSize: '10px', color: '#6b7280', marginTop: '4px', textAlign: 'center' }}>
                            Toggle status to test real-time activation
                        </div>
                    </div>
                )}
            </div>
        )
    }

    if (isAdmin) {
        return (
            <div className="test-auth-container" style={{ flexDirection: 'column', height: '100vh', justifyContent: 'flex-start', padding: '40px', overflowY: 'auto' }}>
                <div style={{ maxWidth: '800px', width: '100%', display: 'flex', flexDirection: 'column', gap: '24px' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '16px' }}>
                        <div>
                            <h1 style={{ margin: 0, fontSize: '28px', fontWeight: '800', color: '#0f172a' }}>Admin Dashboard</h1>
                            <p style={{ margin: '4px 0 0 0', color: '#64748b', fontSize: '14px' }}>Control active tests and verify settings</p>
                        </div>
                        <a href="/" style={{ background: '#2563eb', color: '#fff', border: 'none', padding: '10px 20px', borderRadius: '8px', textDecoration: 'none', fontSize: '14px', fontWeight: '700' }}>
                            Go to Student Page
                        </a>
                    </div>

                    {/* Metrics row */}
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '16px' }}>
                        <div style={{ background: '#fff', padding: '20px', borderRadius: '12px', border: '1px solid rgba(0,0,0,0.06)', boxShadow: '0 4px 6px rgba(0,0,0,0.02)' }}>
                            <span style={{ fontSize: '11px', color: '#64748b', fontWeight: '700', textTransform: 'uppercase', letterSpacing: '0.5px' }}>Total Registered Tests</span>
                            <h2 style={{ fontSize: '32px', margin: '8px 0 0 0', color: '#0f172a', fontWeight: '800' }}>
                                {Object.keys(adminTests).length}
                            </h2>
                        </div>
                        <div style={{ background: '#fff', padding: '20px', borderRadius: '12px', border: '1px solid rgba(0,0,0,0.06)', boxShadow: '0 4px 6px rgba(0,0,0,0.02)' }}>
                            <span style={{ fontSize: '11px', color: '#64748b', fontWeight: '700', textTransform: 'uppercase', letterSpacing: '0.5px' }}>Active Tests</span>
                            <h2 style={{ fontSize: '32px', margin: '8px 0 0 0', color: '#10b981', fontWeight: '800' }}>
                                {Object.values(adminTests).filter(t => t.isEnabled).length}
                            </h2>
                        </div>
                    </div>

                    {/* Test controller panel */}
                    <div style={{ background: '#fff', padding: '30px', borderRadius: '16px', border: '1px solid rgba(0,0,0,0.06)', boxShadow: '0 10px 25px rgba(0,0,0,0.03)' }}>
                        <h3 style={{ margin: '0 0 20px 0', fontSize: '18px', color: '#0f172a', fontWeight: '700' }}>Test List & Toggles</h3>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                            {Object.keys(adminTests).length === 0 ? (
                                <div style={{ color: '#64748b', textAlign: 'center', padding: '20px' }}>Loading tests...</div>
                            ) : (
                                Object.entries(adminTests).map(([tId, test]) => (
                                    <div key={tId} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '16px', borderRadius: '10px', background: '#f8fafc', border: '1px solid #e2e8f0' }}>
                                        <div>
                                            <strong style={{ fontSize: '16px', color: '#0f172a' }}>{tId}</strong>
                                            <span style={{ display: 'block', fontSize: '12px', color: '#64748b', marginTop: '2px' }}>Status: {test.isEnabled ? 'Active' : 'Inactive'}</span>
                                        </div>
                                        <button
                                            onClick={() => handleToggleTest(tId, test.isEnabled)}
                                            style={{
                                                background: test.isEnabled ? '#10b981' : '#64748b',
                                                color: '#fff',
                                                border: 'none',
                                                padding: '8px 16px',
                                                borderRadius: '6px',
                                                fontWeight: '700',
                                                cursor: 'pointer',
                                                transition: 'all 0.2s ease',
                                                boxShadow: test.isEnabled ? '0 4px 10px rgba(16, 185, 129, 0.2)' : 'none'
                                            }}
                                        >
                                            {test.isEnabled ? 'Disable' : 'Enable'}
                                        </button>
                                    </div>
                                ))
                            )}
                        </div>
                    </div>
                </div>
            </div>
        )
    }

    if (step === 'testId') {
        return (
            <div className="test-auth-container">
                <div className="test-auth-card">
                    <h2 className="test-auth-title">Online SQL Test</h2>
                    <p className="test-auth-subtitle">Please enter your Test ID to continue</p>

                    {authError && <div className="test-auth-error">{authError}</div>}

                    <form onSubmit={handleVerifyTestId}>
                        <div className="test-auth-group">
                            <label className="test-auth-label">Test ID</label>
                            <input
                                type="text"
                                className="test-auth-input"
                                placeholder="e.g. T101"
                                value={inputVal}
                                onChange={(e) => setInputVal(e.target.value)}
                                autoFocus
                                required
                            />
                        </div>
                        <button type="submit" className="test-auth-btn">
                            Next
                        </button>
                    </form>
                </div>
                {renderAdminWidget()}
            </div>
        )
    }

    if (step === 'regNo') {
        return (
            <div className="test-auth-container">
                <div className="test-auth-card">
                    <h2 className="test-auth-title">Student Registration</h2>
                    <p className="test-auth-subtitle">Test ID: <strong style={{ color: '#60a5fa' }}>{testId}</strong></p>

                    {authError && <div className="test-auth-error">{authError}</div>}

                    <form onSubmit={handleVerifyRegNo}>
                        <div className="test-auth-group">
                            <label className="test-auth-label">Registration Number</label>
                            <input
                                type="text"
                                className="test-auth-input"
                                placeholder="e.g. 2022-CS-101"
                                value={inputVal}
                                onChange={(e) => setInputVal(e.target.value)}
                                autoFocus
                                required
                            />
                        </div>
                        <button type="submit" className="test-auth-btn">
                            Verify & Continue
                        </button>
                    </form>
                </div>
                {renderAdminWidget()}
            </div>
        )
    }

    if (step === 'start') {
        return (
            <div className="test-auth-container">
                <div className="test-auth-card">
                    <h2 className="test-auth-title">Test Details</h2>
                    <p className="test-auth-subtitle">Verify your details below</p>

                    <div style={{ marginBottom: '24px' }}>
                        <div className="test-auth-info-row">
                            <span className="test-auth-info-label">Student Name</span>
                            <span className="test-auth-info-value">{studentName}</span>
                        </div>
                        <div className="test-auth-info-row">
                            <span className="test-auth-info-label">Registration No</span>
                            <span className="test-auth-info-value">{regNo}</span>
                        </div>
                        <div className="test-auth-info-row">
                            <span className="test-auth-info-label">Test ID</span>
                            <span className="test-auth-info-value">{testId}</span>
                        </div>
                    </div>

                    <button
                        onClick={handleStartTest}
                        disabled={!isEnabled}
                        className="test-auth-btn"
                        style={{
                            background: isEnabled
                                ? 'linear-gradient(135deg, #10b981 0%, #059669 100%)'
                                : '#374151',
                            boxShadow: isEnabled
                                ? '0 4px 12px rgba(16, 185, 129, 0.25)'
                                : 'none'
                        }}
                    >
                        Start Test
                    </button>

                    {!isEnabled ? (
                        <div className="test-auth-status-box">
                            <div className="pulse-dot" />
                            <span>Waiting for instructor to enable test...</span>
                        </div>
                    ) : (
                        <div className="test-auth-status-box" style={{ borderColor: '#10b981', color: '#34d399', background: 'rgba(16, 185, 129, 0.08)' }}>
                            <span>✓ Test is active. Click Start to begin!</span>
                        </div>
                    )}
                </div>
                {renderAdminWidget()}
            </div>
        )
    }

    // active test step
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
                    {/* <div className="header-actions">
                        <button className="btn btn-clear" onClick={handleCopyTestText}>
                            {copiedText ? '✓ Copied' : 'CopY Text'}
                        </button>
                    </div> */}
                </div>
                <div className="queries-scroll-container">
                    {tasks.map((task, index) => (
                        <div
                            key={task.id}
                            onClick={() => setActiveIndex(index)}
                            className={`query-card ${activeIndex === index ? 'active' : ''}`}
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
                    <div className="header-actions" style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                        <span style={{ fontSize: '13px', color: '#94a3b8', fontWeight: '600' }}>
                            {studentName} ({regNo})
                        </span>
                        <button className="btn btn-clear" onClick={handleShowSubmissions}>
                            Submission
                        </button>
                        {/* <button className="btn btn-clear" onClick={handleCopyTerminalOutput}>
                            {copied ? '✓ Copied' : 'Copy Output'}
                        </button> */}
                    </div>
                </div>
                <div className="terminal-content">
                    <Terminal ref={terminalRef} />
                </div>
            </div>
            {renderAdminWidget()}
            {submissionsOpen && (
                <div className="submissions-modal-overlay" onClick={() => setSubmissionsOpen(false)}>
                    <div className="submissions-modal" onClick={(e) => e.stopPropagation()}>
                        <div className="submissions-modal-header">
                            <h3>Submitted Queries & Terminal Outputs</h3>
                            <button className="close-btn" onClick={() => setSubmissionsOpen(false)}>×</button>
                        </div>
                        <div className="submissions-modal-body">
                            {loadingSubmissions ? (
                                <div className="loading-spinner">Loading submissions...</div>
                            ) : submissions.length === 0 ? (
                                <div className="no-submissions">No queries submitted yet.</div>
                            ) : (
                                <div className="submissions-list">
                                    {submissions.map((sub, idx) => (
                                        <div key={idx} className="submission-item">
                                            <div className="submission-question-title">
                                                Question #{idx + 1}: {sub.question_text || 'Unknown Question'}
                                            </div>
                                            <pre className="submission-terminal-view">
                                                {sub.query}
                                            </pre>
                                        </div>
                                    ))}
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            )}
        </div>
    )
}