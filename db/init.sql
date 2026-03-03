-- Kamailio PostgreSQL Schema
-- Standard tables + Auth + Usrloc

-- ====== version table ======
CREATE TABLE IF NOT EXISTS version (
    id SERIAL PRIMARY KEY NOT NULL,
    table_name VARCHAR(32) NOT NULL,
    table_version INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT version_table_name_idx UNIQUE (table_name)
);

INSERT INTO version (table_name, table_version) VALUES ('version','1')
  ON CONFLICT (table_name) DO NOTHING;

-- ====== subscriber table (auth) ======
CREATE TABLE IF NOT EXISTS subscriber (
    id SERIAL PRIMARY KEY NOT NULL,
    username VARCHAR(64) DEFAULT '' NOT NULL,
    domain VARCHAR(64) DEFAULT '' NOT NULL,
    password VARCHAR(64) DEFAULT '' NOT NULL,
    ha1 VARCHAR(128) DEFAULT '' NOT NULL,
    ha1b VARCHAR(128) DEFAULT '' NOT NULL,
    CONSTRAINT subscriber_account_idx UNIQUE (username, domain)
);

CREATE INDEX IF NOT EXISTS subscriber_username_idx ON subscriber (username);

INSERT INTO version (table_name, table_version) VALUES ('subscriber','7')
  ON CONFLICT (table_name) DO NOTHING;

-- ====== location table (usrloc) ======
CREATE TABLE IF NOT EXISTS location (
    id SERIAL PRIMARY KEY NOT NULL,
    ruid VARCHAR(64) DEFAULT '' NOT NULL,
    username VARCHAR(64) DEFAULT '' NOT NULL,
    domain VARCHAR(64) DEFAULT NULL,
    contact VARCHAR(512) DEFAULT '' NOT NULL,
    received VARCHAR(128) DEFAULT NULL,
    path VARCHAR(512) DEFAULT NULL,
    expires TIMESTAMP WITHOUT TIME ZONE DEFAULT '2030-05-28 21:32:15' NOT NULL,
    q REAL DEFAULT 1.0 NOT NULL,
    callid VARCHAR(255) DEFAULT 'Default-Call-ID' NOT NULL,
    cseq INTEGER DEFAULT 1 NOT NULL,
    last_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT '2000-01-01 00:00:01' NOT NULL,
    flags INTEGER DEFAULT 0 NOT NULL,
    cflags INTEGER DEFAULT 0 NOT NULL,
    user_agent VARCHAR(255) DEFAULT '' NOT NULL,
    socket VARCHAR(64) DEFAULT NULL,
    methods INTEGER DEFAULT NULL,
    instance VARCHAR(255) DEFAULT NULL,
    reg_id INTEGER DEFAULT 0 NOT NULL,
    server_id INTEGER DEFAULT 0 NOT NULL,
    connection_id INTEGER DEFAULT 0 NOT NULL,
    keepalive INTEGER DEFAULT 0 NOT NULL,
    partition INTEGER DEFAULT 0 NOT NULL,
    CONSTRAINT location_ruid_idx UNIQUE (ruid)
);

CREATE INDEX IF NOT EXISTS location_account_contact_idx ON location (username, domain, contact);
CREATE INDEX IF NOT EXISTS location_expires_idx ON location (expires);
CREATE INDEX IF NOT EXISTS location_connection_idx ON location (server_id, connection_id);

INSERT INTO version (table_name, table_version) VALUES ('location','9')
  ON CONFLICT (table_name) DO NOTHING;

-- ====== Demo users ======
-- Password: 1234, Domain: localhost
-- ha1 = MD5(username:localhost:1234)
-- ha1b = MD5(username@localhost:localhost:1234)

INSERT INTO subscriber (username, domain, password, ha1, ha1b) VALUES
  ('1000', 'localhost', '1234',
   MD5('1000:localhost:1234'),
   MD5('1000@localhost:localhost:1234')),
  ('1001', 'localhost', '1234',
   MD5('1001:localhost:1234'),
   MD5('1001@localhost:localhost:1234')),
  ('1002', 'localhost', '1234',
   MD5('1002:localhost:1234'),
   MD5('1002@localhost:localhost:1234')),
  ('1003', 'localhost', '1234',
   MD5('1003:localhost:1234'),
   MD5('1003@localhost:localhost:1234')),
  ('1004', 'localhost', '1234',
   MD5('1004:localhost:1234'),
   MD5('1004@localhost:localhost:1234')),
  ('1005', 'localhost', '1234',
   MD5('1005:localhost:1234'),
   MD5('1005@localhost:localhost:1234')),
  ('asterisk', 'localhost', 'asterisk123',
   MD5('asterisk:localhost:asterisk123'),
   MD5('asterisk@localhost:localhost:asterisk123'))
ON CONFLICT (username, domain) DO NOTHING;
