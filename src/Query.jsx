import React from 'react'
import Editor from '@monaco-editor/react'
import { format } from 'sql-formatter'

export default function Query({ label = 'QUERY:', text, value, onChange, onRun }) {
    const handleEditorMount = (editor, monaco) => {
        if (monaco.__sqlFormatterRegistered) return;
        monaco.__sqlFormatterRegistered = true;

        const postProcessSql = (formatted) => {
            const lines = formatted.split('\n');
            const resultLines = [];
            let i = 0;

            const clauseKeywords = new Set([
                'SELECT', 'FROM', 'WHERE', 'GROUP BY', 'ORDER BY', 'HAVING', 'LIMIT',
                'INSERT', 'UPDATE', 'DELETE', 'SET', 'VALUES', 'JOIN', 'LEFT', 'RIGHT',
                'INNER', 'OUTER', 'UNION', 'INTERSECT', 'EXCEPT', 'AND', 'OR'
            ]);

            while (i < lines.length) {
                const line = lines[i].trim();
                const upperLine = line.toUpperCase();

                if (upperLine === 'SELECT') {
                    let selectItems = [];
                    i++;
                    while (i < lines.length) {
                        const nextLine = lines[i].trim();
                        if (!nextLine) {
                            i++;
                            continue;
                        }
                        const firstWord = nextLine.split(/\s+/)[0].toUpperCase();
                        if (clauseKeywords.has(firstWord)) {
                            break;
                        }
                        selectItems.push(nextLine);
                        i++;
                    }
                    resultLines.push(`SELECT ${selectItems.join(' ')}`);
                } else if (upperLine === 'FROM') {
                    let fromItems = [];
                    i++;
                    while (i < lines.length) {
                        const nextLine = lines[i].trim();
                        if (!nextLine) {
                            i++;
                            continue;
                        }
                        const firstWord = nextLine.split(/\s+/)[0].toUpperCase();
                        if (clauseKeywords.has(firstWord)) {
                            break;
                        }
                        fromItems.push(nextLine);
                        i++;
                    }
                    resultLines.push(`FROM ${fromItems.join(' ')}`);
                } else if (upperLine === 'WHERE') {
                    let whereItems = [];
                    i++;
                    while (i < lines.length) {
                        const nextLine = lines[i].trim();
                        if (!nextLine) {
                            i++;
                            continue;
                        }
                        const firstWord = nextLine.split(/\s+/)[0].toUpperCase();
                        if (clauseKeywords.has(firstWord)) {
                            break;
                        }
                        whereItems.push(nextLine);
                        i++;
                    }
                    resultLines.push(`WHERE ${whereItems.join(' ')}`);
                } else {
                    resultLines.push(lines[i]);
                    i++;
                }
            }
            return resultLines.join('\n');
        };

        monaco.languages.registerDocumentFormattingEditProvider('sql', {
            provideDocumentFormattingEdits(model, options) {
                try {
                    const formatted = format(model.getValue(), {
                        language: 'postgresql',
                        keywordCase: 'upper',
                        tabWidth: options.tabSize,
                    });
                    const postProcessed = postProcessSql(formatted);
                    return [
                        {
                            range: model.getFullModelRange(),
                            text: postProcessed,
                        },
                    ];
                } catch (err) {
                    console.error('SQL Formatting failed:', err);
                    return [];
                }
            },
        });
    };

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
                    onMount={handleEditorMount}
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
