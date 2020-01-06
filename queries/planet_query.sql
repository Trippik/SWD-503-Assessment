SELECT 
	planet.id,
	NULLIF(planet_name, 'Planet name unknown') AS "Planet Name",
	xcoordinate AS "X Coordinate",
	ycoordinate AS "Y Coordinate",
	zcoordinate AS "Z Coordinate",
	population AS "Population",
	gases.gas AS "Atmosphere"
FROM planet
LEFT JOIN gases ON planet.atmosphere = gases.id
