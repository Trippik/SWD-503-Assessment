SELECT
	person.id,
	person_name AS "Name",
	organisation.organisation_name AS "Organisation",
	skin_colour.colour_name AS "Skin Colour",
	hair_colour.colour_name AS "Hair Colour",
	birth_planet.planet_name AS "Birth Planet",
	person.dob AS "Date of Birth",
	home_planet.planet_name AS "Home Planet",
	species.species_name AS "Species",
	affiliation.affiliation_type AS "Affiliation",
	grade.rank_name AS "Rank",
	division.division_name AS "Division"
FROM person
LEFT JOIN colour AS skin_colour ON person.skin_colour = skin_colour.id 
LEFT JOIN colour AS hair_colour ON person.hair_colour = hair_colour.id
LEFT JOIN planet AS birth_planet ON person.birth_planet = birth_planet.id
LEFT JOIN planet AS home_planet ON person.home_planet = home_planet.id
LEFT JOIN organisation ON person.organisation = organisation.id
LEFT JOIN species ON person.species = species.id
LEFT JOIN affiliation ON person.affiliation = affiliation.id
LEFT JOIN grade ON person.grade = grade.id
LEFT JOIN division ON person.division = division.id 
