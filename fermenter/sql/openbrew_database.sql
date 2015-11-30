--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: fermenters; Type: TABLE; Schema: public; Owner: openbrew; Tablespace: 
--

CREATE TABLE fermenters (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE fermenters OWNER TO openbrew;

--
-- Name: fermenters_id_seq; Type: SEQUENCE; Schema: public; Owner: openbrew
--

CREATE SEQUENCE fermenters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fermenters_id_seq OWNER TO openbrew;

--
-- Name: fermenters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openbrew
--

ALTER SEQUENCE fermenters_id_seq OWNED BY fermenters.id;


--
-- Name: readings; Type: TABLE; Schema: public; Owner: openbrew; Tablespace: 
--

CREATE TABLE readings (
    id bigint NOT NULL,
    value numeric,
    "time" integer,
    sensorid integer,
    runbatch integer DEFAULT 1
);


ALTER TABLE readings OWNER TO openbrew;

--
-- Name: readings_id_seq; Type: SEQUENCE; Schema: public; Owner: openbrew
--

CREATE SEQUENCE readings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE readings_id_seq OWNER TO openbrew;

--
-- Name: readings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openbrew
--

ALTER SEQUENCE readings_id_seq OWNED BY readings.id;


--
-- Name: sensors; Type: TABLE; Schema: public; Owner: openbrew; Tablespace: 
--

CREATE TABLE sensors (
    id bigint NOT NULL,
    serial character varying(32),
    name character varying(64),
    fermenterid integer
);


ALTER TABLE sensors OWNER TO openbrew;

--
-- Name: sensors_id_seq; Type: SEQUENCE; Schema: public; Owner: openbrew
--

CREATE SEQUENCE sensors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sensors_id_seq OWNER TO openbrew;

--
-- Name: sensors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openbrew
--

ALTER SEQUENCE sensors_id_seq OWNED BY sensors.id;


--
-- Name: v_fridgeone; Type: VIEW; Schema: public; Owner: openbrew
--

CREATE VIEW v_fridgeone AS
 SELECT ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 1'::text))) AND ((s.name)::text = 'Ambient'::text))) AS fridgeone_ambient,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 1'::text))) AND ((s.name)::text = 'Air'::text))) AS fridgeone_air,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 1'::text))) AND ((s.name)::text = 'Wort'::text))) AS fridgeone_wort,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 1'::text))) AND ((s.name)::text = 'Ambient High'::text))) AS fridgeone_ambienthigh,
    r2.runbatch
   FROM readings r2
  GROUP BY r2.runbatch
  ORDER BY r2.runbatch;


ALTER TABLE v_fridgeone OWNER TO openbrew;

--
-- Name: v_fridgetwo; Type: VIEW; Schema: public; Owner: openbrew
--

CREATE VIEW v_fridgetwo AS
 SELECT ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 2'::text))) AND ((s.name)::text = 'Ambient'::text))) AS fridgetwo_ambient,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 2'::text))) AND ((s.name)::text = 'Air'::text))) AS fridgetwo_air,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 2'::text))) AND ((s.name)::text = 'Wort'::text))) AS fridgetwo_wort,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 2'::text))) AND ((s.name)::text = 'Ambient High'::text))) AS fridgetwo_ambienthigh,
    r2.runbatch
   FROM readings r2
  GROUP BY r2.runbatch
  ORDER BY r2.runbatch;


ALTER TABLE v_fridgetwo OWNER TO openbrew;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: openbrew
--

