USE MASS_Entertainment_database
GO
-- Needed proceedures: 
-- usp_getPerformerID
CREATE PROCEDURE usp_getPerformerID
@perfTypeN NVARCHAR(50),
@perfName  NVARCHAR(50),
@perfID    INT OUTPUT
AS
DECLARE @perfTypeID INT
SET @perfTypeN = (SELECT PerformerTypeID 
                FROM tblPERFORMER_TYPE 
                WHERE PerformerTypeName = @perfTypeN)
SET @perfID = (SELECT PerformerID 
                FROM tblPERFORMER 
                WHERE PerformerTypeID = @perfTypeN 
                AND PerformerNAme = @perfName)
GO

-- usp_getEventTypeID
CREATE PROCEDURE usp_getEventTypeID
@eventTN NVARCHAR(50),
@eventID INT OUTPUT
AS
SET @eventID = (SELECT EventTypeID 
                FROM tblEVENT_TYPE 
                WHERE EventTypeName = @eventTN)
GO

-- usp_getEventID
CREATE PROCEDURE usp_getEventID
@eventName NVARCHAR(50),
@eventID INT OUTPUT
AS
SET @eventID = (SELECT EventID FROM tblEVENT WHERE EventName = @eventName)
GO

-- usp_getVenueID
CREATE PROCEDURE usp_getVenueID
@venueName NVARCHAR(50),
@venueID INT OUTPUT
AS
SET @venueID = (SELECT VenueID FROM tblVENUE WHERE VenueName = @venueName)
GO
-- usp_newEvent
-- *GetPerformerID
-- *GetEventTypeID
CREATE PROCEDURE usp_newEvent
@newEventName NVARCHAR(50),
@newEventTypeName NVARCHAR(50),
@newPerformerTypeName NVARCHAR(50),
@newPerformerName NVARCHAR(50)
AS
BEGIN
    DECLARE @ET_ID INT, @P_ID INT
    
    EXECUTE usp_getPerformerID
    @perfTypeN = @newPerformerTypeName,
    @perfName  = @newPerformerName,
    @perfID    = @P_ID OUTPUT
    IF @P_ID IS NULL
        BEGIN
        RAISERROR('Performer name came up empty man!',11,1)
        RETURN
        END

    EXECUTE usp_getEventTypeID
    @eventTN = @newEventTypeName,
    @eventID = @ET_ID OUTPUT
        IF @ET_ID IS NULL
        BEGIN
        RAISERROR('EventType name came up empty man!',11,1)
        RETURN
        END

    BEGIN TRAN T1
        INSERT INTO tblEVENT(EventTypeID, PerformerID, EventName)
        VALUES(@ET_ID, @P_ID, @newEventName)
    COMMIT TRAN T1
END
GO
-- uspNewVenueEvent
-- *GetEventID
-- *GetVenueID


/*
Needed Business Rules:
- Nobody under 21 can by a ticket
- Venue_Vendor duration cant be under 1 year
*/

-- Inserting new values into tblVENUE_TYPE
INSERT INTO tblVENUE_TYPE(VenueTypeName, VenueTypeDesc)
VALUES
    ('Music Venue', NULL),
    ('Cafe', NULL),
    ('Theater', NULL),
    ('Resturant', NULL),
    ('Bar', NULL),
    ('Nightclub', NULL)
GO

-- Adding data from temp table to tblVENUE
INSERT INTO tblVENUE
SELECT * FROM venue_dataCSV
GO

INSERT INTO [dbo].[TableName]
(
 [ColumnName1], [ColumnName2], [ColumnName3]
)
VALUES
(
 ColumnValue1, ColumnValue2, ColumnValue3
)
GO
