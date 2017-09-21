USE master
IF EXISTS(select * from sys.databases where name='Betting')
DROP DATABASE Betting

CREATE DATABASE Betting

USE [Betting]
GO

SET ANSI_NULLS ON
GO
--drop table [dbo].[UserName]
SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
if not exists (select * from sysobjects where name='User' and xtype='U')
CREATE TABLE [dbo].[User](
	[UserID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[SurName] [varchar](100) NOT NULL,	
	[UserPassword] [varchar](100) NOT NULL,
	[E-Mail] [varchar](100) NOT NULL,
)
if not exists (select * from sysobjects where name='UserAccount' and xtype='U')
CREATE TABLE [dbo].[UserAccount](
	[AccountID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	
	[Account] [varchar](100) NOT NULL,
	[Balans] [int] NULL,
	[Currency] [varchar](5)  NOT NULL,
	[UserID] [int] REFERENCES [User](UserID) NOT NULL,
)
if not exists (select * from sysobjects where name='Bet' and xtype='U')
CREATE TABLE [dbo].[Bet](	
    [BetID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Ammount] [decimal] (18,2) NULL,
	[Stake] [decimal] (18,2),
	[TotalStake] [decimal] (18,2),
	[OddsNumber][int] NOT NULL,
	[UserID] [int] REFERENCES [User](UserID) NOT NULL,
	[EventID] [int] REFERENCES [SportEvent](EventID) NOT NULL,
	[Win] [bit] NULL,
	)

CREATE TABLE [dbo].[SportEvent](
	[EventID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	
	[EventName] [varchar](100) NOT NULL,
	[Start] [datetime] NOT NULL,
	[End] [datetime] NOT NULL,
	[Stake1] [decimal] (18,2) NOT NULL,
	[Stake2] [decimal] (18,2) NOT NULL,
	[Stake0] [decimal] (18,2) NOT NULL,
	[Active] [bit] NOT NULL,
	[Final] [varchar](10) NULL,
	--[BetID] [int] Null REFERENCES Bet(BetID),
	)
--ALTER TABLE [Bet] ADD 
--CONSTRAINT FK_BetEvent
--FOREIGN KEY ([EventID], [BetID]) 
--REFERENCES BetEvent([EventID], [BetID])

CREATE TABLE[dbo].[EventBet](	
	[BetID] [int] REFERENCES Bet(BetID) NOT NULL,	
	[EventID] [int] REFERENCES SportEvent(EventID) NOT NULL,
	PRIMARY KEY (BetID, EventID)
	)
CREATE TABLE [dbo].[UserLoged](
	[UserLogedID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[UserID] [int] REFERENCES [User](UserID) NOT NULL,
)
--ALTER TABLE [BetEvent] ADD 
    --CONSTRAINT FK_BetEvent_Betting
    --FOREIGN KEY ([EventID], [BetID]) 
    --REFERENCES BetEvent([EventID], [BetID])
GO

SET ANSI_PADDING OFF
GO



INSERT INTO [User](UserName, Name, SurName, UserPassword, [E-Mail])
VALUES ('Tom@1', 'Tom', 'Skagen', 'skagenBet1', 'Tom@gmail.com');

INSERT INTO [SportEvent](EventName, [Start], [End], Stake1, Stake2, Stake0, [Active])
VALUES ('Aresenal-Liverpool',  '2017-08-01 13:00', '2017-08-01 15:00', '1.45', '2.02', '4.02', 'true');

INSERT INTO [SportEvent](EventName, [Start], [End], Stake1, Stake2, Stake0, [Active])
VALUES ('Hall-Liverpool',  '2017-08-01 15:00', '2017-08-01 15:00', '5.55', '4.32', '2.11', 'true');

INSERT INTO [SportEvent](EventName, [Start], [End], Stake1, Stake2, Stake0, [Active])
VALUES ('Watford-Chelsea',  '2017-07-28 18:00', '2017-07-28 20:00', '3.45', '3.02', '1.52', 'true');

INSERT INTO [SportEvent](EventName, [Start], [End], Stake1, Stake2, Stake0, [Active])
VALUES ('Liverpool-Real Madrid',  '2017-08-11 18:00', '2017-08-11 20:00', '2.45', '5.02', '2.00', 'true');

INSERT INTO [SportEvent](EventName, [Start], [End], Stake1, Stake2, Stake0, [Active])
VALUES ('Manchester United-Manchester City',  '2017-08-21 15:00', '2017-08-21 15:00', '1.55', '5.32', '7.52', 'true');

INSERT INTO [SportEvent](EventName, [Start], [End], Stake1, Stake2, Stake0, [Active])
VALUES ('Watford-Manchester City',  '2017-07-20 18:00', '2017-07-20 20:00', '2.45', '4.02', '1.51', 'true');

INSERT INTO [SportEvent](EventName, [Start], [End], Stake1, Stake2, Stake0, [Active])
VALUES ('Manchester United-Lester',  '2017-08-21 15:00', '2017-08-21 15:00', '1.50', '6.32', '9.52', 'true');

INSERT INTO [SportEvent](EventName, [Start], [End], Stake1, Stake2, Stake0, [Active])
VALUES ('Barcelona-Atletico Madrid',  '2017-08-21 15:00', '2017-08-21 15:00', '1.20', '6.49', '8.34', 'true');




CREATE PROCEDURE User_add
(@UserName VARCHAR(100), @Name VARCHAR(100), @SurName varchar (100), @UserPassword varchar(100), @EMail varchar (100))
AS
INSERT INTO [User](UserName, Name, SurName, UserPassword,[E-Mail]) 
VALUES(@UserName, @Name, @SurName, @UserPassword, @EMail)


CREATE PROCEDURE Account_add1
(@Account VARCHAR(100), @Currency VARCHAR(5))
AS 
INSERT INTO UserAccount(Account, Currency, Balans, UserID) 
VALUES (@Account, @Currency, 0, (select MAX(UserID) from [User]))


Create Procedure UserNamePasswordCorrect
(
  @UserName varchar(100), 
  @UserPassword varchar(100)
)
AS
BEGIN 
SET NOCOUNT ON;
DECLARE @Exists INT
IF EXISTS(SELECT UserName 
FROM [User]
WHERE UserName = @UserName AND UserPassword = @UserPassword)
BEGIN
SET @Exists = 1
END 
ELSE
BEGIN
SET @Exists = 0
END
RETURN @Exists
END

Create Procedure LogedUser
(@UserName varchar(100))
AS
INSERT INTO UserLoged(UserID) 
SELECT  UserID
from [User]
WHERE UserName = @UserName


Create Procedure  ReadBalans
(@UserName varchar(100))
AS
SELECT Balans
FROM UserAccount
WHERE UserID IN  
(SELECT UserID 
FROM [User] 
WHERE UserName = @UserName) 
ORDER BY UserID

Create Procedure  UpdateBalans
(
@UserName varchar(100),
@Balans int
)
AS
UPDATE UserAccount
SET Balans = @Balans + Balans 
WHERE UserID IN  
(SELECT UserID 
FROM [User] 
WHERE UserName = @UserName);


CREATE PROC spShowAllSportEvents
AS
BEGIN
Select EventID, EventName, Start, [End], Stake1, Stake0, Stake2, Active, Final
from SportEvent
ORDER BY EventID
END


Create Proc spGetUserById
(@UserID int)
AS
BEGIN
SELECT [User].UserName,
UserAccount.Balans
From [USER]
CROSS JOIN UserAccount
WHERE([UserAccount].UserID = 14 AND [User].UserID = 14)
END


CREATE PROC spADEventToBet
(@EventID varchar(100), @Stake [decimal](18,2),  @OddsNumber int, @UserName varchar(100))
AS
BEGIN
INSERT INTO [Bet](EventID, [Stake], OddsNumber, UserID)
VALUES (@EventID, @Stake, @OddsNumber,
(Select UserID From [User] WHERE UserName = @UserName))
END


CREATE PROC spUserLogOut
(@UserID int)
AS
BEGIN
DELETE FROM UserLoged
WHERE (UserID = @UserID);
END


CREATE PROC spCreateBetTicket
(@UserName varchar(100))
AS
BEGIN
SELECT 
 C.EventID, L.EventName, C.Stake, C.OddsNumber, C.UserID, S.UserName
FROM
    [Bet] AS C
    INNER JOIN [SportEvent] AS L
    ON C.EventID = L.EventID 
    INNER JOIN  [User] AS S
    ON (S.UserName = @UserName) AND (C.UserID = S.UserID)
	WHERE (C.Ammount IS NULL)
END


CREATE PROC spSavedBets
(@UserName varchar(100))
AS
BEGIN
SELECT 
C.UserID, S.UserName, L.EventID, L.EventName, C.OddsNumber, C.Stake, C.TotalStake, C.Ammount, L.Active, L.Final , C.Win
FROM
    [Bet] AS C
    INNER JOIN [SportEvent] AS L
    ON C.EventID = L.EventID 
    INNER JOIN  [User] AS S
    ON (S.UserName = @UserName) AND (C.UserID = S.UserID)
END


Create Procedure  spWithdrowfromBalans
(
@UserName varchar(100),
@Balans int
)
AS
BEGIN
UPDATE UserAccount
SET Balans = Balans - @Balans
WHERE UserID IN  
(SELECT UserID 
FROM [User] 
WHERE UserName = @UserName);
END


Create Procedure spSaveBetAmmountToDataBase
(
@UserName varchar(100),
@Ammount [decimal](18,2),
@TotalStake [decimal](18,2)
)
AS
BEGIN
UPDATE Bet
SET Ammount = @Ammount, TotalStake = @TotalStake
WHERE UserID IN  
(SELECT UserID 
FROM [User] 
WHERE UserName = @UserName) AND (Ammount IS NULL OR TotalStake IS NULL);
END


Create Procedure spRemove
(
@UserName varchar(100)
)
AS
BEGIN
DELETE FROM Bet
WHERE UserID IN  
(SELECT UserID 
FROM [User] 
WHERE UserName = @UserName) AND (Ammount IS NULL OR TotalStake IS NULL);
END

Create Procedure spEventResult
(
@Final varchar(10),
@EventID int
)
AS
BEGIN
UPDATE SportEvent 
SET Final = @Final, Active = 'False'
WHERE EventID = @EventID AND Active ='True'
END


Create Procedure spBetResult
(
@Final varchar(10),
@Winner int,
@EventID int
)
AS
BEGIN
UPDATE Bet
SET Win = 'True'
WHERE EventID  = @EventID And OddsNumber = @Winner
END




Create Procedure spGetBetForEvent
(
@UserName varchar(100)
)
AS 
BEGIN
SELECT 
C.OddsNumber
FROM
    [Bet] AS C
    INNER JOIN [SportEvent] AS L
    ON C.EventID = L.EventID 
    INNER JOIN  [User] AS S
    ON (S.UserName = @UserName) AND (C.UserID = S.UserID)
END


Create Procedure spNumberOfRow
AS 
BEGIN
select count(*) from SportEvent Where Active = 1
END



drop PROC User_add
drop PROC Account_add1
drop PROC UserNamePasswordCorrect
drop PROC LogedUser
drop PROC ReadBalans
drop PROC UpdateBalans
drop PROC spShowAllSportEvents
drop PROC spGetUserById
drop PROC spADEventToBet
drop PROC spUserLogOut
drop PROC spCreateBetTicket
drop PROC spWithdrowfromBalans
drop PROC spSaveBetAmmountToDataBase
drop PROC spSavedBets
drop PROC spRemove
--drop PROC spGetBetForEvent
drop PROC spEventResult
drop PROC spBetResult
drop PROC spNumberOfRow
--drop PROC spWinOrLost