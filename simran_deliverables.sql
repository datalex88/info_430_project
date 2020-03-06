USE MASS_Entertainment_database
GO

-- procedure to insert into line item and order at the same time 
CREATE PROCEDURE uspPopulateOrder_LineItem
@MerchName NVARCHAR(50),
@PerfName NVARCHAR(50),
@ODate DATETIME,
@Quant INT, 
@LIPrice MONEY
AS

DECLARE @Merch_ID INT, @Performer_ID INT, @Order_ID INT,  @LI_ID INT

SET @Merch_ID = (SELECT MerchID
              FROM tblMerch
              WHERE MerchName = @MerchName)

IF @Merch_ID IS NULL
    BEGIN
        PRINT 'Merchandise ID must have a value; the variable is NULL - check merchant data'
        RAISERROR ('@Merch_ID cannot be NULL',11,1)
    RETURN
END

SET @Performer_ID = (SELECT PerformerID
              FROM tblPerformer
              WHERE PerformerName = @PerfName)

IF @Performer_ID IS NULL
    BEGIN
        PRINT 'Performer ID must have a value; the variable is NULL - check performer data'
        RAISERROR ('@Performer_ID cannot be NULL',11,1)
    RETURN
END

BEGIN TRAN T1
    INSERT INTO tblOrder (PerformerID, OrderDate)
    VALUES (@Performer_ID, @ODate)
    SET @Order_ID = (SELECT Scope_Identity())
    IF @Order_ID IS NULL
        ROLLBACK TRAN T1
    ELSE
        INSERT INTO tblLINEITEM (MerchID, OrderID, LineItemPrice, Quantity, PriceExtended)
        VALUES (@Merch_ID, @Order_ID, @LIPrice, @Quant, (@LIPrice * @Quant))
    IF @@ERROR <> 0
        BEGIN
            PRINT 'Failing transaction'
            ROLLBACK TRAN T1
        END
    ELSE
        COMMIT TRAN T1
GO

-- business rule 
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
GO
-- calculated column 
CREATE FUNCTION fn_calcExtendedPrice(@PK_LI INT)
RETURNS INT
AS
BEGIN
	DECLARE @Ret INT = (SELECT (LineItemPrice * Quantity)
		FROM tblLINEITEM
		WHERE LineItemID = @PK_LI)
RETURN @Ret
END
GO

ALTER TABLE tblLINEITEM
ADD ExtendedPrice AS (dbo.fn_calcExtendedPrice(LineItemID))
GO

-- populate performer & performer_type tables
-- Inserting new values into tblPERFORMER_TYPE
INSERT INTO tblPERFORMER_TYPE(PerformerTypeName, PerformerTypeDesc)
VALUES
    ('Musical Band', NULL),
    ('Pianist', NULL),
    ('Guitarist', NULL),
    ('Opera', NULL),
    ('Singer', NULL),
    ('Orchestra', NULL), 
    ('A cappella', NULL)
GO

-- Adding data from temp table to tblPERFORMER
INSERT INTO tblPERFORMER
SELECT * FROM performer_tempCSV
GO