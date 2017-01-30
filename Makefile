#!/usr/bin/make

R=R
ROPTS=-q --no-save --no-restore-data

all: sample_labels.pdf


sample_protocol.pdf: sample_protocol.tex per_sample_protocol.tex
	latexmk -pdf -pdflatex='xelatex -interaction=nonstopmode %O %S' -use-make $<

per_sample_protocol.tex: make_protocol.pl rna_vial_information.txt
	perl $< < rna_vial_information.txt > $@


sample_labels.pdf: sample_labels.tex vial_labels.tex
	latexmk -pdf -pdflatex='xelatex -interaction=nonstopmode %O %S' -use-make $<

rna_vial_information.txt: make_tsv_labels.R ../selected_vials
	$(R) $(ROPTS) -f $< --args $(wordlist 2,$(words $^),$^) $@

vial_labels.tex: make_vial_labels.pl Labels.csv
	perl make_vial_labels.pl < Labels.csv > $@
