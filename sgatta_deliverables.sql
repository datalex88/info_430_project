--SHANNON GATTA SPROCS


USE MASS_Entertainment_database
GO

--SPROC 1: usp_newBooth

-- Needed proceedures: 
-- usp_getVenueVendorID
CREATE PROCEDURE usp_getVenueVendorID
@s_start Datetime,
@s_end Datetime,
@s_VID INT OUTPUT
AS
SET @s_VID = (SELECT VenueVendorID 
                FROM tblVENUE_VENDOR 
                WHERE ContractStart = @s_start
				AND ContractEnd = @s_end)
GO

-- usp_getLocationID
CREATE PROCEDURE usp_getLocationID
@s_location NVARCHAR(50),
@s_LID INT OUTPUT
AS
SET @s_LID = (SELECT LocationID 
                FROM tblLocation 
                WHERE LocationName = @s_location)
GO

-- usp_getProductID
CREATE PROCEDURE usp_getProductID
@s_Product NVARCHAR(50),
@s_PID INT OUTPUT
AS
SET @s_PID = (SELECT ProductID FROM tblPRODUCT WHERE ProductName = @s_Product)
GO


-- Create usp_newBooth
-- usp_getVenueVendorID
-- usp_getLocationID
-- usp_getProductID
CREATE PROCEDURE usp_newBooth
@product NVARCHAR(50),
@location NVARCHAR(50),
@start Datetime,
@end Datetime
AS
    DECLARE @P_ID INT, @L_ID INT, @V_ID INT
    
    EXECUTE usp_getVenueVendorID
    @s_start = @start,
    @s_end  = @end,
    @s_VID    = @V_ID OUTPUT
    IF @V_ID IS NULL
        BEGIN
        RAISERROR('Venue Vendor is null',11,1)
        RETURN
        END

    EXECUTE usp_getLocationID
    @s_location = @location,
    @s_LID = @L_ID OUTPUT
        IF @L_ID IS NULL
        BEGIN
        RAISERROR('Location name is null',11,1)
        RETURN
        END

	EXECUTE usp_getProductID
    @s_product = @product,
    @s_PID = @P_ID OUTPUT
        IF @P_ID IS NULL
        BEGIN
        RAISERROR('Product name is null',11,1)
        RETURN
        END

    BEGIN TRAN B1
        INSERT INTO tblBOOTH(VenueVendorID, LocationID, ProductID)
        VALUES(@V_ID, @L_ID, @P_ID)

	IF @@ERROR <> 0
	BEGIN
		Rollback TRAN B1
	END
	ELSE
    COMMIT TRAN B1
GO



--SPROC 2: usp_newTicket

-- Needed proceedures: 
-- usp_getVenueEventID
-- usp_getTicketType
CREATE PROCEDURE usp_getVenueEventID
@s_eventstart Datetime,
@s_eventend Datetime,
@s_VEID INT OUTPUT
AS
SET @s_VEID = (SELECT VenueEventID 
                FROM tblVENUE_EVENT 
                WHERE VenueEventStartTime = @s_eventstart
				AND VenueEventEndTime = @s_eventend)
GO

-- usp_getTicketType
CREATE PROCEDURE usp_getTicketType
@s_tickettype NVARCHAR(50),
@s_TTID INT OUTPUT
AS
SET @s_TTID = (SELECT TicketTypeID 
                FROM tblTICKET_TYPE 
                WHERE TicketTypeName = @s_tickettype)
GO


-- Create usp_newTicket
-- usp_getVenueEventID
-- usp_getTicketType
CREATE PROCEDURE usp_newTicket
@tickettype NVARCHAR(50),
@venuestarttime Datetime,
@venueendtime Datetime,
@price INT,
@seatnum INT,
@buydate Date
AS
    DECLARE @VE_ID INT, @TT_ID INT
    
    EXECUTE usp_getVenueEventID
    @s_eventstart = @venuestarttime,
    @s_eventend  = @venueendtime,
    @s_VEID    = @VE_ID OUTPUT
    IF @VE_ID IS NULL
        BEGIN
        RAISERROR('Venue Event is null',11,1)
        RETURN
        END

    EXECUTE usp_getTicketType
    @s_tickettype = @tickettype,
    @s_TTID = @TT_ID OUTPUT
        IF @TT_ID IS NULL
        BEGIN
        RAISERROR('Ticket Type name is null',11,1)
        RETURN
        END

    BEGIN TRAN B2
        INSERT INTO tblTICKET(TicketTypeID, VenueEventID, TicketPrice, TicketSeatNumber, PurchaseDate)
        VALUES(@VE_ID, @TT_ID, @price, @seatnum, @buydate)

	IF @@ERROR <> 0
	BEGIN
		Rollback TRAN B2
	END
	ELSE
    COMMIT TRAN B2
GO


--Business Rule


CREATE FUNCTION fn_ComediansNoUseMusicInstruments()
RETURNS INT
AS
BEGIN
  
    DECLARE @RET INT = 0
    IF EXISTS (SELECT * FROM tblEQUIPMENT_TYPE ET
			JOIN tblEQUIPMENT E ON ET.EquipmentTypeID = e.EquipmentTypeID
			JOIN tblPERFORMER P ON E.PERFORMERID = P.PerformerID
			JOIN tblPERFORMER_TYPE PT ON P.PerformerTypeID = PT.PerformerTypeID
               WHERE EquipmentTypeName = 'Instrument'
			   AND PerformerTypeName = 'Comedian')
        BEGIN
            SET @RET =1
        END
    RETURN @RET
END
GO
 
ALTER TABLE tblEquipment
ADD CONSTRAINT CK_ComediansNoUseInstruments
CHECK (dbo.fn_ComediansNoUseMusicInstruments() = 0) 
GO
--Caluclated column

CREATE FUNCTION fn_CalcTotalTicketsConcert (@PK INT)
RETURNS INT
AS
BEGIN
	DECLARE @Ret INT = (SELECT COUNT(*)
		FROM tblTICKET T
			JOIN tblVenue_Event VE ON T.VenueEventID = VE.VenueEventID
			JOIN tblEvent E ON VE.EventID = E.EventID
		WHERE E.EventName = 'Coachella'
		AND E.EventID = @PK)
RETURN @Ret
END
GO

ALTER TABLE tblEvent
ADD TotalNumTicketsSold AS (fn_CalcTotalTicketsConcert (EventID))
GO
