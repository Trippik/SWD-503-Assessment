CREATE OR REPLACE FUNCTION time_to_point(target IN VARCHAR(255), origin IN VARCHAR(255), warp IN FLOAT) RETURNS FLOAT AS $t$
DECLARE
	distance FLOAT;
BEGIN
	distance = distance(target, origin);
	RETURN(warp_time(distance, warp));
END; $t$ 
LANGUAGE PLPGSQL;
