USE master
IF EXISTS(select * from sys.databases where name='Command')
DROP DATABASE Command

CREATE DATABASE Command

USE [Command]
GO

/****** Object:  Table [dbo].[MacroCommands]    Script Date: 6/22/2017 11:32:30 AM ******/
SET ANSI_NULLS ON
GO

--drop table [dbo].[MacroCommands]

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
if not exists (select * from sysobjects where name='MacroCommands' and xtype='U')
CREATE TABLE [dbo].[MacroCommands](
	[MacroCommandID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[MacroCommandName] [varchar](100) NOT NULL,
	[ParentID] [int] NULL,
)

if not exists (select * from sysobjects where name='MicroCommands' and xtype='U')
CREATE TABLE [dbo].[MicroCommands](
	[MicroCommandID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	
	[MicroCommandName] [varchar](100) NOT NULL,
	[MicroCommandType] [varchar](100) NOT NULL,
	[MicroParameter1] [varchar](100)  NULL,
	[MicroParameter2] [varchar](100)  NULL,
	[MicroParameter3] [varchar](100)  NULL,
)
if not exists (select * from sysobjects where name='MacroMicro' and xtype='U')
CREATE TABLE [dbo].[MacroMicro](
	[MacroMicroID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[MacroCommandID] [int]  FOREIGN KEY REFERENCES MacroCommands(MacroCommandID) NOT NULL ,
	[MicroCommandID] [int]  FOREIGN KEY REFERENCES MicroCommands(MicroCommandID) NOT NULL ,
)

GO

SET ANSI_PADDING OFF
GO


