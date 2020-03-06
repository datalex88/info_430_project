/*
INFO 430
Shannon, Simran, Alex

Creation of database and tables

Create a new database called 'MASS_Entertainment_database'
CREATE DATABASE MASS_Entertainment_database
GO
*/

USE MASS_Entertainment_database

-- Drop the database 'DatabaseName'
-- Connect to the 'master' database to run this snippet

CREATE TABLE [dbo].[tblVENDOR]
(
    [VendorID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VendorName]   NVARCHAR(50)       NOT NULL,
    [VendorTypeID] INT                NOT NULL,
    [VendorEmail]  NVARCHAR(50)       NOT NULL,
    [VendorPhone]  NVARCHAR(10)       NULL,
    [VendorPhone2] NVARCHAR(50)       NULL
);
GO

CREATE TABLE [dbo].[tblVENDOR_TYPE]
(
    [VendorTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VendorTypeName] NVARCHAR(50)       NOT NULL,
    [VendorTypeDesc] NVARCHAR(200)      NULL
);
GO

CREATE TABLE [dbo].[tblVENUE_VENDOR]
(
    [VenueVendorID] INT  IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VenueID]       INT  NOT NULL,
    [VendorID]      INT  NOT NULL,
    [ContractStart] DATE NOT NULL,
    [ContractEnd]   DATE NOT NULL
);
GO

CREATE TABLE [dbo].[tblVENUE]
(
    [VenueID]       INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VenueName]     NVARCHAR(50)       NOT NULL,
    [VenueTypeID]   INT                NOT NULL,
    [VenueAddress]  NVARCHAR(50)       NOT NULL,
    [VenueCity]     NVARCHAR(50)       NOT NULL,
    [VenueState]    NVARCHAR(50)       NOT NULL,
    [VenueZip]      NVARCHAR(10)       NOT NULL,
    [VenuePhone]    NVARCHAR(10)       NULL,
    [VenueWebsite]  NVARCHAR(50)       NULL,
    [VenueCapacity] INT                NULL
);
GO

CREATE TABLE [dbo].[tblVENUE_TYPE]
(
    [VenueTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VenueTypeName] NVARCHAR(50)       NOT NULL,
    [VenueTypeDesc] NVARCHAR(50)       NULL
);
GO

CREATE TABLE [dbo].[tblVENUE_CONTACT]
(
    [VenueContactID] INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [ContactID]      INT NOT NULL,
    [VenueID]        INT NOT NULL
);
GO

