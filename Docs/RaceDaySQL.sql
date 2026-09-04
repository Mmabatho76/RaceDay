 -- Creating a database
CREATE DATABASE RaceDayDb;

-- Using the database I created
USE RaceDayDb;

-- APP USER TABLE: Stores all system users, both Organisers and Participants,
-- renamed from 'User' to avoid conflicts with SQL Server reserved system names.
CREATE TABLE AppUser (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL,
    UserSurname VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL
);

-- EVENT TYPE TABLE: Defines the categories of events (Run, Walk, Cycle).
CREATE TABLE EventType (
    EventTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL
);

-- EVENT TABLE: Captures specific events created by Organisers, linked to
-- a specific AppUser (Organiser) and an EventType via Foreign Keys.
CREATE TABLE Event (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName VARCHAR(100) NOT NULL,
    Description VARCHAR(500) NOT NULL,
    EventDate DATETIME NOT NULL,
    EventLocation VARCHAR(100) NOT NULL,
    Distance FLOAT NOT NULL,
    EventTypeID INT NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (EventTypeID) REFERENCES EventType(EventTypeID),
    FOREIGN KEY (UserID) REFERENCES AppUser(UserID)
);

-- CATEGORY TABLE: Holds age or distance sub-categories for each event
-- with a cascade delete if the parent event is removed.
CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200) NOT NULL,
    Age VARCHAR(20) NOT NULL,
    Distance FLOAT NOT NULL,
    EventID INT NOT NULL,
    FOREIGN KEY (EventID) REFERENCES Event(EventID) ON DELETE CASCADE
);

-- ENROLMENT TABLE: Links Participants (AppUsers) to an Event and a specific
-- Category they have entered.
CREATE TABLE Enrolment (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentDate DATETIME NOT NULL,
    Status VARCHAR(20) NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    UserID INT NOT NULL,
    FOREIGN KEY (EventID) REFERENCES Event(EventID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (UserID) REFERENCES AppUser(UserID)
);

-- RESULT TABLE: Records the finish times and positions for participants
-- after an event concludes, tied back to their Enrolment.
CREATE TABLE Result (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    FinishTime TIME NOT NULL,
    FinishPosition INT NOT NULL,
    PublishedDate DATETIME NOT NULL,
    TotalPosition INT NOT NULL,
    EnrolmentID INT NOT NULL,
    EventID INT NOT NULL,
    FOREIGN KEY (EnrolmentID) REFERENCES Enrolment(EnrolmentID) ON DELETE CASCADE,
    FOREIGN KEY (EventID) REFERENCES Event(EventID)
);

-- =========================================================================
-- DATA SEEDING SECTION
-- Inserting mandatory sample data to satisfy POE rubric requirements
-- =========================================================================

-- Seeding Users: Inserting mandatory minimum 2 Organisers and 2 Participants
INSERT INTO AppUser (UserName, UserSurname, Email, PasswordHash, Role, PhoneNumber) VALUES
('John', 'Doe', 'john.doe@raceday.co.za', 'hash123', 'Organiser', '0821234567'),
('Jane', 'Smith', 'jane.smith@raceday.co.za', 'hash456', 'Organiser', '0839876543'),
('Alice', 'Johnson', 'alice.j@gmail.com', 'hash789', 'Participant', '0723456789'),
('Bob', 'Brown', 'bob.b@gmail.com', 'hash321', 'Participant', '0765432109');

-- Seeding Event Types: Adding reference types (Run, Walk, Cycle)
INSERT INTO EventType (TypeName) VALUES
('Run'),
('Walk'),
('Cycle');

-- Seeding Events: Creating 3 realistic South African sports events mapped to our organisers
INSERT INTO Event (EventName, Description, EventDate, EventLocation, Distance, EventTypeID, UserID) VALUES
('Comrades Warm-up', 'A short local road training run.', '2026-06-10 06:00:00', 'Pietermaritzburg', 10.0, 1, 1),
('Cape Cycle Tour Prep', 'Scenic coastal cycling event.', '2026-07-15 07:00:00', 'Cape Town', 35.0, 3, 1),
('Soweto Community Walk', 'Walking event through historical streets.', '2026-08-20 08:00:00', 'Soweto', 5.0, 2, 2);

-- Seeding Categories: Adding division categories for each event
INSERT INTO Category (CategoryName, Description, Age, Distance, EventID) VALUES
('Open 10km', 'Open division for runners', 'All Ages', 10.0, 1),
('Junior 10km', 'Under 20 division', 'Under 20', 10.0, 1),
('Elite 35km', 'Competitive cycling group', '18-39', 35.0, 2),
('Amateur 35km', 'General cycling participants', 'All Ages', 35.0, 2),
('Family 5km', 'Family group entry', 'All Ages', 5.0, 3);

-- Seeding Sample Enrolments: Connecting participants to events and categories
INSERT INTO Enrolment (EnrolmentDate, Status, EventID, CategoryID, UserID) VALUES
('2026-05-01 10:00:00', 'Confirmed', 1, 1, 3),
('2026-05-02 11:30:00', 'Confirmed', 2, 3, 4);

-- Seeding Sample Results: Adding completed performance details linked to enrolments
INSERT INTO Result (FinishTime, FinishPosition, PublishedDate, TotalPosition, EnrolmentID, EventID) VALUES
('00:45:30', 12, '2026-06-10 12:00:00', 150, 1, 1);

