#Import necessary functions
import psycopg2
import pandas as pd

def login():
    print()
    print("****************************************************")
    print("Please login")
    print("****************************************************")
    try:
        print("Please input user name")
        username = input()
        print("Please input password")
        password = input()
        #Connect to database
        db = psycopg2.connect(
            database="Star Trek",
            user= username,
            password= password,
            host="192.168.40.20",
            port="5432"
        )
        return(db)
    except:
        print("Login failed, returning to main menu...")
        print()
        menu()

def query_execute_write(query):
    db = login()
    cursor = db.cursor()
    cursor.execute(query)
    db.commit()
    print("Enterprise database updated")
    print()

def query_execute_read_basic(query):
    db = psycopg2.connect(
    database="Star Trek",
    user= "ensign",
    password= "star",
    host="192.168.40.20",
    port="5432"
    )
    cursor = db.cursor()
    cursor.execute(query)
    raw_data = cursor.fetchall()
    return(raw_data)

#Function to execute a 'data read query' on the connected database and return data
def query_execute_read(query):
    db = login()
    cursor = db.cursor()
    cursor.execute(query)
    raw_data = cursor.fetchall()
    return(raw_data)

def option_display(table, message):
    base_query = "SELECT * FROM "
    query = base_query + table
    options_raw = query_execute_read_basic(query)
    df = pd.DataFrame(columns=['id', table])
    for row in options_raw:
        df = df.append(pd.Series([row[0], row[1]], index=df.columns), ignore_index=True)
    print("Please input id of " + message + " from table below or type NULL if not applicable")
    print(df.to_string(index=False))
    print("id:")
    variable = input()
    return(variable)

#Function to process warp time to destination data for display/export
def warp_time_calc_process(raw_data):
    df = pd.DataFrame(columns=['Time to destination in hrs'])
    for row in raw_data:
        df = df.append(pd.Series([row[0]], index=df.columns), ignore_index=True)
        print()
        return(df.to_string(index=False))

#Function to process distance from point to point data for display/export
def distance_retrieve_process(raw_data):
    df = pd.DataFrame(columns=['Distance in Light Years'])
    for row in raw_data:
        df = df.append(pd.Series([row[0]], index=df.columns), ignore_index=True)
        print()
        return(df.to_string(index=False))

#Function to calculate the time it will take to get from one point to another at a given warp factor
def warp_time_calc(target, origin, warp):
    base_query = """
    SELECT time_to_point('"""
    query = base_query + target + "','" + origin + "'," + warp + ")"
    raw_data = query_execute_read(query)
    return(raw_data)

#Menu of navigation functions 
def navigation_menu(selected_name):
    base_query_1 = """
SELECT distance('"""
    origin_point = 'USS-Enterprise'
    print("Please select from the below options")
    print("1. Distance between enterprise and selected point")
    print("2. Time for the enterprise to travel to selected point at a given warp factor")
    user_input = int(input())
    if(user_input == 1):
        query = base_query_1 + selected_name + "','" + origin_point +"')"
        raw_data = query_execute_read(query)
        distance = distance_retrieve_process(raw_data)
        print(distance)
        print()
        print("Press enter to continue")
        input()
    elif(user_input == 2):
        print("Please input desired warp factor")
        warp = input()
        warp_time_raw = warp_time_calc(selected_name, origin_point, warp)
        warp_time = warp_time_calc_process(warp_time_raw)
        print(warp_time)
        print()
        print("Press enter to continue")
        input()

#Function to process raw starship class data for display/export
def starship_class_retrieve_process(raw_data):
    df = pd.DataFrame(columns=['id', 'Class Name', 'Design Date', 'Length (m)', 'Breadth (m)', 'No. of Decks', 'Max Warp Factor', 'Cruising Warp Factor', 'Max Sub-Light Speed', 'No. of Phaser Banks', 'No. of Torpedo Launchers', 'Crew Compliment', 'Cargo Capacity'])
    for row in raw_data:
        df = df.append(pd.Series([row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11], row[12]], index=df.columns), ignore_index=True)
    print()
    print(df.to_string(index=False))
    print()

