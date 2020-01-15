/*
INFO 430
Shannon, Simran, Molly, Alex

Creation of database and tables
*/

-- Create a new database called 'MASS_Entertainment_database'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'MASS_Entertainment_database'
)
CREATE DATABASE MASS_Entertainment_database
GO