# Exploratory Data Analysis Using SQL

### An Analysis of the FIFA22 Players Dataset

![image from unsplash](https://images.unsplash.com/photo-1633412802994-5c058f151b66?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3FsfGVufDB8fDB8fHww&auto=format&fit=crop&w=400&q=60)

Exploratory Data Analysis(EDA) is a crucial first step in the data analysis process. it invloves the use of various techniques, tools, <br> and visualization to understand the structure, patterns, and characteristics of a data-set. The primary goal of EDA is to gain <br> insights from the data, identify patterns and trends, detect anomalies, and prepare the data for further analysis and modeling.

The `FIFA22` dataet is extracted from the popular football video games of `FIFA`. Every year, there is a new game released with updated charac- <br> teristics and skills for all players from all the biggest competitions in the world. This means that there are up-to-date characteristics and skills <br> of the players that were transferred between `2015` and `2022`. The player characteristics can be found in the variables: player `name`, `age`, `heiht`<br> `in` `centimeters`, `weight in kilogram`, `nationality`, `player` `position`, `preferred foot`, `international reputation`, and `contract` <br> `duration` etc.The field player skills are divided into six subcategories, namely`passing`, `defending`, `physical`, `dribbling`, `shooting`, and `pace`.<br> For goalkeepers, the subcategories are `kicking`, `handling`, `shooting`, `reflexes`, `diving`, and `speed`. The subcategories all have subcategories themselves as well. Also, every player has an `overall` rating and a `potential`rating in the game. All ratings are in the range of `1` and `99`, where <br>the lowest is `1`and where `99` is the highest possible score. An overview of all variables in the FIFA dataset can be found in Table A1, in <br>`Data discription`.  
The information in the datasets is derived from [sofifa.com](sofifa.com), which is a well-known website with an overview of all FIFA data per year. A copy of the <br>data-set can be downloaded from [this kaggle data repositry](https://www.kaggle.com/datasets/stefanoleone992/fifa-22-complete-player-dataset)

---

<p>The aim of this article is to use EDA technique to dive into the FIFA22 data-set, derive some interesting insights from the data-set and identify <br> anomalies.<br>

The comon question we want to answer include:

- Who are the top fastest players in FIFA 2022?
- Which Players are paid most?
- Who are the Top tallest players?
- Who are the Top strongest players?
- Who are the best players with Long passes?
- Who are the best defenders?

<br>

PREREQUISITE  
You need to have a basic knowledge of SQl in order to follow through this guide, also you can install any of the SQL tool which we are going to be <br> using to run the codes i.e. MySQL, MSSQL, PostgreSQL etc.

<br>

## LOADING THE DATA SET

At first we need to load the dataset we are going to work with. There are several ways to load/import data set into an SQl database, for this lesson <br> i am going to use python to import the data set into PostgreSQL.

> Note: other SQL work bench allow's to import directly from the workbench eg.MySQL. Since i am using Postgres where importing data set is somehow complecated, i decided to use python to import the data set into the PSQL db which is a more faster and convinience way.

<br>

### To import data set into SQL using python;

<p>The to_sql() function in Python is used to write records from a Pandas DataFrame to a SQL database. It is a very powerful function that can be used to store data in a variety of database formats.  <br>
The syntax for the to_sql() function is as follows:

```python
import pandas as pd
player_df = pd.read_csv('player_22')
```

```python
from sqlalchemy import create_engine
engine = create_engine('postgresql://postgres:mlyt09@localhost:5432/projectsql')
```

> Here: `postgresql://` > the sql_tool, `postgres:` > the user, ~~`mlyt09`~~ > the password, `@localhost:` > the host, `5432` > the port, `/projectsql` the database.

```python
player_df.to_sql(name='players', con=engine,index=False if_exists='replace')
```

<br>

- player_df is the Pandas DataFrame that you want to write to the database.
- name is the name of the table that you want to create in the database.
- con is a connection object to the database.
- if_exists specifies what to do if the table already exists. The possible values are fail, replace, and append.
- index specifies whether to write the index of the DataFrame to the database.
- dtype specifies the data types of the columns in the DataFrame.
- schema specifies the schema of the database.

Check to confirm the data is in PSQL...

```sql
projectsql=# \dt players
```

List of relations
Schema | Name | Type | Owner
------ | ----- | ----- | ----------
public | players | table | postgres

```
projectsql=# \d players
```

Table "public.players"
Column | Type | Collation | Nullable | Default |
------- | ---- | --------- | -------- | ------- |
sofifa_id | bigint | | |
player_url | text | | |
short_name | text | | |
long_name | text | | |
year | bigint | | |
player_positions | text | | |
overall | bigint | | |
potential | bigint | | |
value_eur | double precision | | |
wage_eur | double precision | | |
age | bigint | | |
dob | date | | |
height_cm | bigint | | |
weight_kg | bigint | | |
100+ other columns.....

<br>

## Let Start by Using SQL Queries to answer some of our quetions.

### **(Qr1) Check** to confirm the total number of records/players in the dataset:

> Note: Qr here means query, so Qr1,2,3 > Query1,2,3 etc.

```sql
SELECT COUNT(*) AS total_no_of_players FROM players;
```

| total_no_of_players |
| ------------------- |
| 19239               |

<br>

### **(Qr2) Top 10** Nationality of Players for 2022:

```sql
SELECT DISTINCT nationality_name, COUNT(nationality_name) AS total_no_of_players
    FROM players  GROUP BY nationality_name
    ORDER BY total_no_of_players DESC LIMIT 10;
```

| nationality_name | total_no_of_players |
| ---------------- | :-----------------: |
| England          |        1719         |
| Germany          |        1214         |
| Spain            |        1086         |
| France           |         980         |
| Argentina        |         960         |
| Brazil           |         897         |
| Japan            |         546         |
| Netherlands      |         439         |
| United States    |         413         |
| Poland           |         403         |

<br>

As can be noted above, we use the `DISTINCT` key word to select the unique/distinct nationality of players. With the query above, using the `COUNT` function we are able to count the total number of players represeting each country, <br> from the result we could see that `england` has the highest representative in club-football world @2022.

<br>

### **(Qr3) Countries** with the most Football Talented (by pontential) Players:

<br>
<p>
The potential of a football player is a complex and multifaceted concept. It can be defined as the player's ability to reach their full potential as a footballer. This potential is determined by a number of factors, including the player's physical attributes, technical skills, tactical awareness, mental strength, and psychological makeup.

<br>
<p>The potential of a football player is not something that is fixed. It can be developed and improved through training, hard work, and dedication. Players who are willing to put in the hard work and dedication can reach their full potential and become world-class footballers.

<br>

```sql
SELECT sum(potential) FROM players  WHERE potential > 79;

SELECT DISTINCT nationality_name, ROUND((SUM(potential)/147969)*100,2) potential
    FROM players
    WHERE potential > 79
    GROUP BY nationality_name
    ORDER BY potential DESC LIMIT 10;
```

| nationality_name | potential |
| ---------------- | :-------: |
| Spain            |   13.03   |
| England          |   9.29    |
| France           |   8.85    |
| Brazil           |   6.13    |
| Argentina        |   5.95    |
| Germany          |   5.04    |
| Portugal         |   4.78    |
| Netherlands      |   4.30    |
| Italy            |   3.93    |
| Belgium          |   2.86    |
| (10 rows)        |

<br>

Age and Performance are use to rate the potential of a player, the more younger and good performance the more highly potentialy rated. These are one of the metrics club-scouts use to scout for new young and talented players to joined their project. As can be seen above, we calculated for the percentage of potiential players each county has, it's no suprise to see that players from european and south american country have the best potential players.

<br>

### **(Qr4) Top 10** Fastest Players:

<br>
<p>In the following code, these  atrribute listed below will be use to rank the fastest players; <br>  
 movement_acceleration, movement_sprint_speed, pace,club_position. <br>
The most important player attribute from movement_acceleration, movement_sprint_speed, and pace is movement_acceleration. This is because acceleration is the rate at which a player can change their speed. This is important for players in all positions, but it is especially important for players who play in attacking positions, such as wingers and strikers.

Movement_sprint_speed is also important, but it is not as important as movement_acceleration. This is because sprint_speed is the maximum speed that a player can reach. However, players do not need to reach their maximum speed very often. They need to be able to accelerate quickly in order to get past defenders and create scoring opportunities.

Pace is a combination of movement_acceleration and movement_sprint_speed. It is a good overall measure of a player's speed, but it is not as specific as movement_acceleration or movement_sprint_speed.

<br>

```sql
SELECT short_name, movement_acceleration,
       movement_sprint_speed, pace,club_position,nationality_name
    FROM players ORDER BY movement_acceleration DESC LIMIT 10;
```

| short_name    | movement_acceleration | movement_sprint_speed | pace | club_position | nationality_name |
| ------------- | --------------------- | --------------------- | ---- | ------------- | ---------------- |
| K. Mbapp├⌐    | 97                    | 97                    | 97   | ST            | France           |
| Adama Traor├⌐ | 97                    | 96                    | 96   | LW            | Spain            |
| M. Diaby      | 96                    | 92                    | 94   | RM            | France           |
| D. James      | 96                    | 95                    | 95   | SUB           | Wales            |
| A. Davies     | 96                    | 96                    | 96   | LB            | Canada           |
| A. Hakimi     | 95                    | 95                    | 95   | RB            | Morocco          |
| Vin├¡cius Jr. | 95                    | 95                    | 95   | SUB           | Brazil           |
| R. Sterling   | 95                    | 88                    | 91   | SUB           | England          |
| U. Antuna     | 95                    | 90                    | 92   | SUB           | Mexico           |
| C. Ejuke      | 95                    | 93                    | 94   | LM            | Nigeria          |

(10 rows)
<br>

Acceleration usually defines the rate at which someone/thing moves. together with other varibles concider we could see that the most fastest player is `Kylian mbape` which is no suprising due to his high attacking game.

> ### BONUS: _Code Explanation_ <br>
>
> Let's break down the code line by line:

- SELECT is the keyword that tells the database to select specific columns from a table.
- long_name, movement_acceleration, movement_sprint_speed, pace, club_position, and nationality_name are the columns that we want to select.
- FROM is the keyword that tells the database which table to select the columns from. In this case, the table is called players.
- ORDER BY is the keyword that tells the database to order the results by the movement_acceleration column in descending order.
- DESC is the keyword that tells the database to order the results in descending order.
- LIMIT is the keyword that limits the results to the first 10 rows.

  <br>
  The code will return the following results:
  <br>
  The long_name, movement_acceleration, movement_sprint_speed, pace, club_position, and nationality_name of the 10 players with the highest movement_acceleration.
  The results will be ordered by the movement_acceleration column in descending order.

<br>

### **(Qr5) Top 10** Strongest Players by Stregnth:

```sql
SELECT short_name, power_strength, power_stamina,physic, weight_kg, club_name
    FROM players
    ORDER BY power_strength DESC LIMIT 10;
```

| short_name    | power_strength | power_stamina | physic | weight_kg | club_name                 |
| ------------- | -------------- | ------------- | ------ | --------- | ------------------------- |
| A. Akinfenwa  | 97             | 34            | 74     | 110       | Wycombe Wanderers         |
| T. Petr├í┼íek | 96             | 57            | 79     | 99        | Rak├│w Cz─Östochowa       |
| D. Dike       | 96             | 59            | 78     | 100       | Orlando City Soccer Club  |
| R. Lukaku     | 95             | 71            | 83     | 94        | Chelsea                   |
| A. Seck       | 95             | 73            | 86     | 95        | Royal Antwerp FC          |
| A. M├⌐ndez    | 95             | 81            | 86     | 82        | Club Nacional de Football |
| G. Kondogbia  | 94             | 82            | 89     | 76        | Atl├⌐tico de Madrid       |
| S. Coates     | 94             | 80            | 87     | 92        | Sporting CP               |
| C. Luyindama  | 94             | 73            | 85     | 91        | Galatasaray SK            |
| K. Koulibaly  | 94             | 70            | 85     | 89        | Napoli                    |

(10 rows)

<br>
The strength and stamina of a players usually determines thier stability, compose and control of the ball. Players with high qualities of the aforemention usually have an edge over oposition players(defend or attack).

<br>

### **(Qr6) Top 10** Strongest Players by stamina:

```sql
SELECT long_name, power_strength, power_stamina,physic, weight_kg, club_name
 FROM players
 ORDER BY power_stamina DESC LIMIT 10
```

| long_name                      | power_strength | power_stamina | physic | weight_kg |    club_name     |
| ------------------------------ | :------------: | :-----------: | :----: | :-------: | :--------------: |
| N'Golo Kant├⌐                  |       72       |      97       |   83   |    70     |     Chelsea      |
| Jewgienij Baszkirow            |       52       |      96       |   67   |    71     | Zag┼é─Öbie Lubin |
| Rhyan Bert Grant               |       77       |      95       |   82   |    79     |    Sydney FC     |
| Vladim├¡r Darida               |       48       |      95       |   63   |    67     |    Hertha BSC    |
| Andrew Robertson               |       65       |      95       |   76   |    64     |    Liverpool     |
| Nicol├▓ Barella                |       69       |      95       |   78   |    68     |      Inter       |
| σÑÑσƒ£ σìÜΣ║«                  |       71       |      95       |   73   |    68     |   Cerezo Osaka   |
| Pieter Gerkens                 |       58       |      94       |   71   |    72     | Royal Antwerp FC |
| Didier Andr├⌐s Moreno Asprilla |       79       |      94       |   79   |    77     |    Junior FC     |
| Denzel Justus Morris Dumfries  |       89       |      94       |   89   |    80     |      Inter       |

(10 rows)

<br>

## Best Players FIFA22 (position wise)

Who were the best players(position wise) for the FIFA22 video game, concidering variables that are related to each player position we are going to answer the following questions;
<br>

### **(Qr7)** Best Wingers:

<br>
<p>Looking at the dataset, we will realise both the lw(Left-Wing) and rw(Right-Wing) column are formatted as text even though they contain numbers, with the below query we could understan why. 
Some of the number contain character that are not number, we will have to clean this up and convert the columns into an integer!.

```sql
--lw
SELECT lw FROM players WHERE lw LIKE '%-%';
```

> The code above is a `SQL SELECT` statement. It is used to select all rows from the `players` table where the `lw` column contains a hyphen (-).

|  lw  |
| :--: |
| 83-1 |
| 83-1 |
| 82-1 |
| 81-1 |
| 81-1 |

...... 300+ other values

```sql
SELECT lw, SUBSTRING(lw,1,POSITION('-' in  lw)-1) AS lw_cleaned
    FROM players
	WHERE lw LIKE '%-%';
```

> The code above is an `SQL SELECT` statement that will return the `lw` column from the `players` table, along with a new column called `lw_cleaned`. The `lw_cleaned` column will contain the value of the `lw` column, but with the hyphen (-) removed.

|  lw  | lw_cleaned |
| :--: | :--------: |
| 83-1 |     83     |
| 83-1 |     83     |
| 82-1 |     82     |
| 81-1 |     81     |
| 81-1 |     81     |

.... 300+ other values

```sql
UPDATE players SET lw = SUBSTRING(lw,1,POSITION('-' in  lw)-1) WHERE lw LIKE '%-%'
```

UPDATE 326

> The code above is an `SQL UPDATE` statement that will update the `lw` column in the `players` table. The update will remove the hyphen (-) from the `lw` column, if it is present.
> <br>

<p>Finally we need to convert the the column to integer to be able to apply any arithemetic operation.

```sql
ALTER TABLE players ALTER COLUMN  lw TYPE Bigint USING lw::bigint
```

ALTER TABLE

> The above is an `SQL ALTER TABLE` statement that will change the data type of the `lw` column in the players table to `Bigint`.
> <br>

### Let's apply the above to rw(right-winger):

```sql
-- rw
SELECT rw FROM players WHERE rw LIKE '%-%'
```

|  rw  |
| :--: |
| 75-1 |
| 83-1 |
| 82-1 |
| 81-1 |
| 81-1 |

.....300+

```sql
SELECT rw, SUBSTRING(rw,1,POSITION('-' in  rw)-1) AS rw
    FROM players
	WHERE rw LIKE '%-%'
```

|  rw  | rw  |
| :--: | :-: |
| 75-1 | 75  |
| 83-1 | 83  |
| 82-1 | 82  |
| 81-1 | 81  |
| 81-1 | 81  |
| 80-1 | 80  |
| 80-1 | 80  |
| 80-1 | 80  |

```sql
UPDATE players SET rw = SUBSTRING(rw,1,POSITION('-' in  rw)-1) WHERE rw LIKE '%-%'
```

UPDATE 326

```sql
ALTER TABLE players ALTER COLUMN  rw type Bigint USING rw::bigint
```

ALTER TABLE
<br>

<p>Finally we can add the values for lw & rw for each players to get the highest rating player, playing in the wing role!.

> The code below is an `SQL SELECT` statement that will select specific columns from the `players` table and order the results by the wingers column in descending order. The `LIMIT` clause limits the results to the first 10 rows.

```sql
SELECT short_name, rw + lw wingers,skill_dribbling,attacking_short_passing,
       movement_acceleration,overall,age, club_name
	   FROM players  ORDER BY wingers DESC LIMIT 10;
```

| short_name        | wingers | skill_dribbling | attacking_short_passing | movement_acceleration | overall | age | club_name           |
| ----------------- | ------- | --------------- | ----------------------- | --------------------- | ------- | --- | ------------------- |
| L. Messi          | 184     | 96              | 91                      | 91                    | 93      | 34  | Paris Saint-Germain |
| Neymar Jr         | 180     | 95              | 86                      | 93                    | 91      | 29  | Paris Saint-Germain |
| K. Mbapp├⌐        | 180     | 93              | 85                      | 97                    | 91      | 22  | Paris Saint-Germain |
| Cristiano Ronaldo | 176     | 88              | 80                      | 85                    | 91      | 36  | Manchester United   |
| M. Salah          | 176     | 90              | 84                      | 89                    | 89      | 29  | Liverpool           |
| K. De Bruyne      | 176     | 88              | 94                      | 76                    | 91      | 30  | Manchester City     |
| R. Sterling       | 174     | 87              | 83                      | 95                    | 88      | 26  | Manchester City     |
| H. Son            | 174     | 87              | 84                      | 85                    | 89      | 28  | Tottenham Hotspur   |
| S. Man├⌐          | 174     | 90              | 84                      | 93                    | 89      | 29  | Liverpool           |
| P. Dybala         | 174     | 90              | 87                      | 88                    | 87      | 27  | Juventus            |

(10 rows)

<br>
Here is an explanation of the 'rw + lw' AS 'wingers' part of the code:

- The rw + lw expression adds the values of the rw and lw columns.
- The AS wingers clause gives the new column the name wingers.
- This means that the wingers column will contain the sum of the values of the rw and lw columns. This is useful because it allows us to rank the players by their overall attacking ability, regardless of whether they are primarily right wingers, left wingers, or both.

<br>

### **(Qr8)** Best Forwarder (Striker):

<br>
<p>In the following code, these  atrribute listed below will be use to rank the best forwarders; <br>  
shooting, attacking_finishing, attacking_heading_accuracy, skill_dribbling, power_shot_power. <br> 
The most important attribute for a striker is shooting. This is because the main job of a striker is to score goals, and the shooting attribute determines how likely they are to do so. A good striker will have a high shooting attribute, and they will be able to score goals from a variety <br>of different positions.

<br>
The other attributes listed are also important, but they are not as important as shooting. For example, a striker with a high attacking finishing attribute may be able to score goals from close range, but if they do not have a good shooting attribute, they will not be able to score goals from other positions.
<br>
Ultimately, the best way to judge a good striker is to watch them play. However, if you are only able to look at the attributes, then the shooting attribute is the most important one to consider.

<br>

```sql
SELECT COUNT(*) FROM players WHERE shooting IS NULL;
```

| count |
| ----- |
| 2132  |

```sql
UPDATE players SET shooting = 0 WHERE shooting IS NULL;
```

UPDATE 2132

```sql
SELECT short_name, shooting, attacking_finishing, power_shot_power,
       attacking_heading_accuracy, skill_dribbling, club_name
	   FROM players  ORDER BY shooting DESC LIMIT 10;
```

| short_name        | shooting | attacking_finishing | power_shot_power | attacking_heading_accuracy | skill_dribbling | club_name           |
| ----------------- | -------- | ------------------- | ---------------- | -------------------------- | --------------- | ------------------- |
| Cristiano Ronaldo | 94       | 95                  | 94               | 90                         | 88              | Manchester United   |
| L. Messi          | 92       | 95                  | 86               | 70                         | 96              | Paris Saint-Germain |
| R. Lewandowski    | 92       | 95                  | 90               | 90                         | 85              | FC Bayern M├╝nchen  |
| E. Haaland        | 91       | 94                  | 94               | 69                         | 78              | Borussia Dortmund   |
| H. Kane           | 91       | 94                  | 91               | 86                         | 83              | Tottenham Hotspur   |
| L. Su├írez        | 90       | 93                  | 89               | 84                         | 83              | Atl├⌐tico de Madrid |
| S. Ag├╝ero        | 89       | 93                  | 90               | 78                         | 86              | FC Barcelona        |
| K. Mbapp├⌐        | 88       | 93                  | 86               | 72                         | 93              | Paris Saint-Germain |
| H. Son            | 87       | 88                  | 88               | 68                         | 87              | Tottenham Hotspur   |
| M. Salah          | 87       | 91                  | 82               | 59                         | 90              | Liverpool           |

(10 rows)

<br>

### **(Qr9)** Best Midfielder:

<br>

<p>In the following code, these  atrribute listed below will be use to rank the best Midfielders; <br>  
mentality_vision, movement_balance, attacking_crossing, mentality_interceptions, defending_marking_awareness <br>
The most important attribute to judge a midfielder is mentality_vision. This is because midfielders need to be able to see the game ahead of them and make good decisions, both offensively and defensively. A midfielder with a high mentality_vision attribute will be able to see where their teammates are and where the space is, and they will be able to make passes and crosses that create scoring opportunities.

<br>
The other attributes listed  are also important, but they are not as important as mentality_vision. For example, a midfielder with a high attacking_crossing attribute may be able to make good crosses, but if they do not have a good mentality_vision attribute, they will not be able to see where their teammates are and they will not be able to make the right passes.
<br>
Ultimately, the best way to judge a midfielder is to watch them play. However, if you are only able to look at the attributes, then the mentality_vision attribute is the most important one to consider.

<br>

```sql
SELECT short_name, mentality_vision, movement_balance, attacking_crossing,
       mentality_interceptions, defending_marking_awareness, club_name
	   FROM players  ORDER BY mentality_vision DESC LIMIT 10;
```

| short_name      | mentality_vision | movement_balance | attacking_crossing | mentality_interceptions | defending_marking_awareness | club_name           |
| --------------- | ---------------- | ---------------- | ------------------ | ----------------------- | --------------------------- | ------------------- |
| L. Messi        | 95               | 95               | 85                 | 40                      | 20                          | Paris Saint-Germain |
| K. De Bruyne    | 94               | 78               | 94                 | 66                      | 68                          | Manchester City     |
| Luis Alberto    | 92               | 83               | 69                 | 59                      | 58                          | Lazio               |
| P. Dybala       | 91               | 94               | 82                 | 42                      | 32                          | Juventus            |
| T. Kroos        | 90               | 71               | 88                 | 80                      | 71                          | Real Madrid CF      |
| Bruno Fernandes | 90               | 79               | 87                 | 66                      | 72                          | Manchester United   |
| Neymar Jr       | 90               | 84               | 85                 | 37                      | 35                          | Paris Saint-Germain |
| L. Modri─ç      | 90               | 92               | 86                 | 80                      | 70                          | Real Madrid CF      |
| David Silva     | 90               | 89               | 83                 | 50                      | 58                          | Real Sociedad       |
| Iniesta         | 90               | 76               | 75                 | 59                      | 68                          | Vissel Kobe         |

(10 rows)

<br>

### **(Qr10)** Best Defender:

<br>

<p>In the following code, these  atrribute listed below will be use to rank the best Defenders; <br>  
movement_balance, mentality_aggression, mentality_interceptions, defending_marking_awareness, defending_sliding_tackle, defending_standing_tackle <br>
The most important attribute to judge a defender is defending_marking_awareness. This is because defenders need to be able to mark their opponents and prevent them from scoring. A defender with a high defending_marking_awareness attribute will be able to stay close to their opponents and prevent them from getting into good scoring positions.

<br>
The other attributes listed above are also important, but they are not as important as defending_marking_awareness. For example, a defender with a high mentality_aggression attribute may be able to put in hard tackles, but if they do not have a good defending_marking_awareness attribute, they will not be able to mark their opponents effectively.
<br>

```sql
SELECT short_name, defending_marking_awareness, defending_sliding_tackle, defending_standing_tackle,
       mentality_interceptions, mentality_aggression, club_name
	   FROM players
       ORDER BY defending_marking_awareness DESC LIMIT 10;
```

| short_name   | defending_marking_awareness | defending_sliding_tackle | defending_standing_tackle | mentality_interceptions | mentality_aggression | club_name           |
| ------------ | --------------------------- | ------------------------ | ------------------------- | ----------------------- | -------------------- | ------------------- |
| G. Chiellini | 93                          | 88                       | 89                        | 89                      | 88                   | Juventus            |
| V. van Dijk  | 92                          | 86                       | 92                        | 90                      | 83                   | Liverpool           |
| R├║ben Dias  | 90                          | 85                       | 89                        | 85                      | 92                   | Manchester City     |
| M. ┼ákriniar | 90                          | 82                       | 88                        | 86                      | 84                   | Inter               |
| K. Koulibaly | 90                          | 86                       | 88                        | 85                      | 83                   | Napoli              |
| S. Savi─ç    | 90                          | 83                       | 86                        | 87                      | 86                   | Atl├⌐tico de Madrid |
| N. Kant├⌐    | 90                          | 86                       | 93                        | 91                      | 93                   | Chelsea             |
| M. Hummels   | 90                          | 86                       | 90                        | 89                      | 71                   | Borussia Dortmund   |
| S. de Vrij   | 89                          | 85                       | 87                        | 87                      | 77                   | Inter               |
| Marquinhos   | 89                          | 89                       | 89                        | 88                      | 81                   | Paris Saint-Germain |

(10 rows)

<br>

### **(Qr10)** Best Goalkeeper:

<br>

<p>In the following code, these  atrribute listed below will be use to rank the best Goal Keepers; <br>  
goalkeeping_reflexes, goalkeeping_handling, goalkeeping_diving, goalkeeping_kicking <br>

The most important attribute to judge a goalkeeper is goalkeeping_reflexes. This is because goalkeepers need to be able to react quickly to save shots. A goalkeeper with a high goalkeeping_reflexes attribute will be able to make saves that most other goalkeepers would miss.

<br>
The other attributes listed  are also important, but they are not as important as goalkeeping_reflexes. For example, a goalkeeper with a high goalkeeping_handling attribute may be able to catch and hold onto the ball well, but if they do not have good reflexes, they will not be able to save shots that are hit with a lot of power.

<br>

```sql
SELECT short_name, goalkeeping_reflexes, goalkeeping_handling, goalkeeping_diving,
       goalkeeping_kicking,height_cm, club_name
    FROM players
    ORDER BY goalkeeping_reflexes DESC LIMIT 10;
```

<br>

| short_name    | goalkeeping_reflexes | goalkeeping_handling | goalkeeping_diving | goalkeeping_kicking | height_cm | club_name           |
| ------------- | -------------------- | -------------------- | ------------------ | ------------------- | --------- | ------------------- |
| M. ter Stegen | 90                   | 85                   | 88                 | 88                  | 187       | FC Barcelona        |
| H. Lloris     | 90                   | 83                   | 88                 | 65                  | 188       | Tottenham Hotspur   |
| G. Donnarumma | 90                   | 83                   | 91                 | 79                  | 196       | Paris Saint-Germain |
| K. Schmeichel | 90                   | 78                   | 84                 | 80                  | 189       | Leicester City      |
| J. Oblak      | 90                   | 92                   | 87                 | 78                  | 188       | Atl├⌐tico de Madrid |
| Alisson       | 89                   | 86                   | 86                 | 84                  | 191       | Liverpool           |
| K. Navas      | 89                   | 84                   | 89                 | 75                  | 185       | Paris Saint-Germain |
| M. Neuer      | 88                   | 88                   | 88                 | 91                  | 193       | FC Bayern M├╝nchen  |
| Ederson       | 88                   | 82                   | 87                 | 93                  | 188       | Manchester City     |
| T. Courtois   | 88                   | 89                   | 84                 | 74                  | 199       | Real Madrid CF      |

(10 rows)

<br>

### **(Qr10)** Most Paid player(Wage in eur):

<br>
<p>Player wages are the salaries that players receive from their clubs. They are typically paid weekly or monthly, and they can vary depending on a number of factors, including the player's age, experience, ability, and the club's financial situation.

<br>
Player wages are an important part of the economics of professional football. They can be a significant financial burden for clubs, but they are also necessary to attract and retain the best players.

<br>
Player wages can also be affected by other factors, such as the player's contract length, the player's image rights, and the player's performance.

In recent years, player wages have been rising steadily. This is due to a number of factors, including the increasing commercialization of football and the increasing competition for talent.
<br>
As a result, player wages have become a major issue for clubs. Some clubs are struggling to afford the wages of their players, and this is leading to financial problems.
<br>

```sql
SELECT COUNT(*) FROM players WHERE wage_eur IS NULL;
```

| count |
| :---: |
|  61   |

```sql
UPDATE players SET wage_eur = 0 WHERE wage_eur IS NULL;
```

UPDATE 61

```sql
SELECT short_name, wage_eur, value_eur, overall, club_position,nationality_name, club_name
    FROM players
    ORDER BY wage_eur DESC LIMIT 10;
```

| short_name        | wage_eur | value_eur | overall | club_position | nationality_name | club_name           |
| ----------------- | -------- | --------- | ------- | ------------- | ---------------- | ------------------- |
| K. De Bruyne      | 350000   | 125500000 | 91      | RCM           | Belgium          | Manchester City     |
| K. Benzema        | 350000   | 66000000  | 89      | CF            | France           | Real Madrid CF      |
| L. Messi          | 320000   | 78000000  | 93      | RW            | Argentina        | Paris Saint-Germain |
| Casemiro          | 310000   | 88000000  | 89      | CDM           | Brazil           | Real Madrid CF      |
| T. Kroos          | 310000   | 75000000  | 88      | LCM           | Germany          | Real Madrid CF      |
| R. Sterling       | 290000   | 107500000 | 88      | SUB           | England          | Manchester City     |
| R. Lewandowski    | 270000   | 119500000 | 92      | ST            | Poland           | FC Bayern M├╝nchen  |
| Cristiano Ronaldo | 270000   | 45000000  | 91      | ST            | Portugal         | Manchester United   |
| M. Salah          | 270000   | 101000000 | 89      | RW            | Egypt            | Liverpool           |
| Neymar Jr         | 270000   | 129000000 | 91      | LW            | Brazil           | Paris Saint-Germain |

(10 rows)

<br>

### **(Qr11)** Top Rated Player player(Overall):

<br>
<p>The overall rating of a player is a number that represents their overall ability in FIFA. It is calculated based on a number of factors, including their attributes, their position, and their form.

<br>
The overall rating of a player can range from 1 to 99, with 99 being the highest possible rating. Players with a high overall rating are considered to be the best players in the world.

<br>
The overall rating of a player is a dynamic measure, which means that it can change over time. The player's attributes can improve as they get more experience. Their form can also improve or decline, as a result, the overall rating of a player is a good way to track their progress and to see how they compare to other players.
<br>

```sql
SELECT short_name, overall,age,club_position,club_name
    FROM players
    ORDER BY overall DESC LIMIT 10;
```

| short_name        | overall | age | club_position |      club_name      |
| ----------------- | ------- | --- | :-----------: | :-----------------: |
| L. Messi          | 93      | 34  |      RW       | Paris Saint-Germain |
| R. Lewandowski    | 92      | 32  |      ST       | FC Bayern M├╝nchen  |
| Cristiano Ronaldo | 91      | 36  |      ST       |  Manchester United  |
| K. De Bruyne      | 91      | 30  |      RCM      |   Manchester City   |
| J. Oblak          | 91      | 28  |      GK       | Atl├⌐tico de Madrid |
| K. Mbapp├⌐        | 91      | 22  |      ST       | Paris Saint-Germain |
| Neymar Jr         | 91      | 29  |      LW       | Paris Saint-Germain |
| H. Kane           | 90      | 27  |      ST       |  Tottenham Hotspur  |
| N. Kant├⌐         | 90      | 30  |      RCM      |       Chelsea       |
| M. Neuer          | 90      | 35  |      GK       | FC Bayern M├╝nchen  |

(10 rows)

<br>

### **(Qr12)** Preferred Foot of a Player:

<br>
<p>A player's preferred foot is the foot that they use most often to kick the ball. This can have a significant impact on their playing style and their ability to perform certain skills.

<br>
For example, a player who is right-footed will typically be better at crossing the ball with their right foot and shooting with their right foot. <br>They may also be better at dribbling with their right foot and passing with their right foot.
<br>
On the other hand, a player who is left-footed will typically be better at crossing the ball with their left foot and shooting with their left foot. <br>They may also be better at dribbling with their left foot and passing with their left foot.

<br>
Of course, there are some players who are ambidextrous and can use both feet equally well.<br>However, most players have a preferred foot that they use more often. 
<br>
The preferred foot of a player can be determined by a number of factors, including their genetics, their training, and their playing style.

<br>
Finally, a player's playing style can also affect their preferred foot. For example, a player who is a striker will typically need to be good at shooting with both feet, as they will need to be able to score goals from both sides of the goal. However, a player who is a defender may only need to be good at using one foot, as they will typically only need to defend from one side of the field.
<br>

```sql
SELECT DISTINCT preferred_foot, COUNT(*) AS total
    FROM players
    GROUP BY preferred_foot
    ORDER BY total DESC;
```

| preferred_foot | total |
| -------------- | :---: |
| Right          | 14674 |
| Left           | 4565  |

(2 rows)

<br>

### **(Qr13)** What is the player age distribution?:

<br>
<p>Below, we could note that the player age distribution in soccer is typically bimodal, with a peak in the early 20s and another peak in the late 30s. This is because players tend to reach their peak physical and technical abilities in their early 20s, but they can also maintain a high level of performance into their late 30s if they stay fit and healthy.

<br>
There are a few reasons for the bimodal distribution. First, young players are often more physically gifted than older players, and they have more energy. This allows them to run more, tackle harder, and jump higher. Second, young players are often more technically gifted than older players, and they have better ball control and passing skills. This allows them to create more chances and score more goals.

<br>
However, young players often lack experience and decision-making skills. This can lead to mistakes, and it can also make them more susceptible to injuries. As players get older, they gain experience and decision-making skills. This allows them to make better decisions on the field, and it also helps them to avoid injuries.

The age distribution of players also varies depending on the position. For example, goalkeepers tend to be older than other players, because they need to have a high level of experience and decision-making skills. Defenders also tend to be older than other players, because they need to be physically strong and have a good understanding of the game.
<br>

```sql
SELECT DISTINCT age, COUNT(*) total
	   FROM players GROUP BY age ORDER BY total DESC;
```

| age | total |
| --- | :---: |
| 21  | 1547  |
| 22  | 1446  |
| 24  | 1442  |
| 25  | 1394  |
| 23  | 1387  |
| 20  | 1377  |
| 27  | 1200  |
| 26  | 1197  |
| 29  | 1178  |
| 28  | 1129  |
| 19  | 1099  |
| 30  |  901  |
| 31  |  825  |
| 18  |  733  |
| 32  |  634  |
| 33  |  468  |
| 34  |  354  |
| 17  |  271  |
| 35  |  258  |
| 36  |  146  |
| 37  |  105  |
| 38  |  62   |
| 39  |  39   |
| 16  |  20   |
| 40  |  14   |
| 41  |   7   |
| 43  |   3   |
| 42  |   2   |
| 54  |   1   |

(29 rows)

## BONUS

### **(Qr13)** What is the current player age(Now):

<br>
<p> 
<br>

```sql
ALTER TABLE players ALTER COLUMN dob TYPE DATE USING dob::DATE;
```

ALTER TABLE

```sql
SELECT EXTRACT(YEAR FROM AGE(NOW(), dob)) age_now FROM players LIMIT 6;
```

| age_now |
| :-----: |
|   36    |
|   34    |
|   38    |
|   31    |
|   32    |
|   24    |

(6 rows)

```sql
ALTER TABLE players ADD age_now INT;
```

ALTER TABLE

```sql
UPDATE players SET age_now = EXTRACT(YEAR FROM AGE(NOW(), dob))
```

UPDATE 19239

```sql
SELECT short_name, age AS age_2022, age_now
    FROM players
    ORDER BY overall DESC LIMIT 8;
```

| short_name        | age_2022 | age_now |
| ----------------- | :------: | :-----: |
| L. Messi          |    34    |   36    |
| R. Lewandowski    |    32    |   34    |
| J. Oblak          |    28    |   30    |
| K. De Bruyne      |    30    |   32    |
| Neymar Jr         |    29    |   31    |
| Cristiano Ronaldo |    36    |   38    |
| K. Mbapp├⌐        |    22    |   24    |
| H. Kane           |    27    |   30    |

(8 rows)

<br>

## HIGHLIGHTS AND CONCLUSION

<br>
In this EDA of FIFA data set, we have explored a variety of features, including player age, overall rating, preferred foot, wage, and best position. We have found that there are a number of interesting trends and relationships within the data. For example, we have found that:

<br>

- Player age distribution of players is bimodal, with a peak in early 20s and another in late 30s.
- The best players playing in their role/position often have high technical abilities/qualities and can effect their team overall performance.
- The High overall rating of players of result from their form/performance and their atrribute, it can also be from how they effect their team to play better. This is a good way of tracking a player progress.
- lastly the wage of players are skyrocketing by year, this as cause major issue for football clubs. Some clubs are struggling to afford the wages of their players, and this is leading to financial problems.

<br>
Through this EDA, we have learned a number of things about Exporatory Data Analysis in SQL. For example, we have learned how to:
<br>

- Use SQL queries to explore data sets.
- Identify trends and relationships within data sets.
- Test hypotheses about data sets.
- We have also learned that EDA is a powerful tool that can be used to gain insights into data sets. By exploring data sets, we can identify trends and relationships that would not be obvious from simply looking at the data. This information can be used to make better decisions about the data, or to build better models.

<br>
The next step in this project would be to conduct more in-depth analysis of the data. This could involve using statistical tests to test our hypotheses, or building machine learning models to predict player performance.

<br>
Thanks for coming this long....

<!-- -->
<!-- Conclution:conlude the work by summerizing what has been done in the above and what we gain from it. -->
