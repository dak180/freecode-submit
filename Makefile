# Makefile for the freecode-submit tool

VERS=$(shell sed <freecode-submit -n -e '/version="\(.*\)"/s//\1/p')

PREFIX=/usr

CODE    = freecode-submit
DOCS    = README AUTHORS freecode-submit.xml COPYING
SOURCES = $(CODE) $(DOCS) Makefile control gold-mega.png

all: freecode-submit.1

freecode-submit.1: freecode-submit.xml
	xmlto man freecode-submit.xml

freecode-submit.html: freecode-submit.xml
	xmlto html-nochunks freecode-submit.xml

install: freecode-submit.1 uninstall
	cp freecode-submit ${PREFIX}/bin/freecode-submit 
	install -m 755 -o 0 -g 0 -d ${PREFIX}/share/man/man1/
	install -m 755 -o 0 -g 0 freecode-submit.1 ${PREFIX}/share/man/man1/freecode-submit.1

uninstall:
	rm -f ${PREFIX}/bin/freecode-submit 
	rm -f ${PREFIX}/share/man/man1/freecode-submit.1

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

clean:
	rm -f *.pyc *.html freecode-submit.1 MANIFEST ChangeLog SHIPPER.* *~
	rm -f *.tar.gz *.md5

dist: freecode-submit-$(VERS).tar.gz

release: freecode-submit-$(VERS).tar.gz freecode-submit-$(VERS).md5 freecode-submit.html
	shipper -u -m -t; make clean
