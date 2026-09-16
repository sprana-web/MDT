--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: buildings_muni; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.buildings_muni (
    id integer NOT NULL,
    geom public.geometry(MultiPolygon,4326),
    osm_id character varying(12),
    code integer,
    fclass character varying(28),
    name character varying(100),
    type character varying(20)
);


--
-- Name: buildings_muni_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.buildings_muni_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: buildings_muni_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.buildings_muni_id_seq OWNED BY public.buildings_muni.id;


--
-- Name: buildings_within_500m_mjosa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.buildings_within_500m_mjosa (
    id character varying NOT NULL,
    geom public.geometry(MultiPolygon,4326),
    "bbox.xmin" numeric,
    "bbox.xmax" numeric,
    "bbox.ymin" numeric,
    "bbox.ymax" numeric,
    subtype character varying(254),
    class character varying(254),
    "names.prim" character varying(254),
    level bigint,
    has_parts integer,
    height numeric,
    is_undergr integer,
    num_floors bigint,
    num_floo_1 bigint,
    min_height numeric,
    min_floor bigint,
    facade_col character varying(254),
    facade_mat character varying(254),
    roof_mater character varying(254),
    roof_shape character varying(254),
    roof_direc numeric,
    roof_orien character varying(254),
    roof_color character varying(254),
    roof_heigh numeric
);


--
-- Name: contours_123_135; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contours_123_135 (
    id bigint NOT NULL,
    geom public.geometry(MultiLineStringZ,4326),
    fid numeric,
    elev numeric
);


--
-- Name: depth_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.depth_data (
    id integer NOT NULL,
    geom public.geometry(Geometry,4326),
    objtype character varying(32),
    vatnlnr double precision,
    navn character varying(30),
    dybde_m double precision,
    uttakdato date,
    eksptype character varying(25),
    shape_leng double precision
);


--
-- Name: depth_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.depth_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: depth_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.depth_data_id_seq OWNED BY public.depth_data.id;


--
-- Name: muni; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.muni (
    id integer NOT NULL,
    geom public.geometry(MultiPolygon,4326),
    objtype character varying(254),
    kommunenum character varying(254),
    kommunenav character varying(254),
    layer character varying(254),
    pop bigint,
    area double precision
);


--
-- Name: muni_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.muni_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: muni_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.muni_id_seq OWNED BY public.muni.id;


--
-- Name: natural_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.natural_points (
    id integer NOT NULL,
    geom public.geometry(Point,4326),
    osm_id character varying(12),
    code integer,
    fclass character varying(28),
    name character varying(100)
);


--
-- Name: natural_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.natural_points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: natural_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.natural_points_id_seq OWNED BY public.natural_points.id;


--
-- Name: points_muni; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.points_muni (
    id integer NOT NULL,
    geom public.geometry(Point,4326),
    osm_id character varying(12),
    code integer,
    fclass character varying(28),
    population bigint,
    name character varying(100)
);


--
-- Name: points_muni_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.points_muni_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: points_muni_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.points_muni_id_seq OWNED BY public.points_muni.id;


--
-- Name: protected_areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protected_areas (
    id integer NOT NULL,
    geom public.geometry(MultiPolygon,4326),
    gml_id character varying(254),
    lokalid character varying(10),
    navnerom character varying(42),
    kommune character varying(254),
    uuid character varying(36),
    cddaid bigint,
    navn character varying(73),
    offisieltn character varying(118),
    verneform character varying(44),
    vernedato character varying(10),
    forvaltnin character varying(189),
    forvaltn_1 character varying(23),
    iucn character varying(28),
    verneplan character varying(21),
    revisjon character varying(13),
    truetvurde character varying(11),
    planbehov character varying(27),
    tiltaksbeh character varying(11),
    forvaltn_2 character varying(15),
    "skjøtselp" character varying(15),
    skogvern character varying(3),
    majorecosy character varying(18),
    marinearea numeric,
    verneforma character varying(20),
    verneforsk character varying(58),
    faktaark character varying(44),
    "skjøtse_1" character varying(10),
    forvaltn_3 character varying(10),
    "førstegan" character varying(10),
    marinbesky character varying(3)
);


--
-- Name: protected_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protected_areas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protected_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protected_areas_id_seq OWNED BY public.protected_areas.id;


--
-- Name: rivers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rivers (
    id integer NOT NULL,
    geom public.geometry(MultiLineStringZM,4326),
    objtype character varying(32),
    nbfvassnr character varying(15),
    elvenavn character varying(30),
    elvelengde double precision,
    nivaa character varying(2),
    vassomr character varying(3),
    uttakdato date,
    eksptype character varying(25)
);


