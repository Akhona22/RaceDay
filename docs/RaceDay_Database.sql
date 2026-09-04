-- =====================================================
-- RaceDay Database
-- PROG6212 Programming 2B - Part 1
-- SQL Server Database Script
-- =====================================================

CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

-- =====================================================
-- 1. USERS TABLE
-- Stores Organisers and Participants
-- =====================================================

CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL,

    CONSTRAINT CHK_UserRole
        CHECK (Role IN ('Organiser', 'Participant'))
);
GO


-- =====================================================
-- 2. EVENT TYPE TABLE
-- Stores the different types of RaceDay events
-- =====================================================

CREATE TABLE EventType
(
    EventTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL UNIQUE
);
GO


-- =====================================================
-- 3. EVENT TABLE
-- Stores RaceDay event information
-- =====================================================

CREATE TABLE Event
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    EventDate DATE NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Distance DECIMAL(6,2) NOT NULL,
    EventTypeID INT NOT NULL,
    OrganiserID INT NOT NULL,

    CONSTRAINT FK_Event_EventType
        FOREIGN KEY (EventTypeID)
        REFERENCES EventType(EventTypeID),

    CONSTRAINT FK_Event_Organiser
        FOREIGN KEY (OrganiserID)
        REFERENCES Users(UserID)
);
GO


-- =====================================================
-- 4. CATEGORY TABLE
-- Stores categories belonging to events
-- =====================================================

CREATE TABLE Category
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    Distance DECIMAL(6,2) NOT NULL,
    EventID INT NOT NULL,

    CONSTRAINT FK_Category_Event
        FOREIGN KEY (EventID)
        REFERENCES Event(EventID)
);
GO


-- =====================================================
-- 5. ENROLMENT TABLE
-- Stores participant event enrolments
-- =====================================================

CREATE TABLE Enrolment
(
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATE NOT NULL
        CONSTRAINT DF_EnrolmentDate
        DEFAULT CAST(GETDATE() AS DATE),

    CONSTRAINT FK_Enrolment_Participant
        FOREIGN KEY (ParticipantID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Enrolment_Event
        FOREIGN KEY (EventID)
        REFERENCES Event(EventID),

    CONSTRAINT FK_Enrolment_Category
        FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID),

    CONSTRAINT UQ_Participant_Event
        UNIQUE (ParticipantID, EventID)
);
GO


-- =====================================================
-- 6. RESULT TABLE
-- Stores participant race results
-- =====================================================

CREATE TABLE Result
(
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME,
    Position INT,

    CONSTRAINT FK_Result_Enrolment
        FOREIGN KEY (EnrolmentID)
        REFERENCES Enrolment(EnrolmentID),

    CONSTRAINT CHK_ResultPosition
        CHECK (Position IS NULL OR Position > 0)
);
GO


-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Two Organisers and Two Participants

INSERT INTO Users
(FirstName, LastName, Email, Password, Role)
VALUES
('Thabo', 'Mokoena', 'thabo@raceday.co.za', 'Password123', 'Organiser'),
('Naledi', 'Dlamini', 'naledi@raceday.co.za', 'Password123', 'Organiser'),
('Sipho', 'Nkosi', 'sipho@email.com', 'Password123', 'Participant'),
('Lerato', 'Molefe', 'lerato@email.com', 'Password123', 'Participant');
GO


-- Event Types

INSERT INTO EventType
(TypeName)
VALUES
('Running'),
('Cycling'),
('Walking');
GO


-- Three Events

INSERT INTO Event
(EventName, Description, EventDate, Location, Distance, EventTypeID, OrganiserID)
VALUES
('Johannesburg City Run',
 'Annual city running event',
 '2026-10-10',
 'Johannesburg',
 21.10,
 1,
 1),

('Pretoria Cycle Challenge',
 'Road cycling challenge',
 '2026-11-15',
 'Pretoria',
 50.00,
 2,
 2),

('Soweto Community Walk',
 'Community walking event',
 '2026-12-05',
 'Soweto',
 10.00,
 3,
 1);
GO


-- Categories for the Events

INSERT INTO Category
(CategoryName, Distance, EventID)
VALUES
('5 KM Run', 5.00, 1),
('10 KM Run', 10.00, 1),
('Half Marathon', 21.10, 1),

('20 KM Cycle', 20.00, 2),
('50 KM Cycle', 50.00, 2),

('5 KM Walk', 5.00, 3),
('10 KM Walk', 10.00, 3);
GO


-- Sample Participant Enrolments

INSERT INTO Enrolment
(ParticipantID, EventID, CategoryID, EnrolmentDate)
VALUES
(3, 1, 2, '2026-09-01'),
(4, 1, 3, '2026-09-02'),
(3, 2, 4, '2026-09-03'),
(4, 3, 7, '2026-09-03');
GO


-- Sample Results

INSERT INTO Result
(EnrolmentID, FinishTime, Position)
VALUES
(1, '00:52:30', 5),
(2, '01:58:42', 12);
GO


-- =====================================================
-- VERIFY SAMPLE DATA
-- =====================================================

SELECT * FROM Users;
SELECT * FROM EventType;
SELECT * FROM Event;
SELECT * FROM Category;
SELECT * FROM Enrolment;
SELECT * FROM Result;
GO