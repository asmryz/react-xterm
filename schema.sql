-- Schema for the evaluation database
DROP TABLE IF EXISTS result;
DROP TABLE IF EXISTS attempt;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS query;
DROP TABLE IF EXISTS conduct;
DROP TABLE IF EXISTS test;

-- 1. Table: test
CREATE TABLE IF NOT EXISTS test (
    testid SERIAL PRIMARY KEY,
    dbname VARCHAR(100) NOT NULL,
    connurl VARCHAR(300),
    testdate date DEFAULT CURRENT_DATE
);

-- 2. Table: conduct
CREATE TABLE IF NOT EXISTS conduct (
    cid SERIAL PRIMARY KEY,
    testid INT REFERENCES test(testid) ON DELETE CASCADE,
    code VARCHAR(5) NOT NULL,
    duration INT,
    semester VARCHAR(10) NOT NULL,
    year VARCHAR(4) NOT NULL
);

-- 3. Table: query
CREATE TABLE IF NOT EXISTS query (
    qid SERIAL PRIMARY KEY,
    testid INT REFERENCES test(testid) ON DELETE CASCADE,
    query TEXT NOT NULL
);

-- 4. Table: student
CREATE TABLE IF NOT EXISTS student (
    regno VARCHAR(10) PRIMARY KEY,
    sname VARCHAR(300) NOT NULL
);

-- 5. Table: attempt
CREATE TABLE IF NOT EXISTS attempt (
    attid SERIAL PRIMARY KEY,
    cid INT REFERENCES conduct(cid) ON DELETE CASCADE,
    regno VARCHAR(10) REFERENCES student(regno) ON DELETE CASCADE,
    query TEXT
);

-- 6. Table: result
CREATE TABLE IF NOT EXISTS result (
    rid SERIAL PRIMARY KEY,
    attid INT REFERENCES attempt(attid) ON DELETE CASCADE,
    marks DECIMAL(5, 2),
    status VARCHAR(50),
    query TEXT
);

-- Seed initial data
INSERT INTO test (dbname, connurl, testdate) VALUES ('spj', 'postgres://postgres:Aa20195@1@localhost:5432/spj', CURRENT_DATE);

-- Seed conduct table
INSERT INTO conduct (testid, code, duration, semester, year) VALUES 
(1, 'CS101', 60, 'Fall', '2026'),
(1, 'CS201', 90, 'Spring', '2026'),
(1, 'CS301', 120, 'Fall', '2026');

-- Seed students
INSERT INTO student (regno, sname) VALUES 
('2023CS01', 'Alice Smith'),
('2023CS02', 'Bob Jones'),
('2023CS03', 'Charlie Brown');

-- Seed queries
INSERT INTO query (testid, query) VALUES 
(1, 'SELECT * FROM supplier WHERE city = ''London'';'),
(1, 'SELECT pname, weight FROM part WHERE color = ''Red'';'),
(1, 'SELECT jname, city FROM project WHERE city = ''Paris'';');
