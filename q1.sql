-- Name: Angel Paul
-- Student ID:11378273



--This file includes all the triggers written to run all the games. Most of the triggers are based on the new location landed by the player.




--Trigger 1: This trigger checks if the player passes through go but not lands on it(separate trigger handles it to avoid multiple entries in the audit table). 
--If so add 200 pounds to their balance. An additional check is done if their previous position was not jail(for which 200 should not be added)
-- This is triggered during q8
CREATE TRIGGER PassesGo
AFTER UPDATE OF CurrentLocation ON Player 
WHEN OLD.CurrentLocation<9 and NEW.CurrentLocation >9 and NEW.CurrentLocation <>13 and new.CurrentLocation<>9
BEGIN
    UPDATE Player
    SET BankBalance = BankBalance + (Select ValueAdd from Bonus where BonusID=9)
    WHERE PlayerID = old.PlayerID;
	--update the new BankBalance in the audit table as well
	Update AuditTrail
	Set BankBalance= (select BankBalance from Player where PlayerID=old.PlayerID)
	where GameRound= (SELECT New.GameRound from Player where PlayerID=old.PlayerID) and PlayerID=(select old.PlayerID from Player where PlayerID=old.PlayerID);
END;


-- Trigger 2: This trigger checks if the new location landed on is GO, if so add 200 to their bankbalance.
-- Each time a player lands on a bonus it is updated in the Bonus ID column in Player table
-- This is triggered during q1 
CREATE TRIGGER landsOnGo
AFTER UPDATE OF CurrentLocation ON Player 
WHEN NEW.CurrentLocation =9 and NEW.CurrentLocation <>13
BEGIN
    UPDATE Player
    SET BankBalance = BankBalance + (Select ValueAdd from Bonus where BonusID=9), BonusID=9
    WHERE PlayerID = old.PlayerID;

    INSERT INTO AuditTrail (PlayerID, LocationLandedOn, BankBalance, GameRound)
    VALUES (old.PlayerID, NEW.CurrentLocation, (SELECT BankBalance from Player where PlayerID=old.PlayerID), (SELECT GameRound from Player where PlayerID=old.PlayerID));
END;


-- Trigger 3: This is triggered when the player lands on Chance 1, here the player has to pay every other player 50 pounds, due to which his balance reduces by 3 times the paid amount
-- Each time a player lands on a bonus it is updated in the Bonus ID column in Player table
-- This is triggered during q2 
CREATE TRIGGER landsOnChance1
AFTER UPDATE OF CurrentLocation ON Player 
WHEN NEW.CurrentLocation = 11 and NEW.CurrentLocation <>13
BEGIN
    UPDATE Player
    SET BankBalance = BankBalance + (Select ValueAdd from Bonus where BonusID=new.CurrentLocation)
    WHERE PlayerID <> old.PlayerID;
	UPDATE Player
    SET BankBalance = BankBalance - (3*(Select ValueAdd from Bonus where BonusID=new.CurrentLocation)), BonusID=new.CurrentLocation
    WHERE PlayerID = old.PlayerID;

    INSERT INTO AuditTrail (PlayerID, LocationLandedOn, BankBalance, GameRound)
    VALUES (old.PlayerID, NEW.CurrentLocation, (SELECT BankBalance from Player where PlayerID=old.PlayerID), (SELECT GameRound from Player where PlayerID=old.PlayerID));
END;



-- Trigger 4: This is triggered when the player lands on "GO TO JAIL" position. The player to straight away moved to "IN JAIL" posotion without passing GO.
-- This is triggered during q3 
CREATE TRIGGER GotoJail
AFTER UPDATE OF CurrentLocation ON Player 
WHEN NEW.CurrentLocation = 5 and old.CurrentLocation <>13
BEGIN
    UPDATE Player
    SET CurrentLocation= (Select LocationAdd from Bonus where BonusID=new.CurrentLocation), BonusID=5
    WHERE PlayerID = old.PlayerID;

    INSERT INTO AuditTrail (PlayerID, LocationLandedOn, BankBalance, GameRound)
    VALUES (old.PlayerID, (SELECT CurrentLocation from Player where PlayerID=old.PlayerID), (SELECT BankBalance from Player where PlayerID=old.PlayerID), (SELECT GameRound from Player where PlayerID=old.PlayerID));
