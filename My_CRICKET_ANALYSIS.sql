create database cricketmatchanalysis;
use cricketmatchanalysis;
CREATE TABLE Players (
    PlayerID INT PRIMARY KEY,
    PlayerName VARCHAR(100),
    TeamName VARCHAR(100),
    Role VARCHAR(50), -- e.g., Batsman, Bowler, All-Rounder, Wicket-Keeper
    DebutYear INT
);
CREATE TABLE Matches (
    MatchID INT PRIMARY KEY,
    MatchDate DATE,
    Location VARCHAR(100),
    Team1 VARCHAR(100),
    Team2 VARCHAR(100),
    Winner VARCHAR(100)
);
 #Performance Table
CREATE TABLE Performance (
    MatchID INT,
    PlayerID INT,
    RunsScored INT,
    WicketsTaken INT,
    Catches INT,
    Stumpings INT,
    NotOut BOOLEAN,
    RunOuts INT,
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID)
);
#Teams Table
CREATE TABLE Teams (
    TeamName VARCHAR(100) PRIMARY KEY,
    Coach VARCHAR(100),
    Captain VARCHAR(100)
);
#Insert the following data into the tables:
INSERT INTO Players VALUES
(1, 'Virat Kohli', 'India', 'Batsman', 2008),
(2, 'Steve Smith', 'Australia', 'Batsman', 2010),
(3, 'Mitchell Starc', 'Australia', 'Bowler', 2010),
(4, 'MS Dhoni', 'India', 'Wicket-Keeper', 2004),
(5, 'Ben Stokes', 'England', 'All-Rounder', 2011);

INSERT INTO Matches VALUES
(1, '2023-03-01', 'Mumbai', 'India', 'Australia', 'India'),
(2, '2023-03-05', 'Sydney', 'Australia', 'England', 'England');

INSERT INTO Performance VALUES
(1, 1, 82, 0, 1, 0, FALSE, 0),
(1, 4, 5, 0, 0, 1, TRUE, 0),
(2, 3, 15, 4, 0, 0, FALSE, 0);

INSERT INTO Teams VALUES
('India', 'Rahul Dravid', 'Rohit Sharma'),
('Australia', 'Andrew McDonald', 'Pat Cummins');

#Q-1 Identify the player with the 
#best batting average (total runs scored divided by the number of matches played) across all matches.
select pl.PlayerName,round(sum(perf.RunsScored)/count(distinct perf.MatchID),2) as Batting_Avg
from  players pl
join performance perf
on pl.PlayerID= perf.PlayerID
group by pl.PlayerID
order by Batting_Avg desc
limit 1;
#Explanation:
#SUM(perf.RunsScored): This calculates the total runs scored by each player.
#COUNT(DISTINCT perf.MatchID): This counts the number of distinct matches the player has played in.
#BattingAverage: The total runs scored divided by the number of matches played.
#ORDER BY BattingAverage DESC: Sorts the players by their batting average in descending order.
#LIMIT 1: Limits the result to only the player with the highest batting average

#Q-2 Find the team with the highest win percentage in matches played across all locations.
select TeamName,
(count(case when Winner= TeamName then 1 end)/count(*)) * 100 as winning_percentage
from (
select Team1 as TeamName, 
Winner from matches
union 
select Team2 as TeamName,
Winner from matches) as all_Matches
group by TeamName
order by winning_percentage desc
limit 1;
#EXPLANATION->
#COUNT(CASE WHEN Winner = TeamName THEN 1 END):
#This counts how many times each team has won,
#The CASE statement checks if the team is the winner in the match, and if so, counts it as 1.
#COUNT(*):This counts the total number of matches each team has played, considering both Team1 and Team2.
#Win Percentage Calculation: The formula CALCUALTES WINNING %
#Subquery (AllMatches): We use UNION ALL to combine the two teams (Team1 and Team2) in each match into a single list of teams, along with the winner for each match. 
#This way, we ensure that both teams are considered, even if they lose.
#ORDER BY WinPercentage DESC: Sorts the teams by their win percentage in descending order.
#Limits the result to only the team with the highest win percentage BY limiT 1