#Function to process raw starship class data for display/export
def starship_class_retrieve_process_2(raw_data):
    df = pd.DataFrame(columns=['id', 'Class Name'])
    for row in raw_data:
        df = df.append(pd.Series([row[0], row[1]], index=df.columns), ignore_index=True)
    print()
    print(df.to_string(index=False))
    print()

#Function to process raw person data for display/export
def person_retrieve_process(raw_data):
    df = pd.DataFrame(columns=['id', 'Name', 'Organisation', 'Skin Colour', 'Hair Colour', 'Birth Planet', 'Date of Birth', 'Home Planet', 'Species', 'Affiliation', 'Rank', 'Division'])
    for row in raw_data:
        df = df.append(pd.Series([row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11]], index=df.columns), ignore_index=True)
    print()
    print(df.to_string(index=False))
    print()

#Function to process raw organisation data for display/export
def organisation_retrieve_process(raw_data):
    df = pd.DataFrame(columns=['id', 'Name', 'Origin Planet', 'Date Founded', 'Date Closed', 'Organisation Type'])
    for row in raw_data:
        df = df.append(pd.Series([row[0], row[1], row[2], row[3], row[4], row[5]], index=df.columns), ignore_index=True)
    print()
    print(df.to_string(index=False))
    print()

#Function to process raw starship data for display/export
def starship_retrieve_process(raw_data):
    df = pd.DataFrame(columns=['id', 'Name', 'Registry', 'Class', 'Organisation', 'Launch Date', 'Decommisioned'])
    for row in raw_data:
        df = df.append(pd.Series([row[0], row[1], row[2], row[3], row[4], row[5], row[6]], index=df.columns), ignore_index=True)
    print()
    print(df.to_string(index=False))
    print()
    return(df.iloc[0,1])

#Function to process raw species data for display/export
def species_retrieve_process(raw_data):
    df = pd.DataFrame(columns=['id', 'Species Name', 'Breathable Gas', 'Homeworld'])
    for row in raw_data:
        df = df.append(pd.Series([row[0], row[1], row[2], row[3]], index=df.columns), ignore_index=True)
    print()
    print(df.to_string(index=False))
    print()

def species_retrieve_process_2(raw_data):
    df = pd.DataFrame(columns=['id', 'Species Name', 'Breathable Gas', 'Homeworld'])
    for row in raw_data:
        df = df.append(pd.Series([row[0], row[1], row[2], row[3]], index=df.columns), ignore_index=True)
    return(df.iloc[0,0])

#Function to process raw planet data for display/export
def planet_retrieve_process(raw_data):
    df = pd.DataFrame(columns=['id', 'Planet Name', 'X Coordinate', 'Y Coordinate', 'Z Coordinate', 'Population', 'Atmosphere'])
    for row in raw_data:
        df = df.append(pd.Series([row[0], row[1], row[2], row[3], row[4], row[5], row[6]], index=df.columns), ignore_index=True)
    print()
    print(df.to_string(index=False))
    print()
    return(df.iloc[0,1])

def date_collect(field_name):
    print("Please input " + field_name + " (YYYY-MM-DD) or type n if not applicable")
    date = input()
    if(date == 'n'):
        date = "NULL"
    else:
        date = "'" + date + "'"
    return(date)

