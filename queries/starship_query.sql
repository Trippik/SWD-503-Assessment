SELECT 
	starship.id,
	starship.starship_name AS "Name",
	starship.registry AS "Registry",
	starship_class.starship_class_name AS "Class",
	organisation.organisation_name AS "Organisation",
	starship.launch_date AS "Launch Date",
	starship.decommisioned AS "Decommisioned"
FROM starship
LEFT JOIN starship_class ON starship.starship_class = starship_class.id
LEFT JOIN organisation ON starship.organisation = organisation.id
