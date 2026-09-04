# RaceDay

RaceDay is an event management system designed to help organisers manage events, categories, participant enrolments and race results.

This repository contains the planning and database work for PROG6212 Programming 2B Part 1.

## User Roles

### Organiser
An Organiser can create, update and delete events, manage event categories, view participant enrolments, capture participant results and view the events they manage.

### Participant
A Participant can create an account, log in, browse available events, enter an event, select a category and view their own enrolments and results.
## Database Setup

The RaceDay database script is located in the `docs` folder as `RaceDay_Database.sql`.

The current Part 1 database was created and tested using MySQL 8.0.

To set up the database:

1. Open MySQL 8.0.
2. Run the `RaceDay_Database.sql` script.
3. The script creates the RaceDay database tables and relationships.
4. The script inserts sample data for organisers, participants, events, categories, enrolments and results.
5. Run the included SELECT statements to verify the inserted data.
