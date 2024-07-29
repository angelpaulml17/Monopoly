-- Name: Angel Paul
-- Student ID:11378273

-- Game Round 2
-- G5: Jane rolls a 5
update Player
SET CurrentLocation=CurrentLocation+5, GameRound=2
WHERE PlayerID=3;
