-- Initial setup: Import table dump and create table structure

-- Create index idx_name_first_score on the first letter of names and score
CREATE INDEX idx_name_first_score ON names (LEFT(name, 1), score);
