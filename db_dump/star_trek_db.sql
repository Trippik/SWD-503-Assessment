--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5 (Debian 11.5-3.pgdg90+1)
-- Dumped by pg_dump version 11.5

-- Started on 2020-01-06 15:06:48

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
-- TOC entry 239 (class 1255 OID 25101)
-- Name: countships(); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.countships() RETURNS bigint
    LANGUAGE plpgsql
    AS $$
	BEGIN
	RETURN (SELECT COUNT(*) FROM starship);
	END; $$;


ALTER FUNCTION public.countships() OWNER TO cam;

--
-- TOC entry 238 (class 1255 OID 25108)
-- Name: countships(character varying); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.countships(org_name character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
	org_id INTEGER;
BEGIN
	org_id = organisation_return(org_name);
	RETURN (SELECT COUNT(*) FROM starship WHERE organisation = org_id);
END; $$;


ALTER FUNCTION public.countships(org_name character varying) OWNER TO cam;

--
-- TOC entry 240 (class 1255 OID 25114)
-- Name: details(character varying); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.details(per_name character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE 
	p1 VARCHAR(255);
	p2 VARCHAR(255);
BEGIN
	p1 = (person_org_name(per_name));
	p2 = (person_div_name(per_name));
	RETURN(p1 || ' ' || p2);
END; $$;


ALTER FUNCTION public.details(per_name character varying) OWNER TO cam;

--
-- TOC entry 241 (class 1255 OID 25124)
-- Name: distance(character varying, character varying); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.distance(target character varying, origin character varying) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
	target_x FLOAT;
	target_y FLOAT;
	target_z FLOAT;
	origin_x FLOAT;
	origin_y FLOAT;
	origin_z FLOAT;
	delta_x FLOAT;
	delta_y FLOAT;
	delta_z FLOAT;
	element1 FLOAT;
	element2 FLOAT;
	element3 FLOAT;
BEGIN
	target_x = (retrieve_x_corr(target));
	target_y = (retrieve_y_corr(target));
	target_z = (retrieve_z_corr(target));
	origin_x = (retrieve_x_corr(origin));
	origin_y = (retrieve_y_corr(origin));
	origin_z = (retrieve_z_corr(origin));
	delta_x = (target_x - origin_x);
	delta_y = (target_y - origin_y);
	delta_z = (target_z - origin_z);
	element1 = ((delta_y * delta_y) + (delta_x * delta_x));
	element2 = (SQRT(element1));
	element3 = (element2 + (delta_z * delta_z));
	RETURN(SQRT(element3));
END; $$;


ALTER FUNCTION public.distance(target character varying, origin character varying) OWNER TO cam;

--
-- TOC entry 242 (class 1255 OID 25117)
-- Name: max_warp(character varying); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.max_warp(ship character varying) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
	cl_id INTEGER;
BEGIN
	cl_id = (SELECT starship_class FROM starship WHERE starship_name LIKE ('%' || ship || '%'));
	RETURN(SELECT max_warp FROM starship_class WHERE id = cl_id);
END; $$;


ALTER FUNCTION public.max_warp(ship character varying) OWNER TO cam;

--
-- TOC entry 243 (class 1255 OID 25105)
-- Name: organisation_return(character varying); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.organisation_return(org_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN (SELECT ID FROM organisation WHERE organisation_name LIKE ('%' || org_name || '%'));
END;$$;


ALTER FUNCTION public.organisation_return(org_name character varying) OWNER TO cam;

--
-- TOC entry 244 (class 1255 OID 25112)
-- Name: person_div_name(character varying); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.person_div_name(pers character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	pers_id INTEGER;
BEGIN
	pers_id = (SELECT division FROM person WHERE person_name LIKE ('%' || pers || '%'));
	RETURN (SELECT division_name FROM division WHERE id = pers_id);
END;$$;


ALTER FUNCTION public.person_div_name(pers character varying) OWNER TO cam;

--
-- TOC entry 245 (class 1255 OID 25111)
-- Name: person_org_name(character varying); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.person_org_name(pers character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	pers_id INTEGER;
BEGIN
	pers_id = (SELECT organisation FROM person WHERE person_name LIKE ('%' || pers || '%'));
	RETURN (SELECT organisation_name FROM organisation WHERE id = pers_id);
END;$$;


ALTER FUNCTION public.person_org_name(pers character varying) OWNER TO cam;

--
-- TOC entry 246 (class 1255 OID 25118)
-- Name: retrieve_x_corr(character varying); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.retrieve_x_corr(item character varying) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
	planet_id INTEGER;
BEGIN
	planet_id = (SELECT id FROM planet WHERE planet_name LIKE ('%' || item || '%'));
	IF planet_id IS NULL THEN
		RETURN(SELECT xcoordinate FROM starship WHERE starship_name LIKE ('%' || item ||'%'));
	ELSE
		RETURN(SELECT xcoordinate FROM planet WHERE id = planet_id);
	END IF;
END; $$;


ALTER FUNCTION public.retrieve_x_corr(item character varying) OWNER TO cam;

--
-- TOC entry 247 (class 1255 OID 25121)
-- Name: retrieve_y_corr(character varying); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.retrieve_y_corr(item character varying) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
	planet_id INTEGER;
BEGIN
	planet_id = (SELECT id FROM planet WHERE planet_name LIKE ('%' || item || '%'));
	IF planet_id IS NULL THEN
		RETURN(SELECT ycoordinate FROM starship WHERE starship_name LIKE ('%' || item ||'%'));
	ELSE
		RETURN(SELECT ycoordinate FROM planet WHERE id = planet_id);
	END IF;
END; $$;


ALTER FUNCTION public.retrieve_y_corr(item character varying) OWNER TO cam;

--
-- TOC entry 248 (class 1255 OID 25122)
-- Name: retrieve_z_corr(character varying); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.retrieve_z_corr(item character varying) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
	planet_id INTEGER;
BEGIN
	planet_id = (SELECT id FROM planet WHERE planet_name LIKE ('%' || item || '%'));
	IF planet_id IS NULL THEN
		RETURN(SELECT zcoordinate FROM starship WHERE starship_name LIKE ('%' || item ||'%'));
	ELSE
		RETURN(SELECT zcoordinate FROM planet WHERE id = planet_id);
	END IF;
END; $$;


ALTER FUNCTION public.retrieve_z_corr(item character varying) OWNER TO cam;

--
-- TOC entry 249 (class 1255 OID 25126)
-- Name: time_to_point(character varying, character varying, double precision); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.time_to_point(target character varying, origin character varying, warp double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
	distance FLOAT;
BEGIN
	distance = distance(target, origin);
	RETURN(warp_time(distance, warp));
END; $$;


ALTER FUNCTION public.time_to_point(target character varying, origin character varying, warp double precision) OWNER TO cam;

--
-- TOC entry 250 (class 1255 OID 25125)
-- Name: warp_time(double precision, double precision); Type: FUNCTION; Schema: public; Owner: cam
--

CREATE FUNCTION public.warp_time(dist double precision, warp double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
	warp_calc FLOAT;
	warp_days FLOAT;
BEGIN
	warp_calc = (10 * (warp * warp));
	warp_days = ((1 / warp_calc) * 365);
	RETURN(warp_days * 24);
END; $$;


ALTER FUNCTION public.warp_time(dist double precision, warp double precision) OWNER TO cam;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 205 (class 1259 OID 24867)
-- Name: affiliation; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.affiliation (
    id integer NOT NULL,
    affiliation_type character varying(255) NOT NULL
);


ALTER TABLE public.affiliation OWNER TO cam;

--
-- TOC entry 204 (class 1259 OID 24865)
-- Name: affiliation_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.affiliation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.affiliation_id_seq OWNER TO cam;

--
-- TOC entry 3088 (class 0 OID 0)
-- Dependencies: 204
-- Name: affiliation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.affiliation_id_seq OWNED BY public.affiliation.id;


--
-- TOC entry 203 (class 1259 OID 24842)
-- Name: colonies; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.colonies (
    species_id integer NOT NULL,
    planet_id integer NOT NULL,
    date_established date
);


ALTER TABLE public.colonies OWNER TO cam;

--
-- TOC entry 210 (class 1259 OID 24947)
-- Name: colour; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.colour (
    id integer NOT NULL,
    colour_name character varying(255) NOT NULL
);


ALTER TABLE public.colour OWNER TO cam;

--
-- TOC entry 209 (class 1259 OID 24945)
-- Name: colour_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.colour_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.colour_id_seq OWNER TO cam;

--
-- TOC entry 3092 (class 0 OID 0)
-- Dependencies: 209
-- Name: colour_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.colour_id_seq OWNED BY public.colour.id;


--
-- TOC entry 221 (class 1259 OID 25080)
-- Name: crew; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.crew (
    starship_id integer NOT NULL,
    person_id integer NOT NULL,
    assignment_date date NOT NULL,
    crew_role integer
);


ALTER TABLE public.crew OWNER TO cam;

--
-- TOC entry 225 (class 1259 OID 25230)
-- Name: crew_role; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.crew_role (
    id integer NOT NULL,
    crew_role_name character varying(255) NOT NULL
);


ALTER TABLE public.crew_role OWNER TO cam;

--
-- TOC entry 224 (class 1259 OID 25228)
-- Name: crew_role_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.crew_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.crew_role_id_seq OWNER TO cam;

--
-- TOC entry 3095 (class 0 OID 0)
-- Dependencies: 224
-- Name: crew_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.crew_role_id_seq OWNED BY public.crew_role.id;


--
-- TOC entry 214 (class 1259 OID 24971)
-- Name: division; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.division (
    id integer NOT NULL,
    division_name character varying(255) NOT NULL
);


ALTER TABLE public.division OWNER TO cam;

--
-- TOC entry 213 (class 1259 OID 24969)
-- Name: division_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.division_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.division_id_seq OWNER TO cam;

--
-- TOC entry 3097 (class 0 OID 0)
-- Dependencies: 213
-- Name: division_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.division_id_seq OWNED BY public.division.id;


--
-- TOC entry 197 (class 1259 OID 24775)
-- Name: gases; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.gases (
    id integer NOT NULL,
    gas character varying(255) NOT NULL
);


ALTER TABLE public.gases OWNER TO cam;

--
-- TOC entry 196 (class 1259 OID 24773)
-- Name: gases_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.gases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gases_id_seq OWNER TO cam;

--
-- TOC entry 3100 (class 0 OID 0)
-- Dependencies: 196
-- Name: gases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.gases_id_seq OWNED BY public.gases.id;


--
-- TOC entry 212 (class 1259 OID 24955)
-- Name: grade; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.grade (
    id integer NOT NULL,
    rank_name character varying(255) NOT NULL
);


ALTER TABLE public.grade OWNER TO cam;

--
-- TOC entry 211 (class 1259 OID 24953)
-- Name: grade_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.grade_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grade_id_seq OWNER TO cam;

--
-- TOC entry 3103 (class 0 OID 0)
-- Dependencies: 211
-- Name: grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.grade_id_seq OWNED BY public.grade.id;


--
-- TOC entry 202 (class 1259 OID 24829)
-- Name: homeworld; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.homeworld (
    species_id integer NOT NULL,
    planet_id integer NOT NULL
);


ALTER TABLE public.homeworld OWNER TO cam;

--
-- TOC entry 207 (class 1259 OID 24877)
-- Name: organisation; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.organisation (
    id integer NOT NULL,
    organisation_name character varying(255),
    origin_planet integer,
    date_founded date,
    date_closed date,
    organisation_affiliation integer
);


ALTER TABLE public.organisation OWNER TO cam;

--
-- TOC entry 208 (class 1259 OID 24932)
-- Name: organisation_base; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.organisation_base (
    planet_id integer NOT NULL,
    organisation_id integer NOT NULL,
    start_date date,
    end_date date
);


ALTER TABLE public.organisation_base OWNER TO cam;

--
-- TOC entry 206 (class 1259 OID 24875)
-- Name: organisation_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.organisation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organisation_id_seq OWNER TO cam;

--
-- TOC entry 3108 (class 0 OID 0)
-- Dependencies: 206
-- Name: organisation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.organisation_id_seq OWNED BY public.organisation.id;


--
-- TOC entry 216 (class 1259 OID 24984)
-- Name: person; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.person (
    id integer NOT NULL,
    person_name character varying(255),
    organisation integer,
    skin_colour integer,
    hair_colour integer,
    birth_planet integer,
    dob date,
    home_planet integer,
    species integer,
    affiliation integer,
    grade integer,
    division integer
);


ALTER TABLE public.person OWNER TO cam;

--
-- TOC entry 215 (class 1259 OID 24982)
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_id_seq OWNER TO cam;

--
-- TOC entry 3111 (class 0 OID 0)
-- Dependencies: 215
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.person_id_seq OWNED BY public.person.id;


--
-- TOC entry 201 (class 1259 OID 24815)
-- Name: planet; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.planet (
    id integer NOT NULL,
    planet_name character varying(255) NOT NULL,
    xcoordinate real,
    ycoordinate real,
    zcoordinate real,
    population integer,
    atmosphere integer
);


ALTER TABLE public.planet OWNER TO cam;

--
-- TOC entry 200 (class 1259 OID 24813)
-- Name: planet_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.planet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.planet_id_seq OWNER TO cam;

--
-- TOC entry 3114 (class 0 OID 0)
-- Dependencies: 200
-- Name: planet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.planet_id_seq OWNED BY public.planet.id;


--
-- TOC entry 223 (class 1259 OID 25129)
-- Name: ships_location_log; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.ships_location_log (
    id integer NOT NULL,
    date_of_journey date,
    journey_start_time time without time zone,
    warp_factor double precision,
    start_x double precision,
    start_y double precision,
    start_z double precision,
    end_x double precision,
    end_y double precision,
    end_z double precision,
    ship integer NOT NULL
);


ALTER TABLE public.ships_location_log OWNER TO cam;

--
-- TOC entry 222 (class 1259 OID 25127)
-- Name: ships_location_log_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.ships_location_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ships_location_log_id_seq OWNER TO cam;

--
-- TOC entry 3117 (class 0 OID 0)
-- Dependencies: 222
-- Name: ships_location_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.ships_location_log_id_seq OWNED BY public.ships_location_log.id;


--
-- TOC entry 199 (class 1259 OID 24785)
-- Name: species; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.species (
    id integer NOT NULL,
    species_name character varying(255) NOT NULL,
    breathable_gas integer
);


ALTER TABLE public.species OWNER TO cam;

--
-- TOC entry 198 (class 1259 OID 24783)
-- Name: species_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.species_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.species_id_seq OWNER TO cam;

--
-- TOC entry 3120 (class 0 OID 0)
-- Dependencies: 198
-- Name: species_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.species_id_seq OWNED BY public.species.id;


--
-- TOC entry 220 (class 1259 OID 25061)
-- Name: starship; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.starship (
    id integer NOT NULL,
    starship_name character varying(255),
    registry character varying(255),
    starship_class integer NOT NULL,
    organisation integer,
    launch_date date,
    decommisioned date,
    xcoordinate double precision,
    ycoordinate double precision,
    zcoordinate double precision
);


ALTER TABLE public.starship OWNER TO cam;

--
-- TOC entry 218 (class 1259 OID 25051)
-- Name: starship_class; Type: TABLE; Schema: public; Owner: cam
--

CREATE TABLE public.starship_class (
    id integer NOT NULL,
    starship_class_name character varying(255),
    design_date date,
    starship_length real,
    starship_breadth real,
    starship_decks integer,
    max_warp real,
    warp_cruise real,
    max_impulse real,
    phasers integer,
    torpedo_launchers integer,
    max_crew integer,
    max_cargo real
);


ALTER TABLE public.starship_class OWNER TO cam;

--
-- TOC entry 217 (class 1259 OID 25049)
-- Name: starship_class_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.starship_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.starship_class_id_seq OWNER TO cam;

--
-- TOC entry 3124 (class 0 OID 0)
-- Dependencies: 217
-- Name: starship_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.starship_class_id_seq OWNED BY public.starship_class.id;


--
-- TOC entry 219 (class 1259 OID 25059)
-- Name: starship_id_seq; Type: SEQUENCE; Schema: public; Owner: cam
--

CREATE SEQUENCE public.starship_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.starship_id_seq OWNER TO cam;

--
-- TOC entry 3126 (class 0 OID 0)
-- Dependencies: 219
-- Name: starship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cam
--

ALTER SEQUENCE public.starship_id_seq OWNED BY public.starship.id;


--
-- TOC entry 2845 (class 2604 OID 24870)
-- Name: affiliation id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.affiliation ALTER COLUMN id SET DEFAULT nextval('public.affiliation_id_seq'::regclass);


--
-- TOC entry 2847 (class 2604 OID 24950)
-- Name: colour id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.colour ALTER COLUMN id SET DEFAULT nextval('public.colour_id_seq'::regclass);


--
-- TOC entry 2854 (class 2604 OID 25233)
-- Name: crew_role id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.crew_role ALTER COLUMN id SET DEFAULT nextval('public.crew_role_id_seq'::regclass);


--
-- TOC entry 2849 (class 2604 OID 24974)
-- Name: division id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.division ALTER COLUMN id SET DEFAULT nextval('public.division_id_seq'::regclass);


--
-- TOC entry 2842 (class 2604 OID 24778)
-- Name: gases id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.gases ALTER COLUMN id SET DEFAULT nextval('public.gases_id_seq'::regclass);


--
-- TOC entry 2848 (class 2604 OID 24958)
-- Name: grade id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.grade ALTER COLUMN id SET DEFAULT nextval('public.grade_id_seq'::regclass);


--
-- TOC entry 2846 (class 2604 OID 24880)
-- Name: organisation id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.organisation ALTER COLUMN id SET DEFAULT nextval('public.organisation_id_seq'::regclass);


--
-- TOC entry 2850 (class 2604 OID 24987)
-- Name: person id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person ALTER COLUMN id SET DEFAULT nextval('public.person_id_seq'::regclass);


--
-- TOC entry 2844 (class 2604 OID 24818)
-- Name: planet id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.planet ALTER COLUMN id SET DEFAULT nextval('public.planet_id_seq'::regclass);


--
-- TOC entry 2853 (class 2604 OID 25132)
-- Name: ships_location_log id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.ships_location_log ALTER COLUMN id SET DEFAULT nextval('public.ships_location_log_id_seq'::regclass);


--
-- TOC entry 2843 (class 2604 OID 24788)
-- Name: species id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.species ALTER COLUMN id SET DEFAULT nextval('public.species_id_seq'::regclass);


--
-- TOC entry 2852 (class 2604 OID 25064)
-- Name: starship id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.starship ALTER COLUMN id SET DEFAULT nextval('public.starship_id_seq'::regclass);


--
-- TOC entry 2851 (class 2604 OID 25054)
-- Name: starship_class id; Type: DEFAULT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.starship_class ALTER COLUMN id SET DEFAULT nextval('public.starship_class_id_seq'::regclass);


--
-- TOC entry 3048 (class 0 OID 24867)
-- Dependencies: 205
-- Data for Name: affiliation; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.affiliation (id, affiliation_type) FROM stdin;
1	Exploration
2	State
\.


--
-- TOC entry 3046 (class 0 OID 24842)
-- Dependencies: 203
-- Data for Name: colonies; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.colonies (species_id, planet_id, date_established) FROM stdin;
\.


--
-- TOC entry 3053 (class 0 OID 24947)
-- Dependencies: 210
-- Data for Name: colour; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.colour (id, colour_name) FROM stdin;
1	White
2	Bald
3	Black
4	Brown
5	Blue
6	Yellow
7	Green
8	Silver
9	Blonde
10	Red
\.


--
-- TOC entry 3064 (class 0 OID 25080)
-- Dependencies: 221
-- Data for Name: crew; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.crew (starship_id, person_id, assignment_date, crew_role) FROM stdin;
\.


--
-- TOC entry 3068 (class 0 OID 25230)
-- Dependencies: 225
-- Data for Name: crew_role; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.crew_role (id, crew_role_name) FROM stdin;
\.


--
-- TOC entry 3057 (class 0 OID 24971)
-- Dependencies: 214
-- Data for Name: division; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.division (id, division_name) FROM stdin;
2	Command
3	Security
4	Engineering
5	Operations
6	Science
7	Medical
\.


--
-- TOC entry 3040 (class 0 OID 24775)
-- Dependencies: 197
-- Data for Name: gases; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.gases (id, gas) FROM stdin;
1	Air
\.


--
-- TOC entry 3055 (class 0 OID 24955)
-- Dependencies: 212
-- Data for Name: grade; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.grade (id, rank_name) FROM stdin;
1	Captain
2	Commander
3	Chief Petty Officer
4	Ensign
5	Lieutenant Junior Grade
6	Lieutenant
7	Lieutenant Commander
8	Admiral
9	Fleet Admiral
10	General
11	Brigadier
12	Colonel
13	Bekk
14	Legate
15	Gul
16	Glinn
\.


--
-- TOC entry 3045 (class 0 OID 24829)
-- Dependencies: 202
-- Data for Name: homeworld; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.homeworld (species_id, planet_id) FROM stdin;
1	1
11	3
12	5
13	4
15	7
16	8
17	9
18	9
19	1
20	10
\.


--
-- TOC entry 3050 (class 0 OID 24877)
-- Dependencies: 207
-- Data for Name: organisation; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.organisation (id, organisation_name, origin_planet, date_founded, date_closed, organisation_affiliation) FROM stdin;
1	Starfleet	1	2130-01-01	\N	1
2	Klingon Empire	2	0800-01-01	\N	2
3	Romulan Star Empire	8	\N	\N	2
4	Vulcan Science Academy	7	\N	\N	1
5	The Dominion	\N	\N	\N	2
6	Andorian Empire	9	\N	\N	2
7	Test	3	2019-12-17	2019-12-18	2
\.


--
-- TOC entry 3051 (class 0 OID 24932)
-- Dependencies: 208
-- Data for Name: organisation_base; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.organisation_base (planet_id, organisation_id, start_date, end_date) FROM stdin;
\.


--
-- TOC entry 3059 (class 0 OID 24984)
-- Dependencies: 216
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.person (id, person_name, organisation, skin_colour, hair_colour, birth_planet, dob, home_planet, species, affiliation, grade, division) FROM stdin;
2	Jean-Luc Picard	1	1	2	1	2305-06-13	1	1	1	1	2
3	William Riker	1	1	4	1	2335-08-19	1	1	1	\N	2
4	Worf	1	3	4	2	2340-01-01	1	2	\N	6	3
5	Data	1	1	4	11	2338-02-02	\N	22	1	7	5
6	Geordi La Forge	1	3	4	1	2335-02-16	1	1	1	7	4
7	Beverly Crusher	1	1	10	1	2324-10-13	1	1	1	7	7
\.


--
-- TOC entry 3044 (class 0 OID 24815)
-- Dependencies: 201
-- Data for Name: planet; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.planet (id, planet_name, xcoordinate, ycoordinate, zcoordinate, population, atmosphere) FROM stdin;
1	Earth	0	0	0	7700000	1
2	Kronos	1.40999997	1	1	\N	1
3	Cardassia	-2.79999995	2	2	\N	1
4	Ferenginar	-2.79999995	-2	0.140000001	\N	1
5	Bajor	-3	0	0.600000024	\N	1
7	Vulcan	1	0.5	0	\N	1
8	Romulus	-2	-1	0.200000003	\N	1
9	Andoria	1	0.75	-0.5	\N	1
10	Betazed	2	1	0.300000012	\N	1
11	Omicron Theta	4	3	0	\N	1
\.


--
-- TOC entry 3066 (class 0 OID 25129)
-- Dependencies: 223
-- Data for Name: ships_location_log; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.ships_location_log (id, date_of_journey, journey_start_time, warp_factor, start_x, start_y, start_z, end_x, end_y, end_z, ship) FROM stdin;
\.


--
-- TOC entry 3042 (class 0 OID 24785)
-- Dependencies: 199
-- Data for Name: species; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.species (id, species_name, breathable_gas) FROM stdin;
1	Human	1
2	Klingon	1
11	Cardassian	1
12	Bajoran	1
13	Ferengi	1
14	Borg	1
15	Vulcan	1
16	Romulan	1
17	Andorian	1
18	Aenar	1
19	Budgie	1
20	Betazoid	1
21	Betazoid/Human Hybrid	1
22	Soong-Android	\N
\.


--
-- TOC entry 3063 (class 0 OID 25061)
-- Dependencies: 220
-- Data for Name: starship; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.starship (id, starship_name, registry, starship_class, organisation, launch_date, decommisioned, xcoordinate, ycoordinate, zcoordinate) FROM stdin;
2	USS Voyager	NCC-74656	2	1	2371-01-01	\N	\N	\N	\N
3	IKS M`Char	\N	4	2	2364-01-01	\N	\N	\N	\N
4	USS Yamato	NCC-1305-E	1	1	2363-02-01	2365-01-01	\N	\N	\N
5	USS Defiant	NX-74205	5	1	2366-01-01	2375-01-01	\N	\N	\N
1	USS-Enterprise	NCC-1701-D	1	1	2363-01-01	2371-01-01	2	2	0
7	USS Stargazer	NCC-2893	6	1	2333-01-01	\N	\N	\N	\N
8	USS Fearless	NCC-14598	7	1	2364-01-01	\N	\N	\N	\N
9	USS Pegasus	NCC-53847	8	1	\N	2358-01-01	\N	\N	\N
\.


--
-- TOC entry 3061 (class 0 OID 25051)
-- Dependencies: 218
-- Data for Name: starship_class; Type: TABLE DATA; Schema: public; Owner: cam
--

COPY public.starship_class (id, starship_class_name, design_date, starship_length, starship_breadth, starship_decks, max_warp, warp_cruise, max_impulse, phasers, torpedo_launchers, max_crew, max_cargo) FROM stdin;
1	Galaxy Class	2363-01-01	642.5	463.730011	42	9.60000038	6	269813216	14	2	15000	\N
2	Intrepid Class	2370-01-01	344	144.839996	15	9.97500038	9.97500038	269813216	6	4	141	\N
3	Borg Cube	\N	3036	3036	\N	10	10	269813216	30	10	130000	\N
4	Bird of Prey	2280-01-01	110	\N	3	8	6	269813216	2	2	12	\N
5	Defiant Class	2366-01-01	170.679993	134.110001	5	9.5	7	269812992	7	6	50	\N
6	Constellation Class	2275-01-01	310	140	17	9.19999981	5.19999981	269812992	6	6	350	\N
7	Excelsior Class	2280-01-01	511.25	195.639999	29	9.60000038	6	269812992	16	6	750	\N
8	Oberth Class	2250-01-01	120	34	11	9	6	269812992	4	1	100	\N
\.


--
-- TOC entry 3128 (class 0 OID 0)
-- Dependencies: 204
-- Name: affiliation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.affiliation_id_seq', 2, true);


--
-- TOC entry 3129 (class 0 OID 0)
-- Dependencies: 209
-- Name: colour_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.colour_id_seq', 10, true);


--
-- TOC entry 3130 (class 0 OID 0)
-- Dependencies: 224
-- Name: crew_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.crew_role_id_seq', 1, false);


--
-- TOC entry 3131 (class 0 OID 0)
-- Dependencies: 213
-- Name: division_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.division_id_seq', 7, true);


--
-- TOC entry 3132 (class 0 OID 0)
-- Dependencies: 196
-- Name: gases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.gases_id_seq', 1, true);


--
-- TOC entry 3133 (class 0 OID 0)
-- Dependencies: 211
-- Name: grade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.grade_id_seq', 16, true);


--
-- TOC entry 3134 (class 0 OID 0)
-- Dependencies: 206
-- Name: organisation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.organisation_id_seq', 7, true);


--
-- TOC entry 3135 (class 0 OID 0)
-- Dependencies: 215
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.person_id_seq', 7, true);


--
-- TOC entry 3136 (class 0 OID 0)
-- Dependencies: 200
-- Name: planet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.planet_id_seq', 11, true);


--
-- TOC entry 3137 (class 0 OID 0)
-- Dependencies: 222
-- Name: ships_location_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.ships_location_log_id_seq', 1, false);


--
-- TOC entry 3138 (class 0 OID 0)
-- Dependencies: 198
-- Name: species_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.species_id_seq', 22, true);


--
-- TOC entry 3139 (class 0 OID 0)
-- Dependencies: 217
-- Name: starship_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.starship_class_id_seq', 8, true);


--
-- TOC entry 3140 (class 0 OID 0)
-- Dependencies: 219
-- Name: starship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cam
--

SELECT pg_catalog.setval('public.starship_id_seq', 9, true);


--
-- TOC entry 2868 (class 2606 OID 24874)
-- Name: affiliation affiliation_affiliation_type_key; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.affiliation
    ADD CONSTRAINT affiliation_affiliation_type_key UNIQUE (affiliation_type);


--
-- TOC entry 2870 (class 2606 OID 24872)
-- Name: affiliation affiliation_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.affiliation
    ADD CONSTRAINT affiliation_pkey PRIMARY KEY (id);


--
-- TOC entry 2876 (class 2606 OID 24952)
-- Name: colour colour_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.colour
    ADD CONSTRAINT colour_pkey PRIMARY KEY (id);


--
-- TOC entry 2892 (class 2606 OID 25235)
-- Name: crew_role crew_role_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.crew_role
    ADD CONSTRAINT crew_role_pkey PRIMARY KEY (id);


--
-- TOC entry 2880 (class 2606 OID 24976)
-- Name: division division_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.division
    ADD CONSTRAINT division_pkey PRIMARY KEY (id);


--
-- TOC entry 2856 (class 2606 OID 24782)
-- Name: gases gases_gas_key; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.gases
    ADD CONSTRAINT gases_gas_key UNIQUE (gas);


--
-- TOC entry 2858 (class 2606 OID 24780)
-- Name: gases gases_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.gases
    ADD CONSTRAINT gases_pkey PRIMARY KEY (id);


--
-- TOC entry 2878 (class 2606 OID 24960)
-- Name: grade grade_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT grade_pkey PRIMARY KEY (id);


--
-- TOC entry 2872 (class 2606 OID 24884)
-- Name: organisation organisation_organisation_name_key; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_organisation_name_key UNIQUE (organisation_name);


--
-- TOC entry 2874 (class 2606 OID 24882)
-- Name: organisation organisation_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_pkey PRIMARY KEY (id);


--
-- TOC entry 2882 (class 2606 OID 24989)
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- TOC entry 2864 (class 2606 OID 24820)
-- Name: planet planet_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.planet
    ADD CONSTRAINT planet_pkey PRIMARY KEY (id);


--
-- TOC entry 2866 (class 2606 OID 24822)
-- Name: planet planet_planet_name_key; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.planet
    ADD CONSTRAINT planet_planet_name_key UNIQUE (planet_name);


--
-- TOC entry 2890 (class 2606 OID 25134)
-- Name: ships_location_log ships_location_log_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.ships_location_log
    ADD CONSTRAINT ships_location_log_pkey PRIMARY KEY (id);


--
-- TOC entry 2860 (class 2606 OID 24790)
-- Name: species species_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (id);


--
-- TOC entry 2862 (class 2606 OID 24792)
-- Name: species species_species_name_key; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_species_name_key UNIQUE (species_name);


--
-- TOC entry 2884 (class 2606 OID 25056)
-- Name: starship_class starship_class_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.starship_class
    ADD CONSTRAINT starship_class_pkey PRIMARY KEY (id);


--
-- TOC entry 2886 (class 2606 OID 25058)
-- Name: starship_class starship_class_starship_class_name_key; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.starship_class
    ADD CONSTRAINT starship_class_starship_class_name_key UNIQUE (starship_class_name);


--
-- TOC entry 2888 (class 2606 OID 25069)
-- Name: starship starship_pkey; Type: CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.starship
    ADD CONSTRAINT starship_pkey PRIMARY KEY (id);


--
-- TOC entry 2898 (class 2606 OID 24850)
-- Name: colonies colonies_planet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.colonies
    ADD CONSTRAINT colonies_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES public.planet(id) ON DELETE RESTRICT;


--
-- TOC entry 2897 (class 2606 OID 24845)
-- Name: colonies colonies_species_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.colonies
    ADD CONSTRAINT colonies_species_id_fkey FOREIGN KEY (species_id) REFERENCES public.species(id) ON DELETE RESTRICT;


--
-- TOC entry 2916 (class 2606 OID 25236)
-- Name: crew crew_crew_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT crew_crew_role_fkey FOREIGN KEY (crew_role) REFERENCES public.crew_role(id);


--
-- TOC entry 2915 (class 2606 OID 25088)
-- Name: crew crew_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT crew_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE RESTRICT;


--
-- TOC entry 2914 (class 2606 OID 25083)
-- Name: crew crew_starship_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.crew
    ADD CONSTRAINT crew_starship_id_fkey FOREIGN KEY (starship_id) REFERENCES public.starship(id) ON DELETE RESTRICT;


--
-- TOC entry 2896 (class 2606 OID 24837)
-- Name: homeworld homeworld_planet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.homeworld
    ADD CONSTRAINT homeworld_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES public.planet(id) ON DELETE RESTRICT;


--
-- TOC entry 2895 (class 2606 OID 24832)
-- Name: homeworld homeworld_species_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.homeworld
    ADD CONSTRAINT homeworld_species_id_fkey FOREIGN KEY (species_id) REFERENCES public.species(id) ON DELETE RESTRICT;


--
-- TOC entry 2902 (class 2606 OID 24940)
-- Name: organisation_base organisation_base_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.organisation_base
    ADD CONSTRAINT organisation_base_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisation(id) ON DELETE RESTRICT;


--
-- TOC entry 2901 (class 2606 OID 24935)
-- Name: organisation_base organisation_base_planet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.organisation_base
    ADD CONSTRAINT organisation_base_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES public.planet(id) ON DELETE RESTRICT;


--
-- TOC entry 2900 (class 2606 OID 24890)
-- Name: organisation organisation_organisation_affiliation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_organisation_affiliation_fkey FOREIGN KEY (organisation_affiliation) REFERENCES public.affiliation(id) ON DELETE RESTRICT;


--
-- TOC entry 2899 (class 2606 OID 24885)
-- Name: organisation organisation_origin_planet_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_origin_planet_fkey FOREIGN KEY (origin_planet) REFERENCES public.planet(id) ON DELETE RESTRICT;


--
-- TOC entry 2909 (class 2606 OID 25020)
-- Name: person person_affiliation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_affiliation_fkey FOREIGN KEY (affiliation) REFERENCES public.affiliation(id) ON DELETE RESTRICT;


--
-- TOC entry 2906 (class 2606 OID 25005)
-- Name: person person_birth_planet_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_birth_planet_fkey FOREIGN KEY (birth_planet) REFERENCES public.planet(id) ON DELETE RESTRICT;


--
-- TOC entry 2911 (class 2606 OID 25030)
-- Name: person person_division_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_division_fkey FOREIGN KEY (division) REFERENCES public.division(id) ON DELETE RESTRICT;


--
-- TOC entry 2910 (class 2606 OID 25025)
-- Name: person person_grade_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_grade_fkey FOREIGN KEY (grade) REFERENCES public.grade(id) ON DELETE RESTRICT;


--
-- TOC entry 2905 (class 2606 OID 25000)
-- Name: person person_hair_colour_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_hair_colour_fkey FOREIGN KEY (hair_colour) REFERENCES public.colour(id) ON DELETE RESTRICT;


--
-- TOC entry 2907 (class 2606 OID 25010)
-- Name: person person_home_planet_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_home_planet_fkey FOREIGN KEY (home_planet) REFERENCES public.planet(id) ON DELETE RESTRICT;


--
-- TOC entry 2903 (class 2606 OID 24990)
-- Name: person person_organisation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_organisation_fkey FOREIGN KEY (organisation) REFERENCES public.organisation(id) ON DELETE RESTRICT;


--
-- TOC entry 2904 (class 2606 OID 24995)
-- Name: person person_skin_colour_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_skin_colour_fkey FOREIGN KEY (skin_colour) REFERENCES public.colour(id) ON DELETE RESTRICT;


--
-- TOC entry 2908 (class 2606 OID 25015)
-- Name: person person_species_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_species_fkey FOREIGN KEY (species) REFERENCES public.species(id) ON DELETE RESTRICT;


--
-- TOC entry 2894 (class 2606 OID 24823)
-- Name: planet planet_atmosphere_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.planet
    ADD CONSTRAINT planet_atmosphere_fkey FOREIGN KEY (atmosphere) REFERENCES public.gases(id) ON DELETE RESTRICT;


--
-- TOC entry 2917 (class 2606 OID 25241)
-- Name: ships_location_log ships_location_log_ship_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.ships_location_log
    ADD CONSTRAINT ships_location_log_ship_fkey FOREIGN KEY (ship) REFERENCES public.starship(id) ON DELETE RESTRICT;


--
-- TOC entry 2893 (class 2606 OID 24793)
-- Name: species species_breathable_gas_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_breathable_gas_fkey FOREIGN KEY (breathable_gas) REFERENCES public.gases(id) ON DELETE RESTRICT;


--
-- TOC entry 2913 (class 2606 OID 25075)
-- Name: starship starship_organisation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.starship
    ADD CONSTRAINT starship_organisation_fkey FOREIGN KEY (organisation) REFERENCES public.organisation(id) ON DELETE RESTRICT;


--
-- TOC entry 2912 (class 2606 OID 25070)
-- Name: starship starship_starship_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cam
--

ALTER TABLE ONLY public.starship
    ADD CONSTRAINT starship_starship_class_fkey FOREIGN KEY (starship_class) REFERENCES public.starship_class(id) ON DELETE RESTRICT;


--
-- TOC entry 3074 (class 0 OID 0)
-- Dependencies: 239
-- Name: FUNCTION countships(); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.countships() TO star_trek_basic_write;


--
-- TOC entry 3075 (class 0 OID 0)
-- Dependencies: 238
-- Name: FUNCTION countships(org_name character varying); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.countships(org_name character varying) TO star_trek_basic_write;


--
-- TOC entry 3076 (class 0 OID 0)
-- Dependencies: 240
-- Name: FUNCTION details(per_name character varying); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.details(per_name character varying) TO star_trek_basic_write;


--
-- TOC entry 3077 (class 0 OID 0)
-- Dependencies: 241
-- Name: FUNCTION distance(target character varying, origin character varying); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.distance(target character varying, origin character varying) TO star_trek_basic_write;


--
-- TOC entry 3078 (class 0 OID 0)
-- Dependencies: 242
-- Name: FUNCTION max_warp(ship character varying); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.max_warp(ship character varying) TO star_trek_basic_write;


--
-- TOC entry 3079 (class 0 OID 0)
-- Dependencies: 243
-- Name: FUNCTION organisation_return(org_name character varying); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.organisation_return(org_name character varying) TO star_trek_basic_write;


--
-- TOC entry 3080 (class 0 OID 0)
-- Dependencies: 244
-- Name: FUNCTION person_div_name(pers character varying); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.person_div_name(pers character varying) TO star_trek_basic_write;


--
-- TOC entry 3081 (class 0 OID 0)
-- Dependencies: 245
-- Name: FUNCTION person_org_name(pers character varying); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.person_org_name(pers character varying) TO star_trek_basic_write;


--
-- TOC entry 3082 (class 0 OID 0)
-- Dependencies: 246
-- Name: FUNCTION retrieve_x_corr(item character varying); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.retrieve_x_corr(item character varying) TO star_trek_basic_write;


--
-- TOC entry 3083 (class 0 OID 0)
-- Dependencies: 247
-- Name: FUNCTION retrieve_y_corr(item character varying); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.retrieve_y_corr(item character varying) TO star_trek_basic_write;


--
-- TOC entry 3084 (class 0 OID 0)
-- Dependencies: 248
-- Name: FUNCTION retrieve_z_corr(item character varying); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.retrieve_z_corr(item character varying) TO star_trek_basic_write;


--
-- TOC entry 3085 (class 0 OID 0)
-- Dependencies: 249
-- Name: FUNCTION time_to_point(target character varying, origin character varying, warp double precision); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.time_to_point(target character varying, origin character varying, warp double precision) TO star_trek_basic_write;


--
-- TOC entry 3086 (class 0 OID 0)
-- Dependencies: 250
-- Name: FUNCTION warp_time(dist double precision, warp double precision); Type: ACL; Schema: public; Owner: cam
--

GRANT ALL ON FUNCTION public.warp_time(dist double precision, warp double precision) TO star_trek_basic_write;


--
-- TOC entry 3087 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE affiliation; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.affiliation TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.affiliation TO star_trek_basic_write;


--
-- TOC entry 3089 (class 0 OID 0)
-- Dependencies: 204
-- Name: SEQUENCE affiliation_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.affiliation_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.affiliation_id_seq TO star_trek_basic_write;


--
-- TOC entry 3090 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE colonies; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.colonies TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.colonies TO star_trek_basic_write;


--
-- TOC entry 3091 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE colour; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.colour TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.colour TO star_trek_basic_write;


--
-- TOC entry 3093 (class 0 OID 0)
-- Dependencies: 209
-- Name: SEQUENCE colour_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.colour_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.colour_id_seq TO star_trek_basic_write;


--
-- TOC entry 3094 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE crew; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.crew TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.crew TO star_trek_basic_write;


--
-- TOC entry 3096 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE division; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.division TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.division TO star_trek_basic_write;


--
-- TOC entry 3098 (class 0 OID 0)
-- Dependencies: 213
-- Name: SEQUENCE division_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.division_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.division_id_seq TO star_trek_basic_write;


--
-- TOC entry 3099 (class 0 OID 0)
-- Dependencies: 197
-- Name: TABLE gases; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.gases TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.gases TO star_trek_basic_write;


--
-- TOC entry 3101 (class 0 OID 0)
-- Dependencies: 196
-- Name: SEQUENCE gases_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.gases_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.gases_id_seq TO star_trek_basic_write;


--
-- TOC entry 3102 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE grade; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.grade TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.grade TO star_trek_basic_write;


--
-- TOC entry 3104 (class 0 OID 0)
-- Dependencies: 211
-- Name: SEQUENCE grade_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.grade_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.grade_id_seq TO star_trek_basic_write;


--
-- TOC entry 3105 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE homeworld; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.homeworld TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.homeworld TO star_trek_basic_write;


--
-- TOC entry 3106 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE organisation; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.organisation TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.organisation TO star_trek_basic_write;


--
-- TOC entry 3107 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE organisation_base; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.organisation_base TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.organisation_base TO star_trek_basic_write;


--
-- TOC entry 3109 (class 0 OID 0)
-- Dependencies: 206
-- Name: SEQUENCE organisation_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.organisation_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.organisation_id_seq TO star_trek_basic_write;


--
-- TOC entry 3110 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE person; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.person TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.person TO star_trek_basic_write;


--
-- TOC entry 3112 (class 0 OID 0)
-- Dependencies: 215
-- Name: SEQUENCE person_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.person_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.person_id_seq TO star_trek_basic_write;


--
-- TOC entry 3113 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE planet; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.planet TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.planet TO star_trek_basic_write;


--
-- TOC entry 3115 (class 0 OID 0)
-- Dependencies: 200
-- Name: SEQUENCE planet_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.planet_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.planet_id_seq TO star_trek_basic_write;


--
-- TOC entry 3116 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE ships_location_log; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.ships_location_log TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.ships_location_log TO star_trek_basic_write;


--
-- TOC entry 3118 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE ships_location_log_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.ships_location_log_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.ships_location_log_id_seq TO star_trek_basic_write;


--
-- TOC entry 3119 (class 0 OID 0)
-- Dependencies: 199
-- Name: TABLE species; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.species TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.species TO star_trek_basic_write;


--
-- TOC entry 3121 (class 0 OID 0)
-- Dependencies: 198
-- Name: SEQUENCE species_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.species_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.species_id_seq TO star_trek_basic_write;


--
-- TOC entry 3122 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE starship; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.starship TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.starship TO star_trek_basic_write;


--
-- TOC entry 3123 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE starship_class; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON TABLE public.starship_class TO star_trek_basic_read_only;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE public.starship_class TO star_trek_basic_write;


--
-- TOC entry 3125 (class 0 OID 0)
-- Dependencies: 217
-- Name: SEQUENCE starship_class_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.starship_class_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.starship_class_id_seq TO star_trek_basic_write;


--
-- TOC entry 3127 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE starship_id_seq; Type: ACL; Schema: public; Owner: cam
--

GRANT SELECT ON SEQUENCE public.starship_id_seq TO star_trek_basic_read_only;
GRANT SELECT,UPDATE ON SEQUENCE public.starship_id_seq TO star_trek_basic_write;


-- Completed on 2020-01-06 15:06:48

--
-- PostgreSQL database dump complete
--
