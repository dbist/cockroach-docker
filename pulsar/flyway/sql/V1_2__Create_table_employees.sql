CREATE TABLE example.employees (
     dog_id INT REFERENCES example.office_dogs (id),
     employee_name STRING);
