CREATE OR REPLACE FUNCTION retrieve_x_corr(item IN VARCHAR(255)) RETURNS FLOAT AS $x$
DECLARE
	planet_id INTEGER;
BEGIN
	planet_id = (SELECT id FROM planet WHERE planet_name LIKE ('%' || item || '%'));
	IF planet_id IS NULL THEN
		RETURN(SELECT xcoordinate FROM starship WHERE starship_name LIKE ('%' || item ||'%'));
	ELSE
		RETURN(SELECT xcoordinate FROM planet WHERE id = planet_id);
	END IF;
END; $x$
LANGUAGE PLPGSQL;
