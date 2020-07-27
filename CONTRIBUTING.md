# Contributions are welcome

When Contributing, there are a few preliminary checks you may do before submitting a patch

1. Install `pre-commit` and run locally on your branch
2. Run `super-linter` locally to make sure changes do not break the current build, `docker run -e RUN_LOCAL=true -v /Users/artem/Documents/cockroach-work/cockroach-docker/cockroach-gssapi-nodejs:/tmp/lint github/super-linter`