#Q-3 Identify the player who contributed the highest percentage of their team's total runs in any single match?
SELECT p.PlayerName,
       m.MatchID,
       p.TeamName,
       perf.RunsScored,
       (perf.RunsScored / team_runs.TotalTeamRuns) * 100 AS ContributionPercentage
FROM Performance perf
JOIN Players p ON perf.PlayerID = p.PlayerID
JOIN Matches m ON perf.MatchID = m.MatchID
JOIN (
    SELECT MatchID, TeamName, SUM(RunsScored) AS TotalTeamRuns
    FROM Performance
    JOIN Players ON Performance.PlayerID = Players.PlayerID
    GROUP BY MatchID, TeamName
) AS team_runs ON m.MatchID = team_runs.MatchID AND p.TeamName = team_runs.TeamName
ORDER BY ContributionPercentage DESC
LIMIT 1;
#EXPLANATIONS
#subquery (team_runs):This subquery calculates the total runs scored by each team in each match.
#It sums up the RunsScored for all players of the team in each match (GROUP BY MatchID, TeamName).
#Main Query:
#Joins the Performance, Players, and Matches tables to get the relevant data for each player in each match.
#The ContributionPercentage is calculated as (perf.RunsScored / team_runs.TotalTeamRuns) * 100, representing the percentage of runs the player contributed to their team's total runs in that match.
#ORDER BY ContributionPercentage DESC:
#This orders the result by the contribution percentage in descending order to ensure the player with the highest contribution is at the top.
#LIMIT 1: Limits the result to only the player with the highest percentage contribution.

#Q-4 Determine the most consistent player,
#defined as the one with the smallest standard deviation of runs scored across matches

SELECT p.PlayerName, 
       STDDEV_POP(perf.RunsScored) AS STANDARDDEVRUNS
FROM Performance perf
JOIN Players p ON perf.PlayerID = p.PlayerID
GROUP BY p.PlayerID
ORDER BY STANDARDDEVRUNS ASC
LIMIT 1;
#EXPLANATIONS->
#STDDEV_POP(perf.RunsScored):This calculates the population standard deviation of runs scored by each player across all the matches they have played. The population standard deviation is used here because we are calculating it for all matches (rather than a sample).
#JOIN Players p ON perf.PlayerID = p.PlayerID:
#This joins the Performance table with the Players table to get the player’s name along with their performance data.
#GROUP BY p.PlayerID:
#This groups the results by each player to calculate the standard deviation for each player across all their matches.
#ORDER BY RunsStdDev ASC:Sorts the players by their standard deviation in ascending order, so the player with the smallest standard deviation (most consistent) comes first.
#LIMIT 1:Limits the result to only the most consistent player (the one with the smallest standard deviation).

#Q-5 Find all matches where the combined total of runs scored, wickets taken, and catches exceeded 500.
select m.MatchID as No_of_Matches,sum(perf.RunsScored+perf.WicketsTaken+perf.Catches) as TotalStats
from matches m
join performance perf
on perf.MatchID = perf.MatchID
group by m.MatchID
having TotalStats > 500;
#Explanation:
#sum(perf.RunsScored+perf.WicketsTaken+perf.Catches) This sums the runs, wickets, and catches for each player in the match to get the combined total of these statistics for the match.
#JOIN  performance perf on perf.MatchID = perf.MatchID
#This joins the Performance table with the Matches table to get the match details (MatchID)
# GROUP BY mt.MatchID: this groups the results by MatchID so that we calculate the sum for each match.
# having TotalStats > 500; This filters the results, keeping only those matches where the combined total of runs, wickets, and catches exceeds 500.

# Q-6 Identify the player who has won the most 
#"Player of the Match" awards (highest runs scored or wickets taken in a match).
SELECT pl.PlayerName, 
       COUNT(*) AS PlayerOfTheMatchAwards
FROM Performance perf
JOIN Players pl ON perf.PlayerID = pl.PlayerID
JOIN Matches m ON perf.MatchID = m.MatchID
WHERE (perf.RunsScored = (SELECT MAX(RunsScored) 
                           FROM Performance 
                           WHERE MatchID = m.MatchID) 
       OR 
       perf.WicketsTaken = (SELECT MAX(WicketsTaken) 
                            FROM Performance 
                            WHERE MatchID = m.MatchID))
