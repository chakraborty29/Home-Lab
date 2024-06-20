PRECOMMIT_VERSION="3.7.1"

.PHONY: all check-python install-pre-commit install-hooks autoupdate run-all-files clean

all: check-python install-pre-commit install-hooks

check-python:
	@command -v python3 >/dev/null 2>&1 || { echo >&2 "Python3 is not installed. Please install Python3 to continue."; exit 1; }

install-pre-commit:
	@command -v pre-install >/dev/null 2>&1 || { echo >&2 "Installing 'pre-commit'..."; wget -O pre-commit.pyz https://github.com/pre-commit/pre-commit/releases/download/v${PRECOMMIT_VERSION}/pre-commit-${PRECOMMIT_VERSION}.pyz; }

install-hooks:
	python3 pre-commit.pyz install

autoupdate:
	python3 pre-commit.pyz autoupdate

run-all-files:
	python3 pre-commit.pyz run --all-files

clean:
	rm pre-commit.pyz