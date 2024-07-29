-- Name: Angel Paul
-- Student ID:11378273


-- G8: Bill rolls a 6, and then a 3
UPDATE Player
Set CurrentLocation=(CurrentLocation+9)%16, GameRound=2
where PlayerID=2;
