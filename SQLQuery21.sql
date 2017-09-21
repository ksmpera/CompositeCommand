delete top (1) from MacroMicro where MicroCommandID = 9 and MacroCommandID = 3

delete from MacroMicro where MacroMicroID =
(
	select top (1) MacroMicroID from MacroMicro
	where  MicroCommandID = 9 and MacroCommandID = 4
)
UPDATE MacroCommands SET ParentId = null WHERE MacroCommandId = 4

SELECT  MacroCommands.MacroCommandID, MacroCommandName 
FROM MacroCommands 
left join  MacroMicro on MacroCommands.MacroCommandID = MacroMicro.MacroCommandID 
where MacroMicro.MacroCommandID is null


SELECT DISTINCT MacroCommands.MacroCommandID, MacroCommandName, COUNT(MacroMicro.MacroCommandID)
FROM MacroCommands inner join  MacroMicro on MacroCommands.MacroCommandID = MacroMicro.MacroCommandID 
GROUP BY MacroCommands.MacroCommandID, MacroCommandName 
HAVING (COUNT(MacroMicro.MacroCommandID) > 1)

SELECT MacroCommandID, COUNT(1) 
FROM MacroMicro 
GROUP BY MacroCommandID 
HAVING ( COUNT(1) > 1 )


Create Proc procMacroCommands
As
Select MacroCommandID, MacroCommandName, ParentID
from Macrocommands


Create Proc procMicroCommands
As
Select MicroCommandID, MicroCommandName, MicroCommandType, MicroParameter1, MicroParameter2, MicroParameter3
from MicroCommands


Create Proc procMacroMicro
As
select MacroCommandId, MicroCommandId 
from MacroMicro


CREATE PROC [dbo].[spCommandDelete]( @MacroCommandID int, @MicroCommandID int) AS 
BEGIN

delete
top (1) 
from
MacroMicro 
where
MacroCommandID = @MacroCommandID 
and MicroCommandID = @MicroCommandID 
END

drop PROC spCommandDelete


CREATE PROC spCommandInsert( @MacroCommandID int, @MicroCommandID int)AS
BEGIN
INSERT INTO MacroMicro (MacroCommandID, MicroCommandID) 
VALUES (@MacroCommandID, @MicroCommandID)
END

drop PROC spCommandInsert


CREATE PROC spCommandUpdate(@MacroCommandID1 int, @MicroCommandID2 int)AS
BEGIN
UPDATE MacroCommands SET ParentId = @MacroCommandID1 WHERE MacroCommandId = @MicroCommandID2
END

drop PROC spCommandUpdate


CREATE PROC spMacroCommandName(@Val1 varchar(100))AS
BEGIN
INSERT INTO MacroCommands (MacroCommandName) VALUES (@Val1); 
SELECT SCOPE_IDENTITY();
END

drop PROC spMacroCommandName


CREATE PROC spMicroCommandName(@Val1 varchar(100), @Val2 varchar(100), @Val3 varchar(100), @Val4 varchar(100), @Val5 varchar(100))AS
BEGIN
INSERT INTO MicroCommands (MicroCommandName, MicroCommandType, MicroParameter1, MicroParameter2, MicroParameter3 ) 
VALUES (@Val1, @Val2, @Val3, @Val4, @Val5); 
SELECT SCOPE_IDENTITY();
END

drop PROC spMicroCommandName



CREATE PROC spAddMacroCommand( @MacroCommandName varchar (100), @ParentID  int = null)
AS
BEGIN
INSERT INTO MacroCommands(MacroCommandName, ParentID) 
VALUES (@MacroCommandName, @ParentID)
Select MacroCommandID, MacroCommandName, ParentID
from Macrocommands
END


drop PROC spAddMacroCommand

