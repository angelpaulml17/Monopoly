-- Name: Angel Paul
-- Student ID:11378273

-- G7: Mary rolls a 6, and then a 5
UPDATE Player
SET CurrentLocation= (CurrentLocation+11)% 16, GameRound=2
WHERE PlayerID= 1;
