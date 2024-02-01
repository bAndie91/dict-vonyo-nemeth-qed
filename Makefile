
BASENAME_AM = vonyo-nemeth-angol-magyar
BASENAME_MA = vonyo-nemeth-magyar-angol


all: $(BASENAME_AM).dict.dz $(BASENAME_AM).index $(BASENAME_MA).dict.dz $(BASENAME_MA).index
.PHONY: all

$(BASENAME_AM).dict.dz $(BASENAME_MA).dict.dz: %.dict.dz: %.dict
	dictzip --keep $<

$(BASENAME_AM).dict $(BASENAME_AM).index &: headers eng-hu.txt
	cat headers eng-hu.txt | dictfmt -f --utf8 -s "Angol-Magyar szótár, Vonyó Attila, ver. 1.0.0" $(BASENAME_AM)

hu-eng.txt: transpose.pl eng-hu.txt
	./transpose.pl < eng-hu.txt > $@~
	mv -f $@~ $@

$(BASENAME_MA).dict $(BASENAME_MA).index &: headers hu-eng.txt
	cat headers hu-eng.txt | dictfmt -f --utf8 -s "Magyar-Angol szótár, Vonyó Attila, ver. 1.0.0" $(BASENAME_MA)


clean:
	rm hu-eng.txt \
		$(BASENAME_MA).dict $(BASENAME_MA).dict.dz $(BASENAME_MA).index \
		$(BASENAME_AM).dict $(BASENAME_AM).dict.dz $(BASENAME_AM).index 
.PHONY: clean


PREFIX = /usr/share/dictd

install: $(PREFIX)/$(BASENAME_AM).dict.dz $(PREFIX)/$(BASENAME_AM).index $(PREFIX)/$(BASENAME_MA).dict.dz $(PREFIX)/$(BASENAME_MA).index 
	dictdconfig -w
.PHONY: install

$(PREFIX)/$(BASENAME_AM).dict.dz $(PREFIX)/$(BASENAME_AM).index $(PREFIX)/$(BASENAME_MA).dict.dz $(PREFIX)/$(BASENAME_MA).index: $(PREFIX)/%: %
	install --compare -m 0644 $< $@
