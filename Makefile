# Makefile for the freecode-submit tool

VERS=$(shell sed <freecode-submit -n -e '/version *= *"\(.*\)"/s//\1/p')

prefix?=/usr/local
mandir?=share/man
target=$(DESTDIR)$(prefix)

CODE    = freecode-submit
DOCS    = README AUTHORS freecode-submit.xml COPYING
SOURCES = $(CODE) $(DOCS) Makefile control gold-mega.png

all: freecode-submit.1

freecode-submit.1: freecode-submit.xml
	xmlto man freecode-submit.xml

freecode-submit.html: freecode-submit.xml
	xmlto html-nochunks freecode-submit.xml

install: freecode-submit.1 uninstall
	install -d "$(target)/bin"
	install -m 755 freecode-submit "$(target)/bin/"
	install -d "$(target)/$(mandir)/man1"
	install -m 644 freecode-submit.1 "$(target)/$(mandir)/man1/"

uninstall:
	rm -f "$(target)/bin/freecode-submit"
	rm -f "$(target)/$(mandir)/man1/freecode-submit.1"

freecode-submit-$(VERS).tar.gz: $(SOURCES) freecode-submit.1
	find $(SOURCES) freecode-submit.1 -type f | sed "s:^:freecode-submit-$(VERS)/:" >MANIFEST
	(cd ..; ln -s freecode-submit freecode-submit-$(VERS))
	(cd ..; tar -czf freecode-submit/freecode-submit-$(VERS).tar.gz `cat freecode-submit/MANIFEST`)
	(cd ..; rm freecode-submit-$(VERS))

freecode-submit-$(VERS).md5: freecode-submit-$(VERS).tar.gz
	@md5sum freecode-submit-$(VERS).tar.gz >freecode-submit-$(VERS).md5

pychecker:
	@ln -f freecode-submit freecode-submit.py
	@-pychecker --only --limit 50 freecode-submit.py
	@rm -f freecode-submit.py

PYLINTOPTS = --rcfile=/dev/null --reports=n --include-ids=y --disable="C0103,C0301,C0323,R0903,R0912,R0914,W0141,W0621,F0401,E0611,E1101"
pylint:
	@pylint --output-format=parseable $(PYLINTOPTS) freecode-submit

clean:
	rm -f *.pyc *.html freecode-submit.1 MANIFEST ChangeLog *~
	rm -f *.tar.gz *.md5

dist: freecode-submit-$(VERS).tar.gz

release: freecode-submit-$(VERS).tar.gz freecode-submit-$(VERS).md5 freecode-submit.html
	shipper version=$(VERS) | sh -e -x