CREATE TABLE [dbo].[tblPRODUCT_TYPE]
(
    [ProductTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [ProductTypeName] NVARCHAR(50)       NOT NULL,
    [ProductTypeDesc] NVARCHAR(50)       NULL
);
GO

CREATE TABLE [dbo].[tblPRODUCT]
(
    [ProductID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [ProductTypeID] INT                NOT NULL,
    [ProductName]   NVARCHAR(50)       NOT NULL,
    [ProductDesc]   NVARCHAR(50)       NULL
);
GO

CREATE TABLE [dbo].[tblBOOTH]
(
    [BoothID]       INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VenueVendorID] INT NOT NULL,
    [LocationID]    INT NOT NULL,
    [ProductID]     INT NOT NULL
);
GO

CREATE TABLE [dbo].[tblEQUIPMENT]
(
    [EquipmentID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [EquipmentName]   NVARCHAR(50)       NOT NULL,
    [EquipmentTypeID] INT                NOT NULL,
    [PerformerID]     INT                NOT NULL
);
GO


CREATE TABLE [dbo].[tblEQUIPMENT_TYPE]
(
    [EquipmentTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [EquipmentTypeName] NVARCHAR(50)       NOT NULL,
    [EquipmentTypeDesc] NVARCHAR(50)       NULL
);
GO

CREATE TABLE [dbo].[tblPERFORMER_TYPE]
(
    [PerformerTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [PerformerTypeName] NVARCHAR(50)       NOT NULL,
    [PerformerTypeDesc] NVARCHAR(50)       NULL
);
GO

CREATE TABLE [dbo].[tblPERFORMER]
(
    [PerformerID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [PerformerName]   NVARCHAR(50)       NOT NULL,
    [PerformerTypeID] INT                NOT NULL
);
GO

CREATE TABLE [dbo].[tblMEMBER]
(
    [MemberID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [MemberFName]  NVARCHAR(50)       NOT NULL,
	[MemberLName]  NVARCHAR(50)       NOT NULL,
	[MemberStreet] NVARCHAR(50)       NOT NULL,
	[MemberCity]   NVARCHAR(20)       NOT NULL,
	[MemberState]  NVARCHAR(5)        NOT NULL,
	[MemberEmail]  NVARCHAR(50)       NOT NULL,
	[MemberPhone]  NVARCHAR(10)       NOT NULL
);
GO

CREATE TABLE [dbo].[tblPERFORMANCE_MEMBER]
(
    [PerformanceMemberID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [MemberID] INT NOT NULL,
    [PerformerID] INT NOT NULL
);
GO

CREATE TABLE [dbo].[tblEVENT_TYPE]
(
    [EventTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [EventTypeName] NVARCHAR(50)       NOT NULL,
    [EventTypeDesc] NVARCHAR(50)       NULL
);
GO

CREATE TABLE [dbo].[tblEVENT]
(
    [EventID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [EventTypeID] INT                NOT NULL,
	[PerformerID] INT                NOT NULL,
    [EventName]   NVARCHAR(50)       NOT NULL
);
GO

CREATE TABLE [dbo].[tblVENUE_EVENT]
(
    [VenueEventID]        INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VenueID]             INT                NOT NULL,
    [EventID]             INT                NOT NULL,
	[VenueEventStartTime] TIME               NOT NULL,
	[VenueEventEndTime]   TIME               NOT NULL
);
GO

CREATE TABLE [dbo].[tblTICKET_TYPE]
(
    [TicketTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [TicketTypeName] NVARCHAR(50)       NOT NULL,
    [TicketTypeDesc] NVARCHAR(50)       NULL
);
GO

CREATE TABLE [dbo].[tblTICKET]
(
    [TicketID]         INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [TicketTypeID]     INT                NOT NULL,
	[VenueEventID]     INT                NOT NULL,
    [TicketPrice]      MONEY              NOT NULL,
	[TicketSeatNumber] NVARCHAR(5),
	[PurchaseDate]     DATE
);
GO

CREATE TABLE [dbo].[tblMERCH_TYPE]
(
    [MerchTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [MerchTypeName] NVARCHAR(50)       NOT NULL,
    [MerchTypeDesc] NVARCHAR(50)       NULL
);
GO

CREATE TABLE [dbo].[tblMERCH]
(
    [MerchID]       INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [MerchName]     NVARCHAR(50)       NOT NULL,
    [MerchQuantity] INT                NOT NULL,
    [MerchPrice]    MONEY              NOT NULL,
    [MerchTypeID]   INT                NOT NULL
);
GO

CREATE TABLE [dbo].[tblCONTACT]
(
    [ContactID]    INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [ContactName]  NVARCHAR(50)       NOT NULL,
    [ContactPhone] NVARCHAR(10)       NOT NULL,
    [ContactEmail] NVARCHAR(50)       NULL
);
GO

CREATE TABLE [dbo].[tblORDER]
(
    [OrderID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [OrderDate]   DATETIME NOT NULL,
    [PerformerID] INT NOT NULL
);
GO

CREATE TABLE [dbo].[tblLINEITEM]
(
    [LineItemID]  INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [Quantity] INT NOT NULL, 
    [LineItemPrice] MONEY NOT NULL,
    [PriceExtended] MONEY NOT NULL,
    [MerchID] INT NOT NULL, 
    [OrderID] INT NOT NULL
);
GO


CREATE TABLE [dbo].[tblLOCATION]
(
    [LocationID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [LocationName] NVARCHAR(50)    NOT NULL,
    [LocationDesc] NVARCHAR(500)   NULL
);
GO

-- Add foreign Key Constraints
ALTER TABLE tblVENDOR
ADD FOREIGN KEY (VendorTypeID) REFERENCES tblVENDOR_TYPE(VendorTypeID)
GO

ALTER TABLE tblPERFORMER
ADD FOREIGN KEY (PerformerTypeID) REFERENCES tblPERFORMER_TYPE(PerformerTypeID)
GO

ALTER TABLE tblMERCH
ADD FOREIGN KEY (MerchTypeID) REFERENCES tblMERCH_TYPE(MerchTypeID)
GO

ALTER TABLE tblPERFORMANCE_MEMBER
ADD FOREIGN KEY (PerformerID) REFERENCES tblPERFORMER(PerformerID), FOREIGN KEY (MemberID) REFERENCES tblMEMBER(MemberID)
GO

ALTER TABLE tblTICKET
ADD FOREIGN KEY (TicketTypeID) REFERENCES tblTICKET_TYPE(TicketTypeID), FOREIGN KEY (VenueEventID) REFERENCES tblVENUE_EVENT(VenueEventID)
GO

ALTER TABLE tblVENUE_EVENT
ADD FOREIGN KEY (VenueID) REFERENCES tblVENUE(VenueID), FOREIGN KEY (EventID) REFERENCES tblEVENT(EventID)
GO

ALTER TABLE tblEVENT
ADD FOREIGN KEY (EventTypeID) REFERENCES tblEVENT_TYPE(EventTypeID), FOREIGN KEY (PerformerID) REFERENCES tblPERFORMER(PerformerID)
GO

ALTER TABLE tblPRODUCT
ADD FOREIGN KEY (ProductTypeID) REFERENCES tblPRODUCT_TYPE(ProductTypeID)
GO

ALTER TABLE tblProduct
ADD FOREIGN KEY (ProductTypeID) REFERENCES tblProduct_Type(ProductTypeID)
GO

ALTER TABLE tblORDER
ADD FOREIGN KEY (PerformerID) REFERENCES tblPERFORMER(PerformerID)
GO

ALTER TABLE tblLINEITEM
ADD FOREIGN KEY (MerchID) REFERENCES tblMERCH(MerchID), 
    FOREIGN KEY (OrderID) REFERENCES tblORDER(OrderID)
GO

ALTER TABLE tblEQUIPMENT
ADD FOREIGN KEY (PerformerID) REFERENCES tblPERFORMER(PerformerID),
    FOREIGN KEY (EquipmentTypeID) REFERENCES tblEQUIPMENT_TYPE(EquipmentTypeID)
GO

ALTER TABLE tblVendor
ADD FOREIGN KEY (VendorTypeID) REFERENCES tblVENDOR_TYPE(VendorTypeID)
GO

ALTER TABLE tblVENUE_VENDOR
ADD FOREIGN KEY (VendorID) REFERENCES tblVENDOR(VendorID),
    FOREIGN KEY (VenueID) REFERENCES tblVENUE(VenueID)
GO

ALTER TABLE tblVENUE
ADD FOREIGN KEY (VenueTypeID) REFERENCES tblVENUE_TYPE(VenueTypeID)
GO

ALTER TABLE tblVENUE_CONTACT
ADD FOREIGN KEY (ContactID) REFERENCES tblCONTACT(ContactID),
    FOREIGN KEY (VenueID) REFERENCES tblVENUE(VenueID)
GO

ALTER TABLE tblBOOTH
ADD FOREIGN KEY (VenueVendorID) REFERENCES tblVENUE_VENDOR(VenueVendorID),
    FOREIGN KEY (LocationID) REFERENCES tblLOCATION(LocationID),
    FOREIGN KEY (ProductID) REFERENCES tblPRODUCT(ProductID)
GO

ALTER TABLE tblEQUIPMENT
ADD FOREIGN KEY (EquipmentTypeID) REFERENCES tblEQUIPMENT_TYPE(EquipmentTypeID),
    FOREIGN KEY (PerformerID) REFERENCES tblPERFORMER(PerformerID)
GO