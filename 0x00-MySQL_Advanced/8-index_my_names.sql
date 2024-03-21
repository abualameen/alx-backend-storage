-- Create index idx_name_first on the first letter of names
CREATE INDEX idx_name_first ON names (LEFT(name, 1));
