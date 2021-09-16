create or replace view tariffs as
select distinct flight_no, 
	   departure_airport,
	   departure_airport_name,
	   departure_city,
	   arrival_airport,
	   arrival_airport_name,
	   arrival_city,
	   fare_conditions,
	   amount
from flights_v fv join ticket_flights tf using(flight_id)
order by departure_city, arrival_city, fare_conditions
;

create or replace view fact_flights as
select 
	f.flight_id,
	passenger_id,
	actual_departure,
	actual_arrival,
	abs(extract(epoch from actual_departure) - extract(epoch from scheduled_departure)) as delay_departure,
	abs(extract(epoch from actual_arrival) - extract(epoch from scheduled_arrival)) as delay_arrival,
	aircraft_code,
	seat_no,
	departure_airport,
	arrival_airport,
	flight_no,
	fare_conditions
from flights f join ticket_flights tf using(flight_id)
			   join boarding_passes bp on tf.flight_id = bp.flight_id and tf.ticket_no = bp.ticket_no 
			   join tickets t on tf.ticket_no = t.ticket_no 
where f.status = 'Arrived'
order by f.flight_id;