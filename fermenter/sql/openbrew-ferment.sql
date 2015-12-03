

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


CREATE TABLE fermenters (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.fermenters OWNER TO openbrew;

CREATE SEQUENCE fermenters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.fermenters_id_seq OWNER TO openbrew;

ALTER SEQUENCE fermenters_id_seq OWNED BY fermenters.id;

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
    fermenterid integer
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

ALTER TABLE ONLY fermenters ALTER COLUMN id SET DEFAULT nextval('fermenters_id_seq'::regclass);

ALTER TABLE ONLY readings ALTER COLUMN id SET DEFAULT nextval('readings_id_seq'::regclass);

ALTER TABLE ONLY runbatch ALTER COLUMN id SET DEFAULT nextval('runbatch_id_seq'::regclass);

ALTER TABLE ONLY sensors ALTER COLUMN id SET DEFAULT nextval('sensors_id_seq'::regclass);

COPY fermenters (id, name) FROM stdin;
\.

SELECT pg_catalog.setval('fermenters_id_seq', 1, false);

COPY readings (id, value, "time", sensorid) FROM stdin;
\.

SELECT pg_catalog.setval('readings_id_seq', 1, false);

COPY sensors (id, serial, name, fermenterid) FROM stdin;
1	0x234323	Ambient	\N
2	0x234324	Fermenter 1 Wort	\N
3	0x234325	Fermenter 1 Air	\N
4	0x234326	Fermenter 2 Wort	\N
5	0x234327	Fermenter 2 Air	\N
\.

SELECT pg_catalog.setval('sensors_id_seq', 5, true);

ALTER TABLE ONLY fermenters
    ADD CONSTRAINT fermenters_pk PRIMARY KEY (id);

ALTER TABLE ONLY readings
    ADD CONSTRAINT readings_pk PRIMARY KEY (id);

ALTER TABLE ONLY sensors
    ADD CONSTRAINT sensors_pk PRIMARY KEY (id);

ALTER TABLE ONLY sensors
    ADD CONSTRAINT fermenter_fk FOREIGN KEY (fermenterid) REFERENCES fermenters(id);

ALTER TABLE ONLY runbatch
    ADD CONSTRAINT runbatch_pk PRIMARY KEY (id);

ALTER TABLE ONLY readings
    ADD CONSTRAINT sensor_fk FOREIGN KEY (sensorid) REFERENCES sensors(id);

ALTER TABLE ONLY readings
    ADD CONSTRAINT runbatch_fk FOREIGN KEY (runbatchid) REFERENCES runbatch(id);

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM openbrew;
GRANT ALL ON SCHEMA public TO openbrew;
GRANT ALL ON SCHEMA public TO PUBLIC;

