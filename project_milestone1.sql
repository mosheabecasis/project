--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

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
-- Name: sp_delete_airline(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_airline(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM airlines
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_airline(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_airline_flights(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_airline_flights(_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        delete from flights
        using flights
        where flights.airline_id = _id;

        with rows as  (
            delete from airlines
            where airlines.id = _id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_delete_airline_flights(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_and_reset_all(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_delete_and_reset_all()
    LANGUAGE plpgsql
    AS $$
begin

		delete from tickets
        where id >= 1;
        alter sequence tickets_id_seq restart with 1;

		delete from flights
        where id >= 1;
        alter sequence flights_id_seq restart with 1;

		delete from airlines
        where id >= 1;
        alter sequence airlines_id_seq restart with 1;

        delete from countries
        where id >= 1;
        alter sequence countries_id_seq restart with 1;

		delete from users
        where id >= 1;
        alter sequence users_id_seq restart with 1;

	    delete from customers
        where id >= 1;
        alter sequence customers_id_seq restart with 1;

    end;
$$;


ALTER PROCEDURE public.sp_delete_and_reset_all() OWNER TO postgres;

--
-- Name: sp_delete_country(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_country(_id integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM countries
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_country(_id integer) OWNER TO postgres;

--
-- Name: sp_delete_customer(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_customer(_id integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM customers
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_customer(_id integer) OWNER TO postgres;

--
-- Name: sp_delete_customer_user(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_customer_user(_user_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
        rows_count int := 0;
    begin
        delete from customers
        using users
        where customers.user_id = _user_id;

        with rows as  (
            delete from users
            where users.id = _user_id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
$$;


ALTER FUNCTION public.sp_delete_customer_user(_user_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_flight(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_flight(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM flights
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_flight(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_flight_tickets(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_flight_tickets(_flight_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
        rows_count int := 0;
    begin
        delete from tickets
        using flights
        where tickets.flight_id = _flight_id;

        with rows as  (
            delete from flights
            where flights.id = _flight_id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
$$;


ALTER FUNCTION public.sp_delete_flight_tickets(_flight_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_ticket(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_ticket(_id integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM tickets
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_ticket(_id integer) OWNER TO postgres;

--
-- Name: sp_delete_users(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_users(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM users
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_users(_id bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: airlines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airlines (
    id bigint NOT NULL,
    name text,
    country_id integer,
    user_id bigint
);


ALTER TABLE public.airlines OWNER TO postgres;

--
-- Name: sp_get_airline_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_airline_by_id(_id bigint) RETURNS SETOF public.airlines
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from airlines
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_airline_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_get_all_airlines(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_airlines() RETURNS TABLE(id bigint, name text, country_id integer, user_id bigint)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from airlines;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_airlines() OWNER TO postgres;

--
-- Name: sp_get_all_countries(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_countries() RETURNS TABLE(id integer, name text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from countries;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_countries() OWNER TO postgres;

--
-- Name: sp_get_all_customers(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_customers() RETURNS TABLE(id bigint, first_name text, last_name text, address text, phone_no text, credit_card_no text, user_id bigint)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from customers;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_customers() OWNER TO postgres;

--
-- Name: sp_get_all_flights(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_flights() RETURNS TABLE(id bigint, airline_id bigint, origin_country_id integer, destination_country_id integer, departure_time timestamp without time zone, landing_time timestamp without time zone, remaining_tickets integer)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from flights;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_flights() OWNER TO postgres;

--
-- Name: sp_get_all_tickets(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_tickets() RETURNS TABLE(id bigint, flight_id bigint, customer_id bigint)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from tickets;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_tickets() OWNER TO postgres;

--
-- Name: sp_get_all_users(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_users() RETURNS TABLE(id bigint, username text, password text, email text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from users;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_users() OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username text,
    password text,
    email text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: sp_get_country_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_country_by_id(_id bigint) RETURNS SETOF public.users
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from countries
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_country_by_id(_id bigint) OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    first_name text,
    last_name text,
    address text,
    phone_no text,
    credit_card_no text,
    user_id bigint
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: sp_get_customer_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_customer_by_id(_id bigint) RETURNS SETOF public.customers
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from customers
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_customer_by_id(_id bigint) OWNER TO postgres;

--
-- Name: flights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flights (
    id bigint NOT NULL,
    airline_id bigint,
    origin_country_id integer,
    destination_country_id integer,
    departure_time timestamp without time zone,
    landing_time timestamp without time zone,
    remaining_tickets integer
);


ALTER TABLE public.flights OWNER TO postgres;

--
-- Name: sp_get_flight_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_flight_by_id(_id bigint) RETURNS SETOF public.flights
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from flights
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_flight_by_id(_id bigint) OWNER TO postgres;

--
-- Name: tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets (
    flight_id bigint,
    id bigint NOT NULL,
    customer_id bigint
);


ALTER TABLE public.tickets OWNER TO postgres;

--
-- Name: sp_get_ticket_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_ticket_by_id(_id bigint) RETURNS SETOF public.tickets
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from tickets
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_ticket_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_get_user_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_user_by_id(_id bigint) RETURNS SETOF public.users
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from users
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_user_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_airline(text, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_airline(_name text, _country_id integer, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO airlines (name, country_id,user_id)
            VALUES (_name, _country_id,_user_id)
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_airline(_name text, _country_id integer, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_country(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_country(_id integer, _name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO countries (id, name)
            VALUES (_id, _name)
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_country(_id integer, _name text) OWNER TO postgres;

--
-- Name: sp_insert_customer(bigint, text, text, text, text, text, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_customer(_id bigint, _first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO customers (id, first_name, last_name , address, phone_no, credit_card_no, user_id)
            VALUES (_id, _first_name, _last_name , _address, _phone_no, _credit_card_no, _user_id )
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_customer(_id bigint, _first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_flight(bigint, bigint, integer, integer, timestamp without time zone, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_flight(_id bigint, _airline_id bigint, _origin_country_id integer, _destination_country_id integer, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO flights (id , airline_id , origin_country_id , destination_country_id ,
              departure_time , landing_time , remaining_tickets )
            VALUES (_id , _airline_id , _origin_country_id , _destination_country_id ,
              _departure_time , _landing_time , _remaining_tickets )
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_flight(_id bigint, _airline_id bigint, _origin_country_id integer, _destination_country_id integer, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) OWNER TO postgres;

--
-- Name: sp_insert_ticket(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_ticket(_id bigint, _flight_id bigint, _customer_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO tickets (id, flight_id, customer_id)
            VALUES (_id, _flight_id, _customer_id )
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_ticket(_id bigint, _flight_id bigint, _customer_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_user(bigint, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_user(_id bigint, _username text, _password text, _email text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO users (id, username, password, email)
            VALUES (_id, _username, _password, _email)
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_user(_id bigint, _username text, _password text, _email text) OWNER TO postgres;

--
-- Name: sp_update_airlines(bigint, text, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_airlines(_id bigint, _name text, _country_id integer, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE airlines
            SET name =_name, country_id = _country_id, user_id=_user_id
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_airlines(_id bigint, _name text, _country_id integer, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_update_countries(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_countries(_id integer, _name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE countries
            SET id= _id, name= _name
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_countries(_id integer, _name text) OWNER TO postgres;

--
-- Name: sp_update_customers(bigint, text, text, text, text, text, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_customers(_id bigint, _first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE customers
            SET id= _id, first_name= _first_name, last_name= _last_name, address= _address, phone_no= _phone_no,
                credit_card_no= _credit_card_no, user_id= _user_id
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_customers(_id bigint, _first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_update_flights(bigint, bigint, integer, integer, timestamp without time zone, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_flights(_id bigint, _airline_id bigint, _origin_country_id integer, _destination_country_id integer, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE flights
            SET id= _id, airline_id= _airline_id, origin_country_id= _origin_country_id,
                destination_country_id= _destination_country_id, departure_time= _departure_time,
                landing_time= _landing_time, remaining_tickets= _remaining_tickets
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_flights(_id bigint, _airline_id bigint, _origin_country_id integer, _destination_country_id integer, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) OWNER TO postgres;

--
-- Name: sp_update_tickets(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_tickets(_id bigint, _flight_id bigint, _customer_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE tickets
            SET id= _id, flight_id= _flight_id, customer_id= _customer_id
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_tickets(_id bigint, _flight_id bigint, _customer_id bigint) OWNER TO postgres;

--
-- Name: sp_update_users(bigint, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_users(_id bigint, _username text, _password text, _email text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE users
            SET id= _id, username= _username, password= _password, email= _email
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_users(_id bigint, _username text, _password text, _email text) OWNER TO postgres;

--
-- Name: sp_upsert_customer(text, text, text, text, text, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_upsert_customer(_first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint)
    LANGUAGE plpgsql
    AS $$
begin
        if not exists(select 1 from customers where phone_no = _phone_no or credit_card_no=_credit_card_no
					 or user_id=_user_id) then
        insert into customers (first_name, last_name,
		address, phone_no, credit_card_no, user_id)
        values(_first_name, _last_name,
		_address, _phone_no, _credit_card_no, _user_id);
        else
            update customers
            SET first_name=_first_name,last_name= _last_name,
			address=_address,phone_no= _phone_no, credit_card_no=_credit_card_no,
			user_id=_user_id
            where phone_no = _phone_no or credit_card_no=_credit_card_no
					 or user_id=_user_id;
        end if;
    end;
$$;


ALTER PROCEDURE public.sp_upsert_customer(_first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_upsert_user(text, text, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_upsert_user(_username text, _password text, _email text)
    LANGUAGE plpgsql
    AS $$
begin
        INSERT INTO users (username, password, email)
        VALUES(_username, _password, _email)
        ON CONFLICT (username)
        DO
           UPDATE SET username = _username, password=_password, email=_email;
    end;
$$;


ALTER PROCEDURE public.sp_upsert_user(_username text, _password text, _email text) OWNER TO postgres;

--
-- Name: airlines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.airlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.airlines_id_seq OWNER TO postgres;

--
-- Name: airlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.airlines_id_seq OWNED BY public.airlines.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.countries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.countries_id_seq OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_id_seq OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: flights_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.flights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flights_id_seq OWNER TO postgres;

--
-- Name: flights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.flights_id_seq OWNED BY public.flights.id;


--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tickets_id_seq OWNER TO postgres;

--
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tickets_id_seq OWNED BY public.tickets.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: airlines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines ALTER COLUMN id SET DEFAULT nextval('public.airlines_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: flights id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights ALTER COLUMN id SET DEFAULT nextval('public.flights_id_seq'::regclass);


--
-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets ALTER COLUMN id SET DEFAULT nextval('public.tickets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: airlines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.airlines (id, name, country_id, user_id) FROM stdin;
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, name) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, first_name, last_name, address, phone_no, credit_card_no, user_id) FROM stdin;
\.


--
-- Data for Name: flights; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flights (id, airline_id, origin_country_id, destination_country_id, departure_time, landing_time, remaining_tickets) FROM stdin;
\.


--
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tickets (flight_id, id, customer_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, email) FROM stdin;
\.


--
-- Name: airlines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.airlines_id_seq', 5, true);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_seq', 1, false);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 1, false);


--
-- Name: flights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flights_id_seq', 1, false);


--
-- Name: tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tickets_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: airlines airlines_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_pk PRIMARY KEY (id);


--
-- Name: countries countries_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pk PRIMARY KEY (id);


--
-- Name: customers customers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);


--
-- Name: flights flights_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pk PRIMARY KEY (id);


--
-- Name: tickets tickets_flight_id_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_flight_id_customer_id_key UNIQUE (flight_id, customer_id);


--
-- Name: tickets tickets_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pk PRIMARY KEY (id);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pk PRIMARY KEY (id);


--
-- Name: airlines_name_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX airlines_name_uindex ON public.airlines USING btree (name);


--
-- Name: airlines_user_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX airlines_user_id_uindex ON public.airlines USING btree (user_id);


--
-- Name: countries_name_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX countries_name_uindex ON public.countries USING btree (name);


--
-- Name: customers_credit_card_no_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX customers_credit_card_no_uindex ON public.customers USING btree (credit_card_no);


--
-- Name: customers_phone_no_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX customers_phone_no_uindex ON public.customers USING btree (phone_no);


--
-- Name: customers_user_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX customers_user_id_uindex ON public.customers USING btree (user_id);


--
-- Name: users_email_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_uindex ON public.users USING btree (email);


--
-- Name: users_username_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_username_uindex ON public.users USING btree (username);


--
-- Name: airlines airlines_countries_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_countries_id_fk FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: airlines airlines_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: customers customers_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: flights flights_airlines_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_airlines_id_fk FOREIGN KEY (airline_id) REFERENCES public.airlines(id);


--
-- Name: flights flights_countries_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_countries_id_fk FOREIGN KEY (origin_country_id) REFERENCES public.countries(id);


--
-- Name: flights flights_countries_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_countries_id_fk_2 FOREIGN KEY (destination_country_id) REFERENCES public.countries(id);


--
-- Name: tickets tickets_customers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_customers_id_fk FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: tickets tickets_flights_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_flights_id_fk FOREIGN KEY (flight_id) REFERENCES public.flights(id);


--
-- PostgreSQL database dump complete
--