GROUP BY pl.PlayerID
ORDER BY PlayerOfTheMatchAwards DESC
LIMIT 1;
#Explanation:
#(SELECT MAX(RunsScored) FROM Performance WHERE MatchID = m.MatchID):
#This subquery gets the maximum runs scored in each match.
#(SELECT MAX(WicketsTaken) FROM Performance WHERE MatchID = m.MatchID):
#This subquery gets the maximum wickets taken in each match.
#WHERE (perf.RunsScored = MAX(RunsScored) OR perf.WicketsTaken = MAX(WicketsTaken)):
#This condition ensures we only consider players who scored the maximum runs or took the maximum wickets in the match.
#GROUP BY p.PlayerID:
#This groups the results by player so we can count how many times each player has been the top performer in a match.
#COUNT(*) AS PlayerOfTheMatchAwards:
#Counts the number of times each player has been the top performer (Player of the Match).
#ORDER BY PlayerOfTheMatchAwards DESC:
#Sorts the players by the number of Player of the Match awards in descending order.
#LIMIT 1:
#Limits the result to the player with the highest number of Player of the Match awards.

#q-7 Determine the team that has the most diverse player roles in their squad.
SELECT pl.TeamName, 
       COUNT(DISTINCT pl.Role) AS RoleDiversity
FROM Players pl
GROUP BY pl.TeamName
ORDER BY RoleDiversity DESC
LIMIT 1;
#EXPLANATION-
#COUNT(DISTINCT pl.Role) This counts the distinct roles in each team. For example, a team might have players with roles like "Batsman", "Bowler", "All-Rounder", etc. The DISTINCT keyword ensures that each role is only counted once per team.
#GROUP BY p.TeamName:This groups the results by the team so we can count the distinct roles for each team.
#ORDER BY RoleDiversity DESC: This orders the teams by the number of distinct roles in descending order, ensuring the team with the most diverse roles comes first.
#LIMIT 1: Limits the result to only the team with the most diverse set of player roles.

#q-8 Identify matches where the runs scored by both teams were unequal and sort them by the smallest 
#difference in total runs between the two teams.

SELECT m.MatchID,
       m.Team1, 
       m.Team2, 
       SUM(CASE WHEN pl.TeamName = m.Team1 THEN perf.RunsScored ELSE 0 END) AS Team1Runs,
       SUM(CASE WHEN pl.TeamName = m.Team2 THEN perf.RunsScored ELSE 0 END) AS Team2Runs,
       ABS(SUM(CASE WHEN pl.TeamName = m.Team1 THEN perf.RunsScored ELSE 0 END) - 
           SUM(CASE WHEN pl.TeamName = m.Team2 THEN perf.RunsScored ELSE 0 END)) AS RunsDifference
FROM Matches m
JOIN Performance perf
ON m.MatchID = perf.MatchID
JOIN Players pl 
ON perf.PlayerID = pl.PlayerID
GROUP BY m.MatchID
HAVING Team1Runs != Team2Runs
ORDER BY RunsDifference ;
#EXPLANATIONS
#SUM(CASE WHEN p.TeamName = m.Team1 THEN p.RunsScored ELSE 0 END):
#This calculates the total runs scored by Team1 in the match. If the player belongs to Team1, their runs are added; otherwise, 0 is added.
#SUM(CASE WHEN p.TeamName = m.Team2 THEN p.RunsScored ELSE 0 END):
#This calculates the total runs scored by Team2 similarly.
#ABS(SUM(...) - SUM(...)) AS RunsDifference:
#This calculates the absolute difference between the total runs scored by both teams.
#HAVING Team1Runs != Team2Runs:This filters the results to only include matches where the runs scored by the two teams are unequal.
#ORDER BY RunsDifference ASC:This sorts the matches by the smallest difference in runs between the two teams.
#Q-9 Find players who contributed (batted, bowled, or fielded) in every match that their team participated in.

