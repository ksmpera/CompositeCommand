USE [Betting]
GO

/****** Object:  Table [dbo].[UserAccount]    Script Date: 7/14/2017 3:29:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[UserAccount](
	[AccountID] [int] IDENTITY(1,1) NOT NULL,
	[Account] [varchar](100) NOT NULL,
	[Balans] [int] NULL,
	[Currency] [varchar](5) NOT NULL,
	[UserID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[UserAccount]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO



SELECT Balans
FROM UserAccount
WHERE UserID IN  
(SELECT UserID 
FROM [User] 
WHERE UserName = 'Moka') 
ORDER BY UserID

UPDATE UserAccount
SET Balans = '35'
WHERE UserID = 14;

UPDATE UserAccount
SET Balans = '20' + Balans
WHERE UserID IN  
(SELECT UserID 
FROM [User] 
WHERE UserName = 'Moka');

Select SportEventID, EventName, Start, [End], Stake1, Stake2, Stake0, Active, BetID
from SportEvent
ORDER BY SportEventID
END

UPDATE SportEvent
SET [Start] = '2017-08-01 13:00'
WHERE EventName = 'Aresenal-Liverpool'

INSERT INTO [EventBet]
(EventID, Stake)
VALUES (1, '1.45');

INSERT INTO UserLoged(UserID) 
SELECT  UserID
from [User]
WHERE UserName = 'Moka'

DELETE FROM UserLoged
WHERE UserID = 37;

SELECT [User].UserName,
UserAccount.Balans
From [USER]
CROSS JOIN UserAccount
WHERE([UserAccount].UserID = 12 AND [User].UserID = 12)


Select UserID From [User] WHERE UserName = 'Moka'

UPDATE [User]
SET UserName = 'Coka'
WHERE UserID = 2;

INSERT INTO [Bet](EventID, Stake, UserID)
VALUES (2, '1.45',
(Select UserID From [User] WHERE UserName = 'Coka'))



SELECT 
C.UserID, C.EventID, C.Stake, L.EventName, S.UserName
FROM
    [Bet] AS C
    INNER JOIN [SportEvent] AS L
    ON C.EventID = L.EventID 
    INNER JOIN  [User] AS S
    ON S.UserName = 'Moka' AND (C.UserID = S.UserID)
WHERE (C.Ammount IS NULL)



Select Sum Stake
From Bet
Where
(Select UserID 
From [User] 
Where UserName = 'Moka')


UPDATE UserAccount
SET Balans = Balans - '10'
WHERE UserID IN  
(SELECT UserID 
FROM [User] 
WHERE UserName = 'Moka');



UPDATE Bet
SET Ammount = '108.4', TotalStake = '10.84'
WHERE UserID IN  
(SELECT UserID 
FROM [User] 
WHERE UserName = 'Moka') AND (Ammount IS NULL OR TotalStake IS NULL);



SELECT 
C.UserID, S.UserName, L.EventName,L.Active, C.Stake, C.TotalStake, C.Ammount, L.Final , C.Win
FROM
    [Bet] AS C
    INNER JOIN [SportEvent] AS L
    ON C.EventID = L.EventID 
    INNER JOIN  [User] AS S
    ON (S.UserName = 'Moka') AND (C.UserID = '1')



UPDATE SportEvent 
SET Final ='3:2', Active = 'False'
WHERE EventID  < '10000'

UPDATE Bet 
SET Win ='true'
WHERE EventID  < '10000'


SELECT 
C.OddsNumber, C.Stake
FROM
    [Bet] AS C
    INNER JOIN [SportEvent] AS L
    ON C.EventID = L.EventID 
    INNER JOIN  [User] AS S
    ON (S.UserName = 'Moka') AND (C.UserID = S.UserID)


Select EventID, EventName, Start, [End], Stake1, Stake0, Stake2, Active, Final
from SportEvent
WHERE Active = 1
ORDER BY EventID


select count(*) from SportEvent Where Active = 1

SELECT 
C.OddsNumber
FROM
    [Bet] AS C
    INNER JOIN [SportEvent] AS L
    ON C.EventID = L.EventID 
    INNER JOIN  [User] AS S
    ON (S.UserName = 'Moka') AND (C.UserID = S.UserID)

UPDATE SportEvent 
SET Final = ' ', Active = 'True'
WHERE EventID  < '10000' AND Active ='False'



UPDATE SportEvent 
SET Final = '2:2', Active = 'False'
WHERE EventID  < '10000' AND Active ='False'


UPDATE SportEvent 
SET Final = '2:2', Active = 'False'
WHERE EventID  < '10000' AND Active ='False'

UPDATE SportEvent 
SET Final = ' ', Active = 'True'
WHERE EventID  < '10000' AND Active ='False'

UPDATE Bet
SET Win = 'False'
WHERE EventID  = 2 And OddsNumber = 1


UPDATE Bet
SET Win = null
WHERE EventID  >0  And OddsNumber >=0

select count(*) from SportEvent Where Active = 1


SELECT UserID,UserName, Name, SurName, UserPassword, [E-Mail]
FROM [User]
WHERE ('' is null or UserName LIKE '%' + '' +'%')
ORDER BY UserID