END;



-- Trigger 5: This is triggered when player lands on any property on the board (that are not community chests, corners or chances)
-- There are several checks carried out in this, 
--		if the person owns the property he lands on(do nothing), 
--  	then lands on a property he does not own:
			-- Check if the property has an owner
				-- if not buy it
				-- if it has 
						-- Check if the owner has 2 or more buildings of same colour, then pay double
						-- else, pay rent to the owner (this trigger just deducts the amount from the Player-separate trigger updates the paid rent to the owner to reduce repetition of code)
-- This is triggered during q4, q5 , q7 
CREATE TRIGGER landsOnProperty
AFTER UPDATE OF CurrentLocation ON Player 
WHEN NEW.CurrentLocation in (2,4, 6,8,10,12,14,16) and old.CurrentLocation <>13
BEGIN
    UPDATE Player
    SET BankBalance =
        CASE
            WHEN NEW.CurrentLocation NOT IN (SELECT PropertyID FROM Property WHERE PropertyOwner = old.PlayerID) THEN -- not one of the properties the player owns
			CASE 
				when NEW.CurrentLocation in (SELECT PropertyID FROM Property WHERE PropertyOwner is NULL) -- if no one owns the property
				then
				BankBalance -(SELECT PurchaseCost FROM Property WHERE PropertyID = NEW.CurrentLocation) -- buy it
				ELSE(
						CASE WHEN	NEW.CurrentLocation in (SELECT p.PropertyID                         -- else check if the owner has 2 or more properties of same colour
									FROM Property p	
									WHERE p.PropertyOwner <> old.PlayerID
									  AND p.Colour IN (
										SELECT p2.Colour
										FROM Property p2
										WHERE p2.PropertyOwner <> old.PlayerID
										GROUP BY p2.Colour
										HAVING COUNT(p2.PropertyID) >= 2
									  )) THEN
								BankBalance - 2*(SELECT PurchaseCost FROM Property WHERE PropertyID = NEW.CurrentLocation) -- pay double
							ELSE
								BankBalance -(SELECT PurchaseCost FROM Property WHERE PropertyID = NEW.CurrentLocation) --else just pay rent
							END	
				)
			END
			ELSE
			BankBalance+0
		END
		
	where PlayerID=old.PlayerID;

    INSERT INTO AuditTrail (PlayerID, LocationLandedOn, BankBalance, GameRound)
    VALUES (old.PlayerID, (SELECT CurrentLocation from Player where PlayerID=old.PlayerID), (SELECT BankBalance from Player where PlayerID=old.PlayerID), (SELECT GameRound from Player where PlayerID=old.PlayerID));
END;



-- Trigger 6: This is triggered only when the BankBalance gets changed after a person buys a property 
-- it updates the owner column in the Property table
-- This is triggered during q4 
CREATE TRIGGER updatePropertyOwner
AFTER UPDATE OF BankBalance ON Player 
WHEN NEW.CurrentLocation in (6,10,16)
BEGIN
    
        UPDATE Property
        SET PropertyOwner = old.PlayerID
        WHERE PropertyOwner is NULL and PropertyID=new.CurrentLocation;

END;



-- Trigger 7: Gets triggered after the person lands on a property owned by someone else, his rent amount gets deducted in the trigger 5. The owner balance is updated here
-- It is updated by add the difference between the previous and current balance of the player who payed the rent 
-- This is triggered during q5, q7 
CREATE TRIGGER updatePropertyOwnerBalance
AFTER UPDATE OF BankBalance ON Player 
WHEN NEW.CurrentLocation in (2,8,10,14)
BEGIN
    
        UPDATE Player
        SET BankBalance = BankBalance+((SELECT old.BankBalance from Player where PlayerID=old.PlayerID)-(SELECT new.BankBalance from Player where PlayerID=old.PlayerID))
        WHERE PlayerID=(SELECT PropertyOwner from Property WHERE PropertyID=new.CurrentLocation) ;