SELECT pl.PlayerName
FROM players pl
WHERE NOT EXISTS (
    SELECT 1
    FROM matches m
    WHERE (m.Team1 = pl.TeamName OR m.Team2 = pl.TeamName) 
      AND NOT EXISTS (
          SELECT 1
          FROM performance perf
          WHERE perf.PlayerID = pl.PlayerID 
            AND perf.MatchID = m.MatchID 
            AND (perf.RunsScored > 0 OR perf.WicketsTaken > 0 OR perf.Catches > 0 OR perf.Stumpings > 0 OR perf.RunOuts > 0)
      )
);
#EXPLAINATION->
#Outer Query: We select the PlayerName from the Players table.
#First NOT EXISTS:This ensures that for every match that the player's team participated in (m.Team1 = pl.TeamName OR m.Team2 = pl.TeamName), there isn't a match where the player did not contribute.
#Inner NOT EXISTS: For each match, we check if the player contributed by having any value in the Performance table. If the player didn't score runs, take wickets, catch, stump, or cause a run-out, they are considered as not contributing to that match.
#Performance Contribution Check:The condition (perf.RunsScored > 0 OR perf.WicketsTaken > 0 OR perf.Catches > 0 OR perf.Stumpings > 0 OR perf.RunOuts > 0) ensures that the player either batted, bowled, or fielded in the match. 
#You can adjust this condition if you define "contributing" differently.

#Q-10 Identify the match with the closest margin of victory, based on runs scored by both teams?
SELECT m.MatchID, m.MatchDate, m.Team1, m.Team2, 
       ABS(SUM(CASE WHEN m.Team1 = pl.TeamName THEN perf.RunsScored ELSE 0 END) - 
           SUM(CASE WHEN m.Team2 = pl.TeamName THEN perf.RunsScored ELSE 0 END)) AS Margin
FROM matches m
JOIN performance perf ON m.MatchID = perf.MatchID
JOIN players pl ON perf.PlayerID = pl.PlayerID
GROUP BY m.MatchID, m.MatchDate, m.Team1, m.Team2
ORDER BY Margin ASC
LIMIT 1;
#Explanation:ABS(): We use ABS to calculate the absolute difference in runs scored by the two teams (i.e., Team1 and Team2). This gives us the margin of victory.
#CASE Statements: We use a CASE statement inside the SUM function to calculate the runs scored by each team (Team1 and Team2).
#If the player belongs to Team1, we sum the runs for Team1. Similarly, we sum the runs for Team2 using the same logic.
#GROUP BY: This groups the results by MatchID to calculate the total runs for each team in each match.
#ORDER BY: We sort the results by the Margin (difference between the runs) in ascending order to get the match with the closest margin.
#LIMIT 1: We use LIMIT 1 to return only the match with the closest margin
#Q-11 Calculate the total runs scored by each team across all matches.
SELECT pl.TeamName, SUM(perf.RunsScored) AS TotalRuns
FROM players pl
JOIN performance perf ON pl.PlayerID = perf.PlayerID
JOIN matches m ON perf.MatchID = m.MatchID
WHERE m.Team1 = pl.TeamName OR m.Team2 = pl.TeamName
GROUP BY pl.TeamName
ORDER BY TotalRuns DESC;
#EXPLANATION-
#JOINs:
#We join the Players table to the Performance table on PlayerID to access each player's performance.
#We join the Matches table to get the match information, specifically to check whether the player belongs to Team1 or Team2 in that match.
#WHERE Clause:
#We filter the data to include only the matches where the player's team (TeamName) is either Team1 or Team2 in the match. This ensures we only consider the matches in which each team played.
#SUM(perf.RunsScored):
#We use SUM to aggregate the total runs scored by each team. The runs scored by players in a match are summed together for each team.
#GROUP BY:
#We group the result by TeamName to get the total runs for each team.
#ORDER BY TotalRuns DESC: We sort the teams by the total runs scored in descending order, so the team with the highest total runs will appear first
#Q-12 12. List matches where the total wickets taken by the winning team exceeded 2.
select m.MatchID,m.MatchDate, m.Team1, m.Team2, m.Winner,SUM(CASE 
               WHEN m.Winner = m.Team1 AND pl.TeamName = m.Team1 THEN perf.WicketsTaken
               WHEN m.Winner = m.Team2 AND pl.TeamName = m.Team2 THEN perf.WicketsTaken
               ELSE 0
           END) AS TotalWickets
