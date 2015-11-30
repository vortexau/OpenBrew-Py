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
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 1'::text))) AND ((s.name)::text = 'Ambient'::text))) AS ambient,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 1'::text))) AND ((s.name)::text = 'Air'::text))) AS air,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 1'::text))) AND ((s.name)::text = 'Wort'::text))) AS wort,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 1'::text))) AND ((s.name)::text = 'Ambient High'::text))) AS ambienthigh,
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
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 2'::text))) AND ((s.name)::text = 'Ambient'::text))) AS ambient,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 2'::text))) AND ((s.name)::text = 'Air'::text))) AS air,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 2'::text))) AND ((s.name)::text = 'Wort'::text))) AS wort,
    ( SELECT r.value
           FROM readings r,
            fermenters f,
            sensors s
          WHERE (((((r.sensorid = s.id) AND (r.runbatch = r2.runbatch)) AND (s.fermenterid = f.id)) AND (((f.name)::text = 'Ambient'::text) OR ((f.name)::text = 'Fridge 2'::text))) AND ((s.name)::text = 'Ambient High'::text))) AS ambienthigh,
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
4101	24.562	1448872022	9	20
4102	24.625	1448872023	8	20
4103	24.500	1448872023	10	20
4104	22.875	1448872024	6	20
4105	30.312	1448872025	11	20
4106	24.500	1448872026	7	20
4107	24.562	1448872147	9	21
4108	24.625	1448872148	8	21
4109	24.500	1448872149	10	21
4110	22.750	1448872150	6	21
4111	30.312	1448872151	11	21
4112	24.437	1448872152	7	21
4113	24.562	1448872273	9	22
4114	24.562	1448872274	8	22
4115	24.437	1448872275	10	22
4116	22.812	1448872276	6	22
4117	30.250	1448872276	11	22
4118	24.437	1448872278	7	22
4119	24.562	1448872399	9	23
4120	24.562	1448872401	8	23
4121	24.437	1448872402	10	23
4122	22.812	1448872402	6	23
4123	29.875	1448872403	11	23
4124	24.375	1448872404	7	23
4125	24.375	1448872836	9	24
4126	24.375	1448872837	8	24
4127	24.312	1448872839	10	24
4128	22.625	1448872840	6	24
4129	29.875	1448872841	11	24
4130	24.375	1448872842	7	24
4131	24.312	1448872981	9	25
4132	24.375	1448872982	8	25
4133	24.312	1448872983	10	25
4134	22.625	1448872984	6	25
4135	29.750	1448872985	11	25
4136	24.250	1448872986	7	25
4137	24.312	1448873039	9	26
4138	24.375	1448873040	8	26
4139	24.250	1448873041	10	26
4140	22.750	1448873042	6	26
4141	29.750	1448873043	11	26
4142	24.250	1448873044	7	26
4143	24.312	1448873127	9	27
4144	24.437	1448873128	8	27
4145	24.250	1448873129	10	27
4146	22.625	1448873130	6	27
4147	29.937	1448873131	11	27
4148	24.250	1448873132	7	27
4149	24.250	1448873170	9	28
4150	24.375	1448873170	8	28
4151	24.250	1448873171	10	28
4152	22.687	1448873172	6	28
4153	30.187	1448873174	11	28
4154	24.250	1448873175	7	28
4155	24.250	1448873260	9	29
4156	24.375	1448873261	8	29
4157	24.187	1448873262	10	29
4158	22.625	1448873262	6	29
4159	30.187	1448873264	11	29
4160	24.250	1448873265	7	29
4161	24.125	1448873831	9	30
4162	24.187	1448873832	8	30
4163	24.062	1448873833	10	30
4164	22.187	1448873834	6	30
4165	29.375	1448873836	11	30
4166	24.125	1448873837	7	30
4167	24.125	1448873877	9	31
4168	24.187	1448873878	8	31
4169	24.062	1448873880	10	31
4170	22.312	1448873880	6	31
4171	29.250	1448873881	11	31
4172	24.125	1448873882	7	31
4173	24.062	1448873963	9	32
4174	24.250	1448873964	8	32
4175	24.000	1448873964	10	32
4176	22.312	1448873965	6	32
4177	29.437	1448873966	11	32
4178	24.062	1448873967	7	32
\.


--
-- Name: readings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: openbrew
--

SELECT pg_catalog.setval('readings_id_seq', 4178, true);


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

