#!/bin/bash
set -e

# --- Configuration ---
# Set your desired database user and password here.
DB_USER="philip"
DB_PASS="1234"
DB_NAME="vector_db"
# --- End Configuration ---

echo "--- Starting PostgreSQL Setup ---"

# Check if psql is installed
if ! command -v psql &> /dev/null
then
    echo "Error: psql command not found."
    echo "Please make sure PostgreSQL is installed and 'psql' is in your system's PATH."
    exit 1
fi

echo "Connecting to default 'postgres' database as user 'postgres'..."

# Execute SQL commands
# This will:
# 1. Drop the database if it already exists (for a clean start)
# 2. Drop the user (role) if it already exists
# 3. Create the new user with the specified password
# 4. Create the new database
# 5. Grant all privileges on the new database to the new user
# 6. Connect to the new database and enable the 'vector' extension
# 7. Grant permissions on the public schema to the new user

sudo -u postgres psql -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;"
sudo -u postgres psql -d postgres -c "DROP ROLE IF EXISTS $DB_USER;"
sudo -u postgres psql -d postgres -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
sudo -u postgres psql -d postgres -c "CREATE DATABASE $DB_NAME;"
sudo -u postgres psql -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

echo "Connecting to new '$DB_NAME' database as user 'postgres' to enable extension..."
sudo -u postgres psql -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS vector;"
sudo -u postgres psql -d $DB_NAME -c "GRANT ALL ON SCHEMA public TO $DB_USER;"

echo "--- PostgreSQL Setup Complete ---"
echo "Database: $DB_NAME"
echo "User:     $DB_USER"
echo "Password: $DB_PASS"
echo "Vector extension enabled."
echo "You can now start the backend server."
