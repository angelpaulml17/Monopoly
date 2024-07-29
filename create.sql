-- Name: Angel Paul
-- Student ID:11378273

-- Create the Property table
CREATE TABLE Property (
	PropertyID INTEGER NOT NULL PRIMARY KEY,
    PropertyName TEXT NOT NULL, 	
    PurchaseCost REAL,
	Colour TEXT,
	PropertyOwner INTEGER
);


-- Create the Bonus table
-- This table has details of what should be changed when a player lands on a bonus. I have separated the description to location add( if the player has to move few positions ahead)
-- and  Value add if the player has to pay some amount or gets some amount
CREATE TABLE Bonus (
    BonusID INTEGER NOT NULL PRIMARY KEY,
    BonusName TEXT NOT NULL,
    Description TEXT,
	LocationAdd INTEGER,
	ValueAdd INTEGER,
	FOREIGN KEY (BonusID) REFERENCES Property(PropertyID)
);

-- Create the Player table
-- there is an extra column Bonus ID to keep track of what is the latest bonus the player landed on
CREATE TABLE Player (
    PlayerID INTEGER NOT NULL PRIMARY KEY,
    Name TEXT NOT NULL,
    ChosenToken TEXT NOT NULL,
    BankBalance REAL,
    CurrentLocation INTEGER NOT NULL,
    BonusID INTEGER,
    GameRound INTEGER DEFAULT 0,
    FOREIGN KEY (CurrentLocation) REFERENCES Property(PropertyID),
    FOREIGN KEY (BonusID) REFERENCES Bonus(BonusID)
);

-- Create the AuditTrail table
CREATE TABLE AuditTrail (
    PlayerID INTEGER NOT NULL,
    LocationLandedOn INTEGER NOT NULL,
    BankBalance REAL,
    GameRound INTEGER,
	PRIMARY KEY (PlayerID, LocationLandedOn),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    FOREIGN KEY (LocationLandedOn) REFERENCES Property(PropertyID)
);


