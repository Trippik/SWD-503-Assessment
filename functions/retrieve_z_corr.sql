CREATE OR REPLACE FUNCTION retrieve_z_corr(item IN VARCHAR(255)) RETURNS FLOAT AS $z$
DECLARE
	planet_id INTEGER;
BEGIN
	planet_id = (SELECT id FROM planet WHERE planet_name LIKE ('%' || item || '%'));
	IF planet_id IS NULL THEN
		RETURN(SELECT zcoordinate FROM starship WHERE starship_name LIKE ('%' || item ||'%'));
	ELSE
		RETURN(SELECT zcoordinate FROM planet WHERE id = planet_id);
	END IF;
END; $z$
LANGUAGE PLPGSQL;