FROM matches m
JOIN performance perf ON m.MatchID = perf.MatchID
JOIN players pl ON perf.PlayerID = pl.PlayerID
GROUP BY m.MatchID, m.MatchDate, m.Team1, m.Team2, m.Winner
HAVING TotalWickets > 2
ORDER BY m.MatchDate;
#EXPLANATIONS= Explanation:
#JOINs:
#We join the Matches table with the Performance table on MatchID to access the performance data.
#We also join the Players table on PlayerID to know which team the player belongs to.
#CASE Statement:
#The CASE statement checks the winner of each match. If Team1 is the winner, it sums the WicketsTaken for players in Team1. Similarly, if Team2 is the winner, it sums the WicketsTaken for players in Team2. The ELSE 0 ensures that we don't count wickets for the losing team.
#SUM(perf.WicketsTaken):We use SUM to calculate the total wickets taken by the winning team in each match.
#GROUP BY:We group the results by MatchID, MatchDate, Team1, Team2, and Winner to get the total wickets per match.
#HAVING:The HAVING clause filters the results to include only those matches where the total wickets taken by the winning team is greater than 2.
#ORDER BY:We order the results by MatchDate to list the matches chronologically.

#Q-13 13. Retrieve the top 5 matches with the highest individual scores by any player.
SELECT m.MatchID, m.MatchDate, m.Team1, m.Team2, pl.PlayerName, perf.RunsScored
FROM matches m
JOIN performance perf ON m.MatchID = perf.MatchID
JOIN players pl ON perf.PlayerID = pl.PlayerID
ORDER BY perf.RunsScored DESC
LIMIT 5;
#Explanation:
#JOINs:
#We join the Matches table with the Performance table using MatchID to get the performance data of players in each match.
#We join the Players table using PlayerID to get the player's name.
#ORDER BY: We sort the results by RunsScored in descending order so that the matches with the highest individual scores appear first.
#LIMIT:We limit the result to the top 5 rows using LIMIT 5 to get the top 5 matches with the highest individual scores

#Q-14 14. Identify all bowlers who have taken at least 5 wickets across all matches.

SELECT pl.PlayerName, SUM(perf.WicketsTaken) AS TotalWickets
FROM players pl
JOIN performance perf ON pl.PlayerID = perf.PlayerID
WHERE pl.Role = 'Bowler'
GROUP BY pl.PlayerID
HAVING TotalWickets >= 5
ORDER BY TotalWickets DESC;
#Explanation:
#JOIN: #We join the Players table with the Performance table using PlayerID to get each bowler’s performance data (wickets taken).
#WHERE:We filter the players based on the role ('Bowler'), so we only consider bowlers in the results.
#GROUP BY:We group by p.PlayerID to calculate the total number of wickets for each bowler across all matches.
#HAVING:The HAVING clause ensures that only bowlers who have taken at least 5 wickets are included in the results.
#ORDER BY:#We order the results by TotalWickets in descending order to show the bowlers who have taken the most wickets at the top.

#q-15.Find the total number of catches taken by players from the team that won each match?
SELECT m.MatchID, m.MatchDate, m.Winner AS WinningTeam, SUM(perf.Catches) AS TotalCatches
FROM matches m
JOIN performance perf ON m.MatchID = perf.MatchID
JOIN players pl ON perf.PlayerID = pl.PlayerID
WHERE pl.TeamName = m.Winner
GROUP BY m.MatchID
ORDER BY m.MatchID;
#Explanation:
#JOINs: We join the Matches table with the Performance table using MatchID to get the performance data (such as catches taken).
#We join the Players table to associate each performance with the player's team.
#WHERE:We filter the players to include only those from the team that won the match, using WHERE p.TeamName = m.Winner.
#GROUP BY:We group by m.MatchID to calculate the total number of catches taken by players from the winning team in each match.
#SUM:#We use the SUM(perf.Catches) to calculate the total catches taken by players from the winning team for each match.
#ORDER BY:#We order the results by MatchID to maintain a sequential order of matches.
#This query will give you the total number of catches taken by players from the winning team in each match, along with the MatchID, MatchDate, and WinningTeam

