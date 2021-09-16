create table dim_aircrafts (
id serial primary key,
aircraft_code bpchar(3) not null,
model varchar(50) not null,
"range" int4,
qty_seats int4,
seat_no varchar(4),
fare_conditions varchar(10)
);

--drop table dim_calendar cascade;

create table dim_passengers (
id serial primary key,
passenger_id varchar(20) not null,
passenger_name varchar(100) not null,
phone varchar(12),
email varchar(50)
);


create table dim_airports (
id serial primary key,
airport_code bpchar(3) not null,
airport_name varchar(20),
city varchar(50) not null,
longitude float8,
latitude float8,
timezone varchar(50)
);

create table dim_tariff (
id serial primary key,
flight_no varchar(10),
departure_airport bpchar(3) not null,
departure_airport_name varchar(20),
departure_city varchar(50) not null,
arrival_airport bpchar(3) not null,
arrival_airport_name varchar(20),
arrival_city varchar(50) not null,
fare_conditions varchar(10),
amount double precision not null,
is_current boolean not null default true
);

CREATE TABLE dim_calendar as 
with dates as (
	select dd as date_time
	from generate_series('2016-09-01'::timestamptz, '2016-11-30'::timestamptz, '1 minute'::interval) dd
			  )
(
select
	to_char(date_time, 'YYYYMMDDHH24MI')::bigint as id,
	date_time,
	date_time::date as date,
	date_part('isodow', date_time)::int as week_day,
	date_part('week', date_time)::int as week_number,
	date_part('month', date_time)::int as month,
	date_part('isoyear', date_time)::int as year,
	(date_part('isodow', date_time)::smallint between 1 and 5)::int as work_day
from dates
order by date_time
);

alter table dim_calendar add primary key(id);


create table fact_flights (
id serial primary key,
passenger_id int4 references dim_passengers(id),
actual_departure_id bigint references dim_calendar(id),
actual_arrival_id bigint references dim_calendar(id),
delay_departure numeric,
delay_arrival numeric,
aircraft_id int4 references dim_aircrafts(id),
departure_airport_id int4 references dim_airports(id),
arrival_airport_id int4 references dim_airports(id),
tariff_id int4 references dim_tariff(id)
);

--drop table fact_flights;