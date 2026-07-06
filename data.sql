--
-- PostgreSQL database dump
--

\restrict 6ksWJoOS8C3mDyWZOBpW1Hh3pQqbZrJYiwbXHSDgZ7RYvdmCoIvd93yt7ohRix5

-- Dumped from database version 18.1 (Debian 18.1-1.pgdg13+2)
-- Dumped by pg_dump version 18.4 (Ubuntu 18.4-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS evaluation;
--
-- Name: evaluation; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE evaluation WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


\unrestrict 6ksWJoOS8C3mDyWZOBpW1Hh3pQqbZrJYiwbXHSDgZ7RYvdmCoIvd93yt7ohRix5
\connect evaluation
\restrict 6ksWJoOS8C3mDyWZOBpW1Hh3pQqbZrJYiwbXHSDgZ7RYvdmCoIvd93yt7ohRix5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: attempt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attempt (
    attid integer NOT NULL,
    cid integer,
    regno character varying(10),
    query text
);


--
-- Name: attempt_attid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attempt_attid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attempt_attid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attempt_attid_seq OWNED BY public.attempt.attid;


--
-- Name: conduct; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conduct (
    cid integer NOT NULL,
    testid integer,
    code character varying(5) NOT NULL,
    duration integer,
    semester character varying(10) NOT NULL,
    year character varying(4) NOT NULL
);


--
-- Name: conduct_cid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conduct_cid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conduct_cid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conduct_cid_seq OWNED BY public.conduct.cid;


--
-- Name: query; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.query (
    qid integer NOT NULL,
    testid integer,
    query text NOT NULL
);


--
-- Name: query_qid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.query_qid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: query_qid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.query_qid_seq OWNED BY public.query.qid;


--
-- Name: result; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.result (
    rid integer NOT NULL,
    attid integer,
    marks numeric(5,2),
    status character varying(50),
    query text
);


--
-- Name: result_rid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.result_rid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: result_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.result_rid_seq OWNED BY public.result.rid;


--
-- Name: student; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student (
    regno character varying(10) NOT NULL,
    sname character varying(300) NOT NULL
);


--
-- Name: test; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test (
    testid integer NOT NULL,
    dbname character varying(100) NOT NULL,
    connurl character varying(300),
    testdate date DEFAULT CURRENT_DATE
);


--
-- Name: test_testid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.test_testid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: test_testid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.test_testid_seq OWNED BY public.test.testid;


--
-- Name: attempt attid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempt ALTER COLUMN attid SET DEFAULT nextval('public.attempt_attid_seq'::regclass);


--
-- Name: conduct cid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conduct ALTER COLUMN cid SET DEFAULT nextval('public.conduct_cid_seq'::regclass);


--
-- Name: query qid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.query ALTER COLUMN qid SET DEFAULT nextval('public.query_qid_seq'::regclass);


--
-- Name: result rid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.result ALTER COLUMN rid SET DEFAULT nextval('public.result_rid_seq'::regclass);


--
-- Name: test testid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test ALTER COLUMN testid SET DEFAULT nextval('public.test_testid_seq'::regclass);


--
-- Data for Name: attempt; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: conduct; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: query; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.query VALUES
	(1, 1, 'SELECT * FROM supplier WHERE city = ''London'';'),
	(2, 1, 'SELECT pname, weight FROM part WHERE color = ''Red'';'),
	(3, 1, 'SELECT jname, city FROM project WHERE city = ''Paris'';');


--
-- Data for Name: result; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.student VALUES
	('1612103', 'Ahsan Iftikhar'),
	('1612117', 'Maryam Liaquat'),
	('1612134', 'Syed Shujjat Ali Rizvi'),
	('1612140', 'Aartee Simran Dhomeja'),
	('1612141', 'Abdul Sami Hameed'),
	('1612143', 'Afaque Anwer Ali Khowaja'),
	('1612144', 'Ali Khan Mehboob Sachwani'),
	('1612145', 'Ali Sher Muhammad Aslam Alwani'),
	('1612149', 'Daniyal Akbar'),
	('1612151', 'Hamza Waleem Chowdhrey'),
	('1612153', 'Kulsum Siddiqui'),
	('1612155', 'Maha Amin Ahmad'),
	('1612156', 'Mariam Safdar'),
	('1612157', 'Mathan'),
	('1612159', 'Muhammad Ibrahim Khalil'),
	('1612162', 'Muhammad Jalal Sikandar'),
	('1612163', 'Muhammad Shaheer Siddiqui'),
	('1612165', 'Muhammad Tabish Jawaid'),
	('1612166', 'Muhammad Tameem'),
	('1612168', 'Rahul Lal'),
	('1612169', 'Rajesh Kumar'),
	('1612170', 'Rida Abdul Rashid'),
	('1612171', 'Rida Mukaddam'),
	('1612172', 'Sara Shaiq'),
	('1612303', 'Usama Khalid'),
	('1612311', 'Uzair Ahmed'),
	('1512126', 'Suleman Ali'),
	('1512228', 'Muhammad Humayun Aziz'),
	('1612179', 'Abdul Ahad Khan'),
	('1612181', 'Ahsan Amir Ali Mollani'),
	('1612182', 'Akash Kumar'),
	('1612184', 'Bilal Ahmed'),
	('1612185', 'Bushra Muhammad Kamil'),
	('1612190', 'Junaid Ahmed'),
	('1612193', 'Mohammad Dawood Khan'),
	('1612194', 'Muhammad Ahmed Siddiqui'),
	('1612195', 'Muhammad Hassan'),
	('1612196', 'Muhammad Saif Khan'),
	('1612197', 'Muhammad Shayan Akram Munshi'),
	('1612198', 'Muhammad Sufiyan Kundan'),
	('1612199', 'Muhammad Zubair Abdullah'),
	('1612200', 'Mustafa'),
	('1612201', 'Nazeer Ahmed'),
	('1612202', 'Nazim Firdous Ali Mandviwala'),
	('1612203', 'Omer Bin Habib'),
	('1612204', 'Paras Urf Sunny'),
	('1612207', 'Selina Alicia Wilson'),
	('1612209', 'Sufyan Shah'),
	('1612210', 'Sunil Kumar'),
	('1612211', 'Tayyaba Rafiq'),
	('1612306', 'Shayan Iqbal Shaikh'),
	('1612158', 'Muhammad Ahsan'),
	('1612261', 'Ajay Kumar Kataria'),
	('1612262', 'Akshay Lal'),
	('1612263', 'Ali Javed'),
	('1612265', 'Anas Akram Qureshi'),
	('1612266', 'Attaullah Brohi'),
	('1612268', 'Bilal Waqar Hasan'),
	('1612270', 'Faseeh Tahir Memon'),
	('1612272', 'Hasnain Aabdani'),
	('1612273', 'Hunain Ahmed'),
	('1612274', 'Jairam Gopechandani'),
	('1612275', 'M Raza Bin Abid'),
	('1612278', 'Muhammad Saad Vakil'),
	('1612279', 'Muhammad Ameen Tahseen'),
	('1612280', 'Muhammad Bilal Aleem'),
	('1612281', 'Muhammad Daniyal Wasi'),
	('1612283', 'Muhammad Maaz Umer'),
	('1612284', 'Muhammad Osama Khan'),
	('1612285', 'Muhammad Umar Sohail'),
	('1612286', 'Muhammad Zain Uddin'),
	('1612289', 'Noor Saqib Vohra'),
	('1612305', 'Fasih Zaman Siddiqui'),
	('1612133', 'Syed Muhammad Kazim'),
	('1612135', 'Syed Sibte Abbas Rizvi'),
	('1612136', 'Uzair Tariq'),
	('1612139', 'Zian Barkat Ali'),
	('1612173', 'Shweta Dhingana'),
	('1612174', 'Sukaina Mukhtar'),
	('1612175', 'Syed Asfand Hussain Shah'),
	('1612176', 'Wali Muhammad Khubaib'),
	('1612177', 'Zaid Raza'),
	('1612178', 'Zia Ul Hassan'),
	('1612212', 'Umair Riaz Abbasi'),
	('1612213', 'Umar Sharif'),
	('1612214', 'Versha Jagat Mankani'),
	('1612215', 'Vinay Kumar'),
	('1612217', 'Warjeet Lal Kungreja'),
	('1612218', 'Zeeshan Ahmed Shaikh'),
	('1612251', 'Saim Adnan'),
	('1612255', 'Syed Muhammad Kazim Naqvi'),
	('1612257', 'Tabish Taufiq Khalani'),
	('1612258', 'Zohair Lokhandwala'),
	('1612292', 'Sana Abu Ali Sheikh'),
	('1612294', 'Satiwan'),
	('1612297', 'Syeda Sania Jamshed'),
	('1612304', 'Asad Hanif'),
	('1612308', 'Alishba Agha'),
	('1612309', 'Shayan Aurangzeb'),
	('1612310', 'Mir Muhammad Magsi'),
	('1732102', 'Asim Riaz'),
	('1512286', 'Syed Muhammad Hamza'),
	('1512287', 'Wardah Aamer'),
	('1712101', 'Abdul Qadir Sher Gulab Khan'),
	('1712102', 'Adnan Aslam'),
	('1712105', 'Anas Muhammad Ali'),
	('1712106', 'Ayesha Qamaruzzaman Khan'),
	('1712107', 'Hafsa Zahir'),
	('1712108', 'Hamza Kashif'),
	('1712109', 'Hamza Zoeb'),
	('1712110', 'Haseeb Hashwani'),
	('1712112', 'Inaara Kalani'),
	('1712113', 'Jagdesh Tulsi'),
	('1712114', 'Jamshed Pervez'),
	('1712115', 'Junaid Ahmed Qureshi'),
	('1712116', 'Mahek Muhammed Iqbal Peerwani'),
	('1712117', 'Mahesh Kumar'),
	('1712118', 'Manal Zahid Siddique'),
	('1712119', 'Mohammad Ali Akber'),
	('1712121', 'Muhammad Laraib Janjua'),
	('1712122', 'Muhammad Ali'),
	('1712123', 'Muhammad Hammad Ikram'),
	('1712124', 'Muhammad Umar Khan'),
	('1712127', 'Omer Farooq'),
	('1712128', 'Qasim Aftab Sheikh'),
	('1712129', 'Salar Ali Choudhry'),
	('1712130', 'Sayed Saif Arslan Inam Shah'),
	('1712131', 'Sohaib Roomi'),
	('1712132', 'Syed Ali Raza Jaffri'),
	('1712134', 'Trun Raj Pal'),
	('1712135', 'Umaima Talib'),
	('1712136', 'Usama Usman'),
	('1712137', 'Zain Habibullah Baloch'),
	('1712138', 'Zain Abbas Punjwani'),
	('1712139', 'Zohaib Shah Nizar'),
	('1712300', 'Laiba Asim'),
	('1712144', 'Ehtasham Ather'),
	('1712147', 'Hira Fatima Sheharyar'),
	('1712148', 'Humza Farhan Samiullah'),
	('1712149', 'Huzaifa Hussain'),
	('1712150', 'Jawad Javaid'),
	('1712153', 'Lamya Halai'),
	('1712154', 'Maham Azam'),
	('1712157', 'Muhammad Talha Baig'),
	('1712163', 'Muhammad Saad Sohail'),
	('1712164', 'Muhammad Salman Awan'),
	('1712165', 'Muhammad Usman Pervaiz'),
	('1712166', 'Narotam Das'),
	('1712167', 'Naveed Azfar Khan'),
	('1712168', 'Paresh Rahool'),
	('1712169', 'Rohaan Faisal'),
	('1712170', 'Sanjay Kumar'),
	('1712171', 'Shahzadi Zainab Zahid'),
	('1712173', 'Soha Aftab'),
	('1712174', 'Suraksha Vijay Kumar Ramchandani'),
	('1712175', 'Syed Hur Abbas Naqvi'),
	('1712176', 'Syed Huzaifa Ali'),
	('1712177', 'Syed Muhammad Atif Bukhari'),
	('1712178', 'Wasil Anwar'),
	('1712301', 'Zahir Ali Salyani'),
	('1512118', 'Parshant Jagwani'),
	('1512119', 'Priya Khatri'),
	('1512166', 'Shayaan Varzgani'),
	('1512268', 'Shahzaib Ajaz Aziz Durrani'),
	('1512274', 'Taaiba Mohammad Khalid'),
	('1612112', 'Farrukh Adil'),
	('1612123', 'Muhammad Mustufa Kamal Siddiqui'),
	('1612129', 'Sameer Advani'),
	('1612164', 'Muhammad Sharjeel Naeem'),
	('1612167', 'Poonam Khatri'),
	('1612221', 'Ali Shahzad Khan'),
	('1612230', 'Hasnain Sohail'),
	('1612231', 'Jahanzaib Awan'),
	('1612233', 'Kapil Dev'),
	('1612234', 'Karan Kumar'),
	('1612236', 'Love Kumar Lalwani'),
	('1612239', 'Muhammad Ahmed Aijaz'),
	('1612243', 'Muhammed Osama Shaikh'),
	('1612287', 'Mujeeb Ahmed Awan'),
	('1612296', 'Sheryar Gulzar Ali Ladhwani'),
	('1612298', 'Mir Balach Jarwar'),
	('1612315', 'Abdullah Muhammad'),
	('1612318', 'Muhammad Irtiza Raza'),
	('1712104', 'Amna Nasir Bawa'),
	('1712111', 'Ibrahim Hussain Galya'),
	('1712125', 'Muneeb Ahmed'),
	('1712142', 'Chandan Kumar'),
	('1712143', 'Daniyal Faseeh'),
	('1712145', 'Esa Anjum'),
	('1712151', 'Kapil Kumar'),
	('1712152', 'Khurram Asif'),
	('1712172', 'Shayan Ur Rehman Siddiqui'),
	('1712180', 'Abdul Wasay'),
	('1712181', 'Abdullah Meraj Pracha'),
	('1712182', 'Agha Muhammad Ammar Mirza'),
	('1712183', 'Ahmad Raza'),
	('1712184', 'Ahmed Mohammed Bashir'),
	('1712185', 'Ali Shan Momin'),
	('1712189', 'Asbah Jaffri'),
	('1712190', 'Faisal Jamil'),
	('1712193', 'Hisham Akhtar'),
	('1712194', 'Jay Sunder'),
	('1712196', 'Muhammad Dawood Ul Hassan'),
	('1712197', 'Muhammad Hammad Arif'),
	('1712198', 'Muhammad Maaz Khan'),
	('1712199', 'Muhammad Muddasir'),
	('1712200', 'Muhammad Rizzan Imran'),
	('1712201', 'Muhammad Munil Anjum'),
	('1712202', 'Mustafa Mirza Kanjiyani'),
	('1712203', 'Nisha'),
	('1712204', 'Nitesh Kumar'),
	('1712208', 'Rauf Momin'),
	('1712210', 'Rubab Asif'),
	('1712211', 'Saifil Shamsuddin Momin'),
	('1712213', 'Shahul Momin'),
	('1712214', 'Shariq Ansari'),
	('1712217', 'Zeerak Naveed'),
	('1412112', 'Malik Azaz Khan'),
	('1712218', 'Aadesh Kumar'),
	('1712221', 'Arbaz Khan Afridi'),
	('1712222', 'Basit Raza'),
	('1712226', 'Eliza John Chohan'),
	('1712231', 'Muhammad Ali Saeed Motiwala'),
	('1712236', 'Muhammad Shaheem Khan'),
	('1712237', 'Muhammad Sufyan Rangoonwala'),
	('1712242', 'Saad Tariq'),
	('1712243', 'Saad Uddin Ahmed'),
	('1712245', 'Shahnoor Ahmed Khan'),
	('1712246', 'Shahzaib Sher Ali Muradani'),
	('1712248', 'Syed Saqlain Shah'),
	('1712250', 'Talal Abbas Jafri'),
	('1712251', 'Tazeen Fatima'),
	('1712252', 'Umer Nasir'),
	('1712253', 'Umer Rehman'),
	('1712255', 'Zahara Quresh'),
	('9912100', 'Dr. Husnain Mansoor Ali '),
	('9912101', 'Dr. Adeel Ansari        '),
	('9912103', 'Asim Riaz               '),
	('9912104', 'Muhammad Shahzad Haroon '),
	('1912231', 'Mohammad Areeb Faisal'),
	('1912392', 'Katie Homi Khambata'),
	('1912395', 'Muhammad Irtiza Shaikh'),
	('2012101', 'Aayush Kumar'),
	('2012102', 'Abdullah Shaikh'),
	('2012103', 'Ahanaf Hassan'),
	('2012104', 'Ahmer Ali'),
	('2012105', 'Ahsan Khursheed M. Khan'),
	('2012106', 'Amna Ahmed Mangi'),
	('2012107', 'Anish Kumar'),
	('2012108', 'Ankosh Kumar '),
	('2012109', 'Anzalna Anis'),
	('2012110', 'Arslan Ali'),
	('2012111', 'Arun Raj'),
	('2012112', 'Asfar Ali'),
	('2012113', 'Ashish Kumar'),
	('2012114', 'Deepak Veerani'),
	('2012115', 'Doulat Kumar'),
	('2012116', 'Faraz Hussain Mangwano'),
	('2012117', 'Fizza Rafiq Ali'),
	('2012118', 'Hamid Ali'),
	('2012119', 'Hammad Anwar'),
	('2012120', 'Jatesh Lohana'),
	('2012121', 'Khizar Ahmed Bhatti'),
	('2012122', 'Meet Kumar Lohana'),
	('2012124', 'Muhammad Taimoor Khan'),
	('2012125', 'Muhammad Mubeen Soomro'),
	('2012126', 'Muhammad Saad'),
	('2012127', 'Naveen Kumar Kingrani'),
	('2012129', 'Rohan Kumar Veerwani'),
	('2012130', 'Sachan Kumar'),
	('2012131', 'Sahil Katyara'),
	('2012132', 'Sahil Kumar'),
	('2012133', 'Sahil Kumar'),
	('2012134', 'Sahil Kumar Hindu'),
	('2012135', 'Sania Merchant'),
	('2012136', 'Seeba Marediya'),
	('2012137', 'Shajji Ahmed'),
	('2012138', 'Shivani Shamnani'),
	('2012139', 'Sundeep Kumar'),
	('2012140', 'Syeda Umaima Fatima'),
	('2012141', 'Tahir Ali Asghar'),
	('2012143', 'Vikas Kingrani'),
	('2012144', 'Vikash Kumar'),
	('2012145', 'Vishal Kumar'),
	('2012416', 'Muhammad Uzair'),
	('2012281', 'Abdul Muneeb'),
	('2012282', 'Abiali Qutbuddin Gadiwala'),
	('2012283', 'Aiman Siddiqui'),
	('2012284', 'Aleem Maknojia'),
	('2012285', 'Ali Asar Khowaja'),
	('2012286', 'Ali Iqbal Rashid'),
	('2012287', 'Alishah Akber Amin'),
	('2012288', 'Ammar Jawed Syed'),
	('2012289', 'Aqsa Mehmood Gaad'),
	('2012290', 'Asad Ali'),
	('2012291', 'Bilal Saeed'),
	('2012292', 'Bilal Pervez'),
	('2012293', 'Hammad Suleman Khan'),
	('2012294', 'Hareem Kalhoro'),
	('2012295', 'Jashwant Raysi Maheshwary'),
	('2012296', 'Kainaat Rafiqhussain Makhani'),
	('2012297', 'Kirshna Batra'),
	('2012298', 'Kripa Devi'),
	('2012299', 'Laksh Ajeet'),
	('2012300', 'Mohammad Rehmatullah Wadi Wala'),
	('2012301', 'Moiz Hussain Jamnagar'),
	('2012302', 'Muhammad Ali'),
	('2012303', 'Muhammad Ahmed Kamran'),
	('2012304', 'Muhammad Sarim Effendi'),
	('2012305', 'Muhammad Umair Khan'),
	('2012306', 'Nabi Bukhsh Jawed'),
	('2012307', 'Najeeb Ullah'),
	('2012308', 'Nensi Hindu'),
	('2012309', 'Obaid Ul Haq Khan'),
	('2012310', 'Parkash Kumar'),
	('2012311', 'Piyush Kukreja'),
	('2012312', 'Qirat Sohail'),
	('2012313', 'Raksha Kumari'),
	('2012314', 'Saad Abdul Sami'),
	('2012315', 'Saadat Ali'),
	('2012316', 'Sandhesh Kumar'),
	('2012317', 'Shahzeel Hameed Ansari'),
	('2012318', 'Sheetal Golani'),
	('2012319', 'Sheikh Moosa Ali'),
	('2012320', 'Sohasi Kataria'),
	('2012321', 'Syed Mehdi Abbas'),
	('2012322', 'Syed Muhammad Sauood'),
	('2012323', 'Usama Muhammad Afzal'),
	('2012324', 'Vandina Dodeja'),
	('2012325', 'Zeyaan Muhammad'),
	('2012420', 'Abdul Basit Khan'),
	('2012421', 'Muhammad Saif Ur Rehman Qureshi'),
	('1812150', 'Harmeet Jot'),
	('1812151', 'Hasnain Haider'),
	('1812153', 'Hunzala Ali'),
	('1812156', 'Malik Muhammad Basim Mansoor'),
	('1812157', 'Manish Mulchandani'),
	('1812159', 'Mohammad Hassan'),
	('1812161', 'Muhammad Hussain Ahmed'),
	('1812165', 'Ramesh Kumar'),
	('1812170', 'Sheikh Muhammad Asad'),
	('1812172', 'Syed Abdul Rafay'),
	('1812174', 'Syed Rafay Hasan'),
	('1812178', 'Abdul Hannan'),
	('1812179', 'Ahad Salman'),
	('1812180', 'Aqsa Shabir'),
	('1812181', 'Ashish Ali Umatia'),
	('1812182', 'Asif Ahmed'),
	('1812184', 'Fareeha Farooq'),
	('1812185', 'Hafsa Rehman'),
	('1812186', 'Har Pireet Wadhwani'),
	('1812187', 'Kamran Yaqub'),
	('1812188', 'Kashish Chhatani'),
	('1812189', 'Manav Kirshan Thontia'),
	('1812190', 'Mehak Lund'),
	('1812193', 'Muhammad Hassan Nadeem'),
	('1812197', 'Neeraj'),
	('1812201', 'Rimsha Nadeem'),
	('1812202', 'Rohan'),
	('1812204', 'Saad Ahmed Ali'),
	('1812206', 'Salman Ali Mughal'),
	('1812210', 'Tahir Ahmed Syed'),
	('1812228', 'Irfan Leghari'),
	('1812240', 'Muhammad Usman Aaka'),
	('1812326', 'Omar Farooq Malik'),
	('1812330', 'Farhan Ali'),
	('1812207', 'Shah Hussain Brohi'),
	('1812212', 'Umer Nasir'),
	('1812213', 'Virender Chawla'),
	('1812214', 'Wahaj Rashid'),
	('1812215', 'Abdur Rehman'),
	('1812217', 'Afreen Ahmed Baloch'),
	('1812226', 'Haneen Aijaz'),
	('1812227', 'Haziq Javed'),
	('1812229', 'Isbah Rizwan Gangani'),
	('1812231', 'Mahnoor Ashfaq'),
	('1812234', 'Mohammad Hassan Sohail'),
	('1812239', 'Muhammad Saad Yasin'),
	('1812241', 'Muhammed Ahmed'),
	('1812243', 'Osama Hasan Mahmood'),
	('1812247', 'Shayan Ahmed'),
	('1812250', 'Syed Bilal Haider'),
	('1812254', 'Abdul Wasay'),
	('1812255', 'Abdullah Saeed Shaikh'),
	('1812257', 'Anzeela Fatima'),
	('1812261', 'Dawood Mustafa Khan'),
	('1812262', 'Esha Rashid'),
	('1812263', 'Ghulam Mustafa'),
	('1812264', 'Hamza Hussain'),
	('1812279', 'Rumsha Naseem Khan'),
	('1612219', 'Abdur Arham Khatri'),
	('1612252', 'Sheikh Muhammad Jawad'),
	('1612317', 'Saiyida Noorulain Fatima'),
	('1812101', 'Ali Hussain Haneef'),
	('1812102', 'Alishan Nadeem Buddha'),
	('1812103', 'Aqib'),
	('1812104', 'Asim Ebrahim Khatri'),
	('1812105', 'Atif Aziz Memon'),
	('1812106', 'Azmeer'),
	('1812108', 'Danish Khowaja'),
	('1812109', 'Daniyal Riaz Malik'),
	('1812110', 'Elliott Francis Joseph'),
	('1812111', 'Hafeez Ur Rehman'),
	('1812112', 'Hafiz Syed Muhammad Umer Ali'),
	('1812113', 'Hiba Zakir'),
	('1812114', 'Hirdesh Kumar'),
	('1812115', 'Izhar Karim Baig'),
	('1812116', 'Javed'),
	('1812117', 'Mahek Dembra'),
	('1812118', 'Malik Rafaquat'),
	('1812120', 'Muhammad Anas'),
	('1812121', 'Muhammad Asad Ur Rehman Nadeem'),
	('1812122', 'Muhammad Obaid'),
	('1812123', 'Muhammad Rashwan Ur Rehman Siddiqui'),
	('1812124', 'Muhammad Tayyab'),
	('1812125', 'Muskan'),
	('1812126', 'Nabeel'),
	('1812127', 'Neha Bai'),
	('1812128', 'Nitin Kumar'),
	('1812130', 'Rajni Bai'),
	('1812134', 'Syed Mustafa Imam'),
	('1812137', 'Muhammad Usama'),
	('1812139', 'Abdul Rehman'),
	('1812143', 'Ali Muhammad'),
	('1812147', 'Aqsa'),
	('1812149', 'Fiza Ahmed'),
	('1812152', 'Hassaan Ali'),
	('1812155', 'Laiba Abid'),
	('1812158', 'Mian Abdul Manan Qureshi'),
	('1812162', 'Muhammad Anas Rana'),
	('1812163', 'Nida Nadeem'),
	('1812166', 'Sakshi Bai'),
	('1812167', 'Salman Budha'),
	('1812176', 'Zeeshan Waqar'),
	('1812196', 'Muskan Momin'),
	('1812221', 'Ammar Ahmed'),
	('1812224', 'Bushra Malik Shaikh'),
	('1812225', 'Danish Kumar'),
	('1812236', 'Mudassir Ahmed Siddiqui'),
	('1812237', 'Muhammad Hasan Qasim'),
	('1812242', 'Naqeeb Naushad'),
	('1812245', 'Sana Shujrah'),
	('1812246', 'Sarwan Usto'),
	('1812248', 'Sunila Zulfiqar'),
	('1812315', 'Muhib Ur Rehman'),
	('1812327', 'Ahsaan Khatri'),
	('1812328', 'Om Parkash'),
	('1812335', 'Ali Ahmed Khan'),
	('1812129', 'Rahul Gianchandani'),
	('1812131', 'Rohan Kukreja'),
	('1812132', 'Muhammad Shakir Yasin'),
	('1812133', 'Syed Muhammad Abu Talha'),
	('1812135', 'Syed Hurrar Hasan Rizvi'),
	('1812136', 'Tajwar Nazim Shah'),
	('1812138', 'Usman Raza'),
	('1812140', 'Abdul Moiz Qureshi'),
	('1812141', 'Abdul Samad Abdul Rauf Salat'),
	('1812142', 'Ahmed Hanif'),
	('1812145', 'Anjalee Jung'),
	('1812146', 'Anosha Koonger'),
	('1812154', 'Kumail Bukhari'),
	('1812164', 'Rai Muhammad Rafay Uz Zaman'),
	('1812169', 'Sayyan Sohail'),
	('1812171', 'Sunaina Ochani'),
	('1812173', 'Syed Muhammad Abbas Raza'),
	('1812175', 'Yousuf Abbas Lakdawala'),
	('1812177', 'Abdul Rehman Ijaz'),
	('1812183', 'Daniyal Ahmed'),
	('1812192', 'Muhammad Mubeen Shah'),
	('1812195', 'Muhammad Sarib'),
	('1812205', 'Saad Habib Siddiqui'),
	('1812208', 'Syed Nisar'),
	('1812218', 'Ahsan Hamid'),
	('1812219', 'Ali Bin Khalid'),
	('1812220', 'Ali Irtiza'),
	('1812230', 'Kashish Shewani'),
	('1812232', 'Minhal Abbas'),
	('1812233', 'Mohammad Hasnain'),
	('1812235', 'Mohammad Zain Ur Rehman'),
	('1812238', 'Muhammad Rafay Nadeem'),
	('1812244', 'Rana Omer Akhtar'),
	('1812251', 'Uneeb Ahmed'),
	('1812252', 'Zohaib Mohammed Ali'),
	('9912105', 'Maira Sami'),
	('9912106', 'Muhammad Asim Ali'),
	('2012372', 'Ahil Arif Deerani'),
	('2012373', 'Ahzam Mukarram Khan'),
	('2012374', 'Ali Zafar Qureshi'),
	('2012375', 'Aman .'),
	('2012376', 'Atta Ur Rehman'),
	('2012377', 'Chandras Ayush'),
	('2012378', 'Erum Shehzadi'),
	('2012379', 'Fahad Iqbal'),
	('2012380', 'Faiez Waseem'),
	('2012381', 'Gaitri Punjwani'),
	('2012382', 'Hana Noor'),
	('2012383', 'Hani Shah'),
	('2012384', 'Hasnain Ali'),
	('2012385', 'Huzaifa Ali Khan'),
	('2012386', 'Javeria Shaikh'),
	('2012389', 'Mohammad Ali'),
	('2012390', 'Muhammad Faseeh Shahid'),
	('2012391', 'Muhammad Hamza'),
	('2012392', 'Muhammad Hamza Shamsi'),
	('2012393', 'Muhammad Mohsin Khan'),
	('2012394', 'Muhammad Muqarrab Ali'),
	('2012395', 'Muhammad Sajjad'),
	('2012396', 'Muhmmad Owais Khalid'),
	('2012397', 'Muskan Thahim'),
	('2012398', 'Nabeel Hussain'),
	('2012399', 'Naveed Saddruddin'),
	('2012400', 'Nimarta Kingrani'),
	('2012401', 'Rabeya Tasleem'),
	('2012402', 'Ronit Kumar'),
	('2012403', 'Safwan Uddin Mairaj'),
	('2012404', 'Sameeh Raza'),
	('2012405', 'Samrah Durrani'),
	('2012407', 'Shayan Hussain'),
	('2012408', 'Shilpa Kumari'),
	('2012409', 'Suleman Hanif'),
	('2012410', 'Syed Asad Hussain Kazmi'),
	('2012411', 'Syeda Sara Naqvi'),
	('2012412', 'Umair Khan'),
	('2012413', 'Vinay Kumar'),
	('2012414', 'Vineeta Chawla'),
	('2012415', 'Zain Ahmed Multani'),
	('1812265', 'Hiba Furqan'),
	('2012147', 'Ahmed Bin Abdullah'),
	('2012148', 'Alishan Khowaja'),
	('2012149', 'Aman Khuwaja'),
	('2012150', 'Aneel'),
	('2012152', 'Bilal Yousuf Bilal Yousuf'),
	('2012153', 'Chand Mevaram'),
	('2012154', 'Faiza Farooq'),
	('2012155', 'Ghazanfar Haider Golani'),
	('2012156', 'Hammad Aslam'),
	('2012157', 'Hamza Ahmed Siddiqui'),
	('2012158', 'Hanium Iqbal'),
	('2012161', 'Keertan Kumar Talreja'),
	('2012162', 'Laiba Hasan'),
	('2012163', 'Laksh Nanwani'),
	('2012166', 'Mufaddal Hatim Dabbawala'),
	('2012169', 'Muhammad Umer Saeed'),
	('2012171', 'Muhammad Hassan Mirza'),
	('2012172', 'Muhammad Talha'),
	('2012173', 'Mustafa Abbas'),
	('2012174', 'Nabeela Rehman Wazir'),
	('2012175', 'Padma Kumari Talreja'),
	('2012176', 'Qurratulain Qamruddin Mawani'),
	('2012177', 'Raheem Jawed'),
	('2012179', 'Romessa Nazir Palijo'),
	('2012180', 'Sagar Kumar'),
	('2012181', 'Sahil Kumar'),
	('2012183', 'Sarah Amir'),
	('2012184', 'Sarmad Saeed Soomro'),
	('2012185', 'Sheheryar Khan Afridi'),
	('2012186', 'Soha Mehfooz'),
	('2012187', 'Syed Muhammad Ali Hussain Qadri'),
	('2012189', 'Wajahat Ali'),
	('2012190', 'Zahabiya Moiz Hussain'),
	('2012417', 'Syeda Laiba Sabir'),
	('2112282', 'Noor Ahmed'),
	('2112324', 'Omer Siddiqui'),
	('9912107', 'Sadia Aziz'),
	('1912391', 'Bilal Qader'),
	('2112299', 'Abdul Haseeb Majid'),
	('2112300', 'Ahmed Ibrahim'),
	('2112301', 'Aimen Asim'),
	('2112302', 'Ameem Uddin Ahmed'),
	('2112303', 'Ayaan Ahmed'),
	('2112304', 'Ayush Kumar Talreja'),
	('2112305', 'Huzaifa Hanif'),
	('2112306', 'Jetha Nand'),
	('2112307', 'Karan Kumar'),
	('2112308', 'Karishma Bai'),
	('2112309', 'Khawalid Mehmood'),
	('2112310', 'Koonj Mahnoor'),
	('2112311', 'Kulsoom Asim'),
	('2112312', 'Mazin Bhagwanee'),
	('2112313', 'Minahil Khan'),
	('2112314', 'Mohammad Arqam Nakhuda'),
	('2112315', 'Muhammad Suhaib'),
	('2112316', 'Muhammad Abbas Abid'),
	('2112317', 'Muhammad Ali Adil Sarwar'),
	('2112318', 'Muhammad Asad Saeed'),
	('2112319', 'Muhammad Farjad Ghani'),
	('2112320', 'Muhammad Hassan Ashraf'),
	('2112321', 'Muhammad Jahanzaib Baig'),
	('2112322', 'Muhammad Wajih Rashid'),
	('2112323', 'Naveen Kumar'),
	('2112325', 'Rabeel Kumari'),
	('2112326', 'Saad Qasim'),
	('2112327', 'Shahab Mustafa Daudpota'),
	('2112328', 'Shahzaad Sultan Ali'),
	('2112329', 'Subhash Chandar Khatri'),
	('2112330', 'Sufyan Sajjad'),
	('2112331', 'Syed Mehdi Abbas Naqvi'),
	('2112333', 'Syed Haris Ahmed'),
	('2112334', 'Syed Mohammad Mujtaba Abbbas'),
	('2112335', 'Syed Sabih Ghufran Naqvi'),
	('2112336', 'Tuba Nauran'),
	('2112337', 'Umer Ahmed'),
	('2112338', 'Usman Bin Obaid'),
	('2112339', 'Varun Kumar Rathi'),
	('2012362', 'Rohail Rathore'),
	('2112102', 'Ajia Athar'),
	('2112103', 'Akshat Kishore'),
	('2112104', 'Aliyan Sayani'),
	('2112105', 'Asad Awan'),
	('2112106', 'Asma Hafiz Mirnawaz '),
	('2112107', 'Avisha Kataria'),
	('2112108', 'Chankia Pahwani'),
	('2112109', 'Duaa Ali'),
	('2112110', 'Ebad Khan'),
	('2112112', 'Hareem Fatima Fatima'),
	('2112113', 'Hussam Wasti'),
	('2112114', 'Iqbal Shah Nadir'),
	('2112117', 'Mohammad Hadi'),
	('2112118', 'Muhammad Saad'),
	('2112120', 'Murtaza Ali Qazi'),
	('2112121', 'Mustan Ali'),
	('2112122', 'Rateesh Kumar'),
	('2112123', 'Rida Fatima'),
	('2112124', 'Roha Ali'),
	('2112125', 'Saada Asghar Ali Varsani'),
	('2112126', 'Sabih Ul Hassan'),
	('2112127', 'Sandeep Kumar'),
	('2112128', 'Sandya Nankani'),
	('2112129', 'Sanesh Kumar'),
	('2112130', 'Suhaib Tasleem'),
	('2112131', 'Syed Muhammad Abdullah Shah Hamdani'),
	('2112132', 'Syed Muneef Ur Rehman'),
	('2112134', 'Syed Wajahat Hussain'),
	('2112135', 'Syeda Mahnoor Hasan'),
	('2112136', 'Tooba Mushtaq Piracha'),
	('2112241', 'Umer Amir'),
	('2112242', 'Mazahir Abbas Merchant'),
	('2112243', 'Muhammad Mudassir'),
	('2112244', 'Muhammad Taha Jamal'),
	('2112245', 'Ritesh Kumar'),
	('2112340', 'Muhammad Shoaib Zafar'),
	('2112137', 'Abdul Basit'),
	('2112138', 'Anchal Bai'),
	('2112139', 'Areeba Sheikh'),
	('2112140', 'Arish Amin Muhammad Meghani'),
	('2112143', 'Ghazal E Ashar'),
	('2112144', 'Imran Ali'),
	('2112145', 'Mahad Hassan Asim'),
	('2112146', 'Mahira Muhammad Iqbal Peerwani'),
	('2112147', 'Manoj Kumar Talreja'),
	('2112148', 'Mohammad Ali Hassan'),
	('2112149', 'Mohammad Raza Shaikh'),
	('2112150', 'Mohammed Ali Zahir Ali Khowaja'),
	('2112151', 'Mubeen Naushad'),
	('2112153', 'Muhammad Hamza Javed'),
	('2112154', 'Muhammad Waqas Khan'),
	('2112156', 'Muhammad Abrar Junaid'),
	('2112157', 'Muhammad Aqrab'),
	('2112158', 'Muhammad Soban Mallick'),
	('2112159', 'Nijla Kamil'),
	('2112160', 'Rabia Adil Rasool'),
	('2112161', 'Ritika Assnani Lohana'),
	('2112162', 'Sadaf Khalid'),
	('2112163', 'Sandesh Kumar'),
	('2112165', 'Sehar Yousuf'),
	('2112166', 'Shahzeb Ahmed Iqbal'),
	('2112167', 'Syed Hamid Ali'),
	('2112168', 'Usama Habib'),
	('2112169', 'Zoun Ali Zoofi'),
	('2112246', 'Ali Haider'),
	('2112247', 'Muhammad Ammar Thahim'),
	('2112248', 'Paras Talpur'),
	('2112249', 'Shawn Michael'),
	('2112341', 'Asfund Ali Amjad'),
	('21108101', 'Ariba'),
	('21108102', 'Farzam Arshad Ali'),
	('21108104', 'Javeria Shah'),
	('21108105', 'Maria Ashraf'),
	('21108106', 'Mohammad Ahmed Jalali'),
	('21108108', 'Muhammad Aadil'),
	('21108109', 'Muhammad Shaheer'),
	('21108112', 'Muskan Keemat Madhwani'),
	('21108113', 'Nauman Nadeem Alam'),
	('21108115', 'Reenad Khan'),
	('21108116', 'Saad Khan'),
	('21108117', 'Subhan Nayyar'),
	('21108118', 'Sumera Baloch'),
	('21108120', 'Syed Hamza'),
	('21108121', 'Syed Mahd Shoaib'),
	('21108122', 'Syed Muhammad Daniyal Suhail'),
	('21108123', 'Syed Muhammad Momin Naqvi'),
	('21108124', 'Zulfiqar Azeem Fazal'),
	('21108125', 'Ali Ahad'),
	('21108126', 'Bilal Zakir'),
	('21108127', 'Ehsan Ullah Narejo'),
	('21108128', 'Haseeb Ur Rehman Niazi'),
	('21108129', 'Muhammad Aashir Chowdhari'),
	('21108130', 'Muhammad Ali'),
	('21108131', 'Muhammad Amin Rahu'),
	('21108133', 'Muhammad Mehdi'),
	('21108134', 'Rabia Afzal'),
	('21108135', 'Sanjay Kumar'),
	('21108136', 'Sarim Ali Pirzada'),
	('21108137', 'Shaheer Bin Amir'),
	('21108138', 'Shayaan Salim Mehrani'),
	('21108140', 'Suresh Maheshwari'),
	('21108141', 'Syed Ibad Ur Rehman'),
	('21108142', 'Syeda Aliya Jaffrey'),
	('21108143', 'Yawar Jamshed Matin'),
	('21108144', 'Mohit Kumar'),
	('21108145', 'Muhammad Maaz Irfan'),
	('1912178', 'Anas Sohail Quraishi'),
	('1912183', 'Dua Khan'),
	('1912190', 'Mir Muhammad Mazhar Virani'),
	('1912192', 'Muhammad Hamza'),
	('1912198', 'Nehal Faisal'),
	('1912199', 'Nihal Nooruddin Vidhani'),
	('1912204', 'Sami Akhtar Ali'),
	('1912206', 'Shehzad Ismail Khowaja'),
	('1912211', 'Taha Yousuf Ali'),
	('1912214', 'Uzair Fawad'),
	('1912319', 'Pardeep Kumar'),
	('1912333', 'Abdul Moeed Siddiqui'),
	('1912336', 'Aisha Faheem'),
	('1912347', 'Iqra Ghazal'),
	('1912351', 'Khizar Abdul Rahim'),
	('1912360', 'Qamber Ali'),
	('1912366', 'Sharon Agita Massey'),
	('1712146', 'Haider Saba'),
	('1812287', 'Umair Azhar'),
	('1912102', 'Abdullah Usmani'),
	('1912103', 'Absar Ahmed'),
	('1912104', 'Ammar Ahmed Khan'),
	('1912107', 'Atta E Rasool'),
	('1912112', 'Fazeel Ahmed'),
	('1912114', 'Hasan Jan Siddiqui'),
	('1912115', 'Izhan Alam Khan'),
	('1912120', 'Muhammad Jamshed Khan'),
	('1912121', 'Muhammad Kashan'),
	('1912127', 'Noman Azam'),
	('1912128', 'Rabia Bint E Nisar'),
	('1912131', 'Shehrayar Khan'),
	('1912133', 'Syed Murtaza Shah'),
	('1912135', 'Zain Ul Abedin Aslam Sheikh'),
	('1912138', 'Ali Asghar Zaidi'),
	('1912141', 'Anas Naveed'),
	('1912145', 'Hasan Abdul Moeed Khan'),
	('1912146', 'Idrees Mudar Darbar'),
	('1912156', 'Muhammad Ubaid Rathore'),
	('1912159', 'Muhammad Zaid'),
	('1912160', 'Nancy Kumari'),
	('1912161', 'Payal Wadhwani'),
	('1912162', 'Rafay Imtiaz Memon'),
	('1912163', 'Rameel Faisal'),
	('1912164', 'Rameen Aamir Khan'),
	('1912168', 'Samiullah Mughal'),
	('1912169', 'Sobia Muhammad Rizwan Dosani'),
	('1912170', 'Sunena Kumari'),
	('1912171', 'Syed Ahmed Hasan'),
	('1912172', 'Syed Mudassir Ul Haq'),
	('1912175', 'Zamam Ahmed'),
	('1912179', 'Anjalee'),
	('1912185', 'Fahad Amin Lakhani'),
	('1912187', 'Hassan Ur Rehman'),
	('1912194', 'Muhammad Mustafa'),
	('1912215', 'Affan Khurram'),
	('1912225', 'Hamdan Khan Saghri'),
	('1912227', 'Hammad Farman Ahmed Khan'),
	('1912228', 'Hassan Ali'),
	('1912229', 'Hussain Rafiq Tabani'),
	('1912235', 'Muhammad Ubaid Abdul Razzaq'),
	('1912236', 'Muhammad Ammar Memon'),
	('1912237', 'Muhammad Sameer Sajid'),
	('1912242', 'Qudsia Rashid'),
	('1912243', 'Sheharyar Ul Hassan'),
	('1912247', 'Syed Muhammad Yaseen'),
	('1912256', 'Abdullah Gul'),
	('1912259', 'Ali Muhammad'),
	('1912263', 'Hasnain Raza'),
	('1912270', 'Muhammad Hamza Khan'),
	('1912281', 'Rohit Puri'),
	('1912305', 'Labeenah Khan'),
	('1912312', 'Muhammad Aurangzaib Khan'),
	('1912314', 'Muhammad Huzaifa Khan'),
	('1912323', 'Syed Omer Salahuddin'),
	('1912332', 'Abdul Aziz'),
	('1912334', 'Abdullah Bin Tahir'),
	('1912337', 'Akshay Kumar'),
	('1912345', 'Hasham Ahmed'),
	('1912350', 'Kabir Ahmed Bhatti'),
	('1912356', 'Muhammad Abdullah Azhar'),
	('1912357', 'Muhammad Yousha'),
	('1912358', 'Muhammad Zain Noorani'),
	('1912363', 'Raza Ahmed'),
	('1912368', 'Shuaib Yasin'),
	('1912369', 'Syed Hasnain Abbas'),
	('1912371', 'Syed Murtaza Hussain Abidi'),
	('1912373', 'Zohaib Adil Rasool'),
	('1912375', 'Ameer Uddin Shayyan'),
	('1912376', 'Mubashir Ali'),
	('1912377', 'Fatima Tuz Zehra'),
	('1912385', 'Zohaib Ilyas'),
	('1912386', 'Muhammad Asher'),
	('1912393', 'Mohammad Jawad Iqbal'),
	('1912394', 'Muhammad Haziq'),
	('1912396', 'Sara Syed Prasla'),
	('1912397', 'Arisha Arbani'),
	('1712232', 'Muhammad Iftikhar Khan'),
	('1912111', 'Dua Imran'),
	('1912132', 'Syed Muhammad Abbas Hassan'),
	('1912134', 'Syed Zohaib Ahmed'),
	('1912253', 'Vishesh Sagar'),
	('1912254', 'Aakash Kumar'),
	('1912255', 'Abdul Rehman'),
	('1912258', 'Akshay Kumar'),
	('1912260', 'Asma Atique'),
	('1912261', 'Dua Gul Muhammad'),
	('1912262', 'Hamza Ihsan'),
	('1912267', 'Moaz Javed Khan'),
	('1912268', 'Muhammad Anas'),
	('1912272', 'Muhammad Sufyan Mallick'),
	('1912274', 'Muhammad Umer Uzair'),
	('1912275', 'Murk Matlani'),
	('1912276', 'Muzzammil Ishaq'),
	('1912278', 'Prena Parpiani'),
	('1912279', 'Rabia Memon'),
	('1912280', 'Rizwan Hadi'),
	('1912284', 'Sandesh Lal'),
	('1912286', 'Syed Arham Abdullah'),
	('1912288', 'Syed Shayan Mustufa'),
	('1912290', 'Yousuf Zubair Chohan'),
	('1912291', 'Zabloon Albert'),
	('1912359', 'Nimerta Bai'),
	('1912374', 'Abdul Samee Sehol'),
	('1912389', 'Fatima Imran'),
	('1912390', 'Abeera Naveed'),
	('1712191', 'Hassan Mehmood'),
	('1812345', 'Riaz Rafiq Khimani'),
	('1912144', 'Hamza Shafiq'),
	('1912207', 'Sooraj Kumar'),
	('1912217', 'Anmol Keswani'),
	('1912218', 'Apuruwah Amar Lal'),
	('1912219', 'Ashesh Kumar Rejhra'),
	('1912220', 'Avinash Khemani'),
	('1912221', 'Avinash Rejhra'),
	('1912245', 'Somesh Kumar Bhagia'),
	('1912250', 'Uneeb Asad'),
	('1912252', 'Vishal'),
	('1912271', 'Muhammad Shamaeem Ali'),
	('1912273', 'Muhammad Umer'),
	('1912285', 'Sejal Sitani'),
	('1912292', 'Aadesh Kumar'),
	('1912293', 'Abdul Rehman'),
	('1912296', 'Agha Daud Durrani'),
	('1912297', 'Asaad Noman Abbasi'),
	('1912299', 'Bakhtiar Masood'),
	('1912300', 'Danish Aslam Sheikh'),
	('1912304', 'Komal Devi Aruwani'),
	('1912306', 'Moiz Ahmed Khan'),
	('1912310', 'Muhammad Ahsan'),
	('1912311', 'Muhammad Ashhad Siddiqui'),
	('1912313', 'Muhammad Faisal'),
	('1912316', 'Muhammad Yousuf Hyder'),
	('1912317', 'Muskan Makhija'),
	('1912321', 'Shah Mubashir Ul Haq'),
	('1912322', 'Shayan Ali Mankani'),
	('1912325', 'Syed Yousuf Fatmi'),
	('1912326', 'Tabassum Habibullah'),
	('1912327', 'Umer Ali Usmani'),
	('1912328', 'Yousuf Abbas Shah'),
	('1912329', 'Yumna Waseem'),
	('1912330', 'Zawat Masta'),
	('1912331', 'Zeehan Haider'),
	('1912387', 'Akbar Rehmat'),
	('2012164', 'Mohammad Hammad Farooq'),
	('2012210', 'Maria Sajid Gaddi'),
	('2012219', 'Neha Batra'),
	('2012223', 'Rithik Kumar'),
	('2012225', 'Rohan Kumar'),
	('2012227', 'Sattiwan Kumar'),
	('2012231', 'Sindhu Kukreja'),
	('2012232', 'Syed Shajee Haider Zaidi'),
	('2012254', 'Muhammad Ali'),
	('2012329', 'Aleena Fatima Abro'),
	('2012343', 'Hamza Tariq'),
	('2012344', 'Khubaib Bin Naeem'),
	('2012357', 'Muhammad Usama Asif'),
	('2173149', 'Muhammad Danish Khan Jadoon'),
	('2280135', 'Abdullah Ansari'),
	('2280136', 'Afifa Jatoi'),
	('2280137', 'Ameer Umar Khan'),
	('2280138', 'Ariha Zainab'),
	('2280139', 'Arsalan Ayaz'),
	('2280140', 'Arshiya Muhammad Ali'),
	('2280141', 'Eisha Arshad Hussain'),
	('2280142', 'Hafiz Abrar Iqbal'),
	('2280143', 'Hamad Naseem'),
	('2280144', 'Hamd Feroz Ansari'),
	('2280145', 'Hassan Raza Ladha'),
	('2280146', 'Maria Mazari'),
	('2280147', 'Marrium Shaikh'),
	('2280148', 'Mirza Usman Baig'),
	('2280149', 'Misha Sohail Ahmed'),
	('2280150', 'Muhammad Bin Tariq'),
	('2280151', 'Muhammad Osama'),
	('2280152', 'Muhammad Shahmeer'),
	('2280153', 'Muhammad Talha Arif'),
	('2280154', 'Muhammad Usama Zahid'),
	('2280155', 'Muhammad Yahya Ahmer'),
	('2280156', 'Om'),
	('2280157', 'Rafay Hussain'),
	('2280158', 'Rahul Kumar'),
	('2280159', 'Rehan Badshah'),
	('2280160', 'Sameer Ahmed Sahito'),
	('2280161', 'Syed Ahmed Hamza'),
	('2280162', 'Syed Arif Ali Shah'),
	('2280163', 'Syed Muhammad Askari'),
	('2280164', 'Talha Nawab'),
	('2280165', 'Vinod Kumar'),
	('2280166', 'Vivek Kumar'),
	('2280167', 'Yasir Hussain'),
	('2280168', 'Zohaib Hassan'),
	('2280172', 'Afzal Ali'),
	('2280175', 'Badshah Jan'),
	('2280101', 'Abubakar Mangrio'),
	('2280102', 'Adeeba Salman'),
	('2280103', 'Adil Memon'),
	('2280104', 'Aman Asaf'),
	('2280105', 'Aneesh Kumar Talreja'),
	('2280106', 'Anmol Hindu'),
	('2280107', 'Basim Hasan Khan'),
	('2280108', 'Bisma Saeed'),
	('2280109', 'Bisma Sahr'),
	('2280110', 'Dawood Imran'),
	('2280111', 'Farrukh Ali Bhatti'),
	('2280112', 'Furqan Fayaz Shaikh'),
	('2280113', 'Hamza Siraj'),
	('2280114', 'Haroon Hassan Rasheed'),
	('2280115', 'Hasan Mehdi'),
	('2280116', 'Laraib Zafar Khan'),
	('2280117', 'Maha Zafar Iqbal'),
	('2280118', 'Marium Muhammad'),
	('2280119', 'Mohammad Yahyah Adnan'),
	('2280120', 'Muhammad Ahsan Mohsin'),
	('2280121', 'Muhammad Azhar Bhutto'),
	('2280122', 'Muhammad Hamid Raza'),
	('2280123', 'Muhammad Saeed Ansari'),
	('2280124', 'Netaliya Amjad'),
	('2280125', 'Qurat Ul Ain Bashir'),
	('2280126', 'Sajjad Ali Shaikh'),
	('2280127', 'Sartaj'),
	('2280128', 'Shayan Khowaja Shoukat Ali Khowaja'),
	('2280129', 'Syed Ukkashah Ahmed Shah'),
	('2280131', 'Talal Ali Bhatti'),
	('2280132', 'Usman Akbar'),
	('2280133', 'Yumaan Mustafa'),
	('2280134', 'Zainab'),
	('2280169', 'Qatadah Furqan'),
	('2280171', 'Kabir Ahmed'),
	('2280173', 'Abbad Maqbool Qadir'),
	('2280174', 'Muzammil Naeem'),
	('1912119', 'Muhammad Auon Raza'),
	('1912158', 'Muhammad Usman'),
	('2312102', 'Safdar Hussain Abbasi'),
	('2312142', 'Dhani Bux Lashari'),
	('2312101', 'Abdul Aziz Kehar'),
	('2312104', 'Awais Ali Baloch'),
	('2312107', 'Neelam Abbas'),
	('2112260', 'Aihan Mahmood Siddiqui'),
	('2112266', 'Bilal Kashan'),
	('2112269', 'Maaz Khan'),
	('2112270', 'Mohammad Affan'),
	('2112271', 'Mubaraka Zoeb Sadri'),
	('2112273', 'Muhammad Ibrar Kalwar'),
	('2112274', 'Muhammad Zain Sajid'),
	('2112277', 'Muhammad Habib Ur Rehman'),
	('2112283', 'Om Kirshana'),
	('2112284', 'Sameer Ahmed'),
	('2112287', 'Muhammad Shaheer Siddiqui'),
	('2112292', 'Syeda Aliba Naqvi'),
	('2112295', 'Uzair Ahmed Dahraj'),
	('2212270', 'Shahzaib Chughtai'),
	('1812274', 'Muhammad Ukkasha'),
	('2112111', 'Fawad Masood Khan'),
	('2112119', 'Muhammad Taha Malik'),
	('1812347', 'Ali Nasir Shakil'),
	('1912302', 'Hallar Khalil'),
	('2112286', 'Sershti Kumari'),
	('2112202', 'Tamana Jhamani'),
	('2112250', 'Muhammad Fayyaz'),
	('2112182', 'Jaweriya Younus'),
	('2012199', 'Daniyal Ahmed'),
	('2012226', 'Samail Mustafa'),
	('2112278', 'Muhammad Maaz Uddin'),
	('2112185', 'Mir Saqib Raza'),
	('2112194', 'Muhammad Sarwar Hussain'),
	('2112174', 'Ahmed Mustafa Sohail'),
	('2112297', 'Wasil Ahmed'),
	('2112259', 'Abdullah Ayaz Khan'),
	('2012178', 'Ram Sagar');
INSERT INTO public.student VALUES
	('2012253', 'Muhammad Zain'),
	('2012279', 'Umair Bin Naeem'),
	('2012242', 'Bilal Azfar Khan'),
	('2012355', 'Muhammad Sarim Khan'),
	('1912108-1', 'Safiullah Jatoi'),
	('2012125-1', 'Aqib Mustafa Surhio'),
	('2012126-1', 'Ayesha Shaikh'),
	('2012128-1', 'Hamza Ali Ansari'),
	('2012129-1', 'Hassnain Ahmed Soomro'),
	('2012131-1', 'Humera Shaikh'),
	('2012133-1', 'Jai Kumar'),
	('2012135-1', 'Muhammad Ali'),
	('2012137-1', 'Muhammad Tariq Babar'),
	('2012139-1', 'Muskan Panjwani'),
	('2012140-1', 'Sarang Zameer Abbasi'),
	('2012141-1', 'Shafaque Khalil Thebo'),
	('2012144-1', 'Suman Surahio'),
	('2012148-1', 'Zubair Ahmed Mugheri'),
	('2012149-1', 'Areeba Asif Shaikh'),
	('2012153-1', 'Umer Draaz'),
	('2212277', 'Aatir Raza'),
	('2212280', 'Adeeba Kalwar'),
	('2212283', 'Anushe Sadiq Khan'),
	('2212288', 'Ilyaan Umatia'),
	('2212289', 'Kumkum Wadhwani'),
	('2212290', 'Luvai Yahya Bhuriwala'),
	('2212291', 'Mehak'),
	('2212292', 'Mirza Mashhood Ul Hassan'),
	('2212293', 'Misbah Maqbool'),
	('2212295', 'Muhammad Amir'),
	('2212296', 'Muhammad Ammar Kanani'),
	('2212299', 'Nandni Pohani'),
	('2212302', 'Saeed Ul Khair Quaid Joher Ujjain Wala'),
	('2212304', 'Sarah Salim Jamani'),
	('2212309', 'Siya Nanwani'),
	('2212311', 'Umer Farooque'),
	('2212318', 'Bushra Bibi'),
	('2212319', 'Mumta Bai Punjwani'),
	('2212345', 'Anum Zehra Noorani'),
	('2212346', 'Bushra Soomro'),
	('2212347', 'Muhammad Saad Naeem'),
	('2212349', 'Shahzaib Faisal'),
	('2212354', 'Taha Mehmood'),
	('23101117', 'Muhammad Shoaib Pasha'),
	('23101118', 'Muhammad Tafseer'),
	('2212136', 'Agha Nadir Ali'),
	('2212137', 'Ali Abbas'),
	('2212138', 'Ali Haider Jumani'),
	('2212140', 'Anesh Kumar'),
	('2212143', 'Hani Waleed'),
	('2212144', 'Hareem Akhtar'),
	('2212145', 'Iliyan Faisal Valliani'),
	('2212146', 'Jahanzeb Yameen'),
	('2212147', 'Kailash Kumar'),
	('2212148', 'Kashish Nankani'),
	('2212149', 'Kumail Ahmed Soomro'),
	('2212150', 'Laina Vijay Kumar'),
	('2212152', 'Muhammad Sarim'),
	('2212153', 'Muhammad Yaseen Ahmed'),
	('2212155', 'Nathan C F Desouza'),
	('2212156', 'Pranjal Batheja'),
	('2212157', 'Sahil Kumar'),
	('2212160', 'Shamlal'),
	('2212162', 'Siya Santosh'),
	('2212163', 'Syeda Fizza Rashid Zaidi'),
	('2212164', 'Talha Shamim'),
	('2212165', 'Teesha Kumari'),
	('2212169', 'Zainab Loya'),
	('2212170', 'Muhammad Zubair Shah'),
	('2212330', 'Sakinah Batool Kanani'),
	('2212356', 'Atif Nawaz'),
	('2112349', 'Fatima Khan'),
	('2212101', 'Aariz Samdani'),
	('2212102', 'Aleezeh Zehra Shehzad'),
	('2212104', 'Aman'),
	('2212105', 'Ammad Khan'),
	('2212108', 'Elsa Khan'),
	('2212110', 'Hammad Ali Tejani'),
	('2212111', 'Kabir Kumar Charyai'),
	('2212112', 'Kirtan Rai Matlani'),
	('2212113', 'Krisha Thontia'),
	('2212114', 'Laveesha Kumari'),
	('2212115', 'Muhammad Ashhad Baig'),
	('2212118', 'Muhammad Faseeh'),
	('2212119', 'Muhammad Haroon'),
	('2212120', 'Muhammad Hashim Chohan'),
	('2212122', 'Muhammad Moiz Sajjad'),
	('2212123', 'Muhammad Taha Zain'),
	('2212124', 'Nehaa Fatima'),
	('2212126', 'Ritik Kumar'),
	('2212128', 'Shahzeb Khan'),
	('2212129', 'Sumaiya'),
	('2212130', 'Sundar Lal'),
	('2212132', 'Syed Muhammad Naqi Askari'),
	('2212133', 'Syeda Asalah Shah'),
	('2212134', 'Waseem Khan'),
	('2212135', 'Zain Zulfiqar Dhanani'),
	('2212321', 'Ahsan Raza'),
	('2212322', 'Fatima Peerani'),
	('2212323', 'Haika Asif'),
	('2212324', 'Muhammad Araiz'),
	('2212325', 'Muhammad Shayan Shahid'),
	('2112176', 'Anas Hussain Khan'),
	('2112184', 'Maaz Mashhood'),
	('2112196', 'Sameer Sikandar Ali Khamwani'),
	('2112199', 'Sooraj Malhi'),
	('2112203', 'Umair Solangi'),
	('2112215', 'Hayyan Ahmed Zuberi'),
	('2112224', 'Muhammad Hashim Ali Khan'),
	('2112231', 'Reyan Tariq'),
	('2112345', 'Muhammad Mujeeb Ur Rehman Hesab Gopang'),
	('1812290', 'Ali Ahmed'),
	('2012356', 'Muhammad Syed Taha Ali'),
	('2212109', 'Habib Ullah Uqaili'),
	('2212117', 'Muhammad Danish'),
	('2212141', 'Anmol kumari'),
	('2212151', 'Mehik Nankani'),
	('2212158', 'Sahil Kumar Lalwani'),
	('2212161', 'Sheroon Kumar'),
	('2212174', 'Bhavnesh Karmani'),
	('2212184', 'Mohammad Hamza Farrukh Tanoli'),
	('2212187', 'Muhammad Hashir Shaikh'),
	('2212192', 'Muhammad Yousuf Siddiqui'),
	('2212200', 'Syed Shaheryar Shah'),
	('2212203', 'Vishal Kumar'),
	('2212221', 'Muhammad Hadi Faisal'),
	('2212252', 'Hasnain'),
	('2212261', 'Nitesh Kumar Paryani'),
	('2212263', 'Pawan Mahesh'),
	('2212273', 'Son Pari Dembra'),
	('2212279', 'Abdul Rafay'),
	('2212281', 'Ambreen Fatima Bhanji'),
	('2212284', 'Arsalan Aftab Ali'),
	('2212286', 'Fardeel Ahmed Gujar'),
	('2212294', 'Muhammad Afnan Mirza'),
	('2212297', 'Muhammad Ovais Salam'),
	('2212303', 'Salman .'),
	('2212310', 'Syed Shujja Abbas Abidi'),
	('2212312', 'Usama Aqeel Durrani'),
	('2212317', 'Anoosha'),
	('2212334', 'Muhammad Fuzail Ansari'),
	('2212344', 'Taskeen Sarwer'),
	('2212350', 'Mahdeem Abdul Ghani Baloch'),
	('2212352', 'Hameedullah Khan'),
	('2412180', 'Aadersh Kumar Keswani'),
	('2412181', 'Abdul Manan'),
	('2412182', 'Abdul Rafay'),
	('2412183', 'Abdul Wahab'),
	('2412184', 'Abiha Fatima Alarakhya'),
	('2412185', 'Amina'),
	('2412186', 'Atika Mujeeb Uddin'),
	('2412187', 'Daniyal Arshad Khan'),
	('2412188', 'Faiza -'),
	('2412189', 'Furqan Ul-haq'),
	('2412190', 'Harsh Sachrani'),
	('2412191', 'Hasham'),
	('2412192', 'Hassaan Ahmed'),
	('2412193', 'Inayah - Ali'),
	('2412194', 'Mahad Saleem Shaikh'),
	('2412196', 'Muhammad Areeb Shariq'),
	('2412197', 'Muhammad Asher Nadeem'),
	('2412198', 'Muhammad Bilal Kamil'),
	('2412199', 'Muhammad Bilal Siddiqui'),
	('2412200', 'Muhammad Hassan Farooq'),
	('2412201', 'Muhammad Kaif Imran'),
	('2412202', 'Muhammad Sameer Qidwai'),
	('2412203', 'Muhammad Shahzaib'),
	('2412204', 'Muhammad Taha Raza'),
	('2412205', 'Murtaza Khurram'),
	('2412207', 'Numa Nizar Ali'),
	('2412208', 'Raim Uz Zaman'),
	('2412209', 'Raqab'),
	('2412210', 'Rowell Rizwan Khan'),
	('2412211', 'Saadat Ur Rehman'),
	('2412212', 'Sakina Abbas'),
	('2412213', 'Saniya Hans'),
	('2412214', 'Shagun Shewanand Andani'),
	('2412215', 'Shehryar Ahmed'),
	('2412216', 'Sumit'),
	('2412217', 'Syed Hammad Ali'),
	('2412218', 'Syed Mohammed Burair Zaidi'),
	('2412219', 'Syed Mujtaba Mehdi'),
	('2412220', 'Umer Naveed Khan'),
	('2412221', 'Urwah Iftikhar'),
	('2412222', 'Varun Sainani'),
	('2412223', 'Yousuf Shabbar'),
	('2412511', 'Muhammad Taha'),
	('2412101', 'Aahil Hussain Charania'),
	('2412102', 'Abdul Samad Shaikh'),
	('2412103', 'Abdul Sami'),
	('2412105', 'Ali Mohammad Kanji'),
	('2412106', 'Asad Ali Khowaja'),
	('2412107', 'Behroz Ahmed'),
	('2412108', 'Burair Hassan'),
	('2412109', 'Harsh Wardhan'),
	('2412110', 'Jagarti Kumari'),
	('2412111', 'Karan Kumar'),
	('2412112', 'Maryam Iqbal'),
	('2412113', 'Mohammad Salim Jafri'),
	('2412114', 'Mohammad Sami'),
	('2412115', 'Muhammad Ahmed'),
	('2412116', 'Muhammad Ammar Ahmed'),
	('2412117', 'Muhammad Daniyal Shaikh'),
	('2412118', 'Muhammad Huzaifa'),
	('2412119', 'Muhammad Jasir Zaki'),
	('2412120', 'Muhammad Kaif'),
	('2412121', 'Muhammad Zubair'),
	('2412122', 'Niaz Ahmed Abbasi'),
	('2412123', 'Rayyan Ahmed Khan Babi'),
	('2412124', 'Sahil'),
	('2412125', 'Sahran Rajwani'),
	('2412126', 'Sajjad Raza'),
	('2412127', 'Sameer Hayat'),
	('2412128', 'Sandeep Kumar'),
	('2412129', 'Shahreyar Hasan'),
	('2412130', 'Shivam Kumar'),
	('2412131', 'Syed Humza Adnan Shah'),
	('2412132', 'Syed Mohammad Taqi'),
	('2412134', 'Warisha Salman'),
	('2412500', 'Aliza Umrani'),
	('2412503', 'Isbaah Imran Merani'),
	('2412504', 'Kanza Kajani'),
	('2412505', 'Muskan Lohana'),
	('2412506', 'Suraksha Kumari Batra'),
	('2412507', 'Waniya Willayat Jahan'),
	('2412508', 'Yashara Shad'),
	('2412509', 'Nikita'),
	('2412135', 'Aaish Khair Muhammad'),
	('2412136', 'Abdul Basit'),
	('2412137', 'Abdul Basit Qasim'),
	('2412138', 'Abdul Raffay Jabbar'),
	('2412139', 'Abdul Salam'),
	('2412140', 'Ahmed Naveed Khan'),
	('2412141', 'Akshay Kumar'),
	('2412142', 'Alishba'),
	('2412143', 'Amit Kumar'),
	('2412144', 'Anchal Kumari'),
	('2412145', 'Anees Ahmed'),
	('2412146', 'Areeba Faisal'),
	('2412147', 'Bhomika Thorani Bhomika Thorani'),
	('2412148', 'Dilawar Hussain'),
	('2412149', 'Diya Thourani'),
	('2412150', 'Fiza Noor Khowaja'),
	('2412151', 'Furqan Ahmed Shaikh'),
	('2412152', 'Gun Gun Khetpal'),
	('2412153', 'Haseeb Ur Rehman Khan Lodhi'),
	('2412154', 'Hitesh Chhabria'),
	('2412155', 'Hums Mahesar'),
	('2412156', 'Kashish Lund'),
	('2412157', 'Maneesh Kumar Jethani'),
	('2412158', 'Mohammad Eeshan'),
	('2412159', 'Muhammad Aizaz'),
	('2412160', 'Muhammad Ayaan'),
	('2412161', 'Muhammad Fahad Qazi'),
	('2412162', 'Muhammad Safeer Ahmed'),
	('2412163', 'Muhammad Shaheem Ullah Siddiqui'),
	('2412164', 'Muneeb Mushtaq'),
	('2412165', 'Nensi Kumari'),
	('2412166', 'Payal'),
	('2412167', 'Pritam'),
	('2412168', 'Rahil Khalid'),
	('2412169', 'Saad Masood Mir Khan'),
	('2412170', 'Saniya'),
	('2412171', 'Shahzaib Zaheer'),
	('2412172', 'Shaikh Rabeez Khalid'),
	('2412173', 'Siya Haswani'),
	('2412174', 'Soim Pirkash Lund'),
	('2412175', 'Talal Rehan Hashmi'),
	('2412176', 'Vijay Kumar'),
	('2412177', 'Waqar Ali'),
	('2412179', 'Zubair Nahar Ahmed'),
	('2412510', 'Nisha'),
	('2412512', 'Muhammad Haris'),
	('2112350', 'Muhammad Uzair Memon'),
	('2212166', 'Umer Gul Mohammad'),
	('2212206', 'Abdul Basit Imam Akbar'),
	('2212210', 'Anum Naseem'),
	('2212212', 'Bawar Ghulam Sabir'),
	('2212217', 'Laiba Bashir Muhammad Bashir'),
	('2212220', 'Muhammad Abdullah'),
	('2212231', 'Nasir Khan'),
	('2212250', 'Hamza Baloch'),
	('2212253', 'Ibrahim Nabi Mangi'),
	('2212260', 'Munesh Kumar'),
	('2212271', 'Sibtain Ahmed'),
	('2212336', 'Tabish Ali'),
	('2212341', 'Hamza Ahmed Khan'),
	('2212249', 'Divay Kumar'),
	('2212326', 'Sindhu Jeswani'),
	('2312228', 'Alishba Aslam'),
	('2312233', 'Hamza Muhammad Khalid'),
	('2312234', 'Hassan Khozema'),
	('2312241', 'Mahad Baloch'),
	('2312242', 'Marium Saba'),
	('2312243', 'Mehak Gordhan Das'),
	('2312249', 'Muhammad Shayan Atif'),
	('2312251', 'Mustafa Panhwar'),
	('2312259', 'Shayan Muhammad Faisal'),
	('2312260', 'Shifa Saqib'),
	('2312261', 'Simran Kumari'),
	('2312265', 'Wajeeha Jalal'),
	('2312266', 'Zain -'),
	('2312278', 'Hashaam Makani'),
	('2312283', 'Khushi'),
	('2312407', 'Farhan'),
	('2312408', 'Muhammad Saad'),
	('2312409', 'Tasmina'),
	('2312431', 'Chaudhary Saboor Munir'),
	('2312269', 'Abdul Rafay Fasih Siddiqui'),
	('2312270', 'Abdul Rafay Khan'),
	('2312271', 'Abdul Rehman Salman'),
	('2312272', 'Abdul Waleed'),
	('2312273', 'Ayush Kumar Lalwani'),
	('2312274', 'Basirat Zehra'),
	('2312277', 'Dinsha'),
	('2312281', 'Huzaifa Khuzema Kapasi'),
	('2312284', 'Khushi Khadani'),
	('2312289', 'Muhammad Arham'),
	('2312291', 'Mujeeb Ur Rehman'),
	('2312292', 'Mustafa Muhammad Iqbal'),
	('2312293', 'Piyoush Kumar Gurwani'),
	('2312296', 'Sencika'),
	('2312301', 'Subhash Rai'),
	('2312302', 'Syed Abdullah Qadri'),
	('2312303', 'Syed Aneeq Hassan'),
	('2312307', 'Wassam Ul Hasan Khan'),
	('2312413', 'Hifsa Umer'),
	('2312414', 'Rida Bibi'),
	('2212159', 'Shahzaib Hussain'),
	('2212242', 'Adeel Hasan Yousfi'),
	('2212316', 'Fahad Saeed'),
	('2212320', 'Kamran Zakir'),
	('2212359', 'Anaish Kumar'),
	('23101122', 'Neelam Khan'),
	('2312184', 'Abdus Samad Khan'),
	('2312185', 'Ali Raza Ramzan'),
	('2312186', 'Areeba Tariq'),
	('2312187', 'Ayesha Shoaib'),
	('2312189', 'Fatima Antria'),
	('2312190', 'Hafsa Khan'),
	('2312192', 'Kashfi Karim Ali'),
	('2312194', 'Khushboo Susheel Goreja'),
	('2312195', 'Malik Mushtaq Ali'),
	('2312196', 'Mashood Ali'),
	('2312202', 'Muhammad Khuzaimah Khan'),
	('2312203', 'Muhammad Maaz Siddique'),
	('2312205', 'Muhammad Taha Jalbani'),
	('2312206', 'Muhammad Umer Malik'),
	('2312208', 'Mustafa Murtaza Ali'),
	('2312210', 'Parkash'),
	('2312213', 'Saadain Sikandar Ali Khamwani'),
	('2312215', 'Shamikh Shaikh'),
	('2312217', 'Soam Kukreja'),
	('2312218', 'Syed Abdul Hadi'),
	('2312220', 'Syed Muhammad Rayyan'),
	('2312222', 'Vandna'),
	('2312223', 'Vishaka Bai'),
	('2312225', 'Waqar Nadeem Shah'),
	('2312402', 'Bisma Rukhsar'),
	('2312403', 'Haseeb Mudasir'),
	('2312404', 'Maheen Arshad'),
	('2312405', 'Muhammad Zunoon Ali'),
	('2312432', 'Zaheer Hussain'),
	('2212278', 'Abdul Latif Panhwar'),
	('2312128', 'Ronit Kumar Chandwani'),
	('2312306', 'Vermeet Kumar'),
	('24101102', 'Abdul Hadi'),
	('24101122', 'Muhammad Haroon Ur Rashid'),
	('24101123', 'Muhammad Hassan Jawaid'),
	('24101125', 'Muhammad Owais'),
	('24101126', 'Muhammad Owais'),
	('24101127', 'Muhammad Subhan'),
	('24101132', 'Qurrat Ul Ain Bhutto'),
	('24101141', 'Syed Muhammad Faizan Alam'),
	('24101143', 'Talha Khan'),
	('24101144', 'Ummi Mursaleen'),
	('24101148', 'Sunny Deve'),
	('24101152', 'Sandesh Ramrakhiani'),
	('24101153', 'Maheem'),
	('2512147', 'Abdul Hafeez Narejo'),
	('2512148', 'Ahmer Ferhan'),
	('2512149', 'Aman Rathore'),
	('2512150', 'Anand Gir Goswami'),
	('2512151', 'Ashweent Kumar'),
	('2512152', 'Bhawish Kumar'),
	('2512153', 'Danial Ali Helayo'),
	('2512154', 'Diya Kumari'),
	('2512155', 'Furqan Gul'),
	('2512156', 'Hafiz Azfar Masood'),
	('2512157', 'Hammad Ahmed'),
	('2512158', 'Hrithik Kumar'),
	('2512159', 'Jaish Kumar'),
	('2512160', 'Khunesh Kumar'),
	('2512161', 'Khushboo'),
	('2512162', 'Khushboo Mansoor'),
	('2512163', 'Laiba Rizwan'),
	('2512164', 'Lakshmi Raj'),
	('2512166', 'Muhammad Maaz Baloch'),
	('2512167', 'Muhammad Moeen Afzal Wattoo'),
	('2512168', 'Muhammad Owais Raza'),
	('2512169', 'Muhammad Sarim'),
	('2512170', 'Muhammad Tahir Madni'),
	('2512172', 'Muskan'),
	('2512173', 'Parshant Kumar'),
	('2512174', 'Piya'),
	('2512175', 'Puneet Kumar'),
	('2512176', 'Raheel Jamal'),
	('2512177', 'Rifza Riaz Badarpura'),
	('2512178', 'Rishika Kumari Talereja'),
	('2512179', 'Roshani Kukreja'),
	('2512180', 'Saamya Muhammad Amin Sagani'),
	('2512181', 'Sadaqat Ali Khan'),
	('2512182', 'Sanjay Kumar Hardasani'),
	('2512183', 'Shehzad Ali'),
	('2512184', 'Shiva Kumar'),
	('2512185', 'Syeda Ramla Aamir'),
	('2512186', 'Tirpti Alias Tikashi Bhagia'),
	('2512187', 'Vandana Sadhwani'),
	('2512188', 'Yashika Mandhan'),
	('2512189', 'Younas Khan'),
	('2512190', 'Zain Ali'),
	('2512191', 'Zainab Karim Kubar'),
	('2512192', 'Zainab Rehan Ahmed'),
	('2512214', 'Kartik Maheshwari'),
	('2512285', 'Abdullah Imran'),
	('2512286', 'Ahmed Uzair Mughal'),
	('2512287', 'Akash Joshi'),
	('2512288', 'Amna Khan'),
	('2512289', 'Anas Rahman Siddiqui'),
	('2512290', 'Armaan Akhtar'),
	('2512291', 'Ayan Ahmed Ahmed'),
	('2512292', 'Bhavesh Kumar'),
	('2512293', 'Bhoomi'),
	('2512294', 'Daniyal Adil Siddiqui'),
	('2512295', 'Hammad Meer'),
	('2512296', 'Hasnain raza'),
	('2512297', 'Hussain Murtaza Bhinderwala'),
	('2512298', 'Jatin Talreja'),
	('2512300', 'Maaz Mukhtar'),
	('2512301', 'Madiha Nadeem'),
	('2512302', 'Maryam Kazi'),
	('2512303', 'Muhammad Akmal Shehzad'),
	('2512304', 'Muhammad Ayaan Khan'),
	('2512305', 'Muhammad Farooq Baig'),
	('2512306', 'Muhammad Ibrahim'),
	('2512307', 'Muhammad Jahanzaib Asif'),
	('2512308', 'Muhammad Khizar'),
	('2512309', 'Muhammad Saleh'),
	('2512310', 'Muhammad Yousuf Muhammad Altaf'),
	('2512311', 'Prinka Rani'),
	('2512312', 'Ronit Kumar'),
	('2512313', 'Sanjay Kumar'),
	('2512314', 'Shameer Asad'),
	('2512315', 'Shan Khokhar'),
	('2512316', 'Sharaheel Khan'),
	('2512318', 'Syed Ammad Jaffri'),
	('2512319', 'Syed Murtaza Husain Jafri'),
	('2512320', 'Syeda Batool Zehra'),
	('2512321', 'Syeda Maryam Benazir'),
	('2512322', 'Syeda Sophia Ajaz'),
	('2512323', 'Uday Kumar'),
	('2512324', 'Usman Khan'),
	('2512325', 'Usman Khan'),
	('2512326', 'Ved Kumar'),
	('2512327', 'Vishal'),
	('2512328', 'Yash Kumar'),
	('2512329', 'Yousuf Kashif'),
	('2512330', 'Zakir Qasim'),
	('2512510', 'Zohra'),
	('2412489', 'Safwaan Iqbal'),
	('2512217', 'Muhammad Hammad Siddiqui'),
	('2512407', 'Raheel Abbas'),
	('2512421', 'Abdul Majid'),
	('2512422', 'Abdul Muqit'),
	('2512423', 'Abdul Rafay'),
	('2512424', 'Abdul Sajid'),
	('2512425', 'Abdur Rahim Imran'),
	('2512426', 'Ahsan Ullah Khan'),
	('2512427', 'Aima Qasim'),
	('2512428', 'Ali Hyder Khowaja'),
	('2512429', 'Anika Junaid Naeem'),
	('2512430', 'Bilal Yasir Ilyas'),
	('2512431', 'Dilkash'),
	('2512432', 'Disha'),
	('2512433', 'Dua Fatima'),
	('2512434', 'Faizan Ali'),
	('2512435', 'Hammad Ahmed'),
	('2512436', 'Hasnain Hyder Shaikh'),
	('2512437', 'Huzaifa Hussain'),
	('2512438', 'Izha Maknojia'),
	('2512439', 'Jhalak Panjwani'),
	('2512440', 'Kabir Karim'),
	('2512441', 'Lakhan Kumar'),
	('2512442', 'Maaz Shahid'),
	('2512443', 'Maryam Qamar'),
	('2512444', 'Moazam Iftikhar Goraho'),
	('2512445', 'Muhammad Abbas Muzammil'),
	('2512446', 'Muhammad Affan Tauseef'),
	('2512447', 'Muhammad Ahsan Siddiqui'),
	('2512448', 'Muhammad Armughan'),
	('2512449', 'Muhammad Hasnain Ali'),
	('2512450', 'Muhammad Mujtaba Asim'),
	('2512451', 'Muhammad Rohaan Khan'),
	('2512453', 'Muhammad Tariq'),
	('2512454', 'Muhammad Umais'),
	('2512455', 'Muzamil Ali Shaikh'),
	('2512456', 'Rayan Talpur'),
	('2512457', 'Sanjna Bulani'),
	('2512458', 'Shamoon Anjar Wala'),
	('2512459', 'Sidra Mujtaba'),
	('2512460', 'Sonia'),
	('2512461', 'Sufiyan Tariq'),
	('2512462', 'Varsha Maheshwary'),
	('2512463', 'Vishwas Kumar'),
	('2512464', 'Yashfeen Tanveer Qayyum'),
	('2512465', 'Yogesh Kumar'),
	('2512483', 'Hiba Ali'),
	('2512193', 'Aaryan'),
	('2512194', 'Abdul Razzaque'),
	('2512195', 'Abdulqadir Hussain'),
	('2512196', 'Abeer Humayun'),
	('2512197', 'Adeel Ali'),
	('2512198', 'Ali Kazim Zulfiqar'),
	('2512199', 'Alishba Mohammad Irfan'),
	('2512200', 'Alishba Noor'),
	('2512201', 'Ansoya Asnani'),
	('2512202', 'Arish'),
	('2512203', 'Asghar Abbas'),
	('2512204', 'Ayaan Aamir Jiwani'),
	('2512205', 'Bazil Brohi'),
	('2512207', 'Deepa Bai'),
	('2512208', 'Divesh Gul Sachdev'),
	('2512209', 'Emaan Khurram'),
	('2512210', 'Hifza Batool Qureshi'),
	('2512211', 'Hisban Muhammad'),
	('2512212', 'Hussain Mehdi'),
	('2512213', 'Imaad Mustafa Muhammad Ali'),
	('2512215', 'Mohammad Amin .'),
	('2512216', 'Muhammad Hadi'),
	('2512218', 'Muhammad Jahanzaib Imran Umrao'),
	('2512219', 'Muhammad Muzammil Sabir'),
	('2512220', 'Muhammad Samiullah Soomro'),
	('2512221', 'Muhammad Sohaib Shaikh'),
	('2512222', 'Muhammad Tanzeel'),
	('2512223', 'Muhammad Usman Shahid'),
	('2512224', 'Muhammad Zubair'),
	('2512225', 'Murtaza Lelani'),
	('2512226', 'Neev Kumar'),
	('2512227', 'Saad Shamim'),
	('2512228', 'Saeed Ahmed'),
	('2512229', 'Saniya Fatima'),
	('2512230', 'Shagun Bai Omperkash'),
	('2512231', 'Sharan Kapoor'),
	('2512232', 'Sheher Bano'),
	('2512233', 'Syed Kashan Abbas Naqvi'),
	('2512234', 'Taigor Talreja'),
	('2512235', 'Taliah'),
	('2512236', 'Umaima Sohail'),
	('2512237', 'Umaiz Khan'),
	('2512238', 'Yogesh Kumar'),
	('2512171', 'Muhammad Talha Khan'),
	('2512466', 'Abdullah Brohi'),
	('2512467', 'Ajay Kumar'),
	('2512468', 'Aman Kumar Talreja'),
	('2512469', 'Anjeela Raj'),
	('2512470', 'Ashika Kumari'),
	('2512471', 'Awab'),
	('2512472', 'Ayaan Hyder Imran Serai'),
	('2512473', 'Ayosh Kumar Makriya'),
	('2512475', 'Bhomika Kothari'),
	('2512476', 'Bisma Sulhary'),
	('2512477', 'Chaitan Das'),
	('2512478', 'Darpan Kumar Hablani'),
	('2512480', 'Dua Bawani'),
	('2512481', 'Geeta Panjabi'),
	('2512482', 'Hamza Shaikh'),
	('2512484', 'Hira Yasmeen Dal'),
	('2512485', 'Hummam Raza'),
	('2512486', 'Iman - Ali'),
	('2512487', 'Jhalak'),
	('2512488', 'Kamran Hussain'),
	('2512489', 'Keshav Kumar'),
	('2512490', 'Mahik'),
	('2512491', 'Maimoona'),
	('2512492', 'Mehak Rani'),
	('2512493', 'Mehrab'),
	('2512494', 'Muhammad Shayan Luqman'),
	('2512495', 'Muhammad Sualeh Ahmed Siddiqui'),
	('2512496', 'Muhammad Waiz Jamal'),
	('2512497', 'Muhammad Zaryab Khan'),
	('2512498', 'Nisha Lohana'),
	('2512499', 'Ratika Kumari'),
	('2512500', 'Samae Kumar'),
	('2512501', 'Sanjna'),
	('2512502', 'Simran Kumari'),
	('2512503', 'Sineha Rani'),
	('2512504', 'Siya Thourani'),
	('2512505', 'Suhana'),
	('2512506', 'Ushna Waseem Ul Haq Mirza'),
	('2512507', 'Vaneesh Kumar'),
	('2512508', 'Versha Lohana'),
	('2512509', 'Vikash Kumar');


--
-- Data for Name: test; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.test VALUES
	(1, 'spj', 'postgres://postgres:Aa20195@1@localhost:5432/spj', '2026-07-06');


--
-- Name: attempt_attid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.attempt_attid_seq', 1, false);


--
-- Name: conduct_cid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.conduct_cid_seq', 3, true);


--
-- Name: query_qid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.query_qid_seq', 3, true);


--
-- Name: result_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.result_rid_seq', 1, false);


--
-- Name: test_testid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.test_testid_seq', 1, true);


--
-- Name: attempt attempt_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_pkey PRIMARY KEY (attid);


--
-- Name: conduct conduct_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conduct
    ADD CONSTRAINT conduct_pkey PRIMARY KEY (cid);


--
-- Name: query query_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.query
    ADD CONSTRAINT query_pkey PRIMARY KEY (qid);


--
-- Name: result result_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.result
    ADD CONSTRAINT result_pkey PRIMARY KEY (rid);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (regno);


--
-- Name: test test_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_pkey PRIMARY KEY (testid);


--
-- Name: attempt attempt_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_cid_fkey FOREIGN KEY (cid) REFERENCES public.conduct(cid) ON DELETE CASCADE;


--
-- Name: attempt attempt_regno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_regno_fkey FOREIGN KEY (regno) REFERENCES public.student(regno) ON DELETE CASCADE;


--
-- Name: conduct conduct_testid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conduct
    ADD CONSTRAINT conduct_testid_fkey FOREIGN KEY (testid) REFERENCES public.test(testid) ON DELETE CASCADE;


--
-- Name: query query_testid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.query
    ADD CONSTRAINT query_testid_fkey FOREIGN KEY (testid) REFERENCES public.test(testid) ON DELETE CASCADE;


--
-- Name: result result_attid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.result
    ADD CONSTRAINT result_attid_fkey FOREIGN KEY (attid) REFERENCES public.attempt(attid) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 6ksWJoOS8C3mDyWZOBpW1Hh3pQqbZrJYiwbXHSDgZ7RYvdmCoIvd93yt7ohRix5