#q-16 Identify the player with the highest combined impact score in all matches.
#The impact score is calculated as:
#Runs scored × 1.5 + Wickets taken × 25 + Catches × 10 + Stumpings × 15 + Run outs × 10.
#Only include players who participated in at least 3 matches.
SELECT pl.PlayerName,
       SUM(perf.RunsScored * 1.5 + perf.WicketsTaken * 25 + perf.Catches * 10 + perf.Stumpings * 15 + perf.RunOuts * 10) AS TotalImpactScore
FROM players pl
JOIN performance perf ON pl.PlayerID = perf.PlayerID
GROUP BY pl.PlayerID
HAVING COUNT(DISTINCT perf.MatchID) >= 3
ORDER BY TotalImpactScore DESC
LIMIT 1;
#Explanation:
#JOIN:We join the Players table with the Performance table using PlayerID to get the performance data for each player in each match.
#Impact Score Calculation:#We calculate the impact score for each player using the formula:
#RunsScored * 1.5 + WicketsTaken * 25 + Catches * 10 + Stumpings * 15 + RunOuts * 10
#GROUP BY:We group the results by p.PlayerID to calculate the total impact score for each player across all matches.
#HAVING:The HAVING clause ensures that only players who have participated in at least 3 matches are included (COUNT(DISTINCT perf.MatchID) >= 3).
#ORDER BY:#We sort the results by TotalImpactScore in descending order to identify the player with the highest impact score.
#LIMIT:We limit the result to the top 1 player with the highest combined impact score.

#Q-17 Find the match where the winning team had the narrowest margin of victory based on total runs scored by 
#both teams.If multiple matches have the same margin, list all of them.
WITH MatchRunDifferences AS (
    SELECT m.MatchID,
           m.Team1,
           m.Team2,
           m.Winner,
           (SELECT SUM(perf.RunsScored) 
            FROM performance perf 
            JOIN Players pl ON perf.PlayerID = pl.PlayerID 
            WHERE pl.TeamName = m.Team1 AND perf.MatchID = m.MatchID) AS RunsTeam1,
           (SELECT SUM(perf.RunsScored) 
            FROM performance perf 
            JOIN players pl ON perf.PlayerID = pl.PlayerID 
            WHERE pl.TeamName = m.Team2 AND perf.MatchID = m.MatchID) AS RunsTeam2
    FROM Matches m
),
RunMargins AS (
    SELECT MatchID,
           Team1,
           Team2,
           Winner,
           ABS(RunsTeam1 - RunsTeam2) AS RunDifference
    FROM MatchRunDifferences
)
SELECT MatchID, Team1, Team2, Winner, RunDifference
FROM RunMargins
WHERE RunDifference = (
    SELECT MIN(RunDifference) FROM RunMargins
)
ORDER BY RunDifference;
#Explanation:
#CTE MatchRunDifferences:We calculate the total runs scored by both Team1 and Team2 for each match using subqueries in the SELECT clause.
#We store the runs scored for both teams in the columns RunsTeam1 and RunsTeam2.
#CTE RunMargins:#We calculate the margin of victory by finding the absolute difference between the runs scored by both teams (ABS(RunsTeam1 - RunsTeam2)).
#Final Query:We select all the columns from the RunMargins CTE.
#We use a subquery in the WHERE clause to find the match with the smallest margin by comparing each match's RunDifference to the minimum value (MIN(RunDifference)).
#The query returns all matches where the margin is equal to the smallest value.
#Sorting:The result is ordered by RunDifference to ensure that the smallest margin is prioritized.
#Expected Output:
#The result will return the match (or matches) where the winning team had the narrowest margin of victory based on total runs scored.
#If multiple matches have the same margin, they will all be listed.

#Q-18 List all players who have outperformed their teammates in terms of total runs scored in more than half the matches they played.
#This requires finding matches where a player scored the most runs among their teammates and calculating the percentage.
SELECT 
    pl.PlayerName
FROM 
    players pl
JOIN 
    performance perf ON pl.PlayerID = perf.PlayerID
