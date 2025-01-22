--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE pmm;
ALTER ROLE pmm WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:ijL1oWONXXWUhyTF4YyOgw==$z02MpO0wRxkYE5HxlBnYvOrGC8nhopyrcbiPFnGTyhE=:qgkFvZ37zhuEJn4K0JnXGN2BTh874NOzNnqgJFDz/+8=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10 - Percona Distribution
-- Dumped by pg_dump version 15.10 - Percona Distribution

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
-- PostgreSQL database dump complete
--

--
-- Database "dbbench" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10 - Percona Distribution
-- Dumped by pg_dump version 15.10 - Percona Distribution

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
-- Name: dbbench; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE dbbench WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE dbbench OWNER TO postgres;

\connect dbbench

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: data_uuid; Type: TABLE; Schema: public; Owner: pmm
--

CREATE TABLE public.data_uuid (
    id integer NOT NULL,
    a character(36) NOT NULL,
    b character(36) NOT NULL,
    c character(36) NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.data_uuid OWNER TO pmm;

--
-- Name: data_uuid_id_seq; Type: SEQUENCE; Schema: public; Owner: pmm
--

CREATE SEQUENCE public.data_uuid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.data_uuid_id_seq OWNER TO pmm;

--
-- Name: data_uuid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pmm
--

ALTER SEQUENCE public.data_uuid_id_seq OWNED BY public.data_uuid.id;


--
-- Name: data_uuid id; Type: DEFAULT; Schema: public; Owner: pmm
--

ALTER TABLE ONLY public.data_uuid ALTER COLUMN id SET DEFAULT nextval('public.data_uuid_id_seq'::regclass);


--
-- Data for Name: data_uuid; Type: TABLE DATA; Schema: public; Owner: pmm
--

COPY public.data_uuid (id, a, b, c, status) FROM stdin;
\.


--
-- Name: data_uuid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pmm
--

SELECT pg_catalog.setval('public.data_uuid_id_seq', 1, false);


--
-- Name: data_uuid data_uuid_pkey; Type: CONSTRAINT; Schema: public; Owner: pmm
--

ALTER TABLE ONLY public.data_uuid
    ADD CONSTRAINT data_uuid_pkey PRIMARY KEY (id);


--
-- Name: idx_ab; Type: INDEX; Schema: public; Owner: pmm
--

CREATE INDEX idx_ab ON public.data_uuid USING btree (a, b);


--
-- Name: idx_acb; Type: INDEX; Schema: public; Owner: pmm
--

CREATE INDEX idx_acb ON public.data_uuid USING btree (a, c, b);


--
-- Name: idx_ba; Type: INDEX; Schema: public; Owner: pmm
--

CREATE INDEX idx_ba ON public.data_uuid USING btree (b, a);


--
-- Name: idx_bca; Type: INDEX; Schema: public; Owner: pmm
--

CREATE INDEX idx_bca ON public.data_uuid USING btree (b, c, a);


--
-- Name: idx_ca; Type: INDEX; Schema: public; Owner: pmm
--

CREATE INDEX idx_ca ON public.data_uuid USING btree (c, a);


--
-- Name: idx_cb; Type: INDEX; Schema: public; Owner: pmm
--

CREATE INDEX idx_cb ON public.data_uuid USING btree (c, b);


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10 - Percona Distribution
-- Dumped by pg_dump version 15.10 - Percona Distribution

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
-- Name: pg_stat_monitor; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_monitor WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_monitor; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_monitor IS 'The pg_stat_monitor is a PostgreSQL Query Performance Monitoring tool, based on PostgreSQL contrib module pg_stat_statements. pg_stat_monitor provides aggregated statistics, client information, plan details including plan, and histogram information.';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

