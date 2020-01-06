SELECT 
	species.id, 
	species_name AS "Species Name",
	gases.gas AS "Breathable Gas",
	planet.planet_name AS "Homeworld"
FROM species
LEFT JOIN gases ON species.breathable_gas = gases.id
LEFT JOIN homeworld ON species.id = homeworld.species_id
LEFT JOIN planet ON homeworld.planet_id = planet.id
