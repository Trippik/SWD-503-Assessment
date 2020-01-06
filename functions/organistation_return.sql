CREATE OR REPLACE FUNCTION organisation_return(org_name IN VARCHAR(255)) RETURNS INTEGER AS $org_id$
BEGIN
	RETURN (SELECT ID FROM organisation WHERE organisation_name LIKE ('%' || org_name || '%'));
END;$org_id$
LANGUAGE PLPGSQL;
