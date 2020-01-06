SELECT
	id,
	starship_class_name AS "Class Name",
	design_date AS "Design Date",
	starship_length AS "Length (m)",
	starship_breadth AS "Breadth (m)",
	starship_decks AS "No. of Decks",
	max_warp AS "Max Warp Factor",
	warp_cruise AS "Cruising Warp Factor",
	max_impulse AS "Max Sub-Light Speed",
	phasers AS "Number of phaser banks",
	torpedo_launchers AS "Number of Torpedo Launchers",
	max_crew AS "Crew Compliment",
	max_cargo AS "Cargo Capacity"
FROM starship_class
