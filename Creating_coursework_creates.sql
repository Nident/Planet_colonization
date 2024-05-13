-- Create database Coursework;

/* User-defined type */
CREATE TYPE COORDINATES AS (
	latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6)
);

/* Entities */ 
CREATE TABLE Planets (
	planet_id			 INT 		    NOT NULL, -- each planet has id
	planet_name 		 NVARCHAR(50)   NOT NULL, -- each planet has name
	distance 			 DECIMAL(10, 2) NOT NULL, -- how long does it takes to get to the planet (days)
	discovery_date 		 DATE, 			          -- when we've found this planet
	is_colony 			 BIT, 			          -- colony presence flag (0-colony, 1-no colony)
	is_life 			 BIT, 			          -- another life flag (if planet suitable for life) (0-suitable, 1-no)
	lifeAppearance_date  DATE, 			          -- estimated time of appearance of life
	satellites 			 SMALLINT, 		          -- number of planetary satellites
	last_visit_date 	 DATE, 			          -- date of last visit (12.31.2999 if we didnt visit it)
	is_indigenous_people BIT,			          -- indigenous people presence 
	indigenous_status 	 NVARCHAR(30),	          -- hazard status of indigenous people (extreme, high, moderate, low)
	indigenous_stage 	 SMALLINT		          -- indigenous people stage of economic development (12 stages)
	                                           
	create_date 		 DATETIME, 		       	  -- system date of creating a row 
	update_date			 DATETIME 	    ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a ROW
	CONSTRAINT chk_last_visit_date 	 CHECK (last_visit_date >= discovery_date),
	CONSTRAINT chk_indigenous_status CHECK (lower(indigenous_status) IN ('critical', 
																		 'moderate',
																		 'low'),
	CONSTRAINT uc_planet_name UNIQUE (planet_name),
);					
				
/*Colonies*/
CREATE TABLE Colonies (
	colony_id	  INT 		   NOT NULL, -- each colony has id
	colony_name   NVARCHAR(20) NOT NULL, -- each colony has name
	population 	  INT  		   NOT NULL, -- colony population
	settle_date   DATE         NOT NULL, -- colony settelment date
	status 		  NVARCHAR(30) NOT NULL, -- colony status (Under construction, functioning, evacuated, abandoned)
	economy_stage SMALLINT     NOT NULL, -- colony stage of economic development (12 stages)
	location	  COORDINATES  NOT NULL, -- coordinates
	home_planet   INT		   NOT NULL, -- planet
	
	create_date   DATETIME, 			 -- system date of creating a row 
	update_date	  DATETIME 	   ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a ROW
	CONSTRAINT chk_colonies_status CHECK (status IN ('under construction',
													 'functioning',
													 'evacuated',
													 'abandoned'),
	CONSTRAINT uc_colony_location  UNIQUE (location),												 
); 

/*ColonizationStages*/
CREATE TABLE ColonizationStages (
    stage_id 		  INT ,
    stage_name 		  VARCHAR(50),
    stage_description TEXT
);
		
/*Ecosystems*/
CREATE TABLE Ecosystems (
	ecosystem_id   		 INT 			NOT NULL, -- each ecosystem has id
	ecosystem_name 		 NVARCHAR(50) 	NOT NULL, -- each ecosystem has name
	description    		 TEXT, 		  			  -- ecosystem description
	livability_status 	 SMALLINT 		NOT NULL, -- (0—suitable, 1—suitable with restrictions, 2—potentially suitable, 3—recoverable 4—unsuitable)
	
	create_date 		 DATETIME,				  -- system date of creating a row 
	update_date	  		 DATETIME 	    ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a row  
	CONSTRAINT chk_temperature 		 CHECK (temperature BETWEEN -273 AND 100), -- Assuming temperature is in Celsius
	CONSTRAINT chk_livability_status CHECK (livability_status IN (0, 1, 2, 3, 4)),
	CONSTRAINT uc_ecosystem_name UNIQUE (ecosystem_name),											 

);

/*EcosystemSubtype*/
CREATE TABLE EcosystemSubtype (
    subtype_id 	 		 INT,
    subtype_name 		 NVARCHAR(50) 	NOT NULL,
    atmospheric_pressure DECIMAL(10, 2) NOT NULL, -- subecosystem atmospheric pressure
	temperature 		 SMALLINT 		NOT NULL, -- subecosystem temperature
	description			 TEXT 			NOT NULL, 
    ecosystem_id 		 INT 		  	NOT NULL,
--    FOREIGN KEY (ecosystem_id) REFERENCES Ecosystems(ecosystem_id)
	CONSTRAINT uc_subtype_name UNIQUE (subtype_name),											 

);

/*Resources*/
CREATE TABLE Resources (
	resourse_id 		INT 		 NOT NULL, -- each resource has id 
	resource_name 		NVARCHAR(20) NOT NULL, -- each resource has name
	resource_type 		NVARCHAR(20) NOT NULL, -- resource type (gas, mineral, water, energy, biological)
	availability_status SMALLINT, 			   -- resource availability (0—free, 1—poor, 2—difficult)
		
	create_date 		DATETIME,	 		   -- system date of creating a row 
	update_date	  		DATETIME 	 ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a ROW
	CONSTRAINT chk_resourse_type CHECK (resource_type IN ('gas', 
														  'mineral', 
														  'water',
														  'energy',
														  'biological'),
	CONSTRAINT chk_availability_status CHECK (livability_status IN (0, 1, 2)),
	CONSTRAINT uc_resource_name UNIQUE (resource_name),											 

);

/*Expeditions*/
CREATE TABLE Expeditions (
	expedition_id 		 INT 		  NOT NULL, -- each expediton has id
	start_date 			 DATETIME 	  NOT NULL, -- date and time of the start of the expedition  
	end_date 			 DATETIME, 				-- date and time of the end of the expedition (12.31.2999 if current)
	expedition_purpose   NVARCHAR(20) NOT NULL, -- research, colonizaton, rescue
	expedition_commander INT, 					-- Expedition commander id
	expedition_direction INT		  NOT NULL, -- planet id
	
	create_date 		 DATETIME, 				-- system date of creating a row 
	update_date	  		 DATETIME 	  ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a ROW
	CONSTRAINT chk_dates_order CHECK (start_date < end_date),
	CONSTRAINT chk_expedition_purpose CHECK (expedition_purpose IN ('research',
																	'colonizaton',
																	'rescue'),		
);

/*Teams*/
CREATE TABLE Teams (
	team_id 	   INT 			NOT NULL, -- each team has id
	team_name 	   NVARCHAR(20) NOT NULL, -- each ecosystem has name
	team_commander NVARCHAR(20) NOT NULL, -- comander name
	team_field 	   NVARCHAR(20) NOT NULL, -- team's research area
	team_size 	   SMALLINT 	NOT NULL, -- size of the team 
	
	create_date    DATETIME, 			  -- system date of creating a row 
	update_date	   DATETIME 	ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a ROW
	CONSTRAINT chk_team_field CHECK (team_field IN ('researches', 'transportation', 'guides')),
	CONSTRAINT uc_team_name UNIQUE (team_name),
);

/*Researchers*/
CREATE TABLE Researchers (
	researchers_id INT 			NOT NULL, -- each researcher has id
	name 		   NVARCHAR(30) NOT NULL, -- researcher name
	surname 	   NVARCHAR(30) NOT NULL, -- researcher last name 
	age 		   SMALLINT 	NOT NULL, -- researcher age
	post 		   NVARCHAR(40) NOT NULL, -- researcher post
	team 		   INT 			NOT NULL, -- researcher team id
	hiring_date    DATE 		NOT NULL, -- researcher date of hiring in the company
	
	create_date    DATETIME, 			  -- system date of creating a row 
	update_date	   DATETIME 	ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a ROW
	CONSTRAINT chk_researcher_age CHECK (age BETWEEN 10 AND 125),
);

/*Aircrafts*/
CREATE TABLE Aircrafts (
	aircrafts_id   	INT 		   NOT NULL, -- each aircraft has id
	aircrafts_name 	NVARCHAR(15)   NOT NULL, -- each aircraft has name
	team_owner 	  	INT 		   NOT NULL, -- team id
	weight 		  	SMALLINT 	   NOT NULL, -- aircraft weight (tonne)
	capacity 	  	SMALLINT 	   NOT NULL, -- how many people can take the aircraft
	status 		  	SMALLINT 	   NOT NULL, -- Aircraft status (0—well, 1—in need if repair, 2—reparing, 3—broken)
	loсation 	  	COORDINATES			 	 -- name of planet where is the aircraft right now (else NULL) 
	planet_location INT 					 -- palnet id	
	
	create_date   	DATETIME, 				 -- system date of creating a row 
	update_date	 	DATETIME 	   ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a ROW
	CONSTRAINT chk_aircaft_status CHECK (status IN (0, 1, 2, 3),
	CONSTRAINT uc_aircrafts_name UNIQUE (aircrafts_name)

);

/* Bridges */
CREATE TABLE Planets_x_Ecosystems_x_Resources (
	id				  INT		  NOT NULL,
	planet_id		  INT 		  NOT NULL, -- each planet has id 
	ecosystem_id   	  INT 		  NOT NULL, -- each ecosystem has id
	resourse_id 	  INT 		  NOT NULL, -- each resource has id 

	ecosystem_subtype INT					/* subtype of each ecosystem (Rainforests, Deserts, 
											   Tundra, Savannas, Coniferous forests,
											   Deciduous forests, Meadows, Mediterranean forests, 
											   Swamps, Rocks, Caves) */	
	ecosystem_square  DECIMAL(10, 2)		-- square of the area with this ecosystem (km*km)
	life_presence 	  BIT  					-- flag of presence of life 
	
	resource_quantity DECIMAL(10, 2), 		-- quantity of resource on the planet (years og using) 

	create_date    	  DATETIME, 			-- system date of creating a row 
	update_date	  	  DATETIME 	  ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a ROW
);

/*Expeditions_x_Teams*/
CREATE TABLE Expeditions_x_Teams (
	id			   INT		NOT NULL,
	expedition_id  INT 	    NOT NULL, -- each expediton has id
	team_id 	   INT 	    NOT NULL, -- each team has id
	staff_quantity SMALLINT NOT NULL, -- how many researches paticipated
	
	create_date    DATETIME, 		  -- system date of creating a row 
	update_date	   DATETIME ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a ROW
);

/*Teams_x_Researches*/
CREATE TABLE Teams_x_Researches (
	id 				 INT 	  NOT NULL, 
	team_id 	     INT      NOT NULL, -- each team has id
	researchers_id 	 INT 	  NOT NULL, -- each researcher has id
	employ_date 	 DATE     NOT NULL, -- date of being employed to the team
	dismissaled_date DATE 	  NOT NULL, -- date of being dismissaled (12.31.2999 if current)
	
	create_date    	 DATETIME, 			-- system date of creating a row 
	update_date	 	 DATETIME ON UPDATE CURRENT_TIMESTAMP, -- system date of updating a ROW
);

/* Rules */			
CREATE RULE greater_zero
AS 
@colunm >= 0;

EXEC sp_bindrule greater_zero, Planets.distance;
EXEC sp_bindrule greater_zero, Planets.satellites;
EXEC sp_bindrule greater_zero, Colonies.population;
EXEC sp_bindrule greater_zero, Ecosystems.atmospheric_pressure;
EXEC sp_bindrule greater_zero, Teams.team_size;
EXEC sp_bindrule greater_zero, Researchers.age;
EXEC sp_bindrule greater_zero, Aircrafts.weight;
EXEC sp_bindrule greater_zero, Aircrafts.capacity;
EXEC sp_bindrule greater_zero, Expeditions_x_Teams.staff_quantity;


CREATE RULE planet_name
AS
@pl_name LIKE '[A-Za-z0-9\- ]+[ ]*[A-Za-z0-9\+\-]*[ ]*[A-Za-z]*';

EXEC sp_bindrule planet_name Planets.planet_name;


CREATE RULE capital_letter
AS
@name LIKE '[A-Z]%';

EXEC sp_bindrule uppercase_name Ecosystems.ecosystem_name;
EXEC sp_bindrule uppercase_name EcosystemSubtype.subtype_name;
EXEC sp_bindrule uppercase_name Resources.resource_name;
EXEC sp_bindrule uppercase_name Researchers.name;
EXEC sp_bindrule uppercase_name Researchers.surname;



/* Defaults */
CREATE DEFAULT default_zero AS 0;

EXEC sp_bindefault default_zero Planets.indigenous_stage; 
EXEC sp_bindefault default_zero Planets.is_colony; 
EXEC sp_bindefault default_zero Colonies.economy_stage; 
EXEC sp_bindefault default_zero Teams.team_size; 


CREATE DEFAULT default_current_time AS CURRENT_TIMESTAMP;

EXEC sp_bidefault default_current_time Planets.create_date;
EXEC sp_bidefault default_current_time Planets.lifeAppearance_date;
EXEC sp_bidefault default_current_time Colonies.create_date;
EXEC sp_bidefault default_current_time Ecosystems.create_date;
EXEC sp_bidefault default_current_time EcosystemSubtype.create_date;
EXEC sp_bidefault default_current_time EcosystemSubtype.create_date;
EXEC sp_bidefault default_current_time Resources.create_date;
EXEC sp_bidefault default_current_time Expeditions.create_date;
EXEC sp_bidefault default_current_time Teams.create_date;
EXEC sp_bidefault default_current_time Researchers.create_date;
EXEC sp_bidefault default_current_time Aircrafts.create_date;
EXEC sp_bidefault default_current_time Planets_x_Ecosystems_x_Resources.create_date;
EXEC sp_bidefault default_current_time Expeditions_x_Teams.create_date;
EXEC sp_bidefault default_current_time Teams_x_Researches.create_date;
			

CREATE DEFAULT default_future_end AS '12.31.2999';

EXEC sp_bidefault default_future_end Planets.default_future_end;
EXEC sp_bidefault default_future_end Expeditions.end_date;
EXEC sp_bidefault default_future_end Teams_x_Researches.dismissaled_date;


								
/* Views */		
CREATE VIEW Planets_Colonies 
AS
SELECT pl.planet_name           AS Planet
	, CASE 
		WHEN pl.is_indigenous_people = 1
		THEN 'Exists'
		ELSE 'Not exists'
	END AS Indigenous_people
	, pl.indigenous_status      AS Indigenous_hazard_status
	, cs_p.stage_name 			AS Indigenous_stage
	, cs_p.stage_description 	AS Indigenous_stage_description
	, c.colony_name				AS Colony
	, c.population				AS Population
	, c.settle_date				AS Settle_date
	, c.status					AS Colony_status
	, cs_c.stage_name			AS Colony_stage
	, cs_c.stage_description	AS Colony_stage_description
	, c.location				AS Colony_coordinates
FROM Planets pl
JOIN Colonies c ON pl.planet_id = c.home_planet
JOIN ColonizationStages cs_p ON pl.indigenous_stage = cs_p.stage_id
JOIN ColonizationStages cs_c ON c.economy_stage = cs_c.stage_id;
			

CREATE VIEW Ecosystems_Sybtypes 
AS
SELECT ec.ecosystem_name       AS Ecosystem
	, ec.description 	       AS Ecosystem_description
	, ecs.subtype_name	       AS Subecosystem
	, ecs.atmospheric_pressure AS Atmospheric_pressure
	, ecs.temperature   	   AS Mean_temperature
	, ecs.description 		   AS Subecosystem_description
FROM Ecosystems ec
JOIN EcosystemSubtype ecs ON ec.ecosystem_id = ecs.ecosystem_id


CREATE VIEW Ecosystems_Resources
AS
SELECT DISTINCT 
	ec.ecosystem_name       AS Ecosystem
	r.resource_name			AS Resource
	r.resource_type			AS Resource_type
	r.availability_status	AS Resource_availability
FROM Planets_x_Ecosystems_x_Resources per
JOIN Ecosystems ec ON per.ecosystem_id = ec.ecosystem_id
JOIN Resources r ON per.resourse_id = ec.resourse_id


CREATE VIEW Teams_aircrafts
AS
SELECT t.team_name 		AS Team_name
	, t.team_commander  AS Commander
	, a.aircrafts_name  AS Aircrafts
	, a.weight			AS Weight
	, a.capacity 		AS Capacity
	, a.status			AS Status
FROM Teams t
JOIN Aircrafts a ON t.team_id = a.team_owner


/* Triggers */
CREATE TRIGGER update_team_size
ON Researchers
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @new_team_id INT;
    DECLARE @old_team_id INT;

    SELECT @new_team_id = team_id FROM inserted;
    SELECT @old_team_id = team_id FROM deleted;

    IF @new_team_id != @old_team_id OR @old_team_id IS NULL
    BEGIN
        
	    IF EXISTS (SELECT 1 FROM Teams WHERE team_id = @new_team_id)
        BEGIN
            UPDATE Teams
            SET team_size = team_size + 1
            WHERE team_id = @new_team_id;
        END;

        IF EXISTS (SELECT 1 FROM Teams WHERE team_id = @old_team_id)
        BEGIN
            UPDATE Teams
            SET team_size = team_size - 1
            WHERE team_id = @old_team_id;
        END;
    END;
END;


CREATE TRIGGER update_last_visit_date
ON Expeditions_x_Teams
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Planets
    SET last_visit_date = CURRENT_TIMESTAMP 
    WHERE planet_id = (SELECT expedition_direction FROM inserted);
END;



CREATE TRIGGER restore_last_visit_date
ON Expeditions_x_Teams
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @last_visit DATE;

    SELECT @last_visit = MAX(start_date)
    FROM Expeditions_x_Teams
    WHERE expedition_direction = (SELECT expedition_direction FROM deleted);

   IF @last_visit IS NOT NULL
    BEGIN
        UPDATE Planets
        SET last_visit_date = @last_visit
        WHERE planet_id = (SELECT expedition_direction FROM deleted);
    END
    ELSE
    BEGIN
        UPDATE Planets
        SET last_visit_date = '2999-12-31' 
        WHERE planet_id = (SELECT expedition_direction FROM deleted);
    END;
END;


--CREATE TRIGGER generate_expedition_report
--AFTER INSERT ON Expeditions
--FOR EACH ROW
--AS
--BEGIN
--    DECLARE @expedition_id INT;
--    DECLARE @report_text NVARCHAR(MAX);
--    
--    -- Объявляем курсор для выборки данных о новой экспедиции
--    DECLARE expedition_cursor CURSOR FOR
--    SELECT expedition_id, start_date, end_date, expedition_purpose
--    FROM inserted;
--
--    -- Открываем курсор
--    OPEN expedition_cursor;
--
--    -- Извлекаем первую строку данных из курсора
--    FETCH NEXT FROM expedition_cursor INTO @expedition_id, @start_date, @end_date, @purpose;
--
--    -- Пока строки данных доступны, формируем отчет и вставляем его в таблицу ExpeditionReports
--    WHILE @@FETCH_STATUS = 0
--    BEGIN
--        -- Формируем текст отчета
--        SET @report_text = 'Expedition Report' + CHAR(13) + CHAR(10);
--        SET @report_text = @report_text + 'Expedition ID: ' + CAST(@expedition_id AS NVARCHAR(10)) + CHAR(13) + CHAR(10);
--        SET @report_text = @report_text + 'Start Date: ' + CONVERT(NVARCHAR(20), @start_date, 120) + CHAR(13) + CHAR(10);
--        SET @report_text = @report_text + 'End Date: ' + CONVERT(NVARCHAR(20), @end_date, 120) + CHAR(13) + CHAR(10);
--        SET @report_text = @report_text + 'Purpose: ' + @purpose + CHAR(13) + CHAR(10);
--
--        -- Вставляем отчет о состоянии экспедиции в таблицу ExpeditionReports
--        INSERT INTO ExpeditionReports (expedition_id, report_text, create_date)
--        VALUES (@expedition_id, @report_text, GETDATE());
--
--        -- Извлекаем следующую строку данных из курсора
--        FETCH NEXT FROM expedition_cursor INTO @expedition_id, @start_date, @end_date, @purpose;
--    END
--
--    -- Закрываем курсор
--    CLOSE expedition_cursor;
--    DEALLOCATE expedition_cursor;
--END;












							
							
							
							
							
							
							