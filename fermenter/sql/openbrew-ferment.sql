

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE fermentors (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.fermentors OWNER TO openbrew;

CREATE SEQUENCE fermentors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.fermentors_id_seq OWNER TO openbrew;

ALTER SEQUENCE fermentors_id_seq OWNED BY fermentors.id;

CREATE TABLE readings (
    id bigint NOT NULL,
    value numeric,
    sensorid integer,
    runbatchid integer
);

ALTER TABLE public.readings OWNER TO openbrew;

CREATE SEQUENCE readings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.readings_id_seq OWNER TO openbrew;

ALTER SEQUENCE readings_id_seq OWNED BY readings.id;

CREATE TABLE runbatch (
    id bigint NOT NULL,
    timestart integer,
    timeend integer
);

ALTER TABLE public.readings OWNER TO openbrew;

CREATE SEQUENCE runbatch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.runbatch_id_seq OWNER TO openbrew;

ALTER SEQUENCE runbatch_id_seq OWNED BY runbatch.id;

CREATE TABLE sensors (
    id bigint NOT NULL,
    serial character varying(32),
    name character varying(64),
    fermentorid integer
);


ALTER TABLE public.sensors OWNER TO openbrew;

CREATE SEQUENCE sensors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.sensors_id_seq OWNER TO openbrew;

ALTER SEQUENCE sensors_id_seq OWNED BY sensors.id;

CREATE TABLE beerbatches (
    id bigint NOT NULL,
    fermentorid bigint NOT NULL,
    fermenting integer default '0',
    fermentstart integer,
    fermentend integer
);

ALTER TABLE public.beerbatches OWNER TO openbrew;

CREATE SEQUENCE beerbatches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.beerbatches_id_seq OWNER TO openbrew;

ALTER SEQUENCE beerbatches_id_seq OWNED BY beerbatches.id;

-- Insert a table that tracks steps for a batch.

CREATE TABLE batchsteps (
    id bigint NOT NULL,
    beerbatchid bigint NOT NULL,
    stepname character varying(32) NOT NULL,
    steptime integer NOT NULL,
    stepcomplete integer default '0'
);

ALTER TABLE public.batchsteps OWNER TO openbrew;

CREATE SEQUENCE batchsteps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.batchsteps_id_seq OWNED BY batchsteps.id;


--


ALTER TABLE ONLY fermentors ALTER COLUMN id SET DEFAULT nextval('fermentors_id_seq'::regclass);

ALTER TABLE ONLY readings ALTER COLUMN id SET DEFAULT nextval('readings_id_seq'::regclass);

ALTER TABLE ONLY runbatch ALTER COLUMN id SET DEFAULT nextval('runbatch_id_seq'::regclass);

ALTER TABLE ONLY sensors ALTER COLUMN id SET DEFAULT nextval('sensors_id_seq'::regclass);

ALTER TABLE ONLY beerbatches ALTER COLUMN id SET DEFAULT nextval('beerbatches_id_seq'::regclass);

ALTER TABLE ONLY batchsteps ALTER COLUMN id SET DEFAULT nextval('batchsteps_id_seq'::regclass);

-- Indexes

CREATE INDEX ix_fermentor_name ON fermentors (name, id);
CREATE INDEX ix_sensors_name_id ON sensors (name, fermentorid);
CREATE INDEX ix_sensors_runbatch ON readings (sensorid, runbatchid);

-- Insert some data.

COPY fermentors (id, name) FROM stdin;
1	Ambient
2	Fermentor 1
3	Fermentor 2
\.

SELECT pg_catalog.setval('fermentors_id_seq', 1, false);

COPY readings (id, value, sensorid) FROM stdin;
\.

SELECT pg_catalog.setval('readings_id_seq', 1, false);

COPY sensors (id, serial, name, fermentorid) FROM stdin;
1	0x234323	Ambient	1
2	0x234324	Fermentor 1 Wort	2
3	0x234325	Fermentor 1 Air	2
4	0x234326	Fermentor 2 Wort	3
5	0x234327	Fermentor 2 Air	3
6	0x878763	Ambient High	1
\.

SELECT pg_catalog.setval('sensors_id_seq', 6, true);

ALTER TABLE ONLY fermentors
    ADD CONSTRAINT fermentors_pk PRIMARY KEY (id);

ALTER TABLE ONLY readings
    ADD CONSTRAINT readings_pk PRIMARY KEY (id);

ALTER TABLE ONLY sensors
    ADD CONSTRAINT sensors_pk PRIMARY KEY (id);

ALTER TABLE ONLY sensors
    ADD CONSTRAINT fermentor_fk FOREIGN KEY (fermentorid) REFERENCES fermentors(id);

ALTER TABLE ONLY runbatch
    ADD CONSTRAINT runbatch_pk PRIMARY KEY (id);

ALTER TABLE ONLY readings
    ADD CONSTRAINT sensor_fk FOREIGN KEY (sensorid) REFERENCES sensors(id);

ALTER TABLE ONLY readings
    ADD CONSTRAINT runbatch_fk FOREIGN KEY (runbatchid) REFERENCES runbatch(id);

ALTER TABLE ONLY beerbatches
    ADD CONSTRAINT beerbatches_pk PRIMARY KEY (id);

ALTER TABLE ONLY beerbatches
    ADD CONSTRAINT fermentor_fk FOREIGN KEY (fermentorid) REFERENCES fermentors(id);

ALTER TABLE ONLY batchsteps
    ADD CONSTRAINT batchsteps_pk PRIMARY KEY (id);

ALTER TABLE ONLY batchsteps
    ADD CONSTRAINT beerbatch_fk FOREIGN KEY (beerbatchid) REFERENCES beerbatches(id); 

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM openbrew;
GRANT ALL ON SCHEMA public TO openbrew;
GRANT ALL ON SCHEMA public TO PUBLIC;


CREATE OR REPLACE VIEW v_tempminmax_day AS
SELECT sensorid, 
       MIN(value), 
       MAX(value) 
FROM   readings 
WHERE  runbatchid IN (SELECT id 
                      FROM   runbatch 
                      WHERE  timestart > (SELECT EXTRACT(epoch FROM NOW()) - 
                                                 ( 86400 * 1 )))                                               
GROUP  BY sensorid 
ORDER  BY sensorid; 


CREATE OR REPLACE VIEW v_tempminmax_threeday AS
SELECT sensorid, 
       MIN(value),
       MAX(value)
FROM   readings
WHERE  runbatchid IN (SELECT id
                      FROM   runbatch
                      WHERE  timestart > (SELECT EXTRACT(epoch FROM NOW()) -
                                                 ( 86400 * 3 )))
GROUP  BY sensorid
ORDER  BY sensorid;


CREATE OR REPLACE VIEW v_tempminmax_week AS
SELECT sensorid, 
       MIN(value),
       MAX(value)
FROM   readings
WHERE  runbatchid IN (SELECT id
                      FROM   runbatch
                      WHERE  timestart > (SELECT EXTRACT(epoch FROM NOW()) -
                                                 ( 86400 * 7 )))
GROUP  BY sensorid
ORDER  BY sensorid;


CREATE OR REPLACE VIEW v_tempminmax_month AS
SELECT sensorid, 
       MIN(value),
       MAX(value)
FROM   readings
WHERE  runbatchid IN (SELECT id
                      FROM   runbatch
                      WHERE  timestart > (SELECT EXTRACT(epoch FROM NOW()) -
                                                 ( 86400 * 31 )))
GROUP  BY sensorid
ORDER  BY sensorid;




CREATE OR REPLACE VIEW v_fridgetwo AS
 SELECT ( SELECT r.value
           FROM readings r,
            fermentors f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatchid = r2.runbatchid)) AND (s.fermentorid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fermentor 2'::text))) AND ((s.name)::text = 'Ambient'::text))) AS ambient,
    ( SELECT r.value
           FROM readings r,
            fermentors f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatchid = r2.runbatchid)) AND (s.fermentorid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fermentor 2'::text))) AND ((s.name)::text = 'Fermentor 2 Air'::text))) AS air,
    ( SELECT r.value
           FROM readings r,
            fermentors f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatchid = r2.runbatchid)) AND (s.fermentorid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fermentor 2'::text))) AND ((s.name)::text = 'Fermentor 2 Wort'::text))) AS wort,
    ( SELECT r.value
           FROM readings r,
            fermentors f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatchid = r2.runbatchid)) AND (s.fermentorid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fermentor 2'::text))) AND ((s.name)::text = 'Ambient High'::text))) AS ambienthigh,
    ( SELECT timestart FROM runbatch rb WHERE rb.id = r2.runbatchid) runtime,
    r2.runbatchid
   FROM readings r2
  GROUP BY r2.runbatchid
  ORDER BY r2.runbatchid;


CREATE OR REPLACE VIEW v_fridgeone AS
 SELECT ( SELECT r.value
           FROM readings r,
            fermentors f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatchid = r2.runbatchid)) AND (s.fermentorid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fermentor 1'::text))) 
AND ((s.name)::text = 'Ambient'::text))) AS ambient,
    ( SELECT r.value
           FROM readings r,
            fermentors f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatchid = r2.runbatchid)) AND (s.fermentorid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fermentor 1'::text)))  AND ((s.name)::text = 'Fermentor 1 Air'::text))) AS air,
    ( SELECT r.value
           FROM readings r,
            fermentors f,
            sensors s 
          WHERE (((((r.sensorid = s.id) AND (r.runbatchid = r2.runbatchid)) AND (s.fermentorid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fermentor 1'::text))) AND ((s.name)::text = 'Fermentor 1 Wort'::text))) AS wort,
    ( SELECT r.value
           FROM readings r,
            fermentors f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatchid = r2.runbatchid)) AND (s.fermentorid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fermentor 1'::text))) 
AND ((s.name)::text = 'Ambient High'::text))) AS ambienthigh,
    ( SELECT timestart FROM runbatch rb WHERE rb.id = r2.runbatchid) runtime,
    r2.runbatchid
   FROM readings r2
  GROUP BY r2.runbatchid
  ORDER BY r2.runbatchid;


