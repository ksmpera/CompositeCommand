USE master
IF EXISTS(select * from sys.databases where name='Academy')
DROP DATABASE Academy

CREATE DATABASE Academy

USE [Academy]
GO

/****** Object:  Table [dbo].[MacroCommands]    Script Date: 6/22/2017 11:32:30 AM ******/
SET ANSI_NULLS ON
GO

--drop table [dbo].[Student]

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
if not exists (select * from sysobjects where name='Teacher' and xtype='U')
CREATE TABLE [dbo].[Teacher](
	[TeacherID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[TeacherName] [varchar](100),
	[TeacherSurname] [varchar](100),
	[TeacherDateofBirth] [date],
	[TeacherTitle]  [varchar](100),	
)

if not exists (select * from sysobjects where name='Subjects' and xtype='U')
CREATE TABLE [dbo].[Subjects](
	[SubjectID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	
	[SubjectName] [varchar](100) NOT NULL,
	[AtYear] [int] NOT NULL,		
)
if not exists (select * from sysobjects where name='Student' and xtype='U')
CREATE TABLE [dbo].[Student](
	[StudentID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[StudentName] [varchar](100) NOT NULL,
	[StudentrSurname] [varchar](100) NOT NULL,
	[StudentDateofBirth] [date] NOT NULL,   
)

if not exists (select * from sysobjects where name='Lecture' and xtype='U')
CREATE TABLE [dbo].[Lecture](
	[SubjectID]  [int] REFERENCES Subjects(SubjectID) NOT NULL,
	[TeacherID] [int] REFERENCES Teacher(TeacherID) NOT NULL,
	[Year] [int] NOT NULL,
	[Semester] [varchar](100) NOT NULL,
	PRIMARY KEY (SubjectID, TeacherID)
)
if not exists (select * from sysobjects where name='Listen' and xtype='U')
CREATE TABLE [dbo].[Listen](
	[SubjectID]  [int] NOT NULL,
	[TeacherID] [int] NOT NULL,
	[StudentID]  [int] REFERENCES Student(StudentID) NOT NULL,
	[Signature] [bit],
	[Dateofsignature] [date],
	PRIMARY KEY (SubjectID, TeacherID, StudentID)
)

ALTER TABLE [Listen] ADD 
    CONSTRAINT FK_Listen_Lecture
    FOREIGN KEY ([SubjectID], [TeacherID]) 
    REFERENCES Lecture ([SubjectID], [TeacherID])

if not exists (select * from sysobjects where name='Exam' and xtype='U')
CREATE TABLE [dbo].[Exam](
    [ExamID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[SubjectID]  [int] NOT NULL,
	[TeacherID] [int] NOT NULL,
	[StudentID]  [int] REFERENCES Student(StudentID) NOT NULL,
	[Mark] [int],
	[MarkDate] [date],
	[NumberOfExams] [int],
)
ALTER TABLE [Exam] ADD 
    CONSTRAINT FK_Exam_Lecture
    FOREIGN KEY ([SubjectID], [TeacherID]) 
    REFERENCES Lecture ([SubjectID], [TeacherID])

GO

SET ANSI_PADDING OFF
GO


INSERT INTO Student(StudentName, StudentrSurname, StudentDateofBirth)
VALUES ('Tom', 'Skagen', '2000-04-12');
INSERT INTO Student(StudentName, StudentrSurname, StudentDateofBirth)
VALUES ('Marko', 'Skagen', '2001-04-12');

INSERT INTO Teacher(TeacherName, TeacherSurname, TeacherDateofBirth,TeacherTitle )
VALUES ('Tom', 'Skagen', '1970-04-12', 'professor');
INSERT INTO Teacher(TeacherName, TeacherSurname, TeacherDateofBirth,TeacherTitle )
VALUES ('Marko', 'Skagen', '1971-04-12', 'professor');
INSERT INTO Teacher(TeacherName, TeacherSurname, TeacherDateofBirth,TeacherTitle )
VALUES ('Marko', 'Kekic', '1984-04-12', 'professor');
INSERT INTO Teacher(TeacherName, TeacherSurname, TeacherDateofBirth,TeacherTitle )
VALUES ('Kalina', 'Ivanovic', '2012-11-20', 'professor');
INSERT INTO Teacher(TeacherName, TeacherSurname, TeacherDateofBirth,TeacherTitle )
VALUES ('Kalina', 'Ivanovic', '1980-11-20', 'professor');
INSERT INTO Teacher(TeacherName, TeacherSurname, TeacherDateofBirth,TeacherTitle )
VALUES ('Tom', 'Skagen', '1990-04-12', 'Teacher');
INSERT INTO Teacher(TeacherName, TeacherSurname, TeacherDateofBirth,TeacherTitle )
VALUES ('Marko', 'Skagen', '1991-04-12', 'Teacher');
INSERT INTO Teacher(TeacherName, TeacherSurname, TeacherDateofBirth,TeacherTitle )
VALUES ('Tom', 'Mildfen', '1990-04-12', 'Teacher');
INSERT INTO Teacher(TeacherName, TeacherSurname, TeacherDateofBirth,TeacherTitle )
VALUES ('Marko', 'Markovic', '1991-04-12', 'Teacher');
INSERT INTO Teacher(TeacherName, TeacherSurname, TeacherDateofBirth,TeacherTitle )
VALUES ('Nikola', 'Nikolic', '1961-07-24', 'Teacher');



CREATE PROC spSearchTeacher(
@TeacherName varchar (100)=null, 
@TeacherSurname varchar(100)=null, 
@TeacherDateofBirth varchar(100) = null, 
@TeacherTitle varchar(100)=null)
AS
BEGIN
Select TeacherID, TeacherName, TeacherSurname, TeacherDateofBirth, TeacherTitle  
from Teacher
WHERE (@TeacherName is null or TeacherName LIKE '%' + @TeacherName +'%') AND
(@TeacherSurname is null or TeacherSurname LIKE '%' + @TeacherSurname + '%') AND
--(@TeacherDateofBirth is null or TeacherDateofBirth = @TeacherDateofBirth) AND
(@TeacherTitle is null or TeacherTitle LIKE '%' + @TeacherTitle + '%')
ORDER BY TeacherID
END

drop PROC spSearchTeacher