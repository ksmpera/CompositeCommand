USE master
IF EXISTS(select * from sys.databases where name='UserSearch')
DROP DATABASE UserSearch

CREATE DATABASE UserSearch

USE [UserSearch]
GO

SET ANSI_NULLS ON
GO
--drop table [dbo].[UserAccount]
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
GO
SET ANSI_PADDING OFF
GO

INSERT INTO [User](UserName, Name, SurName, UserPassword, [E-Mail])
VALUES ('Tom@1', 'Tom', 'Skagen', 'skagen1', 'Tom@gmail.com');

INSERT INTO [UserAccount](Account, Balans, Currency, UserID)
VALUES ('23-24455948-443', '1000', 'Eur', '1');

INSERT INTO [UserAccount](Account, Balans, Currency, UserID)
VALUES ('43-24321228-554', '1000', 'Eur', '1');


CREATE PROCEDURE spAddUser
(@UserName VARCHAR(100), @Name VARCHAR(100), @SurName varchar (100), @UserPassword varchar(100), @EMail varchar (100))
AS
INSERT INTO [User](UserName, Name, SurName, UserPassword,[E-Mail]) 
VALUES(@UserName, @Name, @SurName, @UserPassword, @EMail)


CREATE PROCEDURE spAddAccount
(@Account VARCHAR(100), @Currency VARCHAR(5))
AS 
INSERT INTO UserAccount(Account, Currency, Balans, UserID) 
VALUES (@Account, @Currency, 0, (select MAX(UserID) from [User]))



CREATE PROCEDURE spSearch(
@UserName varchar (100)=null)
AS
BEGIN
SELECT UserID,UserName, Name, SurName, UserPassword, [E-Mail]
FROM [User]
WHERE (@UserName is null or UserName LIKE (@UserName +'%'))
ORDER BY UserID
END

drop PROC spAddUser
drop PROC spAddAccount
drop PROC spSearch