END;



-- Trigger 8: This gets triggered when a player lands on a Community chest, the amount mentioned in the bonus tables is added/ subtracted based on the signs 
-- This is triggered during q6 when Norman lands on Community Chest1 
Create TRIGGER LandsOnChest
AFTER UPDATE OF CurrentLocation ON Player 
WHEN NEW.CurrentLocation in(7, 15) and NEW.CurrentLocation <>13
BEGIN
    UPDATE Player
    SET BankBalance=BankBalance+(SELECT ValueAdd from Bonus WHERE BonusID=new.CurrentLocation), BonusID=new.CurrentLocation
    WHERE PlayerID = old.PlayerID;

    INSERT INTO AuditTrail (PlayerID, LocationLandedOn, BankBalance, GameRound)
    VALUES (old.PlayerID, (SELECT CurrentLocation from Player where PlayerID=old.PlayerID), (SELECT BankBalance from Player where PlayerID=old.PlayerID), (SELECT GameRound from Player where PlayerID=old.PlayerID));
END;



-- Trigger 9: This gets triggered if the previous position of the player was jail, and if the player rolled a 6 then these 6 positions must be subtracted from the new position 
-- as the first 6 is needed for the person to come out of the jail and the second roll is used to move the played by those many positions
-- This is triggered during q7  
CREATE TRIGGER Rolls6
AFTER UPDATE OF CurrentLocation ON Player 
WHEN OLD.CurrentLocation = 13 
BEGIN
    UPDATE Player
    SET CurrentLocation=CurrentLocation-6
    WHERE PlayerID = old.PlayerID;
END;


-- Trigger 10: This is triggered when player lands on parking. 
-- This is not triggered
CREATE TRIGGER GotoParking
AFTER UPDATE OF CurrentLocation ON Player 
WHEN NEW.CurrentLocation = 1 and NEW.CurrentLocation <>13
BEGIN
    UPDATE Player
    SET BankBalance=BankBalance+ (SELECT ValueAdd from Bonus WHERE BonusID=new.CurrentLocation), BonusID=New.CurrentLocation
    WHERE PlayerID = old.PlayerID;

    INSERT INTO AuditTrail (PlayerID, LocationLandedOn, BankBalance, GameRound)
    VALUES (old.PlayerID, (SELECT CurrentLocation from Player where PlayerID=old.PlayerID), (SELECT BankBalance from Player where PlayerID=old.PlayerID), (SELECT GameRound from Player where PlayerID=old.PlayerID));
END;


-- Trigger 11: This is triggered when player lands on Chance 2, the player should be moved ahead by those many positions as mentioned in the bonus description
-- This is not triggered
CREATE TRIGGER landsOnChance2
AFTER UPDATE OF CurrentLocation ON Player 
WHEN NEW.CurrentLocation = 3 and old.CurrentLocation <>13
BEGIN
    UPDATE Player
    SET CurrentLocation=CurrentLocation+(SELECT LocationAdd from Bonus WHERE BonusID=new.CurrentLocation), BonusID=3
    WHERE PlayerID = old.PlayerID;

    INSERT INTO AuditTrail (PlayerID, LocationLandedOn, BankBalance, GameRound)
    VALUES (old.PlayerID, NEW.CurrentLocation, (SELECT BankBalance from Player where PlayerID=old.PlayerID), (SELECT GameRound from Player where PlayerID=old.PlayerID));
END;


-- Game Round 1
-- G1: Jane rolls a 3 
-- Game round is passed to update the audit TABLE  
UPDATE Player
SET CurrentLocation= CurrentLocation+3, GameRound=1
WHERE PlayerID= 3;


