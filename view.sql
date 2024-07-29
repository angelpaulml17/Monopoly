-- Name: Angel Paul
-- Student ID:11378273


-- create a view that Joins the property and Player tables to get the leaderboard.
-- This displays the players in the descending order of their bank balance
CREATE VIEW gameView AS
SELECT
    P.Name AS PlayerName,
    Location.PropertyName AS PositionOnBoard,
    P.BankBalance,
    GROUP_CONCAT(Prop.PropertyName, ', ') AS PropertiesOwned,
	P.GameRound
    
FROM
    Player AS P
INNER JOIN
    Property AS Prop ON P.PlayerID = Prop.PropertyOwner 
INNER JOIN
    Property AS Location ON P.CurrentLocation = Location.PropertyID

GROUP BY
    P.PlayerID
	ORDER by P.BankBalance DESC;

