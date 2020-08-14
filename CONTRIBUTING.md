# Contributions are welcome

When Contributing, there are a few preliminary checks you may do before submitting a patch

1. Install `pre-commit` and run locally on your branch
2. Run `super-linter` locally to make sure changes do not break the current build, `docker run -e RUN_LOCAL=true -v /Users/artem/Documents/cockroach-work/cockroach-docker/cockroach-gssapi-nodejs:/tmp/lint github/super-linter`
run pylint manually ************* Module myproject.migrations.0001_initial
myproject/migrations/0001_initial.py:1:0: C0103: Module name "0001_initial" doesn't conform to snake_case naming style (invalid-name)
myproject/migrations/0001_initial.py:1:0: C0114: Missing module docstring (missing-module-docstring)
myproject/migrations/0001_initial.py:7:0: C0115: Missing class docstring (missing-class-docstring)

------------------------------------------------------------------
Your code has been rated at 5.00/10 (previous run: 5.00/10, +0.00)
run flake8 manually myproject/settings.py:99:80: E501 line too long (91 > 79 characters)
myproject/settings.py:102:80: E501 line too long (81 > 79 characters)
myproject/settings.py:105:80: E501 line too long (82 > 79 characters)
myproject/settings.py:108:80: E501 line too long (83 > 79 characters)
myproject/views.py:16:80: E501 line too long (101 > 79 characters)
myproject/views.py:26:80: E501 line too long (97 > 79 characters)
run sql-lint with create-changefeed.sql:19 [sql-lint: invalid-create-option] Option 'changefeed' is not a valid option, must be one of '["algorithm","database","definer","event","function","index","or","procedure","server","table","tablespace","temporary","trigger","user","unique","view"]'.
:19 [sql-lint: invalid-create-option] Option 'changefeed' is not a valid option, must be one of '["algorithm","database","definer","event","function","index","or","procedure","server","table","tablespace","temporary","trigger","user","unique","view"]'.
run sql-lint with config cockroach-minio/create-changefeed.sql:19 [sql-lint: invalid-create-option] Option 'changefeed' is not a valid option, must be one of '["algorithm","database","definer","event","function","index","or","procedure","server","table","tablespace","temporary","trigger","user","unique","view"]'.
:19 [sql-lint: invalid-create-option] Option 'changefeed' is not a valid option, must be one of '["algorithm","database","definer","event","function","index","or","procedure","server","table","tablespace","temporary","trigger","user","unique","view"]'.
