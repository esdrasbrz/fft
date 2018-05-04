all: doc.tex bib
	pdflatex doc.tex && pdflatex doc.tex

bib: doc.bib doc.tex
	pdflatex doc.tex && bibtex doc

clean:
	rm *.log *.pdf *.aux *.bbl *.blg *.toc