--
-- Name: rivers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rivers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rivers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rivers_id_seq OWNED BY public.rivers.id;


--
-- Name: stations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stations (
    id integer NOT NULL,
    geom public.geometry(Point,4326),
    name character varying(80),
    long numeric,
    municipali character varying(20),
    stid character varying(8),
    lat double precision
);


--
-- Name: stations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stations_id_seq OWNED BY public.stations.id;


--
-- Name: watershed_full; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.watershed_full (
    id integer NOT NULL,
    geom public.geometry(MultiPolygonZ,4326),
    nbfhavnr character varying(15),
    shape_leng double precision,
    shape_area double precision
);


--
-- Name: watershed_full_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.watershed_full_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: watershed_full_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.watershed_full_id_seq OWNED BY public.watershed_full.id;


--
-- Name: watershed_parts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.watershed_parts (
    id integer NOT NULL,
    geom public.geometry(MultiPolygonZ,4326),
    objtype character varying(32),
    vassdragnr character varying(15),
    navnlokal character varying(30),
    enhareal double precision,
    totareal double precision,
    hierarki character varying(100),
    regineq double precision,
    tottilsig double precision,
    vnrofelt character varying(15),
    navnnedbf character varying(30),
    nbfhavnr character varying(15),
    navnnbfhav character varying(30),
    niva character varying(3),
    pktnavnfra character varying(60),
    tilpktnavn character varying(60),
    q6190lskm2 double precision,
    q3060lskm2 double precision,
    statomrnr character varying(15)
);


--
-- Name: watershed_parts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.watershed_parts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: watershed_parts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.watershed_parts_id_seq OWNED BY public.watershed_parts.id;


--
-- Name: buildings_muni id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buildings_muni ALTER COLUMN id SET DEFAULT nextval('public.buildings_muni_id_seq'::regclass);


--
-- Name: depth_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.depth_data ALTER COLUMN id SET DEFAULT nextval('public.depth_data_id_seq'::regclass);


--
-- Name: muni id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.muni ALTER COLUMN id SET DEFAULT nextval('public.muni_id_seq'::regclass);


--
-- Name: natural_points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.natural_points ALTER COLUMN id SET DEFAULT nextval('public.natural_points_id_seq'::regclass);


--
-- Name: points_muni id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points_muni ALTER COLUMN id SET DEFAULT nextval('public.points_muni_id_seq'::regclass);


--
-- Name: protected_areas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_areas ALTER COLUMN id SET DEFAULT nextval('public.protected_areas_id_seq'::regclass);


--
-- Name: rivers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rivers ALTER COLUMN id SET DEFAULT nextval('public.rivers_id_seq'::regclass);


--
-- Name: stations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations ALTER COLUMN id SET DEFAULT nextval('public.stations_id_seq'::regclass);


--
-- Name: watershed_full id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.watershed_full ALTER COLUMN id SET DEFAULT nextval('public.watershed_full_id_seq'::regclass);


--
-- Name: watershed_parts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.watershed_parts ALTER COLUMN id SET DEFAULT nextval('public.watershed_parts_id_seq'::regclass);


--
-- Name: buildings_muni buildings_muni_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buildings_muni
    ADD CONSTRAINT buildings_muni_pkey PRIMARY KEY (id);


--
-- Name: buildings_within_500m_mjosa buildings_within_500m_mjosa_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buildings_within_500m_mjosa
    ADD CONSTRAINT buildings_within_500m_mjosa_pkey PRIMARY KEY (id);


--
-- Name: contours_123_135 contours_123_135_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contours_123_135
    ADD CONSTRAINT contours_123_135_pkey PRIMARY KEY (id);


--
-- Name: depth_data depth_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.depth_data
    ADD CONSTRAINT depth_data_pkey PRIMARY KEY (id);


--
-- Name: muni muni_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.muni
    ADD CONSTRAINT muni_pkey PRIMARY KEY (id);


--
-- Name: natural_points natural_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.natural_points
    ADD CONSTRAINT natural_points_pkey PRIMARY KEY (id);


--
-- Name: points_muni points_muni_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points_muni
    ADD CONSTRAINT points_muni_pkey PRIMARY KEY (id);


--
-- Name: protected_areas protected_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_areas
    ADD CONSTRAINT protected_areas_pkey PRIMARY KEY (id);


--
-- Name: rivers rivers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rivers
    ADD CONSTRAINT rivers_pkey PRIMARY KEY (id);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- Name: watershed_full watershed_full_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.watershed_full
    ADD CONSTRAINT watershed_full_pkey PRIMARY KEY (id);


--
-- Name: watershed_parts watershed_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.watershed_parts
    ADD CONSTRAINT watershed_parts_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