JOIN 
    matches m ON perf.MatchID = m.MatchID
JOIN 
    (SELECT 
        perf.MatchID, 
        MAX(perf.RunsScored) AS MaxRuns
    FROM 
        performance perf
    GROUP BY 
        perf.MatchID) AS MaxRunsPerMatch
    ON perf.MatchID = MaxRunsPerMatch.MatchID
    AND perf.RunsScored = MaxRunsPerMatch.MaxRuns
GROUP BY 
    pl.PlayerID, pl.PlayerName
HAVING 
    COUNT(DISTINCT perf.MatchID) > (SELECT COUNT(DISTINCT MatchID) / 2 FROM performance WHERE PlayerID = pl.PlayerID);
#Explanation:
#CTE PlayerMaxRuns:This step uses the RANK() window function to rank players within each match (PARTITION BY perf.MatchID), based on the RunsScored in descending order.
#This assigns a rank to each player for each match, with the player who scored the most runs in that match ranked first (RunRank = 1).
#CTE MaxScorers:#We select the players who scored the most runs in each match by filtering where the RunRank is equal to 1.
#Main Query:#We join the Players table with the MaxScorers CTE to get the players who scored the most runs in each match.
#We count the number of distinct matches where each player was the highest scorer (COUNT(DISTINCT max_runs.MatchID)).
#We compare this count to half of the total matches the player participated in. The player must have outperformed their teammates in more than half of the matches they played.
#The result is ordered by PlayerName.
#Expected Output: The result will return the players who scored the most runs in more than half of the matches they played. The percentage is calculated based on the matches where the player was the highest scorer.

#Q-19 Rank players by their average impact per match, considering only those who played at least three matches.
#The impact is calculated as:Runs scored × 1.5 + Wickets taken × 25 + Catches × 10 + Stumpings × 15 + Run outs × 10.
#Players with the same average impact should share the same rank.

SELECT 
    pl.PlayerName,
    AVG(
        (perf.RunsScored * 1.5) + 
        (perf.WicketsTaken * 25) + 
        (perf.Catches * 10) + 
        (perf.Stumpings * 15) + 
        (perf.RunOuts * 10)
    ) AS AvgImpact,
    RANK() OVER (ORDER BY AVG(
        (perf.RunsScored * 1.5) + 
        (perf.WicketsTaken * 25) + 
        (perf.Catches * 10) + 
        (perf.Stumpings * 15) + 
        (perf.RunOuts * 10)
    ) DESC) AS Ranking
FROM 
    players pl
JOIN 
    performance perf ON pl.PlayerID = perf.PlayerID
GROUP BY 
    pl.PlayerID
HAVING 
    COUNT(DISTINCT perf.MatchID) >= 3
ORDER BY 
    Ranking;
#Explanation:
#Impact Calculation:The impact is calculated by the formula:
#(RunsScored * 1.5) + (WicketsTaken * 25) + (Catches * 10) + (Stumpings * 15) + (RunOuts * 10).
#AVG() Function:The AVG() function computes the average impact per match for each player.
#RANK() Window Function:The RANK() function is used to rank players by their average impact. Players with the same average impact will share the same rank.
#HAVING Clause:#The HAVING clause ensures that only players who have participated in at least 3 matches are included.
#Sorting:#Finally, the results are ordered by Rank to list the players from highest to lowest average impact.
#Output:This query will return a list of players ranked by their average impact, considering only those who have played at least three matches. Players with the same average impact will share the same rank.

#Q-20 Identify the top 3 matches with the highest cumulative total runs scored by both teams.
#Rank the matches based on total runs using window functions. If multiple matches have the same total runs, they should share the same rank.

SELECT 
    m.MatchID,
    m.MatchDate,
    m.Team1,
    m.Team2,
    (SUM(CASE WHEN p.TeamName = m.Team1 THEN perf.RunsScored ELSE 0 END) +
     SUM(CASE WHEN p.TeamName = m.Team2 THEN perf.RunsScored ELSE 0 END)) AS TotalRuns,
    RANK() OVER (ORDER BY 
        (SUM(CASE WHEN p.TeamName = m.Team1 THEN perf.RunsScored ELSE 0 END) +
         SUM(CASE WHEN p.TeamName = m.Team2 THEN perf.RunsScored ELSE 0 END)) DESC
    ) AS Ranking
