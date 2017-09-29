# Makefile for PSYLAB/doc
#
# Author:  Martin Hansen <martin.hansen AT fh-oldenburg.de>
# Date:    16 Jan 2006
# Updated: 10 Mar 2006
#

DOCU = psylab-doc

docu: 
	latex $(DOCU) 
	bibtex $(DOCU) 
	makeindex $(DOCU)
	latex $(DOCU)
	latex $(DOCU)
	dvips -Ppdf $(DOCU)
	ps2pdf -sPAPERSIZE=a4 $(DOCU).ps


%.ind: %.tex
	latex $< 
	makeindex $<
	latex $< 
	latex $< 

%.dvi: %.tex %.idx
	latex $< 
	latex $< 

%.ps: %.dvi
#	dvips -Ppdf $< -o $@
	dvips $< -o $@

%.pdf: %.ps %.dvi
	ps2pdf -sPAPERSIZE=a4 $< $@




# End of Makefile
