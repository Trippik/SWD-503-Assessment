CREATE OR REPLACE FUNCTION retrieve_y_corr(item IN VARCHAR(255)) RETURNS FLOAT AS $y$
DECLARE
	planet_id INTEGER;
BEGIN
	planet_id = (SELECT id FROM planet WHERE planet_name LIKE ('%' || item || '%'));
	IF planet_id IS NULL THEN
		RETURN(SELECT ycoordinate FROM starship WHERE starship_name LIKE ('%' || item ||'%'));
	ELSE
		RETURN(SELECT ycoordinate FROM planet WHERE id = planet_id);
	END IF;
END; $y$
LANGUAGE PLPGSQL;
