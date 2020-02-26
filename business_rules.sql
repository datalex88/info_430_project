CREATE FUNCTION fn_VenueEndStartTime()
RETURNS INT
AS
BEGIN
 
    DECLARE @RET INT = 0
    IF EXISTS (SELECT * FROM tblVenue_Event
               WHERE VenueEventEndTime < VenueEventStartTime)
        BEGIN
            SET @RET =1
        END
    RETURN @RET
END
GO
 
ALTER TABLE tblVenue_Event
ADD CONSTRAINT CK_VenueEndStartTime
CHECK (dbo.fn_VenueEndStartTime() = 0)
