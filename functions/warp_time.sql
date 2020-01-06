CREATE OR REPLACE FUNCTION warp_time (dist IN FLOAT, warp IN FLOAT) RETURNS FLOAT AS $hrs$
DECLARE
	warp_calc FLOAT;
	warp_days FLOAT;
BEGIN
	warp_calc = (10 * (warp * warp));
	warp_days = ((1 / warp_calc) * 365);
	RETURN(warp_days * 24);
END; $hrs$
LANGUAGE PLPGSQL;
