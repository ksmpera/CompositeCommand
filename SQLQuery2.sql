USE [Lift]
GO

/****** Object:  Table [dbo].[Button]    Script Date: 6/22/2017 11:17:55 AM ******/
SET ANSI_NULLS ON
GO

/*drop table [dbo].[Lift]*/

SET QUOTED_IDENTIFIER ON
GO

if not exists (select * from sysobjects where name='Lift' and xtype='U')
CREATE TABLE [dbo].[Lift](
	[LiftID] [int] IDENTITY(1,1) NOT NULL,
	[MAX_POSITION] [int] NOT NULL,
	[MIN_POSITION] [int] NOT NULL,
	[numFloors] [int] NOT NULL,
	[SINGLE_STEP] [int] NOT NULL,
 CONSTRAINT [PK_Lift] PRIMARY KEY CLUSTERED 
(
	[LiftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/*drop table [dbo].[Button]*/

SET QUOTED_IDENTIFIER ON
GO

if not exists (select * from sysobjects where name='Button' and xtype='U')
CREATE TABLE [dbo].[Button](
	[ButtonID] [int] NOT NULL,
	[button type] [bit] NOT NULL,
	[button state] [bit] NOT NULL,
	[button floor] [int] NOT NULL,
	[LiftID] [int]  FOREIGN KEY REFERENCES Lift(LiftID),
 CONSTRAINT [PK_Button] PRIMARY KEY CLUSTERED 
(
	[ButtonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/*insert into [dbo].[Lift] ([MAX_POSITION], [MIN_POSITION], [numFloors], [SINGLE_STEP]) value(5, 0, 6, 1);*/
