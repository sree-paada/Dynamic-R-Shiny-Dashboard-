# Data

-   **Paralympic**: The DataDNA Challenge (September 2024) provides us with the which presents detailed information about medal performance across different games, years and sports. The available metadata includes information about country and city alongside continent and game start-end dates as well as season and rankings. The dataset tracks three types of medals namely gold, silver, and bronze together with a specified rank. 

# Codebook for Paralympic Dataset

## Variable Names and Descriptions:

-   **games_code** : The year and type of Paralympic Games. For years with both summer and winter events, the prefix is PG (Summer) or PW (Winter). For years with only one Paralympics, the prefix is always PG.

-   **games_year** : The year in which the Paralympic Games were held.

-   **games_city** : The city that hosted the Paralympic Games.

-   **games_country** : The country that hosted the Paralympic Games.

-   **games_continent** : The continent where the host country of the Games is located.

-   **games_start** : The start date of the Paralympic Games.

-   **games_end** : The end date of the Paralympic Games.

-   **games_season** : Indicates whether the Games were Summer or Winter Paralympics.

-   **npc** : The original IOC country code representing the participating country or the athlete’s country, may include outdated codes.

-   **npc_new** : The updated country code that reflects current geopolitical boundaries (e.g., Soviet Union updated to Russia).

-   **npc_name** : The full name of the country (based on the updated npc_new code).

-   **rank_type** : Specifies whether the rank is overall or specific to a particular sport.

-   **npc_rank** : The ranking of the country either overall for that year or for a particular sport in that year.

-   **npc_gold** : The number of gold medals won by the country in that year and/or sport.

-   **npc_silver** : The number of silver medals won by the country in that year and/or sport.

-   **npc_bronze** : The number of bronze medals won by the country in that year and/or sport.

-   **sport_code** : A short abbreviation or code used to identify each sport.

-   **sport** : The name of the sport in which the medals or rankings apply.


## Data Types:

-   **games_code** : character.

-   **games_year** : integer.

-   **games_city** : character.

-   **games_country** : character.

-   **games_continent** : character.

-   **games_start** : datetime.

-   **games_end** : datetime.

-   **games_season** : character.

-   **npc** : character.

-   **npc_new** : character.

-   **npc_name** : character.

-   **rank_type** : character.

-   **npc_rank** : integer.

-   **npc_gold** : integer.

-   **npc_silver** : integer.

-   **npc_bronze** : integer.

-   **sport_code** : integer.

-   **sport** : character.


## Dimensions

The dataset consists of 18 columns and approximately 2347 rows.
