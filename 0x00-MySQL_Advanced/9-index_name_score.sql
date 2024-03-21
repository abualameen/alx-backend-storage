-- Import the SQL dump file to create the 'names' table
mysql -u root -p holberton < names.sql

-- Create the index idx_name_first_score on the table 'names' for the first letter of name and score
USE holberton;
CREATE INDEX idx_name_first_score ON names (LEFT(name, 1), score);
