-- Name: Angel Paul
-- Student ID:11378273


-- Insert values into the Property table
INSERT INTO Property (PropertyID, PropertyName) VALUES (1, 'Free Parking');
INSERT INTO Property (PropertyID, PropertyName, PurchaseCost, Colour, PropertyOwner) VALUES (2, 'Oak House', 100, 'Orange', 4);
INSERT INTO Property (PropertyID, PropertyName) VALUES (3, 'Chance 2');
INSERT INTO Property (PropertyID,PropertyName, PurchaseCost, Colour, PropertyOwner) VALUES (4, 'Owens Park', 30, 'Orange', 4);
INSERT INTO Property (PropertyID, PropertyName) VALUES (5, 'Go to Jail');
INSERT INTO Property (PropertyID,PropertyName, PurchaseCost, Colour) VALUES (6,'AMBS', 400, 'Blue');
INSERT INTO Property (PropertyID, PropertyName) VALUES (7, 'Community Chest 2');
INSERT INTO Property (PropertyID,PropertyName, PurchaseCost, Colour, PropertyOwner) VALUES (8,'Co-Op', 30, 'Blue', 3);
INSERT INTO Property (PropertyID, PropertyName) VALUES (9, 'Go');
INSERT INTO Property (PropertyID,PropertyName, PurchaseCost, Colour) VALUES (10, 'Kilburn', 120, 'Yellow');
INSERT INTO Property (PropertyID, PropertyName) VALUES (11, 'Chance 1');
INSERT INTO Property (PropertyID,PropertyName, PurchaseCost, Colour, PropertyOwner) VALUES (12,'Uni Place', 100, 'Yellow', 1);
INSERT INTO Property (PropertyID, PropertyName) VALUES (13, 'In Jail');
INSERT INTO Property (PropertyID,PropertyName, PurchaseCost, Colour, PropertyOwner) VALUES (14, 'Victoria', 75, 'Green', 2);
INSERT INTO Property (PropertyID, PropertyName) VALUES (15, 'Community Chest 1');
INSERT INTO Property (PropertyID,PropertyName, PurchaseCost, Colour) VALUES (16,'Piccadilly', 35, 'Green');

-- Insert values into the Player table
INSERT INTO Player (Name, ChosenToken, CurrentLocation, BankBalance) VALUES ('Mary', 'Battleship', 1, 190);
INSERT INTO Player (Name, ChosenToken, CurrentLocation, BankBalance) VALUES ('Bill', 'Dog', 4, 500);
INSERT INTO Player (Name, ChosenToken, CurrentLocation, BankBalance) VALUES ('Jane', 'Car', 6, 150);
INSERT INTO Player (Name, ChosenToken, CurrentLocation, BankBalance) VALUES ('Norman', 'Thimble', 10, 250);


-- Insert values into the Bonus table
INSERT INTO Bonus (BonusID, BonusName, Description, LocationAdd, ValueAdd) VALUES ( 11, 'Chance 1', 'Pay each of the other players Â£50', 0, 50);
INSERT INTO Bonus (BonusID,BonusName, Description,  LocationAdd, ValueAdd) VALUES ( 3, 'Chance 2', 'Move forward 3 spaces', 3, 0);
INSERT INTO Bonus (BonusID,BonusName, Description,  LocationAdd, ValueAdd) VALUES (15, 'Community Chest 1', 'For winning a Beauty Contest, you win Â£100', 0,100);
INSERT INTO Bonus (BonusID,BonusName, Description,  LocationAdd, ValueAdd) VALUES (7, 'Community Chest 2', 'Your library books are overdue. Pay a fine of Â£30', 0,-30);
INSERT INTO Bonus (BonusID,BonusName, Description,  LocationAdd, ValueAdd) VALUES (1, 'Free Parking', 'No action',0,0 );
INSERT INTO Bonus (BonusID,BonusName, Description,  LocationAdd, ValueAdd) VALUES (5, 'Go to Jail', 'Go to Jail, do not pass GO, do not collect Â£200', 13,0);
INSERT INTO Bonus (BonusID,BonusName, Description,  LocationAdd, ValueAdd) VALUES (9, 'GO', 'Collect Â£200', 0, 200);