def complex_id_collect(element, field_name, table):
    planet_query = """
SELECT 
	planet.id,
	NULLIF(planet_name, 'Planet name unknown') AS "Planet Name",
	xcoordinate AS "X Coordinate",
	ycoordinate AS "Y Coordinate",
	zcoordinate AS "Z Coordinate",
	population AS "Population",
	gases.gas AS "Atmosphere"
FROM planet
LEFT JOIN gases ON planet.atmosphere = gases.id"""
    organisation_query = """
SELECT 
	organisation.id,
	organisation.organisation_name,
	planet.planet_name,
	organisation.date_founded,
	organisation.date_closed,
	affiliation.affiliation_type
FROM organisation
LEFT JOIN planet ON organisation.origin_planet = planet.id
LEFT JOIN affiliation ON organisation.organisation_affiliation = affiliation.id"""
    species_query = """
SELECT 
	species.id, 
	species_name AS "Species Name",
	gases.gas AS "Breathable Gas",
	planet.planet_name AS "Homeworld"
FROM species
LEFT JOIN gases ON species.breathable_gas = gases.id
LEFT JOIN homeworld ON species.id = homeworld.species_id
LEFT JOIN planet ON homeworld.planet_id = planet.id"""
    starship_class_query = """
SELECT
    starship_class.id,
    starship_class_name
    FROM
    starship_class"""
    print("Please input id of " + element + " " + field_name + " from table below of type NULL if not applicable")
    if(table == "planet"):
        df = query_execute_read_basic(planet_query)
        planet_retrieve_process(df)
    elif(table == "organisation"):
        df = query_execute_read_basic(organisation_query)
        organisation_retrieve_process(df)
    elif(table == "species"):
        df = query_execute_read_basic(species_query)
        species_retrieve_process(df)
    elif(table == "starship_class"):
        df = query_execute_read_basic(starship_class_query)
        starship_class_retrieve_process_2(df)
    print("Please input id:")
    variable = input()
    return(variable)

#Function to generate queries for retrieving starship class data
def starship_class_retrieve(mode, starship_class):
    basic_query = """
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
    """
    if(mode == 1):
        raw_data = query_execute_read(basic_query)
        starship_class_retrieve_process(raw_data)
    elif(mode == 2):
        query = basic_query + "WHERE starship_class_name LIKE '%" + starship_class + "%'"
        raw_data = query_execute_read(query)
        starship_class_retrieve_process(raw_data)
    print("Press enter to return to menu")
    input()

#Function to generate queries for retrieving person data
def person_retrieve(mode, person):
    basic_query = """
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
    """
    if(mode == 1):
        raw_data = query_execute_read(basic_query)
        person_retrieve_process(raw_data)
        print("Press enter to return to menu")
        input()
    elif(mode == 2):
        query = basic_query + "WHERE person_name LIKE '%" + person + "%'"
        raw_data = query_execute_read(query)
        person_retrieve_process(raw_data)
        print("Press enter to return to menu")
        input()




#Function to generate queries for retrieving organisation data
def organisation_retrieve(mode, organisation):
    basic_query = """
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
    """
    if(mode == 1):
        raw_data = query_execute_read(basic_query)
        organisation_retrieve_process(raw_data)
        print("Press enter to return to menu")
        input()
    elif(mode == 2):
        query = basic_query + "WHERE organisation_name LIKE '%" + organisation + "%'"
        raw_data = query_execute_read(query)
        organisation_retrieve_process(raw_data)
        print("Press enter to return to menu")
        input()

#Function to generate queries for retrieving starship data
def starship_retrieve(mode, starship):
    basic_query = """
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
    """
    if(mode == 1):
        raw_data = query_execute_read(basic_query)
        starship_retrieve_process(raw_data)
        print()
        print("Press enter to return to main menu")
        input()
    elif(mode == 2):
        query = basic_query + " WHERE starship.starship_name LIKE '%" + starship + "%'"
        raw_data = query_execute_read(query)
        ship_id = starship_retrieve_process(raw_data)
        print()
        print("Would you like to see navigation functions (y/n)")
        user_input = input()
        if(user_input == 'y'):
            print()
            navigation_menu(ship_id)
    menu()

