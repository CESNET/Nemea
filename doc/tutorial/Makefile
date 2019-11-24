.PHONY: all

all:
	for i in ./*.md; do markdown -f +autolink "$$i" > $${i%.md}.html; done

.PHONY: clean

clean:
	rm -f outputfile.trapcap soubor.* *.html
