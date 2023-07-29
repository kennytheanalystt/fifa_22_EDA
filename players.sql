/*  Exploratory Data analysis:
This method is use to deep dive into rough data which helps us to gain insight, 
see anomalies and relationships in the data

in this notebook we are going to use EDA technique to derive insight from the FIFA 2021 edition. 
comon question to ask include:
Who are the top fastest players in FIFA 2021?
Which Players are paid most?
Who are the Top tallest players?
Who are the Top strongest players?
Who are the best players with Long passes?
Who are the best players with short passes?
Who are the best defenders? */

SELECT* FROM players LIMIT 100;

/* Cheking for total number of records.*/
SELECT COUNT(*) FROM players;

/* Top 10 nationality of players as of 2022*/
SELECT DISTINCT nationality_name, COUNT(nationality_name) total_no_of_players 
FROM players  GROUP BY nationality_name
ORDER BY total_no_of_players DESC LIMIT 10;

/* top countries with high pontential player */
SELECT sum(potential) FROM players  WHERE potential > 79;
--
SELECT DISTINCT nationality_name, ROUND((SUM(potential)/147969)*100,2) potential 
FROM players  WHERE potential > 79 GROUP BY nationality_name
ORDER BY potential DESC LIMIT 10;

--
/* Checking for the different body of players*/
SELECT DISTINCT body_type, COUNT(body_type) bt_no 
FROM players   GROUP BY body_type
ORDER BY bt_no DESC;

/* Top 10 Fastest Player*/
SELECT short_name, movement_acceleration,
       movement_sprint_speed, pace,club_position,nationality_name
    FROM players ORDER BY movement_acceleration DESC LIMIT 10;
--
/* Tallest players */
SELECT long_name,ROUND(height_cm/30.48,2) height_feet, weight_kg, club_position, nationality_name, club_name
FROM players ORDER BY height_feet DESC LIMIT 10
-
/* Best Defenders*/
SELECT long_name, defending_marking_awareness, defending_sliding_tackle, defending_standing_tackle, club_position, age,nationality_name, club_name
FROM players ORDER BY defending_marking_awareness DESC LIMIT 10
-
/* Strongest players by power_strength*/
SELECT long_name, power_strength, power_stamina,physic, weight_kg, club_position, age,nationality_name, club_name
FROM players ORDER BY power_strength DESC LIMIT 10
-
/* Strongest players by power_stamina*/
SELECT long_name, power_strength, power_stamina,physic, weight_kg, club_position, age,nationality_name, club_name
FROM players ORDER BY power_stamina DESC LIMIT 10
-
/* Best passer of the Ball(long passes)*/
SELECT long_name, skill_long_passing, skill_ball_control, passing,power_stamina,club_position,nationality_name, club_name
FROM players ORDER BY skill_long_passing DESC LIMIT 10
--
/* Top 10 most payed players 
Let fill the null value */
SELECT * FROM players WHERE wage_eur IS NULL
UPDATE players SET wage_eur = 0 WHERE wage_eur IS NULL
--
SELECT long_name, wage_eur, value_eur, overall, club_position,nationality_name, club_name
FROM players ORDER BY wage_eur DESC LIMIT 10
--
/* Best Goal Keepers*/
SELECT long_name, goalkeeping_reflexes, goalkeeping_handling, goalkeeping_kicking,overall,height_cm, club_name
FROM players  ORDER BY goalkeeping_reflexes DESC LIMIT 10
--
/* Best wingers
firstly we need to clean the colmns rw and lw */
-- lw
SELECT lw FROM players WHERE lw LIKE '%-%'
SELECT lw, SUBSTRING(lw,1,POSITION('-' in  lw)-1) as lw FROM players
	   WHERE lw LIKE '%-%'
UPDATE players SET lw = SUBSTRING(lw,1,POSITION('-' in  lw)-1) WHERE lw LIKE '%-%'
ALTER TABLE players ALTER COLUMN  lw TYPE Bigint USING lw::bigint
-- rw
SELECT rw FROM players WHERE rw LIKE '%-%'
SELECT rw, SUBSTRING(rw,1,POSITION('-' in  rw)-1) as rw FROM players
	   WHERE rw LIKE '%-%'
UPDATE players SET rw = SUBSTRING(rw,1,POSITION('-' in  rw)-1) WHERE rw LIKE '%-%'
ALTER TABLE players ALTER COLUMN  rw type Bigint USING rw::bigint
-- 
SELECT long_name, rw + lw wingers,skill_dribbling, skill_moves, dribbling,attacking_short_passing,
	   attacking_volleys,movement_acceleration,overall,age, club_name
	   FROM players  ORDER BY wingers DESC LIMIT 10
--
/* Best Forward*/
SELECT COUNT(*) FROM players WHERE shooting IS NULL;

UPDATE players SET shooting = 0 WHERE shooting IS NULL;

SELECT short_name, shooting, attacking_finishing, power_shot_power,
       attacking_heading_accuracy, skill_dribbling, club_name
	   FROM players  ORDER BY shooting DESC LIMIT 10;
--	   

/*Best midfielder*/
SELECT short_name, mentality_vision, movement_balance, attacking_crossing,
       mentality_interceptions, defending_marking_awareness, club_name
	   FROM players  ORDER BY mentality_vision DESC LIMIT 10;
--
/* Best GoalKeeper*/
SELECT short_name, goalkeeping_reflexes, goalkeeping_handling, goalkeeping_diving,
       goalkeeping_kicking,height_cm, club_name
    FROM players
    ORDER BY goalkeeping_reflexes DESC LIMIT 10;

/* Top Overall Rating*/
SELECT long_name, overall,age,work_rate,club_position,club_name
	   FROM players  ORDER BY overall DESC LIMIT 10
--	   
/* Preferred foot*/
SELECT DISTINCT preferred_foot, COUNT(*) total
	   FROM players GROUP BY preferred_foot ORDER BY total DESC
--	  
/* AGE NOW*/
SELECT EXTRACT(YEAR FROM AGE(NOW(), dob)) age_now FROM players LIMIT 10;
ALTER TABLE players ADD age_now INT;
UPDATE players SET age_now = EXTRACT(YEAR FROM AGE(NOW(), dob))
-- 
/* Players Age distribution*/
SELECT DISTINCT age, COUNT(*) total
	   FROM players GROUP BY age ORDER BY total DESC