#Funtion to generate queries for retrieving species data
def species_retrieve(mode, species):
    basic_query = """
SELECT 
	species.id, 
	species_name AS "Species Name",
	gases.gas AS "Breathable Gas",
	planet.planet_name AS "Homeworld"
FROM species
LEFT JOIN gases ON species.breathable_gas = gases.id
LEFT JOIN homeworld ON species.id = homeworld.species_id
LEFT JOIN planet ON homeworld.planet_id = planet.id
    """
    if(mode == 1):
        raw_data = query_execute_read(basic_query)
        species_retrieve_process(raw_data)
        print("Press enter to return to menu")
        input()
    elif(mode == 2):
        query = basic_query + " WHERE species.species_name LIKE '%" + species + "%'"
        raw_data = query_execute_read(query)
        species_retrieve_process(raw_data)
        print("Press enter to return to menu")
        input()
    elif(mode == 3):
        query = basic_query + " WHERE species.species_name LIKE '%" + species + "%'"
        raw_data = query_execute_read(query)
        target = species_retrieve_process_2(raw_data)
        return(target)


#Function to generate queries for retrieving planet data
def planet_retrieve(mode, planet):
    basic_query = """
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
    """
    if(mode == 1):
        raw_data = query_execute_read(basic_query)
        planet_retrieve_process(raw_data)
    elif(mode == 2):
        query = basic_query + "WHERE planet_name LIKE '%" + planet + "%'"
        raw_data = query_execute_read(query)
        selected_id = planet_retrieve_process(raw_data)
        print("Would you like to see navigation functions (y/n)")
        user_input = input()
        if(user_input == 'y'):
            print()
            navigation_menu(selected_id)
    elif(mode == 3):
        raw_data = query_execute_read(basic_query)
        data = planet_retrieve_process(raw_data)
        return(data)

    
def planet_insert():
    basic_query = """
INSERT INTO public.planet(
planet_name, xcoordinate, ycoordinate, zcoordinate, population, atmosphere)
VALUES ("""
    print()
    print("Please type in planet name")
    planet_name = input()
    print("Input planet's x coordinate")
    x_coor = input()
    print("Input planet's y coordinate")
    y_coor = input()
    print("Input planet's z coordinate")
    z_coor = input()
    print("Input planet's population")
    population = input()
    gas = option_display('gases', "planet atmospheric gas")
    query = basic_query + "'" + planet_name + "'" + "," + x_coor + "," + y_coor + "," + z_coor + "," + population + "," + gas + ")"
    query_execute_write(query)
    print("Planet recorded in database, returning to menu ...")


def species_insert():
    basic_query = """
INSERT INTO public.species(
species_name, breathable_gas)
VALUES ("""
    basic_query_3 = """
SELECT 
	species.id, 
	species_name AS "Species Name",
	gases.gas AS "Breathable Gas",
	planet.planet_name AS "Homeworld"
FROM species
LEFT JOIN gases ON species.breathable_gas = gases.id
LEFT JOIN homeworld ON species.id = homeworld.species_id
LEFT JOIN planet ON homeworld.planet_id = planet.id"""
    basic_query_4 = """
INSERT INTO public.homeworld(
species_id, planet_id)
VALUES ("""
    print()
    print("Please type in species name")
    species_name = input()
    gas = option_display('gases', "breathable gas")
    query_1 = basic_query + "'" + species_name + "'" + "," + gas + ")"
    planet_id = complex_id_collect("species", "planet", "planet")
    query_execute_write(query_1)
    if(planet_id != "NULL"):
        print()
        print("Adding homeworld data")
        read_query = basic_query_3 + " WHERE species.species_name = '" + species_name + "'"
        df = query_execute_read_basic(read_query)
        species_id = str(species_retrieve_process_2(df))
        query_2 = basic_query_4 + species_id + "," + planet_id + ")"
        query_execute_write(query_2) 
    else:
        print("Skipping homeworld data")
    print("Species recorded in database, returning to menu ...")

