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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: meal_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE meal_products (
    meal_id integer NOT NULL,
    product_id integer NOT NULL,
    amount numeric(10,2) DEFAULT 1 NOT NULL
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    serving_size numeric(10,2) NOT NULL,
    serving_unit character varying(255) NOT NULL,
    calories numeric(10,2) NOT NULL,
    fat numeric(10,2) NOT NULL,
    carbs numeric(10,2) NOT NULL,
    proteins numeric(10,2) NOT NULL,
    vendor_id integer NOT NULL
);


--
-- Name: meal_product_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW meal_product_details AS
 SELECT r.meal_id,
    p.vendor_id,
    r.product_id,
    r.amount,
    p.name,
    (p.serving_size * r.amount) AS serving_size,
    p.serving_unit,
    (p.calories * r.amount) AS calories,
    (p.fat * r.amount) AS fat,
    (p.carbs * r.amount) AS carbs,
    (p.proteins * r.amount) AS proteins
   FROM (meal_products r
     JOIN products p ON ((p.id = r.product_id)));


--
-- Name: meal_recipes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE meal_recipes (
    meal_id integer NOT NULL,
    recipe_id integer NOT NULL
);


--
-- Name: meals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE meals (
    id integer NOT NULL,
    user_id integer NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: recipe_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recipe_products (
    recipe_id integer NOT NULL,
    product_id integer NOT NULL,
    amount numeric(10,2) DEFAULT 1 NOT NULL
);


--
-- Name: recipe_product_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW recipe_product_details AS
 SELECT r.recipe_id,
    p.vendor_id,
    r.product_id,
    r.amount,
    p.name,
    (p.serving_size * r.amount) AS serving_size,
    p.serving_unit,
    (p.calories * r.amount) AS calories,
    (p.fat * r.amount) AS fat,
    (p.carbs * r.amount) AS carbs,
    (p.proteins * r.amount) AS proteins
   FROM (recipe_products r
     JOIN products p ON ((p.id = r.product_id)));


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recipes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: recipe_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW recipe_details AS
 SELECT r.id,
    r.name,
    count(p.product_id) AS products,
    sum(p.calories) AS calories,
    sum(p.fat) AS fat,
    sum(p.carbs) AS carbs,
    sum(p.proteins) AS proteins
   FROM (recipes r
     LEFT JOIN recipe_product_details p ON ((r.id = p.recipe_id)))
  GROUP BY r.id, r.name;


--
-- Name: meal_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW meal_details AS
 SELECT m.id,
    m.date,
    sum(u.products) AS products,
    sum(u.calories) AS calories,
    sum(u.fat) AS fat,
    sum(u.carbs) AS carbs,
    sum(u.proteins) AS proteins
   FROM (meals m
     LEFT JOIN ( SELECT mr.meal_id,
            r.products,
            r.calories,
            r.fat,
            r.carbs,
            r.proteins
           FROM (recipe_details r
             JOIN meal_recipes mr ON ((r.id = mr.recipe_id)))
        UNION ALL
         SELECT mp.meal_id,
            count(mp.product_id) AS products,
            sum(mp.calories) AS calories,
            sum(mp.fat) AS fat,
            sum(mp.carbs) AS carbs,
            sum(mp.proteins) AS proteins
           FROM meal_product_details mp
          GROUP BY mp.meal_id) u ON ((m.id = u.meal_id)))
  GROUP BY m.id, m.date;


--
-- Name: meals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE meals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE meals_id_seq OWNED BY meals.id;


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recipes_id_seq OWNED BY recipes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    CONSTRAINT check_email CHECK (((email)::text ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'::text))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: vendors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vendors (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    address text
);


--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vendors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vendors_id_seq OWNED BY vendors.id;


--
-- Name: weights; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE weights (
    id integer NOT NULL,
    user_id integer NOT NULL,
    weight numeric(5,2) NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: weights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE weights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE weights_id_seq OWNED BY weights.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY meals ALTER COLUMN id SET DEFAULT nextval('meals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes ALTER COLUMN id SET DEFAULT nextval('recipes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vendors ALTER COLUMN id SET DEFAULT nextval('vendors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY weights ALTER COLUMN id SET DEFAULT nextval('weights_id_seq'::regclass);


--
-- Name: meal_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY meal_products
    ADD CONSTRAINT meal_products_pkey PRIMARY KEY (meal_id, product_id);


--
-- Name: meal_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY meal_recipes
    ADD CONSTRAINT meal_recipes_pkey PRIMARY KEY (meal_id, recipe_id);


--
-- Name: meals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY meals
    ADD CONSTRAINT meals_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: recipe_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recipe_products
    ADD CONSTRAINT recipe_products_pkey PRIMARY KEY (recipe_id, product_id);


--
-- Name: recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: weights_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY weights
    ADD CONSTRAINT weights_pkey PRIMARY KEY (id);


--
-- Name: index_meal_products_on_meal_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_meal_products_on_meal_id ON meal_products USING btree (meal_id);


--
-- Name: index_meal_products_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_meal_products_on_product_id ON meal_products USING btree (product_id);


--
-- Name: index_meal_recipes_on_meal_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_meal_recipes_on_meal_id ON meal_recipes USING btree (meal_id);


--
-- Name: index_meal_recipes_on_recipe_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_meal_recipes_on_recipe_id ON meal_recipes USING btree (recipe_id);


--
-- Name: index_meals_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_meals_on_user_id ON meals USING btree (user_id);


--
-- Name: index_products_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_name ON products USING btree (name);


--
-- Name: index_products_on_vendor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_vendor_id ON products USING btree (vendor_id);


--
-- Name: index_recipe_products_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recipe_products_on_product_id ON recipe_products USING btree (product_id);


--
-- Name: index_recipe_products_on_recipe_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recipe_products_on_recipe_id ON recipe_products USING btree (recipe_id);


--
-- Name: index_recipes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recipes_on_user_id ON recipes USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_vendors_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_vendors_on_name ON vendors USING btree (name);


--
-- Name: index_weights_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_weights_on_user_id ON weights USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: meal_products_meal_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY meal_products
    ADD CONSTRAINT meal_products_meal_id_fk FOREIGN KEY (meal_id) REFERENCES meals(id) ON DELETE CASCADE;


--
-- Name: meal_products_product_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY meal_products
    ADD CONSTRAINT meal_products_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT;


--
-- Name: meal_recipes_meal_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY meal_recipes
    ADD CONSTRAINT meal_recipes_meal_id_fk FOREIGN KEY (meal_id) REFERENCES meals(id) ON DELETE CASCADE;


--
-- Name: meal_recipes_recipe_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY meal_recipes
    ADD CONSTRAINT meal_recipes_recipe_id_fk FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE RESTRICT;


--
-- Name: meals_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY meals
    ADD CONSTRAINT meals_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: products_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES vendors(id);


--
-- Name: recipe_products_product_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipe_products
    ADD CONSTRAINT recipe_products_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT;


--
-- Name: recipe_products_recipe_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipe_products
    ADD CONSTRAINT recipe_products_recipe_id_fk FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE;


--
-- Name: recipes_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes
    ADD CONSTRAINT recipes_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: weights_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY weights
    ADD CONSTRAINT weights_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20141221111734');

INSERT INTO schema_migrations (version) VALUES ('20141221111736');

INSERT INTO schema_migrations (version) VALUES ('20141221112943');

INSERT INTO schema_migrations (version) VALUES ('20141221113219');

INSERT INTO schema_migrations (version) VALUES ('20141221115235');

INSERT INTO schema_migrations (version) VALUES ('20141221115805');

INSERT INTO schema_migrations (version) VALUES ('20141221121131');

INSERT INTO schema_migrations (version) VALUES ('20141221130720');

INSERT INTO schema_migrations (version) VALUES ('20141221131345');

INSERT INTO schema_migrations (version) VALUES ('20150122211732');

INSERT INTO schema_migrations (version) VALUES ('20150123171037');

INSERT INTO schema_migrations (version) VALUES ('20150123172720');

INSERT INTO schema_migrations (version) VALUES ('20150123180654');

INSERT INTO schema_migrations (version) VALUES ('20150123185420');

INSERT INTO schema_migrations (version) VALUES ('20150123191404');

INSERT INTO schema_migrations (version) VALUES ('20150123192755');

INSERT INTO schema_migrations (version) VALUES ('20150123194218');

INSERT INTO schema_migrations (version) VALUES ('20150123211104');

INSERT INTO schema_migrations (version) VALUES ('20150126115445');
