CREATE OR REPLACE FUNCTION person_div_name(pers IN VARCHAR(255)) RETURNS VARCHAR(255) AS $div$
DECLARE
	pers_id INTEGER;
BEGIN
	pers_id = (SELECT organisation FROM person WHERE person_name LIKE ('%' || pers || '%'));
	RETURN (SELECT division_name FROM division WHERE id = pers_id);
END;$div$
LANGUAGE PLPGSQL;