def organisation_insert():
    basic_query = """
INSERT INTO organisation(
 organisation_name, origin_planet, date_founded, date_closed, organisation_affiliation)
	VALUES ("""
    print("Please input organisation name")
    organisation_name = input()
    origin_planet = complex_id_collect("organisation", "origin planet", "planet")
    date_founded = date_collect("date founded")
    date_closed = date_collect("date closed")
    print("Please select organisation affiliation id from table below of type NULL if not applicable")
    affiliation = option_display('affiliation', "organisation affiliation")
    query = basic_query + "'" + organisation_name + "'," + origin_planet + "," + date_founded + "," + date_closed + "," + affiliation + ")"
    query_execute_write(query)
    print("Organisation recorded in database, returning to menu ...")
    
def person_insert():
    basic_query_1 = """
INSERT INTO public.person(
	person_name, organisation, skin_colour, hair_colour, birth_planet, dob, home_planet, species, affiliation, grade, division)
	VALUES ("""
    print("Please input person name")
    person_name = input()
    print()
    organisation = complex_id_collect("person", "organisation", "organisation") 
    print()
    skin_colour = option_display("colour", "skin colour")
    print()
    hair_colour = option_display("colour", "hair colour")
    print()
    birth_planet = complex_id_collect("person's", "birth planet", "planet")
    print()
    dob = date_collect("date of birth")
    print()
    home_planet = complex_id_collect("person's", "home planet", "planet") 
    print()
    species = complex_id_collect("person's", "species", "species")
    print()
    affiliation = option_display("affiliation", "person's affiliation")
    print()
    grade = option_display("grade", "person's rank")
    print()
    division = option_display("division", "person's division within organisation")
    query = basic_query_1 + "'" + person_name + "'," + organisation + "," + skin_colour + "," + hair_colour + "," + birth_planet + "," + dob + "," + home_planet + "," + species + "," + affiliation + "," + grade + "," + division + ")"
    query_execute_write(query)
    print("Person recorded in database, returning to menu ...")

def starship_insert():
    basic_query_1 = """
INSERT INTO public.starship(
	starship_name, registry, starship_class, organisation, launch_date, decommisioned, xcoordinate, ycoordinate, zcoordinate)
	VALUES ("""
    print("Please input starship name or NULL if unknown")
    ship_name = input()
    if (ship_name != "NULL"):
        ship_name = "'" + ship_name + "'"
    else: 
        ship_name = "NULL"
    print()
    print("Please input starship registry or NULL if unknown")
    registry = input()
    if (registry != "NULL"):
        registry = "'" + registry + "'"
    else:
        registry = "NULL"
    print()
    ship_class = complex_id_collect("Starship's", "class", "starship_class")
    print()
    organisation = complex_id_collect("Starship's", "organisation", "organisation")
    print()
    launch_date = date_collect("Launch Date")
    print()
    decommisioned = date_collect("Decommisioned Date")
    print()
    print("Please input ships current x coordinate or NULL if not applicable")
    x_coor = input()
    print()
    print("Please input ships current y coordinate or NULL if not applicable")
    y_coor = input()
    print()
    print("Please input ships current z coordinate or NULL if not applicable")
    z_coor = input()
    print()
    query = basic_query_1 + ship_name + "," + registry + "," + ship_class + "," + organisation + "," + launch_date + "," + decommisioned + "," + x_coor + "," + y_coor + "," + z_coor + ")"
    query_execute_write(query)  
    print("Starship stored in database, returning to menu ...")

