# CRICKET-MYSQL-ANALYSIS
Cricket Analysis SQL Case Study
Here’s a polished and professional **README summary** for your **Cricket Analysis SQL Case Study** project. It’s concise, well-structured, and tailored to impress recruiters by showcasing your SQL skills, problem-solving approach, and the depth of your analysis:

---

# 🏏 Cricket Analysis SQL Case Study

## 🌟 Overview
This project is a comprehensive **SQL-based analysis** of cricket match data, focusing on player performance, team statistics, and match outcomes. The goal of this project is to derive meaningful insights from cricket data by solving **21 complex SQL queries**, ranging from identifying the best-performing players to analyzing team dynamics and match results. This case study demonstrates my ability to work with relational databases, write efficient SQL queries, and extract actionable insights from raw data.

---

## 🚀 Key Features
- **📊 21 Complex SQL Queries**: Solved a variety of analytical problems, including player performance, team statistics, and match outcomes.
- **📈 Advanced SQL Techniques**: Used **window functions**, **aggregations**, **joins**, **subqueries**, and **conditional logic** to derive insights.
- **🎯 Performance Metrics**: Calculated key metrics such as **batting averages**, **win percentages**, **impact scores**, and **consistency measures**.
- **🔍 Data Exploration**: Analyzed player roles, match results, and team dynamics to uncover patterns and trends.
- **📅 Time-Based Analysis**: Tracked player and team performance over time using cumulative and running totals.

---

## 📊 Key Insights

### **Player Performance**
- Identified the **player with the best batting average** across all matches.
- Determined the **most consistent player** based on the smallest standard deviation of runs scored.
- Ranked players by their **average impact score** (runs, wickets, catches, stumpings, and run-outs).
- Found players who **outperformed their teammates** in more than half of their matches.

### **Team Performance**
- Calculated the **team with the highest win percentage** across all locations.
- Identified the **team with the most diverse player roles** in their squad.
- Determined the **total runs scored by each team** across all matches.

### **Match Analysis**
- Found matches with the **closest margin of victory** based on runs scored.
- Identified matches where the **combined total of runs, wickets, and catches exceeded 500**.
- Ranked the **top 5 matches** with the highest individual scores by any player.
- Listed matches where the **winning team took more than 2 wickets**.

### **Advanced Metrics**
- Calculated the **impact score** for each player, considering runs, wickets, catches, stumpings, and run-outs.
- Tracked the **running cumulative impact score** for players across all matches.
- Identified bowlers who have taken **at least 5 wickets** across all matches.

---

## 🛠️ Tools and Technologies
- **SQL**: For querying and analyzing cricket match data.
- **Relational Database**: Used to store and manage cricket data (e.g., MySQL, PostgreSQL).
- **Data Cleaning**: Prepared and transformed raw data for analysis.
- **Advanced SQL Functions**: Utilized **window functions**, **aggregations**, **joins**, and **subqueries** for complex analysis.

---

## 🔑 Key Takeaways
- Demonstrated **advanced SQL skills** by solving 21 complex analytical problems.
- Provided actionable insights into **player performance**, **team dynamics**, and **match outcomes**.
- Highlighted the ability to work with **large datasets** and derive meaningful insights using SQL.
- Showcased problem-solving skills by addressing real-world cricket analytics challenges.

---

## 🛠️ How to Use
1. Clone the repository and set up the database using the provided schema or below the schema ⬇️⬇️⬇️⬇️⬇️⬇️ is and then perform the case study problem solving.
2. 📂 Database Schema
   Players Table
