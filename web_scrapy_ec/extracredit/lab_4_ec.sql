
-- create a new database
--CREATE DATABASE g4_music_venues;
USE g4_music_venues;

-- create table Music Venues
CREATE TABLE tblMusic_Venues
(MusicVenueID INT IDENTITY(1,1) primary key,
MusicVenueName varchar(50) not null,
MusicVenueContact varchar(100) null,
MusicVenueDesc varchar(700) null,
);
GO

-- insert data from imported web scraped data
-- insert into Music Venue Name
INSERT INTO tblMusic_Venues(MusicVenueName, MusicVenueContact, MusicVenueDesc)
SELECT h2, em, p
FROM web_scraped_data 
WHERE h2 IS NOT NULL;

select * from tblMusic_Venues;

select * from web_scraped_data;