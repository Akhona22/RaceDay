-- RaceDay Database
-- PROG6212 Part 1
-- MySQL 8.0 Database Script

CREATE DATABASE RaceDayDB;
USE RaceDayDB;

-- =========================================
-- 1. USERS TABLE
-- =========================================
CREATE TABLE Users
(
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL,
    CHECK (Role IN ('Organiser', 'Participant'))
);

-- =========================================
-- 2. EVENT TYPE TABLE
-- =========================================
CREATE TABLE EventType
(
    EventTypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL UNIQUE
);

-- =========================================
-- 3. EVENT TABLE
-- =========================================
CREATE TABLE Event
(
    EventID INT AUTO_INCREMENT PRIMARY KEY,
    EventName VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    EventDate DATE NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Distance DECIMAL(6,2) NOT NULL,
    EventTypeID INT NOT NULL,
    OrganiserID INT NOT NULL,

    FOREIGN KEY (EventTypeID)
        REFERENCES EventType(EventTypeID),

    FOREIGN KEY (OrganiserID)
        REFERENCES Users(UserID)
);

-- =========================================
-- 4. CATEGORY TABLE
-- =========================================
CREATE TABLE Category
(
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    Distance DECIMAL(6,2) NOT NULL,
    EventID INT NOT NULL,

    FOREIGN KEY (EventID)
        REFERENCES Event(EventID)
);

-- =========================================
-- 5. ENROLMENT TABLE
-- =========================================
CREATE TABLE Enrolment
(
    EnrolmentID INT AUTO_INCREMENT PRIMARY KEY,
    ParticipantID INT NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATE NOT NULL DEFAULT (CURRENT_DATE),

    FOREIGN KEY (ParticipantID)
        REFERENCES Users(UserID),

    FOREIGN KEY (EventID)
        REFERENCES Event(EventID),

    FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID),

    UNIQUE (ParticipantID, EventID)
);

-- =========================================
-- 6. RESULT TABLE
-- =========================================
CREATE TABLE Result
(
    ResultID INT AUTO_INCREMENT PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME,
    Position INT,

    FOREIGN KEY (EnrolmentID)
        REFERENCES Enrolment(EnrolmentID),

    CHECK (Position IS NULL OR Position > 0)
);

-- =========================================
-- SEED DATA
-- =========================================

-- Add 2 Organisers and 2 Participants
INSERT INTO Users
(FirstName, LastName, Email, Password, Role)
VALUES
('Thabo', 'Mokoena', 'thabo@raceday.co.za', 'Password123', 'Organiser'),
('Naledi', 'Dlamini', 'naledi@raceday.co.za', 'Password123', 'Organiser'),
('Sipho', 'Nkosi', 'sipho@email.com', 'Password123', 'Participant'),
('Lerato', 'Molefe', 'lerato@email.com', 'Password123', 'Participant');

-- Add Event Types
INSERT INTO EventType (TypeName)
VALUES
('Running'),
('Cycling'),
('Walking');

-- Add 3 Events
INSERT INTO Event
(EventName, Description, EventDate, Location, Distance, EventTypeID, OrganiserID)
VALUES
('Johannesburg City Run', 'Annual city running event', '2026-10-10', 'Johannesburg', 21.10, 1, 1),
('Pretoria Cycle Challenge', 'Road cycling challenge', '2026-11-15', 'Pretoria', 50.00, 2, 2),
('Soweto Community Walk', 'Community walking event', '2026-12-05', 'Soweto', 10.00, 3, 1);

-- Add Categories
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

-- Add Sample Enrolments
INSERT INTO Enrolment
(ParticipantID, EventID, CategoryID, EnrolmentDate)
VALUES
(3, 1, 2, '2026-09-01'),
(4, 1, 3, '2026-09-02'),
(3, 2, 4, '2026-09-03'),
(4, 3, 7, '2026-09-03');

-- Add Sample Results
INSERT INTO Result
(EnrolmentID, FinishTime, Position)
VALUES
(1, '00:52:30', 5),
(2, '01:58:42', 12);

-- =========================================
-- TEST / DISPLAY DATA
-- =========================================

SELECT * FROM Users;
SELECT * FROM EventType;
SELECT * FROM Event;
SELECT * FROM Category;
SELECT * FROM Enrolment;
SELECT * FROM Result;