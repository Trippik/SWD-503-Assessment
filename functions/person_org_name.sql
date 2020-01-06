CREATE OR REPLACE FUNCTION person_org_name(pers IN VARCHAR(255)) RETURNS VARCHAR(255) AS $org$
DECLARE
	pers_id INTEGER;
BEGIN
	pers_id = (SELECT organisation FROM person WHERE person_name LIKE ('%' || pers || '%'));
	RETURN (SELECT organisation_name FROM organisation WHERE id = pers_id);
END;$org$
LANGUAGE PLPGSQL;
