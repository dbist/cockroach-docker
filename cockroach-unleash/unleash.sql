--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1 (Debian 14.1-1.pgdg110+1)
-- Dumped by pg_dump version 14.1 (Debian 14.1-1.pgdg110+1)

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
-- Name: addons; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.addons (
    id integer NOT NULL,
    provider text NOT NULL,
    description text,
    enabled boolean DEFAULT true,
    parameters json,
    events json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.addons OWNER TO unleash_user;

--
-- Name: addons_id_seq; Type: SEQUENCE; Schema: public; Owner: unleash_user
--

CREATE SEQUENCE public.addons_id_seq
    --AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addons_id_seq OWNER TO unleash_user;

--
-- Name: addons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: unleash_user
--

ALTER SEQUENCE public.addons_id_seq OWNED BY public.addons.id;


--
-- Name: api_tokens; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.api_tokens (
    secret text NOT NULL,
    username text NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone,
    seen_at timestamp with time zone,
    project character varying,
    environment character varying
);


ALTER TABLE public.api_tokens OWNER TO unleash_user;

--
-- Name: client_applications; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.client_applications (
    app_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    seen_at timestamp with time zone,
    strategies json,
    description character varying(255),
    icon character varying(255),
    url character varying(255),
    color character varying(255),
    announced boolean DEFAULT false,
    created_by text
);


ALTER TABLE public.client_applications OWNER TO unleash_user;

--
-- Name: client_instances; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.client_instances (
    app_name character varying(255) NOT NULL,
    instance_id character varying(255) NOT NULL,
    client_ip character varying(255),
    last_seen timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    sdk_version character varying(255),
    environment character varying(255) DEFAULT 'default'::character varying NOT NULL
);


ALTER TABLE public.client_instances OWNER TO unleash_user;

--
-- Name: client_metrics_env; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.client_metrics_env (
    feature_name character varying(255) NOT NULL,
    app_name character varying(255) NOT NULL,
    environment character varying(100) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    yes integer DEFAULT 0,
    no integer DEFAULT 0
);


ALTER TABLE public.client_metrics_env OWNER TO unleash_user;

--
-- Name: context_fields; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.context_fields (
    name character varying(255) NOT NULL,
    description text,
    sort_order integer DEFAULT 10,
    legal_values text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    stickiness boolean DEFAULT false
);


ALTER TABLE public.context_fields OWNER TO unleash_user;

--
-- Name: environments; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.environments (
    name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    sort_order integer DEFAULT 9999,
    type text NOT NULL,
    enabled boolean DEFAULT true,
    protected boolean DEFAULT false
);


ALTER TABLE public.environments OWNER TO unleash_user;

--
-- Name: events; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.events (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    type character varying(255) NOT NULL,
    created_by character varying(255) NOT NULL,
    data json,
    tags json DEFAULT '[]'::json,
    project text,
    environment text,
    feature_name text,
    pre_data jsonb
);


ALTER TABLE public.events OWNER TO unleash_user;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: unleash_user
--

CREATE SEQUENCE public.events_id_seq
    --AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_id_seq OWNER TO unleash_user;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: unleash_user
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: feature_environments; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.feature_environments (
    environment character varying(100) DEFAULT 'default'::character varying NOT NULL,
    feature_name character varying(255) NOT NULL,
    enabled boolean NOT NULL
);


ALTER TABLE public.feature_environments OWNER TO unleash_user;

--
-- Name: feature_strategies; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.feature_strategies (
    id text NOT NULL,
    feature_name character varying(255) NOT NULL,
    project_name character varying(255) NOT NULL,
    environment character varying(100) DEFAULT 'default'::character varying NOT NULL,
    strategy_name character varying(255) NOT NULL,
    parameters jsonb DEFAULT '{}'::jsonb NOT NULL,
    constraints jsonb,
    sort_order integer DEFAULT 9999 NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.feature_strategies OWNER TO unleash_user;

--
-- Name: feature_tag; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.feature_tag (
    feature_name character varying(255) NOT NULL,
    tag_type text NOT NULL,
    tag_value text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.feature_tag OWNER TO unleash_user;

--
-- Name: feature_types; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.feature_types (
    id character varying(255) NOT NULL,
    name character varying NOT NULL,
    description character varying,
    lifetime_days integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.feature_types OWNER TO unleash_user;

--
-- Name: features; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.features (
    created_at timestamp with time zone DEFAULT now(),
    name character varying(255) NOT NULL,
    description text,
    archived boolean DEFAULT false,
    variants json DEFAULT '[]'::json,
    type character varying DEFAULT 'release'::character varying,
    stale boolean DEFAULT false,
    project character varying DEFAULT 'default'::character varying,
    last_seen_at timestamp with time zone
);


ALTER TABLE public.features OWNER TO unleash_user;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    run_on timestamp without time zone NOT NULL
);


ALTER TABLE public.migrations OWNER TO unleash_user;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: unleash_user
--

CREATE SEQUENCE public.migrations_id_seq
    --AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_id_seq OWNER TO unleash_user;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: unleash_user
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: project_environments; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.project_environments (
    project_id character varying(255) NOT NULL,
    environment_name character varying(100) NOT NULL
);


ALTER TABLE public.project_environments OWNER TO unleash_user;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.projects (
    id character varying(255) NOT NULL,
    name character varying NOT NULL,
    description character varying,
    created_at timestamp without time zone DEFAULT now(),
    health integer DEFAULT 100,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.projects OWNER TO unleash_user;

--
-- Name: reset_tokens; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.reset_tokens (
    reset_token text NOT NULL,
    user_id integer,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    created_by text
);


ALTER TABLE public.reset_tokens OWNER TO unleash_user;

--
-- Name: role_permission; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.role_permission (
    role_id integer NOT NULL,
    project text,
    permission text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.role_permission OWNER TO unleash_user;

--
-- Name: role_user; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.role_user (
    role_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.role_user OWNER TO unleash_user;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    type text DEFAULT 'custom'::text NOT NULL,
    project text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.roles OWNER TO unleash_user;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: unleash_user
--

CREATE SEQUENCE public.roles_id_seq
    --AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO unleash_user;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: unleash_user
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.settings (
    name character varying(255) NOT NULL,
    content json
);


ALTER TABLE public.settings OWNER TO unleash_user;

--
-- Name: strategies; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.strategies (
    created_at timestamp with time zone DEFAULT now(),
    name character varying(255) NOT NULL,
    description text,
    parameters json,
    built_in integer DEFAULT 0,
    deprecated boolean DEFAULT false,
    sort_order integer DEFAULT 9999,
    display_name text
);


ALTER TABLE public.strategies OWNER TO unleash_user;

--
-- Name: tag_types; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.tag_types (
    name text NOT NULL,
    description text,
    icon text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tag_types OWNER TO unleash_user;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.tags (
    type text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tags OWNER TO unleash_user;

--
-- Name: unleash_session; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.unleash_session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    expired timestamp with time zone NOT NULL
);


ALTER TABLE public.unleash_session OWNER TO unleash_user;

--
-- Name: user_feedback; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.user_feedback (
    user_id integer NOT NULL,
    feedback_id text NOT NULL,
    given timestamp with time zone,
    nevershow boolean DEFAULT false NOT NULL
);


ALTER TABLE public.user_feedback OWNER TO unleash_user;

--
-- Name: user_splash; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.user_splash (
    user_id integer NOT NULL,
    splash_id text NOT NULL,
    seen boolean DEFAULT false NOT NULL
);


ALTER TABLE public.user_splash OWNER TO unleash_user;

--
-- Name: users; Type: TABLE; Schema: public; Owner: unleash_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255),
    username character varying(255),
    email character varying(255),
    image_url character varying(255),
    password_hash character varying(255),
    login_attempts integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    seen_at timestamp without time zone,
    settings json,
    permissions json DEFAULT '[]'::json
);


ALTER TABLE public.users OWNER TO unleash_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: unleash_user
--

CREATE SEQUENCE public.users_id_seq
--    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.users_id_seq OWNER TO unleash_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: unleash_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: addons id; Type: DEFAULT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.addons ALTER COLUMN id SET DEFAULT nextval('public.addons_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: addons; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.addons (id, provider, description, enabled, parameters, events, created_at) FROM stdin;
\.


--
-- Data for Name: api_tokens; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.api_tokens (secret, username, type, created_at, expires_at, seen_at, project, environment) FROM stdin;
\.


--
-- Data for Name: client_applications; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.client_applications (app_name, created_at, updated_at, seen_at, strategies, description, icon, url, color, announced, created_by) FROM stdin;
\.


--
-- Data for Name: client_instances; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.client_instances (app_name, instance_id, client_ip, last_seen, created_at, sdk_version, environment) FROM stdin;
\.


--
-- Data for Name: client_metrics_env; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.client_metrics_env (feature_name, app_name, environment, "timestamp", yes, no) FROM stdin;
\.


--
-- Data for Name: context_fields; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.context_fields (name, description, sort_order, legal_values, created_at, updated_at, stickiness) FROM stdin;
environment	Allows you to constrain on application environment	0	\N	2022-01-10 19:42:19.194005	2022-01-10 19:42:19.194005	f
userId	Allows you to constrain on userId	1	\N	2022-01-10 19:42:19.194005	2022-01-10 19:42:19.194005	f
appName	Allows you to constrain on application name	2	\N	2022-01-10 19:42:19.194005	2022-01-10 19:42:19.194005	f
\.


--
-- Data for Name: environments; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.environments (name, created_at, sort_order, type, enabled, protected) FROM stdin;
development	2022-01-10 19:42:19.501228+00	100	development	t	f
production	2022-01-10 19:42:19.501228+00	200	production	t	f
default	2022-01-10 19:42:19.479817+00	1	production	f	t
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.events (id, created_at, type, created_by, data, tags, project, environment, feature_name, pre_data) FROM stdin;
1	2022-01-10 19:42:19.128557+00	strategy-created	migration	{"name":"default","description":"Default on or off Strategy."}	[]	\N	\N	\N	\N
2	2022-01-10 19:42:19.170626+00	strategy-created	migration	{"name":"userWithId","description":"Active for users with a userId defined in the userIds-list","parameters":[{"name":"userIds","type":"list","description":"","required":false}]}	[]	\N	\N	\N	\N
3	2022-01-10 19:42:19.170626+00	strategy-created	migration	{"name":"applicationHostname","description":"Active for client instances with a hostName in the hostNames-list.","parameters":[{"name":"hostNames","type":"list","description":"List of hostnames to enable the feature toggle for.","required":false}]}	[]	\N	\N	\N	\N
4	2022-01-10 19:42:19.170626+00	strategy-created	migration	{"name":"gradualRolloutRandom","description":"Randomly activate the feature toggle. No stickiness.","parameters":[{"name":"percentage","type":"percentage","description":"","required":false}]}	[]	\N	\N	\N	\N
5	2022-01-10 19:42:19.170626+00	strategy-created	migration	{"name":"gradualRolloutSessionId","description":"Gradually activate feature toggle. Stickiness based on session id.","parameters":[{"name":"percentage","type":"percentage","description":"","required":false},{"name":"groupId","type":"string","description":"Used to define a activation groups, which allows you to correlate across feature toggles.","required":true}]}	[]	\N	\N	\N	\N
6	2022-01-10 19:42:19.170626+00	strategy-created	migration	{"name":"gradualRolloutUserId","description":"Gradually activate feature toggle for logged in users. Stickiness based on user id.","parameters":[{"name":"percentage","type":"percentage","description":"","required":false},{"name":"groupId","type":"string","description":"Used to define a activation groups, which allows you to correlate across feature toggles.","required":true}]}	[]	\N	\N	\N	\N
7	2022-01-10 19:42:19.170626+00	strategy-created	migration	{"name":"remoteAddress","description":"Active for remote addresses defined in the IPs list.","parameters":[{"name":"IPs","type":"list","description":"List of IPs to enable the feature toggle for.","required":true}]}	[]	\N	\N	\N	\N
8	2022-01-10 19:42:19.19024+00	strategy-created	migration	{"name":"flexibleRollout","description":"Gradually activate feature toggle based on sane stickiness","parameters":[{"name":"rollout","type":"percentage","description":"","required":false},{"name":"stickiness","type":"string","description":"Used define stickiness. Possible values: default, userId, sessionId, random","required":true},{"name":"groupId","type":"string","description":"Used to define a activation groups, which allows you to correlate across feature toggles.","required":true}]}	[]	\N	\N	\N	\N
\.


--
-- Data for Name: feature_environments; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.feature_environments (environment, feature_name, enabled) FROM stdin;
\.


--
-- Data for Name: feature_strategies; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.feature_strategies (id, feature_name, project_name, environment, strategy_name, parameters, constraints, sort_order, created_at) FROM stdin;
\.


--
-- Data for Name: feature_tag; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.feature_tag (feature_name, tag_type, tag_value, created_at) FROM stdin;
\.


--
-- Data for Name: feature_types; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.feature_types (id, name, description, lifetime_days, created_at) FROM stdin;
release	Release	Used to enable trunk-based development for teams practicing Continuous Delivery.	40	2022-01-10 19:42:19.228339+00
experiment	Experiment	Used to perform multivariate or A/B testing.	40	2022-01-10 19:42:19.228339+00
operational	Operational	Used to control operational aspects of the system behavior.	7	2022-01-10 19:42:19.228339+00
kill-switch	Kill switch	Used to to gracefully degrade system functionality.	\N	2022-01-10 19:42:19.228339+00
permission	Permission	Used to change the features or product experience that certain users receive.	\N	2022-01-10 19:42:19.228339+00
\.


--
-- Data for Name: features; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.features (created_at, name, description, archived, variants, type, stale, project, last_seen_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.migrations (id, name, run_on) FROM stdin;
1	/20141020151056-initial-schema	2022-01-10 19:42:19.111
2	/20141110144153-add-description-to-features	2022-01-10 19:42:19.121
3	/20141117200435-add-parameters-template-to-strategies	2022-01-10 19:42:19.123
4	/20141117202209-insert-default-strategy	2022-01-10 19:42:19.126
5	/20141118071458-default-strategy-event	2022-01-10 19:42:19.129
6	/20141215210141-005-archived-flag-to-features	2022-01-10 19:42:19.132
7	/20150210152531-006-rename-eventtype	2022-01-10 19:42:19.135
8	/20160618193924-add-strategies-to-features	2022-01-10 19:42:19.139
9	/20161027134128-create-metrics	2022-01-10 19:42:19.145
10	/20161104074441-create-client-instances	2022-01-10 19:42:19.149
11	/20161205203516-create-client-applications	2022-01-10 19:42:19.154
12	/20161212101749-better-strategy-parameter-definitions	2022-01-10 19:42:19.165
13	/20170211085502-built-in-strategies	2022-01-10 19:42:19.168
14	/20170211090541-add-default-strategies	2022-01-10 19:42:19.179
15	/20170306233934-timestamp-with-tz	2022-01-10 19:42:19.183
16	/20170628205541-add-sdk-version-to-client-instances	2022-01-10 19:42:19.186
17	/20190123204125-add-variants-to-features	2022-01-10 19:42:19.188
18	/20191023184858-flexible-rollout-strategy	2022-01-10 19:42:19.192
19	/20200102184820-create-context-fields	2022-01-10 19:42:19.198
20	/20200227202711-settings	2022-01-10 19:42:19.203
21	/20200329191251-settings-secret	2022-01-10 19:42:19.206
22	/20200416201319-create-users	2022-01-10 19:42:19.214
23	/20200429175747-users-settings	2022-01-10 19:42:19.216
24	/20200805091409-add-feature-toggle-type	2022-01-10 19:42:19.222
25	/20200805094311-add-feature-type-to-features	2022-01-10 19:42:19.224
26	/20200806091734-add-stale-flag-to-features	2022-01-10 19:42:19.226
27	/20200810200901-add-created-at-to-feature-types	2022-01-10 19:42:19.229
28	/20200928194947-add-projects	2022-01-10 19:42:19.234
29	/20200928195238-add-project-id-to-features	2022-01-10 19:42:19.237
30	/20201216140726-add-last-seen-to-features	2022-01-10 19:42:19.239
31	/20210105083014-add-tag-and-tag-types	2022-01-10 19:42:19.25
32	/20210119084617-add-addon-table	2022-01-10 19:42:19.255
33	/20210121115438-add-deprecated-column-to-strategies	2022-01-10 19:42:19.257
34	/20210127094440-add-tags-column-to-events	2022-01-10 19:42:19.259
35	/20210208203708-add-stickiness-to-context	2022-01-10 19:42:19.262
36	/20210212114759-add-session-table	2022-01-10 19:42:19.268
37	/20210217195834-rbac-tables	2022-01-10 19:42:19.276
38	/20210218090213-generate-server-identifier	2022-01-10 19:42:19.28
39	/20210302080040-add-pk-to-client-instances	2022-01-10 19:42:19.284
40	/20210304115810-change-default-timestamp-to-now	2022-01-10 19:42:19.287
41	/20210304141005-add-announce-field-to-application	2022-01-10 19:42:19.29
42	/20210304150739-add-created-by-to-application	2022-01-10 19:42:19.293
43	/20210322104356-api-tokens-table	2022-01-10 19:42:19.299
44	/20210322104357-api-tokens-convert-enterprise	2022-01-10 19:42:19.303
45	/20210323073508-reset-application-announcements	2022-01-10 19:42:19.306
46	/20210409120136-create-reset-token-table	2022-01-10 19:42:19.314
47	/20210414141220-fix-misspellings-in-role-descriptions	2022-01-10 19:42:19.318
48	/20210415173116-rbac-rename-roles	2022-01-10 19:42:19.322
49	/20210421133845-add-sort-order-to-strategies	2022-01-10 19:42:19.328
50	/20210421135405-add-display-name-and-update-description-for-strategies	2022-01-10 19:42:19.333
51	/20210423103647-lowercase-all-emails	2022-01-10 19:42:19.339
52	/20210428062103-user-permission-to-rbac	2022-01-10 19:42:19.344
53	/20210428103923-onboard-projects-to-rbac	2022-01-10 19:42:19.349
54	/20210504101429-deprecate-strategies	2022-01-10 19:42:19.353
55	/20210520171325-update-role-descriptions	2022-01-10 19:42:19.357
56	/20210602115555-create-feedback-table	2022-01-10 19:42:19.368
57	/20210610085817-features-strategies-table	2022-01-10 19:42:19.382
58	/20210615115226-migrate-strategies-to-feature-strategies	2022-01-10 19:42:19.385
59	/20210618091331-project-environments-table	2022-01-10 19:42:19.391
60	/20210618100913-add-cascade-for-user-feedback	2022-01-10 19:42:19.395
61	/20210624114602-change-type-of-feature-archived	2022-01-10 19:42:19.401
62	/20210624114855-drop-strategies-column-from-features	2022-01-10 19:42:19.405
63	/20210624115109-drop-enabled-column-from-features	2022-01-10 19:42:19.408
64	/20210625102126-connect-default-project-to-global-environment	2022-01-10 19:42:19.412
65	/20210629130734-add-health-rating-to-project	2022-01-10 19:42:19.416
66	/20210830113948-connect-projects-to-global-envrionments	2022-01-10 19:42:19.42
67	/20210831072631-add-sort-order-and-type-to-env	2022-01-10 19:42:19.426
68	/20210907124058-add-dbcritic-indices	2022-01-10 19:42:19.442
69	/20210907124850-add-dbcritic-primary-keys	2022-01-10 19:42:19.449
70	/20210908100701-add-enabled-to-environments	2022-01-10 19:42:19.456
71	/20210909085651-add-protected-field-to-environments	2022-01-10 19:42:19.462
72	/20210913103159-api-keys-scoping	2022-01-10 19:42:19.467
73	/20210915122001-add-project-and-environment-columns-to-events	2022-01-10 19:42:19.477
74	/20210920104218-rename-global-env-to-default-env	2022-01-10 19:42:19.483
75	/20210921105032-client-api-tokens-default	2022-01-10 19:42:19.487
76	/20210922084509-add-non-null-constraint-to-environment-type	2022-01-10 19:42:19.491
77	/20210922120521-add-tag-type-permission	2022-01-10 19:42:19.495
78	/20210928065411-remove-displayname-from-environments	2022-01-10 19:42:19.499
79	/20210928080601-add-development-and-production-environments	2022-01-10 19:42:19.503
80	/20210928082228-connect-default-environment-to-all-existing-projects	2022-01-10 19:42:19.507
81	/20211004104917-client-metrics-env	2022-01-10 19:42:19.52
82	/20211011094226-add-environment-to-client-instances	2022-01-10 19:42:19.526
83	/20211013093114-feature-strategies-parameters-not-null	2022-01-10 19:42:19.528
84	/20211029094324-set-sort-order-env	2022-01-10 19:42:19.531
85	/20211105104316-add-feature-name-column-to-events	2022-01-10 19:42:19.534
86	/20211105105509-add-predata-column-to-events	2022-01-10 19:42:19.537
87	/20211108130333-create-user-splash-table	2022-01-10 19:42:19.543
88	/20211109103930-add-splash-entry-for-users	2022-01-10 19:42:19.546
89	/20211126112551-disable-default-environment	2022-01-10 19:42:19.549
90	/20211130142314-add-updated-at-to-projects	2022-01-10 19:42:19.552
91	/20211209205201-drop-client-metrics	2022-01-10 19:42:19.555
\.


--
-- Data for Name: project_environments; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.project_environments (project_id, environment_name) FROM stdin;
default	development
default	production
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.projects (id, name, description, created_at, health, updated_at) FROM stdin;
default	Default	Default project	2022-01-10 19:42:19.23087	100	2022-01-10 19:42:19.551001+00
\.


--
-- Data for Name: reset_tokens; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.reset_tokens (reset_token, user_id, expires_at, used_at, created_at, created_by) FROM stdin;
\.


--
-- Data for Name: role_permission; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.role_permission (role_id, project, permission, created_at) FROM stdin;
1	\N	ADMIN	2022-01-10 19:42:19.269561+00
2		CREATE_STRATEGY	2022-01-10 19:42:19.269561+00
2		UPDATE_STRATEGY	2022-01-10 19:42:19.269561+00
2		DELETE_STRATEGY	2022-01-10 19:42:19.269561+00
2		UPDATE_APPLICATION	2022-01-10 19:42:19.269561+00
2		CREATE_CONTEXT_FIELD	2022-01-10 19:42:19.269561+00
2		UPDATE_CONTEXT_FIELD	2022-01-10 19:42:19.269561+00
2		DELETE_CONTEXT_FIELD	2022-01-10 19:42:19.269561+00
2		CREATE_PROJECT	2022-01-10 19:42:19.269561+00
2		CREATE_ADDON	2022-01-10 19:42:19.269561+00
2		UPDATE_ADDON	2022-01-10 19:42:19.269561+00
2		DELETE_ADDON	2022-01-10 19:42:19.269561+00
2	default	UPDATE_PROJECT	2022-01-10 19:42:19.269561+00
2	default	DELETE_PROJECT	2022-01-10 19:42:19.269561+00
2	default	CREATE_FEATURE	2022-01-10 19:42:19.269561+00
2	default	UPDATE_FEATURE	2022-01-10 19:42:19.269561+00
2	default	DELETE_FEATURE	2022-01-10 19:42:19.269561+00
4	default	UPDATE_PROJECT	2022-01-10 19:42:19.346304+00
4	default	DELETE_PROJECT	2022-01-10 19:42:19.346304+00
4	default	CREATE_FEATURE	2022-01-10 19:42:19.346304+00
4	default	UPDATE_FEATURE	2022-01-10 19:42:19.346304+00
4	default	DELETE_FEATURE	2022-01-10 19:42:19.346304+00
5	default	CREATE_FEATURE	2022-01-10 19:42:19.346304+00
5	default	UPDATE_FEATURE	2022-01-10 19:42:19.346304+00
5	default	DELETE_FEATURE	2022-01-10 19:42:19.346304+00
2	\N	UPDATE_TAG_TYPE	2022-01-10 19:42:19.493447+00
2	\N	DELETE_TAG_TYPE	2022-01-10 19:42:19.493447+00
2	default	UPDATE_TAG_TYPE	2022-01-10 19:42:19.493447+00
2	default	DELETE_TAG_TYPE	2022-01-10 19:42:19.493447+00
\.


--
-- Data for Name: role_user; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.role_user (role_id, user_id, created_at) FROM stdin;
1	1	2022-01-10 19:42:19.903897+00
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.roles (id, name, description, type, project, created_at) FROM stdin;
4	Owner	Users with this role have full control over the project, and can add and manage other users within the project context, manage feature toggles within the project, and control advanced project features like archiving and deleting the project.	project	default	2022-01-10 19:42:19.346304+00
5	Member	Users with this role within a project are allowed to view, create and update feature toggles, but have limited permissions in regards to managing the projects user access and can not archive or delete the project.	project	default	2022-01-10 19:42:19.346304+00
2	Editor	Users with the editor role have access to most features in Unleash, but can not manage users and roles in the global scope. Editors will be added as project owner when creating projects and get superuser rights within the context of these projects.	root	\N	2022-01-10 19:42:19.269561+00
1	Admin	Users with the global admin role have superuser access to Unleash and can perform any operation within the unleash platform.	root	\N	2022-01-10 19:42:19.269561+00
3	Viewer	Users with this role can only read root resources in Unleash. The viewer can be added to specific projects as project member.	root	\N	2022-01-10 19:42:19.269561+00
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.settings (name, content) FROM stdin;
unleash.secret	"ef528c885802cef2ac800f7428bfc7e1991c17f6"
instanceInfo	{"id" : "28dd78ed-4115-40ff-b2ca-af1fca4aca04"}
\.


--
-- Data for Name: strategies; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.strategies (created_at, name, description, parameters, built_in, deprecated, sort_order, display_name) FROM stdin;
2022-01-10 19:42:19.125655+00	default	The standard strategy is strictly on / off for your entire userbase.	[]	1	f	0	Standard
2022-01-10 19:42:19.19024+00	flexibleRollout	Roll out to a percentage of your userbase, and ensure that the experience is the same for the user on each visit.	[{"name":"rollout","type":"percentage","description":"","required":false},{"name":"stickiness","type":"string","description":"Used define stickiness. Possible values: default, userId, sessionId, random","required":true},{"name":"groupId","type":"string","description":"Used to define a activation groups, which allows you to correlate across feature toggles.","required":true}]	1	f	1	Gradual rollout
2022-01-10 19:42:19.170626+00	userWithId	Enable the feature for a specific set of userIds.	[{"name":"userIds","type":"list","description":"","required":false}]	1	f	2	UserIDs
2022-01-10 19:42:19.170626+00	remoteAddress	Enable the feature for a specific set of IP addresses.	[{"name":"IPs","type":"list","description":"List of IPs to enable the feature toggle for.","required":true}]	1	f	3	IPs
2022-01-10 19:42:19.170626+00	applicationHostname	Enable the feature for a specific set of hostnames.	[{"name":"hostNames","type":"list","description":"List of hostnames to enable the feature toggle for.","required":false}]	1	f	4	Hosts
2022-01-10 19:42:19.170626+00	gradualRolloutRandom	Randomly activate the feature toggle. No stickiness.	[{"name":"percentage","type":"percentage","description":"","required":false}]	0	t	9999	\N
2022-01-10 19:42:19.170626+00	gradualRolloutSessionId	Gradually activate feature toggle. Stickiness based on session id.	[{"name":"percentage","type":"percentage","description":"","required":false},{"name":"groupId","type":"string","description":"Used to define a activation groups, which allows you to correlate across feature toggles.","required":true}]	0	t	9999	\N
2022-01-10 19:42:19.170626+00	gradualRolloutUserId	Gradually activate feature toggle for logged in users. Stickiness based on user id.	[{"name":"percentage","type":"percentage","description":"","required":false},{"name":"groupId","type":"string","description":"Used to define a activation groups, which allows you to correlate across feature toggles.","required":true}]	0	t	9999	\N
\.


--
-- Data for Name: tag_types; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.tag_types (name, description, icon, created_at) FROM stdin;
simple	Used to simplify filtering of features	#	2022-01-10 19:42:19.240927+00
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.tags (type, value, created_at) FROM stdin;
\.


--
-- Data for Name: unleash_session; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.unleash_session (sid, sess, created_at, expired) FROM stdin;
mLbsMe2MW3qyJ53K4W7Ixujabwy9VSvz	{"cookie":{"originalMaxAge":172800000,"expires":"2022-01-12T19:42:36.606Z","secure":false,"httpOnly":true,"path":"/"},"user":{"isAPI":false,"id":1,"username":"admin","imageUrl":"https://gravatar.com/avatar/21232f297a57a5a743894a0e4a801fc3?size=42&default=retro","seenAt":null,"loginAttempts":0,"createdAt":"2022-01-10T19:42:19.829Z"}}	2022-01-10 19:42:36.609032+00	2022-01-12 19:44:38.795+00
\.


--
-- Data for Name: user_feedback; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.user_feedback (user_id, feedback_id, given, nevershow) FROM stdin;
\.


--
-- Data for Name: user_splash; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.user_splash (user_id, splash_id, seen) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: unleash_user
--

COPY public.users (id, name, username, email, image_url, password_hash, login_attempts, created_at, seen_at, settings, permissions) FROM stdin;
1	\N	admin	\N	\N	$2b$10$lwE/Jgr8YLOcCKp5EJFiJuGCDIRnSCyVV63rWEuPLbFv9Lx7yGjJ6	0	2022-01-10 19:42:19.829907	2022-01-10 19:42:36.604	\N	[]
\.


--
-- Name: addons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: unleash_user
--

SELECT pg_catalog.setval('public.addons_id_seq', 1, false);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: unleash_user
--

SELECT pg_catalog.setval('public.events_id_seq', 8, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: unleash_user
--

SELECT pg_catalog.setval('public.migrations_id_seq', 91, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: unleash_user
--

SELECT pg_catalog.setval('public.roles_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: unleash_user
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: addons addons_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.addons
    ADD CONSTRAINT addons_pkey PRIMARY KEY (id);


--
-- Name: api_tokens api_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.api_tokens
    ADD CONSTRAINT api_tokens_pkey PRIMARY KEY (secret);


--
-- Name: client_applications client_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.client_applications
    ADD CONSTRAINT client_applications_pkey PRIMARY KEY (app_name);


--
-- Name: client_instances client_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.client_instances
    ADD CONSTRAINT client_instances_pkey PRIMARY KEY (app_name, environment, instance_id);


--
-- Name: client_metrics_env client_metrics_env_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.client_metrics_env
    ADD CONSTRAINT client_metrics_env_pkey PRIMARY KEY (feature_name, app_name, environment, "timestamp");


--
-- Name: context_fields context_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.context_fields
    ADD CONSTRAINT context_fields_pkey PRIMARY KEY (name);


--
-- Name: environments environments_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.environments
    ADD CONSTRAINT environments_pkey PRIMARY KEY (name);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: feature_environments feature_environments_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.feature_environments
    ADD CONSTRAINT feature_environments_pkey PRIMARY KEY (environment, feature_name);


--
-- Name: feature_strategies feature_strategies_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.feature_strategies
    ADD CONSTRAINT feature_strategies_pkey PRIMARY KEY (id);


--
-- Name: feature_tag feature_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.feature_tag
    ADD CONSTRAINT feature_tag_pkey PRIMARY KEY (feature_name, tag_type, tag_value);


--
-- Name: feature_types feature_types_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.feature_types
    ADD CONSTRAINT feature_types_pkey PRIMARY KEY (id);


--
-- Name: features features_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.features
    ADD CONSTRAINT features_pkey PRIMARY KEY (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: project_environments project_environments_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.project_environments
    ADD CONSTRAINT project_environments_pkey PRIMARY KEY (project_id, environment_name);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: reset_tokens reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.reset_tokens
    ADD CONSTRAINT reset_tokens_pkey PRIMARY KEY (reset_token);


--
-- Name: role_user role_user_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.role_user
    ADD CONSTRAINT role_user_pkey PRIMARY KEY (role_id, user_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (name);


--
-- Name: strategies strategies_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.strategies
    ADD CONSTRAINT strategies_pkey PRIMARY KEY (name);


--
-- Name: tag_types tag_types_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.tag_types
    ADD CONSTRAINT tag_types_pkey PRIMARY KEY (name);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (type, value);


--
-- Name: unleash_session unleash_session_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.unleash_session
    ADD CONSTRAINT unleash_session_pkey PRIMARY KEY (sid);


--
-- Name: user_feedback user_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_pkey PRIMARY KEY (user_id, feedback_id);


--
-- Name: user_splash user_splash_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.user_splash
    ADD CONSTRAINT user_splash_pkey PRIMARY KEY (user_id, splash_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: client_instances_environment_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX client_instances_environment_idx ON public.client_instances USING btree (environment);


--
-- Name: events_environment_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX events_environment_idx ON public.events USING btree (environment);


--
-- Name: events_project_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX events_project_idx ON public.events USING btree (project);


--
-- Name: feature_environments_feature_name_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX feature_environments_feature_name_idx ON public.feature_environments USING btree (feature_name);


--
-- Name: feature_name_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX feature_name_idx ON public.events USING btree (feature_name);


--
-- Name: feature_strategies_environment_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX feature_strategies_environment_idx ON public.feature_strategies USING btree (environment);


--
-- Name: feature_strategies_feature_name_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX feature_strategies_feature_name_idx ON public.feature_strategies USING btree (feature_name);


--
-- Name: feature_tag_tag_type_and_value_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX feature_tag_tag_type_and_value_idx ON public.feature_tag USING btree (tag_type, tag_value);


--
-- Name: idx_client_metrics_f_name; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX idx_client_metrics_f_name ON public.client_metrics_env USING btree (feature_name);


--
-- Name: idx_unleash_session_expired; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX idx_unleash_session_expired ON public.unleash_session USING btree (expired);


--
-- Name: project_environments_environment_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX project_environments_environment_idx ON public.project_environments USING btree (environment_name);


--
-- Name: reset_tokens_user_id_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX reset_tokens_user_id_idx ON public.reset_tokens USING btree (user_id);


--
-- Name: role_permission_role_id_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX role_permission_role_id_idx ON public.role_permission USING btree (role_id);


--
-- Name: role_user_user_id_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX role_user_user_id_idx ON public.role_user USING btree (user_id);


--
-- Name: user_feedback_user_id_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX user_feedback_user_id_idx ON public.user_feedback USING btree (user_id);


--
-- Name: user_splash_user_id_idx; Type: INDEX; Schema: public; Owner: unleash_user
--

CREATE INDEX user_splash_user_id_idx ON public.user_splash USING btree (user_id);


--
-- Name: api_tokens api_tokens_environment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.api_tokens
    ADD CONSTRAINT api_tokens_environment_fkey FOREIGN KEY (environment) REFERENCES public.environments(name) ON DELETE CASCADE;


--
-- Name: api_tokens api_tokens_project_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.api_tokens
    ADD CONSTRAINT api_tokens_project_fkey FOREIGN KEY (project) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: feature_environments feature_environments_environment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.feature_environments
    ADD CONSTRAINT feature_environments_environment_fkey FOREIGN KEY (environment) REFERENCES public.environments(name) ON DELETE CASCADE;


--
-- Name: feature_environments feature_environments_feature_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.feature_environments
    ADD CONSTRAINT feature_environments_feature_name_fkey FOREIGN KEY (feature_name) REFERENCES public.features(name) ON DELETE CASCADE;


--
-- Name: feature_strategies feature_strategies_environment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.feature_strategies
    ADD CONSTRAINT feature_strategies_environment_fkey FOREIGN KEY (environment) REFERENCES public.environments(name) ON DELETE CASCADE;


--
-- Name: feature_strategies feature_strategies_feature_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.feature_strategies
    ADD CONSTRAINT feature_strategies_feature_name_fkey FOREIGN KEY (feature_name) REFERENCES public.features(name) ON DELETE CASCADE;


--
-- Name: feature_tag feature_tag_feature_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.feature_tag
    ADD CONSTRAINT feature_tag_feature_name_fkey FOREIGN KEY (feature_name) REFERENCES public.features(name) ON DELETE CASCADE;


--
-- Name: feature_tag feature_tag_tag_type_tag_value_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.feature_tag
    ADD CONSTRAINT feature_tag_tag_type_tag_value_fkey FOREIGN KEY (tag_type, tag_value) REFERENCES public.tags(type, value) ON DELETE CASCADE;


--
-- Name: project_environments project_environments_environment_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.project_environments
    ADD CONSTRAINT project_environments_environment_name_fkey FOREIGN KEY (environment_name) REFERENCES public.environments(name) ON DELETE CASCADE;


--
-- Name: project_environments project_environments_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.project_environments
    ADD CONSTRAINT project_environments_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: reset_tokens reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.reset_tokens
    ADD CONSTRAINT reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: role_permission role_permission_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.role_permission
    ADD CONSTRAINT role_permission_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: role_user role_user_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.role_user
    ADD CONSTRAINT role_user_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: role_user role_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.role_user
    ADD CONSTRAINT role_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: tags tags_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_type_fkey FOREIGN KEY (type) REFERENCES public.tag_types(name) ON DELETE CASCADE;


--
-- Name: user_feedback user_feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.user_feedback
    ADD CONSTRAINT user_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_splash user_splash_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: unleash_user
--

ALTER TABLE ONLY public.user_splash
    ADD CONSTRAINT user_splash_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

