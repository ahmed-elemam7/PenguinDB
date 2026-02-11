🐧 PenguinDB
A File-Based DBMS Implemented in Bash with Dialog GUI

PenguinDB is a lightweight file-based Database Management System implemented entirely in Bash scripting.
It provides a structured database environment using the Linux file system as storage and a dialog-based GUI for user interaction.

This project demonstrates core DBMS concepts including schema definition, primary key enforcement, datatype validation, and CRUD operations.

👨‍💻 Authors

Ibrahim Eita - Ahmed Elemam

🎯 Project Objective

The goal of PenguinDB is to simulate the behavior of a relational DBMS while storing data directly on disk using only Bash scripting and enforcing data integrity rules.

🧱 System Architecture

PenguinDB contains:

dbms.sh (Entry point)

core folder (Contains logic and operations)

data folder (Stores databases)

The core folder includes configuration files, validation logic, menu handling, and database/table operations.

💾 Storage Design

Each database is stored as a directory inside the data folder.

Each table consists of two files:

A meta file that stores the schema definition in the format:
column_name:datatype:isPrimaryKey

A data file that stores actual records separated by the delimiter |

🧠 Supported Datatypes

PenguinDB supports:

int

float

string

🔐 Data Integrity Rules

The system enforces:

Valid naming conventions

Exactly one Primary Key per table

Primary Key uniqueness

Datatype validation on insert and update

Prevention of Primary Key modification

No delimiter allowed inside values

🖥 GUI Interface

PenguinDB uses dialog to provide:

Interactive menus

Input forms

Confirmation dialogs

Error messages

Table viewers

⚙️ Installation

Install dialog on Ubuntu or WSL using the package manager before running the system.

▶️ Running the System

Navigate to the project directory, make the main script executable, then run it.

📌 Implemented Operations

Database Operations:

Create Database

List Databases

Connect To Database

Drop Database

Table Operations:

Create Table

List Tables

Drop Table

Insert Into Table

Select From Table

Delete From Table

Update Table