ALTER TABLE ONLY fermenters ALTER COLUMN id SET DEFAULT nextval('fermenters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: openbrew
--

ALTER TABLE ONLY readings ALTER COLUMN id SET DEFAULT nextval('readings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: openbrew
--

ALTER TABLE ONLY sensors ALTER COLUMN id SET DEFAULT nextval('sensors_id_seq'::regclass);


--
-- Data for Name: fermenters; Type: TABLE DATA; Schema: public; Owner: openbrew
--

COPY fermenters (id, name) FROM stdin;
7	Ambient
8	Fridge 1
9	Fridge 2
\.


--
-- Name: fermenters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: openbrew
--

SELECT pg_catalog.setval('fermenters_id_seq', 9, true);


--
-- Data for Name: readings; Type: TABLE DATA; Schema: public; Owner: openbrew
--

COPY readings (id, value, "time", sensorid, runbatch) FROM stdin;
3987	25.875	1448860768	9	1
3988	26.000	1448860769	8	1
3989	25.687	1448860771	10	1
3990	24.500	1448860772	6	1
3991	32.562	1448860773	11	1
3992	25.750	1448860775	7	1
3993	25.875	1448860786	9	2
3994	26.062	1448860787	8	2
3995	25.687	1448860788	10	2
3996	24.562	1448860789	6	2
3997	32.375	1448860790	11	2
3998	25.687	1448860792	7	2
3999	25.875	1448860913	9	3
4000	26.000	1448860914	8	3
4001	25.687	1448860915	10	3
4002	24.500	1448860916	6	3
4003	32.375	1448860917	11	3
4004	25.687	1448860918	7	3
4005	25.875	1448861039	9	4
4006	26.000	1448861040	8	4
4007	25.687	1448861041	10	4
4008	24.562	1448861042	6	4
4009	31.750	1448861043	11	4
4010	25.687	1448861044	7	4
4011	25.812	1448861165	9	5
4012	25.875	1448861166	8	5
4013	25.625	1448861167	10	5
4014	24.437	1448861168	6	5
4015	31.750	1448861170	11	5
4016	25.625	1448861170	7	5
4017	25.875	1448861292	9	6
4018	25.875	1448861293	8	6
4019	25.625	1448861294	10	6
4020	24.375	1448861295	6	6
4021	31.937	1448861296	11	6
4022	25.625	1448861298	7	6
4023	24.937	1448870388	9	7
4024	24.937	1448870389	8	7
4025	24.812	1448870392	10	7
4026	23.312	1448870393	6	7
4027	30.500	1448870394	11	7
4028	25.625	1448870394	7	7
4029	24.875	1448870515	9	8
4030	24.937	1448870516	8	8
4031	24.812	1448870517	10	8
4032	23.250	1448870518	6	8
4033	30.687	1448870519	11	8
4034	25.625	1448870520	7	8
4035	24.875	1448870641	9	9
4036	24.937	1448870642	8	9
4037	24.750	1448870642	10	9
4038	23.250	1448870643	6	9
4039	30.250	1448870644	11	9
4040	24.687	1448870645	7	9
4041	24.875	1448870766	9	10
4042	24.875	1448870768	8	10
4043	24.750	1448870768	10	10
4044	23.250	1448870769	6	10
4045	30.250	1448870770	11	10
4046	24.687	1448870771	7	10
4047	24.875	1448870892	9	11
4048	24.812	1448870893	8	11
4049	24.687	1448870894	10	11
4050	23.187	1448870894	6	11
4051	30.375	1448870895	11	11
4052	24.687	1448870896	7	11
4053	24.812	1448871017	9	12
4054	24.750	1448871018	8	12
4055	24.687	1448871019	10	12
4056	23.187	1448871020	6	12
4057	30.375	1448871021	11	12
4058	24.625	1448871021	7	12
4059	24.812	1448871142	9	13
4060	24.750	1448871143	8	13
4061	24.687	1448871144	10	13
4062	23.125	1448871145	6	13
4063	30.437	1448871146	11	13
4064	24.625	1448871147	7	13
4065	24.750	1448871268	9	14
4066	24.750	1448871268	8	14
4067	24.687	1448871269	10	14
4068	23.062	1448871270	6	14
4069	30.562	1448871271	11	14
4070	24.625	1448871272	7	14
4071	24.750	1448871393	9	15
4072	24.750	1448871394	8	15
4073	24.687	1448871395	10	15
4074	23.062	1448871395	6	15
4075	30.562	1448871396	11	15
4076	24.562	1448871397	7	15
4077	24.687	1448871518	9	16
4078	24.750	1448871519	8	16
4079	24.625	1448871520	10	16
4080	23.062	1448871521	6	16
4081	30.062	1448871522	11	16
4082	24.562	1448871522	7	16
4083	24.687	1448871644	9	17
4084	24.625	1448871645	8	17
4085	24.562	1448871646	10	17
4086	23.062	1448871647	6	17
4087	30.187	1448871648	11	17
4088	24.500	1448871649	7	17
4089	24.687	1448871770	9	18
4090	24.562	1448871771	8	18
4091	24.562	1448871772	10	18
4092	22.937	1448871773	6	18
4093	30.125	1448871774	11	18
4094	24.500	1448871775	7	18
4095	24.625	1448871896	9	19
4096	24.625	1448871896	8	19
4097	24.562	1448871898	10	19
4098	23.000	1448871899	6	19
4099	30.062	1448871900	11	19
4100	24.500	1448871901	7	19
\.


--
-- Name: readings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: openbrew
--

SELECT pg_catalog.setval('readings_id_seq', 4100, true);


--
-- Data for Name: sensors; Type: TABLE DATA; Schema: public; Owner: openbrew
--

COPY sensors (id, serial, name, fermenterid) FROM stdin;
6	\N	Ambient	7
7	\N	Air	8
8	\N	Wort	8
9	\N	Air	9
10	\N	Wort	9
11	\N	Ambient High	7
\.


--
-- Name: sensors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: openbrew
--

SELECT pg_catalog.setval('sensors_id_seq', 11, true);


--
-- Name: fermenters_pk; Type: CONSTRAINT; Schema: public; Owner: openbrew; Tablespace: 
--

ALTER TABLE ONLY fermenters
    ADD CONSTRAINT fermenters_pk PRIMARY KEY (id);


--
-- Name: readings_pk; Type: CONSTRAINT; Schema: public; Owner: openbrew; Tablespace: 
--

ALTER TABLE ONLY readings
    ADD CONSTRAINT readings_pk PRIMARY KEY (id);


--
-- Name: sensors_pk; Type: CONSTRAINT; Schema: public; Owner: openbrew; Tablespace: 
--

ALTER TABLE ONLY sensors
    ADD CONSTRAINT sensors_pk PRIMARY KEY (id);


--
-- Name: fermenter_fk; Type: FK CONSTRAINT; Schema: public; Owner: openbrew
--

ALTER TABLE ONLY sensors
    ADD CONSTRAINT fermenter_fk FOREIGN KEY (fermenterid) REFERENCES fermenters(id);


--
-- Name: sensor_fk; Type: FK CONSTRAINT; Schema: public; Owner: openbrew
--

ALTER TABLE ONLY readings
    ADD CONSTRAINT sensor_fk FOREIGN KEY (sensorid) REFERENCES sensors(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

