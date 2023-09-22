Drop schema if exists qms;
Drop table if exists qms.region cascade;
Drop table if exists qms.service cascade;
Drop table if exists qms.seat cascade;
Drop table if exists qms.queue cascade;
Drop table if exists queue_call cascade;
Drop table if exists qms.queue_status cascade;
Drop table if exists qms.service_type cascade;
Drop table if exists qms.setting cascade;

CREATE SCHEMA qms;

CREATE TABLE qms.region(
	mr_code character varying(20) PRIMARY KEY,
	description character varying (255),
	created_date timestamp without time zone NOT NULL,
	active boolean not null
);

CREATE TABLE qms.service(  
	service_id serial PRIMARY KEY,
	service_type character varying (20) not null,
	region_code character varying(20) not null,
	created_date timestamp without time zone NOT NULL,
	active boolean not null
);

CREATE TABLE qms.seat(  
	seat_id serial PRIMARY KEY,
	service_id int not null,
	seat_number integer NOT NULL,
	assigned_id integer NOT NULL,
	created_date timestamp without time zone NOT NULL,
	modified_date timestamp without time zone NOT NULL,
	active boolean not null,
	modified_by integer NOT NULL
);

CREATE TABLE qms.queue(  
	queue_id serial PRIMARY KEY,
	service_id int not null,
	queue_number integer NOT NULL,
	assigned_id integer,
	created_date timestamp without time zone NOT NULL,
	modified_date timestamp without time zone NOT NULL,
	start_date timestamp without time zone,
	end_date timestamp without time zone,
	queue_status character varying(20) not null,
	called boolean not null,
	call_date timestamp without time zone,
	seat_id int
);

CREATE TABLE qms.queue_status(  
	mr_code character varying(20) PRIMARY KEY,
	active boolean NOT NULL,
	description character varying(255)
);

CREATE TABLE qms.service_type(  
	mr_code character varying(20) PRIMARY KEY,
	active boolean NOT NULL,
	description character varying(255)
);

CREATE TABLE qms.setting(  
	mr_code character varying (20) PRIMARY KEY,  
	value character varying (200) NOT NULL,  
	active boolean NOT NULL,
	description character varying (255)
);

--appuser table
CREATE TABLE appuser (  
	appuser_id serial PRIMARY KEY,  
	username character varying (20) NOT NULL,  
	first_name character varying(60),
	last_name character varying(60),
	password character varying (100) NOT NULL,
	active boolean NOT NULL,
	created_by integer,
	created_date timestamp without time zone NOT NULL,
	modified_by integer,
	modified_date timestamp without time zone NOT NULL
);

----
ALTER TABLE qms.qms_service
ADD FOREIGN KEY (region_code) 
REFERENCES qms.qms_region (mr_code)
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION,
ADD FOREIGN KEY (service_type) 
REFERENCES qms.qms_service_type (mr_code)
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION,
ADD UNIQUE (service_type, region_code);
-----
ALTER TABLE qms.qms_seat
ADD FOREIGN KEY (service_id) 
REFERENCES qms.qms_service (service_id)
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION,
ADD FOREIGN KEY (assigned_id) 
REFERENCES public.appuser (appuser_id)
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION,
ADD FOREIGN KEY (modified_by) 
REFERENCES public.appuser (appuser_id)
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION;
-----
ALTER TABLE qms.qms_queue
ADD FOREIGN KEY (service_id) 
REFERENCES qms.qms_service (service_id)
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION,
ADD FOREIGN KEY (assigned_id) 
REFERENCES public.appuser (appuser_id)
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION,
ADD FOREIGN KEY (queue_status) 
REFERENCES qms.qms_queue_status (mr_code)
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION,
ADD FOREIGN KEY (seat_id) 
REFERENCES qms.qms_seat (seat_id)
                       ON DELETE NO ACTION
                       ON UPDATE NO ACTION;