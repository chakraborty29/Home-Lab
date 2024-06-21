PRECOMMIT_VERSION="3.7.1"

.PHONY: all check-python check-docker install-pre-commit docker-pull-kics install-hooks autoupdate run-all-files clean

all: check-python check-docker install-pre-commit docker-pull-kics install-hooks

check-python:
	@echo "Checking for python3..."
	@command -v python3 >/dev/null 2>&1 || { echo >&2 "Python3 is not installed. Please install Python3 to continue."; exit 1; }

check-docker:
	@echo "Checking for docker..."
	@command -v docker >/dev/null 2>&1 || { echo >&2 "Docker is not installed. Please install Docker to continue."; exit 1; }

install-pre-commit:
	@echo "Checking for pre-commit..."
	@python3 pre-commit.pyz --version >/dev/null 2>&1 || { echo >&2 "Installing 'pre-commit'..."; wget -O pre-commit.pyz https://github.com/pre-commit/pre-commit/releases/download/v${PRECOMMIT_VERSION}/pre-commit-${PRECOMMIT_VERSION}.pyz; }

docker-pull-kics:
	docker pull checkmarx/kics:latest

install-hooks:
	python3 pre-commit.pyz install

autoupdate:
	python3 pre-commit.pyz autoupdate

run-all-files:
	python3 pre-commit.pyz run --all-files

clean:
	python3 pre-commit.pyz uninstall
	rm pre-commit.pyz