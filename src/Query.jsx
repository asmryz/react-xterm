import React from 'react'
import Editor from '@monaco-editor/react'

export default function Query({ label = 'QUERY:', text, value, onChange, onRun }) {
    return (
        <>
            <div className="task-banner" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', width: '100%' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px', minWidth: 0, flex: 1 }}>
                    <span className="task-label">{label}</span>
                    <span className="task-text">{text}</span>
                </div>
                <div className="header-actions">
                    <button className="btn btn-run" onClick={onRun}>
                        <span className="play-icon">▶</span>
                    </button>
                </div>
            </div>
            <div className="editor-container">
                <Editor
                    height="150px"
                    language="sql"
                    theme="light"
                    value={value}
                    onChange={(val) => onChange(val || '')}
                    options={{
                        minimap: { enabled: false },
                        fontSize: 14,
                        fontFamily: 'Menlo, Monaco, "Courier New", monospace',
                        automaticLayout: true,
                        scrollBeyondLastLine: false,
                        tabSize: 2,
                        wordWrap: 'on',
                        lineNumbersMinChars: 3,
                        lineHeight: 20,
                        padding: { top: 0, bottom: 0 }
                    }}
                />
            </div>
        </>
    )
}
