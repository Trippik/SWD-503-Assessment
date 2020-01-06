CREATE OR REPLACE FUNCTION countships(org_name IN VARCHAR(255)) RETURNS BIGINT AS $number$
DECLARE
	org_id INTEGER;
BEGIN
	org_id = organisation_return(org_name);
	RETURN (SELECT COUNT(*) FROM starship WHERE organisation = org_id);
END; $number$
LANGUAGE PLPGSQL;
