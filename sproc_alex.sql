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
CREATE PROCEDURE usp_newVenueEvent
@venueName NVARCHAR(50),
@newEventName NVARCHAR(50),
@start     DATETIME,
@end       DATETIME
AS
BEGIN
    DECLARE @E_ID INT, @V_ID INT

    EXEC usp_getEventID
    @eventName = @newEventName,
    @eventID = @E_ID OUTPUT
    IF @E_ID IS NULL
    BEGIN
        RAISERROR('Event name is NULL man!', 11, 1)
        RETURN
    END

    SET @V_ID = (SELECT VenueID FROM tblVENUE WHERE VenueName = @venueName)
    IF @V_ID IS NULL
    BEGIN
        RAISERROR('Venue name is NULL man!', 11, 1)
        RETURN
    END

    BEGIN TRAN T1
    INSERT INTO tblVENUE_EVENT(VenueID, EventID, VenueEventStartTime, VenueEventEndTime)
    VALUES(@V_ID, @E_ID, @start, @end)
    COMMIT TRAN T1
END
GO

/*
Needed Business Rules:
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

-- Computed Column: Concert duration
CREATE FUNCTION fn_durationOfConcert(@PKID INT) 
RETURNS INT
AS
    BEGIN
        DECLARE @RET INT = (
            SELECT (DATEDIFF(MINUTE, VenueEventStartTime, VenueEventEndTime))
            FROM tblVENUE_EVENT
            WHERE VenueEventID = @PKID
                            )
        RETURN @RET
    END
GO

ALTER TABLE tblVENUE_EVENT 
ADD Duration
AS (dbo.fn_durationOfConcert(VenueEventID))
GO

CREATE FUNCTION NoGuitarsInCafes() 
RETURNS INT 
AS 
BEGIN    
    DECLARE @RET INT = 0    
    IF EXISTS (
        SELECT *
        FROM tblEQUIPMENT_TYPE ET 
        JOIN tblEQUIPMENT       E ON ET.EquipmentTypeID = E.EquipmentTypeID
        JOIN tblPERFORMER       P ON E.PerformerID      = P.PerformerID
        JOIN tblEVENT          EV ON P.PerformerID      = EV.PerformerID
        JOIN tblVENUE_EVENT    VE ON EV.EventID         = VE.EventID
        JOIN tblVENUE           V ON VE.VenueID         = V.VenueID
        JOIN tblVENUE_TYPE     VT ON V.VenueTypeID      = VT.VenueTypeID
        WHERE VT.VenueTypeName   LIKE 'Cafe'
        AND ET.EquipmentTypeName LIKE 'Guitar'             
    )
    BEGIN           
        SET @RET = 1    
    END 
    RETURN @RET 
END 
GO 

ALTER TABLE tblVENUE_EVENT   
ADD CONSTRAINT CK_NoGuitarsInCafes 
CHECK (dbo.NoGuitarsInCafes() = 0)
GO

-- Number of Events held at each venue, greater than 10
CREATE VIEW v_EventsPerVenue AS
SELECT V.VenueName, COUNT(E.EventID) AS NumberOfEvents
FROM tblVENUE V 
JOIN tblVENUE_EVENT VE ON V.VenueID = VE.VenueID
JOIN tblEVENT E ON VE.EventID = E.EventID
GROUP BY V.VenueName
HAVING COUNT(E.EventID) > 10
GO

SELECT * FROM v_EventsPerVenue
ORDER BY NumberOfEvents DESC