DROP TABLE IF EXISTS countries;

IMPORT
TABLE
    countries (
        id INT8 PRIMARY KEY, country STRING,
        INDEX country_idx (country)
    )
CSV
    DATA ('http://10.0.4.56:8000/data.csv')
WITH skip = '1';
