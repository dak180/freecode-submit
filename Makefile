# Makefile for the freshmeat-submit tool

VERS=$(shell sed <freshmeat-submeat -n -e '/version=\(.*\)/s//\1/p')

CODE    = freshmeat-submit
DOCS    = README AUTHORS freshmeat-submit.xml COPYING
SOURCES = $(CODE) $(DOCS) freshmeat-submit.spec Makefile gold-mega.png

all: freshmeat-submit.1

freshmeat-submit.1: freshmeat-submit.xml
	xmlto man freshmeat-submit.xml

freshmeat-submit.html: freshmeat-submit.xml
	xmlto html-nochunks freshmeat-submit.xml

install: freshmeat-submit.1 uninstall
	cp freshmeat-submit ${ROOT}/usr/bin/freshmeat-submit 
	install -m 755 -o 0 -g 0 -d $(ROOT)/usr/share/man/man1/
	install -m 755 -o 0 -g 0 freshmeat-submit.1 $(ROOT)/usr/share/man/man1/freshmeat-submit.1

uninstall:
	rm -f ${ROOT}/usr/bin/freshmeat-submit 
	rm -f ${ROOT}/usr/share/man/man1/freshmeat-submit.1

freshmeat-submit-$(VERS).tar.gz: $(SOURCES) freshmeat-submit.1
	find $(SOURCES) freshmeat-submit.1 -type f | sed "s:^:freshmeat-submit-$(VERS)/:" >MANIFEST
	(cd ..; ln -s freshmeat-submit freshmeat-submit-$(VERS))
	(cd ..; tar -czf freshmeat-submit/freshmeat-submit-$(VERS).tar.gz `cat freshmeat-submit/MANIFEST`)
	(cd ..; rm freshmeat-submit-$(VERS))

pychecker:
	@echo "Expect: Object (data) has no attribute (update)"
	@ln -f freshmeat-submit freshmeat-submit.py
	@-pychecker --only --limit 50 freshmeat-submit.py
	@rm -f freshmeat-submit.py

clean:
	rm -f *.pyc *.html freshmeat-submit.1 MANIFEST ChangeLog SHIPPER.* *~

dist: freshmeat-submit-$(VERS).tar.gz

release: freshmeat-submit-$(VERS).tar.gz freshmeat-submit.html
	shipper -u -m -t; make clean
