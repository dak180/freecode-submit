# Makefile for the freecode-submit tool

VERS=$(shell sed <freecode-submit -n -e '/version="\(.*\)"/s//\1/p')

CODE    = freecode-submit
DOCS    = README AUTHORS freecode-submit.xml COPYING
SOURCES = $(CODE) $(DOCS) Makefile control gold-mega.png

all: freecode-submit.1

freecode-submit.1: freecode-submit.xml
	xmlto man freecode-submit.xml

freecode-submit.html: freecode-submit.xml
	xmlto html-nochunks freecode-submit.xml

install: freecode-submit.1 uninstall
	cp freecode-submit ${ROOT}/usr/bin/freecode-submit 
	install -m 755 -o 0 -g 0 -d $(ROOT)/usr/share/man/man1/
	install -m 755 -o 0 -g 0 freecode-submit.1 $(ROOT)/usr/share/man/man1/freecode-submit.1

uninstall:
	rm -f ${ROOT}/usr/bin/freecode-submit 
	rm -f ${ROOT}/usr/share/man/man1/freecode-submit.1

freecode-submit-$(VERS).tar.gz: $(SOURCES) freecode-submit.1
	find $(SOURCES) freecode-submit.1 -type f | sed "s:^:freecode-submit-$(VERS)/:" >MANIFEST
	(cd ..; ln -s freecode-submit freecode-submit-$(VERS))
	(cd ..; tar -czf freecode-submit/freecode-submit-$(VERS).tar.gz `cat freecode-submit/MANIFEST`)
	(cd ..; rm freecode-submit-$(VERS))

pychecker:
	@echo "Expect: Object (data) has no attribute (update)"
	@ln -f freecode-submit freecode-submit.py
	@-pychecker --only --limit 50 freecode-submit.py
	@rm -f freecode-submit.py

clean:
	rm -f *.pyc *.html freecode-submit.1 MANIFEST ChangeLog SHIPPER.* *~

dist: freecode-submit-$(VERS).tar.gz

release: freecode-submit-$(VERS).tar.gz freecode-submit.html
	shipper -u -m -t; make clean
