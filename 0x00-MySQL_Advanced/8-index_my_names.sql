-- Create index idx_name_first on the first letter of names
ALTER TABLE names
ADD first_letter CHAR(1) GENERATED ALWAYS AS (LEFT(name, 1)) STORED,
ADD INDEX idx_name_first (first_letter);
