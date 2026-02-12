# PenguinDB - Database Management System
## Technical Documentation

**Version 1.0**

**Developed by:**
- Ahmed Ibrahim Elemam
- Ibrahim Mohamed Eita

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [System Architecture](#system-architecture)
3. [Installation Guide](#installation-guide)
4. [User Guide](#user-guide)
5. [Technical Specifications](#technical-specifications)
6. [Code Structure and Functions](#code-structure-and-functions)
7. [API Reference](#api-reference)
8. [Troubleshooting](#troubleshooting)
9. [Appendix](#appendix)

---

## 1. Executive Summary

PenguinDB is a lightweight, file-based Database Management System (DBMS) built entirely in Bash shell scripting. It provides a terminal-based interactive interface using the dialog utility, allowing users to create and manage databases and tables without requiring complex database server installations.

### 1.1 Key Features

- Zero-dependency database system written entirely in Bash
- Interactive terminal UI using dialog menus
- Full CRUD operations (Create, Read, Update, Delete)
- Data type validation (int, string, float)
- Primary key constraints
- File-based storage using delimiter-separated format
- Portable and lightweight architecture

### 1.2 Use Cases

- Educational tool for learning database concepts
- Lightweight data storage for shell scripts
- Embedded database for terminal applications
- Prototyping and testing database schemas

---

## 2. System Architecture

### 2.1 Directory Structure

```
.
├── dbms.sh                 # Main entry point
├── core/                   # Core system modules
│   ├── config.sh           # Configuration settings
│   ├── utils.sh            # Utility functions
│   ├── validate.sh         # Validation logic
│   ├── main/               # Database operations
│   │   ├── create_database.sh
│   │   ├── list_databases.sh
│   │   ├── connect_database.sh
│   │   └── drop_database.sh
│   ├── db/                 # Table operations
│   │   ├── create_table.sh
│   │   ├── list_tables.sh
│   │   ├── drop_table.sh
│   │   ├── insert_into_table.sh
│   │   ├── select_from_table.sh
│   │   ├── delete_from_table.sh
│   │   └── update_table.sh
│   └── menus/              # User interface menus
│       ├── main_menu.sh
│       └── db_menu.sh
├── data/                   # Data storage directory
└── README.md               # Project documentation
```

### 2.2 Component Overview

| Component | Description |
|-----------|-------------|
| **dbms.sh** | Main entry point that loads all modules and initializes the system |
| **config.sh** | Global configuration including data directory path and field delimiter |
| **utils.sh** | UI utilities (dialog wrappers), path helpers, and formatting functions |
| **validate.sh** | Data validation functions for types, names, and constraints |
| **main/** | Database-level operations (create, drop, list, connect) |
| **db/** | Table-level operations (create, drop, insert, select, update, delete) |
| **menus/** | Interactive menu systems for main and database contexts |

### 2.3 Data Storage Model

PenguinDB uses a file-based storage system with the following structure:

- Each database is a directory under `data/`
- Each table has two files: `.meta` (schema) and `.data` (records)
- Metadata files store column definitions in format: `column:type:pk_flag`
- Data files use pipe (`|`) delimiter for field separation

**Example storage structure:**

```
data/
└── mydb/
    ├── meta/
    │   └── users.meta      # Column definitions
    └── users.data          # Actual records
```

---

## 3. Installation Guide

### 3.1 System Requirements

| Requirement | Specification |
|-------------|---------------|
| **Operating System** | Linux/Unix-based systems (Ubuntu, Debian, CentOS, macOS) |
| **Shell** | Bash 4.0 or higher |
| **Dialog Utility** | dialog package (for interactive UI) |
| **Disk Space** | Minimal (<1MB for application, variable for data) |
| **Permissions** | Read/write access to installation directory |

### 3.2 Installation Steps

**Step 1: Install Dialog Utility**

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install dialog

# CentOS/RHEL
sudo yum install dialog

# macOS
brew install dialog
```

**Step 2: Clone or Download PenguinDB**

```bash
# Clone from repository (if using git)
git clone <repository-url> penguindb
cd penguindb

# Or extract from archive
unzip penguindb.zip
cd penguindb
```

**Step 3: Set Execute Permissions**

```bash
chmod +x dbms.sh
chmod +x core/main/*.sh
chmod +x core/db/*.sh
chmod +x core/menus/*.sh
```

**Step 4: Launch PenguinDB**

```bash
./dbms.sh
```

### 3.3 Optional: Add to System PATH

To run PenguinDB from anywhere, create a symbolic link:

```bash
sudo ln -s $(pwd)/dbms.sh /usr/local/bin/penguindb

# Now you can run from anywhere
penguindb
```

---

## 4. User Guide

### 4.1 Main Menu

Upon launching PenguinDB, users are presented with the main menu containing the following options:

| Option | Description |
|--------|-------------|
| **Create Database** | Create a new database with a unique name |
| **List Databases** | Display all existing databases |
| **Connect To Database** | Connect to an existing database to perform table operations |
| **Drop Database** | Delete a database and all its tables (with confirmation) |
| **Exit** | Exit the application |

### 4.2 Database Menu

After connecting to a database, users can perform the following table operations:

| Operation | Description |
|-----------|-------------|
| **Create Table** | Define a new table with columns, data types, and primary key |
| **List Tables** | Show all tables in the current database |
| **Drop Table** | Delete a table and all its data (with confirmation) |
| **Insert Into Table** | Add new records with validated data types |
| **Select From Table** | View all records or search by primary key |
| **Delete From Table** | Remove a record by primary key (with confirmation) |
| **Update Record** | Modify existing record fields (except primary key) |
| **Back** | Return to the main menu |

### 4.3 Creating a Database

Follow these steps to create a new database:

1. Select 'Create Database' from the main menu
2. Enter a database name (must start with letter/underscore, contain only alphanumeric characters and underscores)
3. System validates the name and creates the database directory structure
4. Confirmation message displays upon successful creation

### 4.4 Creating a Table

To create a table within a database:

1. Connect to a database from the main menu
2. Select 'Create Table' from the database menu
3. Enter a table name (following same naming rules as databases)
4. Specify the number of columns
5. For each column:
   - Enter column name
   - Choose data type (int, string, or float)
   - Designate if this column is the primary key
6. Exactly one column must be designated as the primary key
7. System creates the table metadata and data files

### 4.5 Inserting Records

To insert data into a table:

1. Select 'Insert Into Table' from the database menu
2. Choose the target table
3. For each column, enter a value:
   - System validates the data type
   - Primary key must be unique and cannot be empty
   - Values cannot contain the pipe (`|`) delimiter
4. Record is added to the table upon successful validation

### 4.6 Querying Records

PenguinDB provides two query options:

**Select All:**
- Displays all records in a formatted table view
- Shows column headers with data aligned underneath
- Indicates if table is empty

**Select By Primary Key:**
- Enter the primary key value to search for
- Returns only matching record(s)
- Displays in the same formatted table view

### 4.7 Updating Records

To modify existing records:

1. Select 'Update Record' from the database menu
2. Choose the table to update
3. Enter the primary key of the record to update
4. For each field:
   - Enter a new value to update the field
   - Leave empty to keep the existing value
   - Primary key cannot be modified
5. Updated record is validated and saved

### 4.8 Deleting Records

To remove records from a table:

1. Select 'Delete From Table' from the database menu
2. Choose the table
3. Enter the primary key of the record to delete
4. Confirm the deletion when prompted
5. Record is permanently removed from the table

---

## 5. Technical Specifications

### 5.1 Data Types

| Type | Validation Pattern | Examples |
|------|-------------------|----------|
| **int** | `^-?[0-9]+$` | 42, -17, 0, 1000 |
| **float** | `^-?[0-9]+([.][0-9]+)?$` | 3.14, -0.5, 2.0, 99.99 |
| **string** | Any text (no pipe delimiter) | John Doe, hello@example.com |

### 5.2 Naming Conventions

Database and table names must follow these rules:

- Must start with a letter (A-Z, a-z) or underscore (_)
- Can contain letters, numbers, and underscores
- No spaces allowed (automatically converted to underscores)
- Case-sensitive on most file systems
- Validated using pattern: `^[A-Za-z_][A-Za-z0-9_]*$`

### 5.3 File Format Specifications

**Metadata File Format (.meta):**

Each line represents a column definition in the format:

```
column_name:data_type:pk_flag
```

Where:
- `column_name`: Name of the column
- `data_type`: One of int, string, or float
- `pk_flag`: 1 if primary key, 0 otherwise

**Example metadata file:**

```
id:int:1
name:string:0
age:int:0
salary:float:0
```

**Data File Format (.data):**

Each line represents a record with fields separated by the pipe (`|`) delimiter:

```
field1|field2|field3|...
```

**Example data file:**

```
1|John Doe|30|50000.50
2|Jane Smith|25|45000.00
3|Bob Johnson|35|60000.75
```

### 5.4 Constraints and Limitations

| Constraint | Description |
|------------|-------------|
| **Primary Key Requirement** | Every table must have exactly one primary key column |
| **Primary Key Uniqueness** | Primary key values must be unique across all records |
| **Primary Key Nullability** | Primary key cannot be empty or null |
| **Delimiter Restriction** | Field values cannot contain the pipe (`|`) delimiter |
| **Update Restriction** | Primary key values cannot be updated after insertion |
| **Data Type Validation** | All values must match their column's declared type |
| **No Foreign Keys** | Referential integrity not enforced |
| **No Transactions** | ACID properties not supported |

---

## 6. Code Structure and Functions

### 6.1 Core Functions

**utils.sh - User Interface Functions:**

| Function | Purpose |
|----------|---------|
| `ui_msg()` | Display informational message box |
| `ui_error()` | Display error message box |
| `ui_input()` | Get text input from user with optional default value |
| `ui_yesno()` | Display yes/no confirmation dialog |
| `ui_menu()` | Display selection menu with multiple options |
| `ui_textbox()` | Display content from file in scrollable text box |

**utils.sh - Helper Functions:**

| Function | Purpose |
|----------|---------|
| `normalize_name()` | Trim whitespace and replace spaces with underscores |
| `valid_name()` | Validate name against naming rules |
| `db_path()` | Return full path to database directory |
| `meta_dir()` | Return path to metadata directory |
| `table_meta()` | Return path to table metadata file |
| `table_data()` | Return path to table data file |
| `db_exists()` | Check if database exists |
| `table_exists()` | Check if table exists |
| `value_has_delim()` | Check if value contains delimiter |
| `build_db_menu_items()` | Build array of database names for menu |
| `build_table_menu_items()` | Build array of table names for menu |
| `format_table_to_file()` | Format table data for display with aligned columns |

**validate.sh - Validation Functions:**

| Function | Purpose |
|----------|---------|
| `is_valid_type()` | Check if type is int, string, or float |
| `check_value_type()` | Validate value matches specified data type |
| `read_meta()` | Parse metadata file into arrays (cols, types, pkIndex) |
| `pk_exists()` | Check if primary key value exists in table |

### 6.2 Operation Flow Diagrams

**Insert Operation Flow:**

1. User selects table
2. System reads table metadata
3. For each column:
   - Prompt user for value
   - Validate data type
   - Check for delimiter presence
   - Verify primary key uniqueness (if applicable)
   - Store value in array
4. Concatenate values with delimiter
5. Append record to data file
6. Display success message

**Select Operation Flow:**

1. User selects table
2. System reads table metadata
3. User chooses query type (All or By Primary Key)
4. If By Primary Key:
   - Get primary key value from user
   - Filter data file using awk
5. Format results with column headers
6. Display in textbox viewer

**Update Operation Flow:**

1. User selects table
2. System reads table metadata
3. User provides primary key of record to update
4. System verifies record exists
5. For each non-PK column:
   - Prompt for new value (empty = keep existing)
   - Validate data type if value provided
6. Use awk to update matching record
7. Write updated data to temporary file
8. Replace original data file
9. Display success message

**Delete Operation Flow:**

1. User selects table
2. System reads table metadata
3. User provides primary key of record to delete
4. System verifies record exists
5. User confirms deletion
6. Use awk to filter out matching record
7. Write filtered data to temporary file
8. Replace original data file
9. Display success message

---

## 7. API Reference

### 7.1 Configuration Variables

```bash
# config.sh
DATA_DIR="$PROJECT_DIR/data"    # Root directory for all databases
DELIM="|"                        # Field delimiter for data files
```

### 7.2 Global Variables

```bash
APP_NAME="PenguinDB"            # Application name displayed in UI
APP_VER="v1.0"                  # Application version
PROJECT_DIR                     # Base directory of installation
CORE_DIR                        # Directory containing core modules
```

### 7.3 Metadata Arrays

After calling `read_meta()`, the following arrays are populated:

```bash
cols=()        # Array of column names
types=()       # Array of data types
pkIndex=-1     # Index of primary key column (0-based)
```

### 7.4 Key Code Patterns

**Reading Metadata:**

```bash
read_meta "$meta_file"
# Now cols[], types[], and pkIndex are available

# Example usage:
for i in "${!cols[@]}"; do
  echo "Column: ${cols[$i]}, Type: ${types[$i]}"
  if [[ "$i" -eq "$pkIndex" ]]; then
    echo "  ^ This is the primary key"
  fi
done
```

**Validating Input:**

```bash
# Validate data type
if check_value_type "int" "$user_input"; then
  echo "Valid integer"
fi

# Validate name
if valid_name "$db_name"; then
  echo "Valid database name"
fi

# Check for delimiter
if value_has_delim "$value"; then
  echo "Error: Value contains delimiter"
fi
```

**Primary Key Operations:**

```bash
# Check if PK exists
if pk_exists "$data_file" "$pkIndex" "$pk_value"; then
  echo "Primary key found"
else
  echo "Primary key not found"
fi
```

**AWK Patterns for Data Manipulation:**

```bash
# Select by primary key
awk -F"$DELIM" -v idx="$((pkIndex+1))" -v val="$pkval" \
  '($idx==val){print}' "$data_file"

# Delete by primary key
awk -F"$DELIM" -v idx="$((pkIndex+1))" -v val="$pkval" \
  '($idx!=val){print}' "$data_file"

# Update record
awk -F"$DELIM" -v OFS="$DELIM" \
  -v pkcol="$((pkIndex+1))" -v pk="$pkval" \
  -v n="${#cols[@]}" \
  -v upd="$(IFS=$'\t'; echo "${updates[*]}")" '
  BEGIN { split(upd, u, "\t") }
  {
    if ($pkcol == pk) {
      for (i = 1; i <= n; i++) {
        if (i != pkcol && u[i] != "") $i = u[i]
      }
    }
    print
  }' "$data_file"
```

---

## 8. Troubleshooting

### 8.1 Common Issues

**Issue: "dialog is not installed" error**

**Solution:**
```bash
# Install dialog package
sudo apt update && sudo apt install dialog  # Ubuntu/Debian
sudo yum install dialog                      # CentOS/RHEL
brew install dialog                          # macOS
```

**Issue: Permission denied when running dbms.sh**

**Solution:**
```bash
# Make the script executable
chmod +x dbms.sh
chmod +x core/**/*.sh
```

**Issue: "No databases found" but databases exist**

**Solution:**
- Check that the `data/` directory exists in the project root
- Verify database directories are not hidden
- Ensure proper read permissions on the data directory

**Issue: Data appears corrupted or misaligned**

**Solution:**
- Check that values don't contain the pipe (`|`) delimiter
- Verify metadata file matches data file structure
- Ensure no manual editing introduced formatting errors

**Issue: Cannot update primary key**

**Solution:**
- Primary keys are immutable by design
- To change a primary key, delete the record and insert a new one

### 8.2 Data Recovery

**Backup Databases:**

```bash
# Backup entire data directory
tar -czf penguindb_backup_$(date +%Y%m%d).tar.gz data/

# Backup specific database
tar -czf mydb_backup.tar.gz data/mydb/
```

**Restore Databases:**

```bash
# Restore from backup
tar -xzf penguindb_backup_20260212.tar.gz
```

**Manual Data Repair:**

If data files become corrupted:

1. Locate the `.data` and `.meta` files in `data/database_name/`
2. Verify metadata format: `column:type:pk_flag`
3. Verify data format: `value1|value2|value3`
4. Ensure field count matches column count
5. Remove any lines with formatting issues

### 8.3 Performance Considerations

**Large Tables:**

- PenguinDB uses sequential file scanning
- Performance degrades with tables > 10,000 records
- Consider splitting large datasets across multiple tables

**Frequent Updates:**

- Each operation rewrites the entire data file
- High-frequency updates may cause performance issues
- Batch operations when possible

---

## 9. Appendix

### 9.1 Example Workflows

**Creating a Complete Employee Database:**

```bash
# 1. Launch PenguinDB
./dbms.sh

# 2. Create database (via UI)
Select: Create Database
Enter: employees_db

# 3. Connect to database
Select: Connect To Database
Choose: employees_db

# 4. Create employees table
Select: Create Table
Table name: employees
Number of columns: 5

Column 1:
  Name: emp_id
  Type: int
  Primary Key: Yes

Column 2:
  Name: first_name
  Type: string
  Primary Key: No

Column 3:
  Name: last_name
  Type: string
  Primary Key: No

Column 4:
  Name: department
  Type: string
  Primary Key: No

Column 5:
  Name: salary
  Type: float
  Primary Key: No

# 5. Insert records
Select: Insert Into Table
emp_id: 1
first_name: John
last_name: Doe
department: Engineering
salary: 75000.00

# Repeat for additional employees
```

**Querying and Updating:**

```bash
# View all employees
Select: Select From Table
Choose: employees
Option: Select All

# Find specific employee
Select: Select From Table
Choose: employees
Option: Select By Primary Key
emp_id: 1

# Update salary
Select: Update Record
Choose: employees
emp_id: 1
first_name: [press Enter to keep]
last_name: [press Enter to keep]
department: [press Enter to keep]
salary: 80000.00
```

### 9.2 File Structure Examples

**Example Database Directory:**

```
data/company/
├── meta/
│   ├── employees.meta
│   ├── departments.meta
│   └── projects.meta
├── employees.data
├── departments.data
└── projects.data
```

**Sample employees.meta:**

```
emp_id:int:1
first_name:string:0
last_name:string:0
email:string:0
hire_date:string:0
salary:float:0
```

**Sample employees.data:**

```
101|Alice|Smith|alice.smith@company.com|2020-01-15|65000.00
102|Bob|Johnson|bob.j@company.com|2019-06-20|72000.50
103|Carol|Williams|carol.w@company.com|2021-03-10|58000.00
104|David|Brown|david.brown@company.com|2018-11-05|81000.75
```

### 9.3 Best Practices

**Naming Conventions:**
- Use descriptive, lowercase names: `customer_orders` instead of `co`
- Prefix related tables: `sales_orders`, `sales_items`, `sales_customers`
- Avoid reserved words or special characters

**Data Type Selection:**
- Use `int` for whole numbers, IDs, counts
- Use `float` for decimal numbers, prices, measurements
- Use `string` for text, dates (store as YYYY-MM-DD), emails

**Schema Design:**
- Choose natural primary keys when possible (email, employee_id)
- Keep tables focused on single entities
- Document your schema in comments or separate files

**Data Integrity:**
- Validate input before insertion
- Use consistent date formats (YYYY-MM-DD)
- Backup regularly before major changes
- Test queries on sample data first

**Performance:**
- Index frequently queried primary keys
- Avoid storing large text blocks
- Split large tables into smaller, related tables
- Archive old data periodically

### 9.4 Advanced Usage

**Scripting with PenguinDB:**

You can source PenguinDB modules in your own scripts:

```bash
#!/usr/bin/env bash

# Source PenguinDB modules
PENGUINDB_DIR="/path/to/penguindb"
source "$PENGUINDB_DIR/core/config.sh"
source "$PENGUINDB_DIR/core/utils.sh"
source "$PENGUINDB_DIR/core/validate.sh"

# Use PenguinDB functions
db="mydb"
table="users"

meta_file="$(table_meta "$db" "$table")"
data_file="$(table_data "$db" "$table")"

# Read metadata
read_meta "$meta_file"

# Query data programmatically
awk -F"$DELIM" '{print $1, $2}' "$data_file"
```

**Batch Data Import:**

```bash
# Create CSV import script
while IFS=',' read -r id name email; do
  echo "$id|$name|$email" >> data/mydb/users.data
done < import.csv
```

**Automated Backups:**

```bash
#!/usr/bin/env bash
# backup_penguindb.sh

BACKUP_DIR="/backups/penguindb"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/penguindb_$TIMESTAMP.tar.gz" \
  -C /path/to/penguindb data/

# Keep only last 7 days
find "$BACKUP_DIR" -name "penguindb_*.tar.gz" -mtime +7 -delete
```

### 9.5 Future Enhancements

Potential improvements for future versions:

- **Indexing:** B-tree indexes for faster lookups
- **Foreign Keys:** Referential integrity constraints
- **Transactions:** ACID compliance with rollback capability
- **Query Language:** SQL-like query syntax
- **Export/Import:** CSV and JSON format support
- **Backup Utilities:** Built-in backup and restore commands
- **User Management:** Multi-user access control
- **Encryption:** Data-at-rest encryption
- **Compression:** Automatic data compression for large tables
- **Web Interface:** Browser-based management console

### 9.6 License and Credits

**License:** MIT License (or specify your license)

**Authors:**
- Ahmed Ibrahim Elemam
- Ibrahim Mohamed Eita

**Dependencies:**
- Bash (GNU Bash 4.0+)
- Dialog utility for terminal UI

**Acknowledgments:**
- Built as an educational project to demonstrate database concepts
- Inspired by traditional RDBMS systems
- Uses standard Unix tools (awk, grep, sed) for data manipulation

---

**Document Version:** 1.0  
**Last Updated:** February 12, 2026  
**Document Status:** Final

---

**End of Documentation**