SELECT 
	organisation.id,
	organisation.organisation_name,
	planet.planet_name,
	organisation.date_founded,
	organisation.date_closed,
	affiliation.affiliation_type
FROM organisation
LEFT JOIN planet ON organisation.origin_planet = planet.id
LEFT JOIN affiliation ON organisation.organisation_affiliation = affiliation.id
