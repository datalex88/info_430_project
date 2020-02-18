/*
INFO 430
Shannon, Simran, Alex

Creation of database and tables

-- Create a new database called 'MASS_Entertainment_database'
CREATE DATABASE MASS_Entertainment_database
GO
*/

USE MASS_Entertainment_database

CREATE TABLE [dbo].[tblVENDOR]
(
    [VendorID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VendorName]   NVARCHAR(50) NOT NULL,
    [VendorTypeID] INT NOT NULL,
    [VendorEmail]  NVARCHAR(50) NOT NULL,
    [VendorPhone]  NVARCHAR(50) NULL,
    [VendorPhone2] NVARCHAR(50) NULL
);
GO

CREATE TABLE [dbo].[tblVENDOR_TYPE]
(
    [VendorTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VendorTypeName] NVARCHAR(50)  NOT NULL,
    [VendorTypeDesc] NVARCHAR(200) NULL
);
GO

CREATE TABLE [dbo].[tblVENUE_VENDOR]
(
    [VenueVendorID] INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VenueID]       INT NOT NULL,
    [VendorID]      INT NOT NULL
);
GO

CREATE TABLE [dbo].[tblVENUE]
(
    [VenueID]       INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VenueName]     NVARCHAR(50) NOT NULL,
    [VenueTypeID]   INT NOT NULL,
    [VenueAddress]  NVARCHAR(50) NOT NULL,
    [VenueCity]     NVARCHAR(50) NOT NULL,
    [VenueState]    NVARCHAR(50) NOT NULL,
    [VenueZip]      NVARCHAR(10) NOT NULL,
    [VenuePhone]    NVARCHAR(50) NULL,
    [VenuePhone2]   NVARCHAR(50) NULL,
    [VenueCapacity] INT NULL
);
GO

CREATE TABLE [dbo].[tblVENUE_TYPE]
(
    [VenueTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [VenueTypeName] NVARCHAR(50) NOT NULL,
    [VenueTypeDesc] NVARCHAR(50) NULL
);
GO

CREATE TABLE [dbo].[tblVENUE_CONTACT]
(
    [VenueContactID] INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [ContactID]      INT NOT NULL,
    [VenueID]        INT NOT NULL
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
    [EquipmentName]   NVARCHAR(50) NOT NULL,
    [EquipmentTypeID] INT NOT NULL
);
GO

CREATE TABLE [dbo].[tblEQUIPMENT_TYPE]
(
    [EquipmentTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [EquipmentTypeName] NVARCHAR(50) NOT NULL,
    [EquipmentTypeDesc] NVARCHAR(50) NULL
);
GO

CREATE TABLE [dbo].[tblPERFORMER_TYPE]
(
    [PerformerTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [PerformerTypeName] NVARCHAR(50) NOT NULL,
    [PerformerTypeDesc] NVARCHAR(50) NULL
);
GO

CREATE TABLE [dbo].[tblPERFORMER]
(
    [PerformerID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [PerformerName]   NVARCHAR(50) NOT NULL,
    [PerformerTypeID] INT NOT NULL
);
GO

CREATE TABLE [dbo].[tblMERCH_TYPE]
(
    [MerchTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [MerchTypeName] NVARCHAR(50) NOT NULL,
    [MerchTypeDesc] NVARCHAR(50) NULL
);
GO

CREATE TABLE [dbo].[tblPRODUCT_TYPE]
(
    [ProductTypeID]   INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [ProductTypeName] NVARCHAR(50) NOT NULL,
    [ProductTypeDesc] NVARCHAR(50) NULL
);
GO

CREATE TABLE [dbo].[tblMERCH]
(
    [MerchID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [MerchName]   NVARCHAR(50) NOT NULL,
    [MerchQuantity]   INT NOT NULL,
    [MerchPrice]   MONEY NOT NULL,
    [MerchTypeID] INT NOT NULL
);
GO

CREATE TABLE [dbo].[tblCONTACT]
(
    [ContactID]     INT IDENTITY (1,1) NOT NULL PRIMARY KEY, -- Primary Key column
    [ContactName]   NVARCHAR(50) NOT NULL,
    [ContactPhone]   INT NOT NULL,
    [ContactEmail] NVARCHAR(50) NULL
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