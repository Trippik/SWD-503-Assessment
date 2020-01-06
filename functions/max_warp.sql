CREATE OR REPLACE FUNCTION details(per_name IN VARCHAR(255)) RETURNS VARCHAR(255) AS $result$
DECLARE 
	p1 VARCHAR(255);
	p2 VARCHAR(255);
BEGIN
	p1 = (person_org_name(per_name));
	p2 = (person_div_name(per_name));
	RETURN(p1 || ' ' || p2);
END; $result$
LANGUAGE PLPGSQL;
