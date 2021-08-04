# \ var
MODULE  = $(notdir $(CURDIR))
OS      = $(shell uname -s)
MACHINE = $(shell uname -m)
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
CORES   = $(shell grep processor /proc/cpuinfo| wc -l)
# / var

# \ dir
CWD     = $(CURDIR)
BIN     = $(CWD)/bin
DOC     = $(CWD)/doc
SRC     = $(CWD)/src
TMP     = $(CWD)/tmp
# / dir

# \ tool
CURL    = curl -L -o
JAVA    = java
JAVAC   = javac
GRADLE  = gradle
# / tool

# \ src
J += $(shell find src -type f -regex ".+.java$$")
F += $(shell find lib -type f -regex ".+.f$$")
# / src

# \ all
.PHONY: all
all: bin/main.class
	$(JAVA) -cp bin main $(F)

.PHONY: repl
repl:

.PHONY: test
test:

.PHONY: format
format: tmp/format
tmp/format:
	touch $@
# / all

# \ rule
bin/%.class: src/%.java
	$(JAVAC) -d bin $<
# / rule

# \ doc
.PHONY: doc
doc:

.PHONY: doxy
doxy: doxy.gen
	doxygen $< 1>/dev/null
# / doc

# \ install
.PHONY: install update
install: $(OS)_install doc
	$(MAKE) update
update: $(OS)_update

.PHONY: Linux_install Linux_update
Linux_install Linux_update:
	sudo apt update
	sudo apt install -u `cat apt.txt apt.dev`
# / install

# \ merge
MERGE  = Makefile .gitignore README.md LICENSE apt.txt apt.dev .vscode
MERGE += bin doc src tmp lib

.PHONY: zip
zip:
	git archive \
		--format zip \
		--output $(TMP)/$(MODULE)_$(BRANCH)_$(NOW)_$(REL).src.zip \
	HEAD

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout ponymuck -- $(MERGE)

.PHONY: ponymuck
ponymuck:
	git push -v
	git checkout $@
	git pull -v
# / merge