FROM 
    Matches m
JOIN 
    Performance perf ON m.MatchID = perf.MatchID
JOIN 
    Players p ON perf.PlayerID = p.PlayerID
GROUP BY 
    m.MatchID, m.MatchDate, m.Team1, m.Team2
ORDER BY 
    Ranking
LIMIT 3;

#Explanation:JOIN Statements:
#We're joining the Matches, Performance, and Players tables.
#The Matches table provides the match details.
#The Performance table provides the runs scored by players.
#The Players table helps in filtering and grouping runs based on teams (Team1 and Team2). 
#SUM with CASE:For each match, we're calculating the total runs scored by both teams (Team1 and Team2).
#The SUM(CASE WHEN p.TeamName = m.Team1 THEN perf.RunsScored ELSE 0 END) calculates the runs for Team1.
#Similarly, SUM(CASE WHEN p.TeamName = m.Team2 THEN perf.RunsScored ELSE 0 END) calculates the runs for Team2.
#Window Function (RANK())-The RANK() function ranks the matches based on the total runs scored by both teams in descending order.
#GROUP BY:We're grouping by MatchID, MatchDate, Team1, and Team2 to get the total runs for each match.
#LIMIT:The query limits the results to the top 3 matches.
#The query will return the top 3 matches with the highest cumulative runs scored by both teams, 
#and they will be ranked accordingly using the RANK() window function.

#Q-21 For each player, calculate their running cumulative impact score across all matches they’ve played, ordered by match date.
#Include only players who have played in at least 3 matches.

WITH PlayerMatchCount AS (
    SELECT 
        PlayerID,
        COUNT(DISTINCT MatchID) AS MatchCount
    FROM performance
    GROUP BY PlayerID
    HAVING MatchCount >= 3
)

SELECT 
    pl.PlayerName,
    perf.MatchID,
    (perf.RunsScored * 1.5 + perf.WicketsTaken * 25 + perf.Catches * 10 + perf.Stumpings * 15 + perf.RunOuts * 10) AS ImpactScore,
    SUM(perf.RunsScored * 1.5 + perf.WicketsTaken * 25 + perf.Catches * 10 + perf.Stumpings * 15 + perf.RunOuts * 10) 
        OVER (PARTITION BY pl.PlayerID ORDER BY m.MatchDate) AS CumulativeImpactScore
FROM 
    players pl
JOIN 
    performance perf ON pl.PlayerID = perf.PlayerID
JOIN 
    matches m ON perf.MatchID = m.MatchID
JOIN 
    PlayerMatchCount pmc ON pl.PlayerID = pmc.PlayerID
ORDER BY 
    pl.PlayerID, m.MatchDate;

#EXPLANATION
#Explanation of Changes:
#CTE PlayerMatchCount:
#This common table expression calculates the number of distinct matches for each player (COUNT(DISTINCT MatchID)).
#The HAVING COUNT(DISTINCT MatchID) >= 3 clause ensures that only players who have played at least 3 matches are included.
#Main Query:We join the Players, Performance, and Matches tables.
#The ImpactScore for each match is calculated using the provided formula.
#The running cumulative impact score is calculated using the window function SUM(...) OVER (PARTITION BY pl.PlayerID ORDER BY m.MatchDate). This ensures the cumulative score is calculated in the correct match order for each player.
#Ordering:
#The results are ordered by PlayerID and MatchDate to ensure that the cumulative impact score is computed in the correct order.
#Expected Output: PlayerName: The name of the player.,MatchID: The ID of the match.
#MatchDate: The date of the match.
#ImpactScore: The individual impact score for the match.
#CumulativeImpactScore: The running cumulative impact score for the player across all matches, ordered by match date.
#Why This Approach Should Work: Cumulative Calculation: The use of window functions ensures that we correctly compute a running total for each player based on their matches.
#Player Filtering: The HAVING COUNT(DISTINCT MatchID) >= 3 ensures we only include players who have played in at least 3 matches.

