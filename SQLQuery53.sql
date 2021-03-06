USE [Academy]
GO
/****** Object:  StoredProcedure [dbo].[spSearchTeacher]    Script Date: 7/7/2017 4:28:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[spSearchTeacher](
@TeacherName varchar (100)=null,
 @TeacherSurname varchar(100)=null, 
 @TeacherDateofBirth date=null, 
 @TeacherTitle varchar(100)=null)
AS
BEGIN

Select TeacherID, TeacherName, TeacherSurname, TeacherDateofBirth, TeacherTitle  
from Teacher
WHERE (@TeacherName is null or TeacherName LIKE '%' + @TeacherName +'%') AND
(@TeacherSurname is null or TeacherSurname LIKE '%' + @TeacherSurname + '%') AND

(@TeacherDateofBirth is null or TeacherDateofBirth = @TeacherDateofBirth) AND
(@TeacherTitle is null or TeacherTitle LIKE '%' + @TeacherTitle + '%')
ORDER BY TeacherID
END