| `PlayerID` | `PlayerName`   | `TeamName`  | `Role`         | `DebutYear` |
|------------|----------------|-------------|----------------|-------------|
| 1          | Virat Kohli    | India       | Batsman        | 2008        |
| 2          | Steve Smith    | Australia   | Batsman        | 2010        |
| 3          | Mitchell Starc | Australia   | Bowler         | 2010        |
| 4          | MS Dhoni       | India       | Wicket-Keeper  | 2004        |
| 5          | Ben Stokes     | England     | All-Rounder    | 2011        |
Matches Table
| `MatchID` | `MatchDate`  | `Location` | `Team1`    | `Team2`      | `Winner`  |
|-----------|--------------|------------|------------|--------------|-----------|
| 1         | 2023-03-01   | Mumbai     | India      | Australia    | India     |
| 2         | 2023-03-05   | Sydney     | Australia  | England      | England   |
Performance Table
| `MatchID` | `PlayerID` | `RunsScored` | `WicketsTaken` | `Catches` | `Stumpings` | `NotOut` | `RunOuts` |
|-----------|------------|--------------|----------------|-----------|-------------|----------|-----------|
| 1         | 1          | 82           | 0              | 1         | 0           | FALSE    | 0         |
| 1         | 4          | 5            | 0              | 0         | 1           | TRUE     | 0         |
| 2         | 3          | 15           | 4              | 0         | 0           | FALSE    | 0         |

Teams Table

| `TeamName`  | `Coach`          | `Captain`      |
|-------------|------------------|----------------|
| India       | Rahul Dravid     | Rohit Sharma   |
| Australia   | Andrew McDonald  | Pat Cummins    |

Players Table Schema
| Column Name   | Data Type     | Description                              |
|---------------|---------------|------------------------------------------|
| `PlayerID`    | `INT`         | Primary key, unique ID for each player.  |
| `PlayerName`  | `VARCHAR(100)`| Name of the player.                      |
| `TeamName`    | `VARCHAR(100)`| Team the player belongs to.              |
| `Role`        | `VARCHAR(50)` | Role of the player (e.g., Batsman, Bowler, All-Rounder, Wicket-Keeper). |
| `DebutYear`   | `INT`         | Year the player made their debut.        |

Matches Table Schema
| Column Name   | Data Type     | Description                              |
|---------------|---------------|------------------------------------------|
| `MatchID`     | `INT`         | Primary key, unique ID for each match.   |
| `MatchDate`   | `DATE`        | Date of the match.                       |
| `Location`    | `VARCHAR(100)`| Location where the match was played.     |
| `Team1`       | `VARCHAR(100)`| Name of the first team.                  |
| `Team2`       | `VARCHAR(100)`| Name of the second team.                 |
| `Winner`      | `VARCHAR(100)`| Name of the winning team.                |

Performance Table Schema
| Column Name     | Data Type     | Description                              |
|-----------------|---------------|------------------------------------------|
| `MatchID`       | `INT`         | Foreign key referencing `Matches(MatchID)`. |
| `PlayerID`      | `INT`         | Foreign key referencing `Players(PlayerID)`. |
| `RunsScored`    | `INT`         | Runs scored by the player in the match.  |
| `WicketsTaken`  | `INT`         | Wickets taken by the player in the match.|
| `Catches`       | `INT`         | Catches taken by the player in the match.|
| `Stumpings`     | `INT`         | Stumpings made by the player in the match.|
| `NotOut`        | `BOOLEAN`     | Whether the player was not out.          |
| `RunOuts`       | `INT`         | Run-outs made by the player in the match.|

Teams Table Schema
| Column Name   | Data Type     | Description                              |
|---------------|---------------|------------------------------------------|
| `TeamName`    | `VARCHAR(100)`| Primary key, name of the team.           |
| `Coach`       | `VARCHAR(100)`| Coach of the team.                       |
| `Captain`     | `VARCHAR(100)`| Captain of the team.                     |

4. Execute the SQL queries to reproduce the analysis.
5. Explore the results and insights generated by each query.
6. and if there is some issue persist download my cricket analysis .sql file➡️➡️➡️  and to see where you can feel lag because ![giphy](https://github.com/user-attachments/assets/35ae1bf7-301a-4210-927c-0c6b23bf738a)


   
---

## 🤝 Contributions
Feel free to fork this repository and contribute by adding new queries, improving existing ones, or enhancing the dataset. Please submit a **pull request** for any changes.