def starship_class_insert():
    basic_query_1 = """
INSERT INTO public.starship_class(
	starship_class_name, design_date, starship_length, starship_breadth, starship_decks, max_warp, warp_cruise, max_impulse, phasers, torpedo_launchers, max_crew, max_cargo)
	VALUES ("""
    print("Please input class name or NULL if not applicable")
    class_name = input()
    if (class_name != "NULL"):
        class_name = "'" + class_name + "'"
    else:
        class_name = "NULL"
    print()
    design_date = date_collect("Design date")
    print()
    print("Please input length of class in meters or NULL if not applicable")
    length = input()
    print()
    print("Please input breadth of class in meters or NULL if not applicable")
    breadth = input()
    print()
    print("Please input number of decks or NULL if not applicable")
    decks = input()
    print()
    print("Please input max warp factor of class or NULL if not applicable")
    max_warp = input()
    print()
    print("Please input cruising warp factor of class or NULL if not applicable")
    cruise_warp = input()
    print()
    max_impulse = "2.69813e+08"
    print("Please input number of Phaser banks for class or NULL if not applicable")
    phasers = input()
    print()
    print("Please input number of Torpedo Launchers for class or NULL if not applicable")
    torpedo = input()
    print()
    print("Please input maximum number of crew for class or NULL if not applicable")
    crew = input()
    print()
    print("Please input maximum cargo capacity for class or NULL if not applicable")
    cargo = input()
    query = basic_query_1 + class_name + "," + design_date + "," + length + "," + breadth + "," + decks + "," + max_warp + "," + cruise_warp + "," + max_impulse + "," + phasers + "," + torpedo + "," + crew + "," + cargo + ")"
    query_execute_write(query)
    print("Starship class stored in database, returning to menu ...")


#Primary menu function
def menu():
    print("****************************************************")
    print("Welcome to the USS-Enterprise Computer")
    print("****************************************************")
    print()
    print("Please select from the functions below:")
    print("****************************************************")
    print("READ FUNCTIONS")
    print("****************************************************")
    print("1. Retrieve planet data")
    print("2. Retrieve planet data by planet name")
    print("3. Retrieve species data")
    print("4. Retrieve species data by species name")
    print("5. Retrieve starship data")
    print("6. Retrieve starship data by starship name")
    print("7. Retrieve organisation data")
    print("8. Retrieve organisation data by name")
    print("9. Retrieve people data")
    print("10. Retrieve people data by name")
    print("11. Retrieve starship classes")
    print("12. Retrieve starship class by name")
    print("****************************************************")
    print("WRITE FUNCTIONS")
    print("****************************************************")
    print("13. Insert planet entry into database")
    print("14. Insert species entry into database")
    print("15. Insert organisation entry into database")
    print("16. Insert person entry into database")
    print("17. Insert starship entry into database")
    print("18. Insert starship class entry into database")
    user_input = int(input())
    if(user_input == 1):
        planet_retrieve(1, "NULL")
        menu()
    elif(user_input == 2):
        print("Please input planet name")
        planet = input()
        planet_retrieve(2, planet)
        menu()
    elif(user_input == 3):
        species_retrieve(1, "NULL")
        menu()
    elif(user_input == 4):
        print("Please input species name")
        species = input()
        species_retrieve(2, species)
        menu()
    elif(user_input == 5):
        starship_retrieve(1, "NULL")
    elif(user_input == 6):
        print("Please input starship name")
        starship = input()
        starship_retrieve(2, starship)
    elif(user_input == 7):
        organisation_retrieve(1, "NULL")
        menu()
    elif(user_input == 8):
        print("Please input organisation name")
        organisation = input()
        organisation_retrieve(2, organisation)
        menu()
    elif(user_input == 9):
        person_retrieve(1, "NULL")
        menu()
    elif(user_input == 10):
        print("Please input person name")
        person = input()
        person_retrieve(2, person)
        menu()
    elif(user_input == 11):
        starship_class_retrieve(1, "NULL")
        menu()
    elif(user_input == 12):
        print("Please input starship name")
        starship_name = input()
        starship_class_retrieve(2, starship_name)
        menu()
    elif(user_input == 13):
        planet_insert()
        menu()
    elif(user_input == 14):
        species_insert()
        menu()
    elif(user_input == 15):
        organisation_insert()
        menu()
    elif(user_input == 16):
        person_insert()
        menu()
    elif(user_input == 17):
        starship_insert()
        menu()
    elif(user_input == 18):
        starship_class_insert()
        menu()

menu()
