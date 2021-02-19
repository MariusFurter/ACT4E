all:
	@echo do
	@echo 	make -B ACT4E-vol1.pdf
	@echo 	make -B ACT4E-vol1-final.pdf
	@echo 	make -B ACT4E-vol2.pdf
	@echo Create the chached tikz using \"make tikz\".


tmpdir=tmp

#%.pdf: %.tex
#	rm -f $*.aux $(tmpdir)/$*.aux
#	latexmk -pdflatex -outdir=$(tmpdir) -f $<
#	cp $(tmpdir)/$*.pdf $@


ACTE-vol%.pdf:: nomenc-vol%.tex redo-nomenc

%.pdf: %.tex
	#rm -f $*.aux
	latexmk -synctex=1 -pdflatex -shell-escape  -f $<
	# latexmk does not seem to do this, even though we put in latexmkrc
	# makeindex $*.nlo -s nomencl.ist -o $*.nls
	pdflatex -synctex=1 -shell-escape $*

clean:
	rm -f *.fdb_latexmk *.fls *.log  *.aux *.dvi *.out *.maf *.mtc* *.ptc* *-blx.bib *.run.xml *.idx *.toc *.bbl *.blg *.ind *.ilg   *.ptc* *.mtc* *.gls

# rm -f nomenc-*.tex used*yaml


tikz:
	touch sag/*pdf
	make -C sag -j

%/standalone.tex:
	cp template-standalone.tex $@


mains=$(wildcard volumes/vol*/part*/*/main.tex)
standalones=$(subst main.tex,standalone.tex,$(mains))

standalone: $(standalones)


twovolumes:
	make -B ACT4E-vol1.pdf
	make -B ACT4E-vol2.pdf
	make -B ACT4E-vol1.pdf
	make -B ACT4E-vol2.pdf



used-%.yaml:
	@lsm_collect $(shell find volumes/$* -name '*.tex') $(shell find papers -name '*.tex')  $(shell find sag -name '*.tikz') >$@

nomenc-%.tex: used-%.yaml
	lsm_nomenc  --only $< utils/symbols*.tex > $@
	# lsm_nomenc  utils/symbols*.tex > $@

nomenc: nomenc-vol1.tex  nomenc-vol2.tex

#
#redo-nomenc: nomenc
#	makeindex ACT4E-vol1.nlo -s nomencl.ist -o ACT4E-vol1.nls
#	makeindex ACT4E-vol2.nlo -s nomencl.ist -o ACT4E-vol2.nls


used.yaml:
	@lsm_collect $(shell find volumes -name '*.tex') $(shell find papers -name '*.tex')  $(shell find sag -name '*.tikz') >$@


table: utils/tables/full/all.tex


utils/tables/full/all.tex: utils/symbols*.tex
	$(MAKE) used.yaml -B
	lsm_table --only used.yaml --style full $^ > $@



used-%.yaml:
	@lsm_collect $(shell find volumes/$* -name '*.tex') $(shell find papers -name '*.tex')  $(shell find sag -name '*.tikz') >$@


vol1-nomenc-update: table
	$(MAKE) used.yaml -B
	$(MAKE) table -B
	$(MAKE) nomenc -B
	pdflatex -synctex=1 ACT4E-vol1



pysnippets:
	pysnip-make -c make
remake:
	pysnip-make -c "clean; rmake; ls"
