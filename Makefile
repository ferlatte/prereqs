SHELL = /bin/bash
PRE-COMMIT := $(shell which pre-commit)
# The test_runner needs this in order to find its shell libraries.
export LIB_DIR := $(shell pwd)/lib

.PHONY: all
all: .prereqs.make-step pre-commit test

.PHONY: test
test:
	pushd tests > /dev/null && ./test_runner -s /bin/bash

.PHONY: clean
clean:
	$(RM) -f .*.make-step

# Shortcut to run pre-commit hooks over the entire repo.
.PHONY: pre-commit
pre-commit: .git/hooks/pre-commit
	$(PRE-COMMIT) run --all-files

# Update the pre-commit hooks if the pre-commit binary is updated.
.git/hooks/pre-commit: $(PRE-COMMIT)
	pre-commit install

# Re-check prereqs if the prereqs configuration is newer than the last time
# we checked.
.prereqs.make-step: README.md bin/prereqs
	bin/prereqs -r README.md
	touch $@
