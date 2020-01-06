CREATE OR REPLACE FUNCTION distance(target IN VARCHAR(255), origin VARCHAR(255)) RETURNS FLOAT AS $dist$
DECLARE
	target_x FLOAT;
	target_y FLOAT;
	target_z FLOAT;
	origin_x FLOAT;
	origin_y FLOAT;
	origin_z FLOAT;
	delta_x FLOAT;
	delta_y FLOAT;
	delta_z FLOAT;
	element1 FLOAT;
	element2 FLOAT;
	element3 FLOAT;
BEGIN
	target_x = (retrieve_x_corr(target));
	target_y = (retrieve_y_corr(target));
	target_z = (retrieve_z_corr(target));
	origin_x = (retrieve_x_corr(origin));
	origin_y = (retrieve_y_corr(origin));
	origin_z = (retrieve_z_corr(origin));
	delta_x = (target_x - origin_x);
	delta_y = (target_y - origin_y);
	delta_z = (target_z - origin_z);
	element1 = ((delta_y * delta_y) + (delta_x * delta_x));
	element2 = (SQRT(element1));
	element3 = (element2 + (delta_z * delta_z));
	RETURN(SQRT(element3));
END; $dist$
LANGUAGE PLPGSQL;
