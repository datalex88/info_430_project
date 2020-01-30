-- Lab 04

USE lab_04_group04
GO

-- Create the table in the specified schema
CREATE TABLE [dbo].[tblProduct]
(
    [ProductID]   INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [ProductName] NVARCHAR(50) NOT NULL,
    [Price]       NVARCHAR(50) NOT NULL,
    [ProductDesc] NVARCHAR(50) NOT NULL
);
GO

-- Create the table in the specified schema
CREATE TABLE [dbo].[tblCustomer]
(
    [CustID]        INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [FName]         NVARCHAR(50) NOT NULL,
    [LName]         NVARCHAR(50) NOT NULL,
    [BirthDate]     DATE         NOT NULL,
    [StreetAddress] NVARCHAR(50) NULL,
    [City]          NVARCHAR(50) NULL,
    [State]         NVARCHAR(50) NULL,
    [Zip]           NVARCHAR(50) NULL
);
GO

-- Create the table in the specified schema
CREATE TABLE [dbo].[tblLineItem]
(
    [LineItemID]    INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [ProductID]     INT NOT NULL,
    [OrderID]       INT NOT NULL,
    [Qty]           INT NOT NULL
);
GO

-- Create the table in the specified schema
CREATE TABLE [dbo].[tblCart]
(
    [CartID]        INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [ProductID]     INT NOT NULL,
    [CustomerID]    INT NOT NULL,
    [Quantity]      INT NULL,
    [PriceExtended] NUMERIC (7,2) NULL
);
GO

-- Create the table in the specified schema
CREATE TABLE [dbo].[tblOrder]
(
    [OrderID]    INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [OrderDate]  DATE NULL,
    [CustomerID] INT NOT NULL,
    [OrderTotal] NUMERIC(7,2) NULL
);
GO

-- Add foreign Key Constraints
ALTER TABLE tblOrder
ADD CONSTRAINT FK_Order_CustID
FOREIGN KEY (CustomerID) REFERENCES tblCustomer(CustomerID)
GO

ALTER TABLE tblLineItem
ADD CONSTRAINT FK_Line_Order
FOREIGN KEY (OrderID) REFERENCES tblOrder(OrderID)
GO

ALTER TABLE tblLineItem
ADD CONSTRAINT FK_Line_Prod
FOREIGN KEY (ProductID) REFERENCES tblProduct(ProductID)
GO

ALTER TABLE tblCart
ADD CONSTRAINT FK_Cart_Prod
FOREIGN KEY (ProductID) REFERENCES tblProduct(ProductID)
GO

-- nested procedure for get product id
CREATE PROCEDURE group4_GetProdID
@PName varchar(20),
@P_ID INT OUTPUT
AS
SET @P_ID = (SELECT ProductID
             FROM tblProduct
             WHERE ProductName = @PName)
GO

-- nested procedure for get customer id
CREATE PROCEDURE group4_GetCustID
@F_C varchar(20),
@L_C varchar(20),
@BOD_C Date,
@C_ID INT OUTPUT
AS
SET @C_ID = (SELECT CustID
             FROM tblCustomer
             WHERE Fname = @F_C
             AND Lname = @L_C
             AND BirthDate = @BOD_C)
GO

-- Inserts to tblCart
CREATE PROCEDURE uspAddToCart
@PN VARCHAR(50),
@CFN VARCHAR(50),
@CLN VARCHAR(50),
@Birth DATE,
@Quantity INT

AS

DECLARE @PR_ID INT
DECLARE @cust INT

EXEC group4_GetProdID
@PName = @PN,
@P_ID = @PT_ID OUTPUT

EXEC group4_GetCustID
@F_C   = @CFN,
@L_C   = @CLN,
@BOD_C = @Birth,
@C_ID  = @cust OUTPUT

BEGIN
    BEGIN TRAN G2
        INSERT INTO tblCart(ProductID, CustomerID, Quantity, PriceExtended)
        VALUES             (@PT_ID, @cust, @Quantity, null)
    COMMIT TRAN G2
END
GO

-- LAST PART ** Inserts from tblCart to tblOrder and tblLineItem
CREATE PROCEDURE uspAddToOrderFromCart
@FNAME  VARCHAR(50),
@LNAME  VARCHAR(50),
@BIRTHY DATE

AS

DECLARE @RUN INT 
DECLARE @PID INT
DECLARE @CID INT

EXEC group4_GetCustID
@F_C   = @FNAME,
@L_C   = @LNAME,
@BOD_C = @BIRTHY,
@C_ID  = @CID OUTPUT

SET @RUN = (SELECT COUNT(*) FROM tblCart WHERE CustomerID = @CID)
PRINT 'Creating Order for Customer'
INSERT INTO tblOrder(OrderDate, CustomerID, OrderTotal)
VALUES ((SELECT GETDATE()), @CID, NULL)

PRINT 'Getting all products for customer'

IF @CID IS NULL
    BEGIN
    PRINT 'PRODUCT NAME IS NULL'
    RAISERROR('PRODUCT NAME CANNOT BE NULL',11,1)
    RETURN 
    END

BEGIN TRAN G2
INSERT INTO tblLineItem(ProductID, OrderID, Qty)
SELECT ProductID, SCOPE_IDENTITY(), Quantity FROM tblCart WHERE CustomerID = @CID
COMMIT TRAN G2
PRINT 'PRODUCTS MOVED TO AN ORDER'

BEGIN
DELETE
FROM tblCart
WHERE CustomerID = @CID
PRINT 'DELETED FROM TABLE CART AND ADDED TO TABLE LINE ITEM'
END
GO

EXEC uspAddToOrderFromCart
@FNAME  = 'Chloris',
@LNAME  = 'Benza',
@BIRTHY = '2015-08-05'

-- Drop the stored procedure called 'StoredProcedureName' in schema 'dbo'
DROP PROCEDURE dbo.uspAddToOrderFromCart
GO