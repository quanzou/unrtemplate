VERSION=
LATEXTARGET=thesis$(VERSION)
#
# LaTeX Makefile
# --------------
#
# Author : s.m.vandenoord@student.utwente.nl (Stefan van den Oord)
# Date   : March 18, 1999, second version of today.
# 
# Modification Log:
# 
# Jul25, 2010 update:
# Add Makefile into git version control system. 
#
# Oct18, 2009 update:
# Change $*.gls $*.glo into $*.nlo, since nomencl package has been updated
#
# Sep21, 2005 update:
# debugged some minor issues. 
#
# Usage
# -----
# The Makefile can do the following things for you:
# - generate PostScript equivalents of XFig figures;
# - run makeindex and BibTeX, but only if necessary;
# - compile the .dvi file, running LaTeX as many times as needed;
# - run XDvi with the compiled .dvi file;
# - create a PostScript equivalent of the .dvi file;
# - create a PDF equivalent of the .dvi file;
# - generate a HTML equivalent of the .dvi file (if Latex2HTML is
#   installed);
# - remove all generated output.
#
# The Makefile is in some points even RCS aware.
# In many cases, you don't even have to tell the Makefile which LaTeX
# file it has to compile. The Makefile uses the following strategy:
# 1. Check if the environment variable LATEXTARGET is set; if it is,
#    generate $LATEXTARGET.dvi.
# 2. If there is only one .tex file, use that one.
# 3. Check if there is a LaTeX file that has the same basename as the
#    directory. For example, if the directory is named "Thesis" and
#    there is a file "Thesis.tex", "Thesis.dvi" is generated.
#
# Invocation
# ----------
# When the MAKEFILES environment variable is set, you can use the
# following commands:
# - make latexhelp
#   Prints an overview of the available commands.
# - make latexfigures (no effect so far)
#   Only generate the PostScript equivalents of XFig figures.
# - make file.dvi
#   Generates the specified DVI file.
# - make file.ps
#   Generates the DVI file and then runs dvips.
# - make latex
#   Use the above explained strategy to find out what has to be
#   generated, and generate it.
# - make view
#   Do a make latex and then run XDvi.
# - make latexps
#   Do a make latex and then run dvips.
# - make html
#   Do a make latex and then use LaTeX2HTML to create the HTML equivalent.
#   To do this, the following environment variables are used:
#   * HTMLDIR : the base dir in which the output is written. For example,
#               if HTMLDIR=~/public_html/LaTeX, and the file that is
#               generated is "Thesis", the output will be written in the
#               directory ~/public_html/LaTeX/Thesis.
#   * LATEX2HTML_OPTS : if you want to pass options to LaTeX2HTML, put
#                       them in this variable.
#   * notes: this option is far away from mature, because LATEX2html does 
#            not read .sty files. Instead it looks for .perl files with 
#            the same prefix.
# - make latexclean
#   This command removes all generated output. CAUTION: the files that are
#   removed are thought out pretty well, but it is possible that files are
#   removed that you wanted to keep! Check below what files are removed if
#   you want to be certain!
#   Note that a file figure.eps is only removed if a file figure.fig exists.
#   (Even if the file figure.fig exists, but is checked in using RCS, the
#   file figure.eps will be removed.)
#
# Tip
# ---
# For some projects it is useful to have a separate Makefile in the project's
# directory. For example, when you use RCS, you could add functionality for
# automatic checkouts of the right files (adding dependencies is sufficient;
# GNU Make rocks :-).
# The command "latexclean" is declared so that you can add your own
# functionality in the project's Makefile; instead of one colon, declare it
# with two colons if you want to do that.
# For example:
# latexclean::
#     rm -f foo.bar
# This way both the origional definition in this Makefile and your own are
# used.
PWD=pwd
LATEX=latex
PDFLATEX=pdflatex
BIBTEX=bibtex
DVIPS=dvips
MAKEINDEX=makeindex
DVIVIEWER=xdvi -geometry 710x950-0+10
LATEX2HTML=latex2html

FIGURES=$(wildcard *.fig)
FIGUREOBJS=$(FIGURES:.fig=.eps)

BIBFILES=$(wildcard *.bib)
TEXFILES=$(wildcard *.tex)

# Disable standard pattern rule:
# The '%' (rule character) is a wild card, matching zero or more characters.
# The source determined by an inference rule is called the 'inferred source'.
# A dependency line says 'the target %.dvi depends on the sources %.tex'. 
%.dvi: %.tex

# Do not delete the following targets:
# special targets '.PRECIOUS' prevents the target from being removed.
.PRECIOUS: %.aux %.bbl %.eps %.ind

%.aux: %.tex $(FIGUREOBJS) $(TEXFILES)
	@$(LATEX) $*
# Look for citations. Make sure grep never returns an error code.
# grep regular expression started with "\bibcite"
# debugged by Quan Zou, Quan.Zou@iaf.cnrs-gif.fr
	@grep "^\\\\citation" *.aux > .btmp.new || true

# If the citations are not changed, don't do anything. Otherwise replace
# the .btmp file to make sure Bibtex will be run.
	@if ( diff .btmp.new .btmp >& /dev/null ); then \
		rm .btmp.new; \
	else \
		mv .btmp.new .btmp; \
	fi

	@if [ -f $*.idx ]; then cp $*.idx .itmp.new; else touch .itmp.new; fi
	@if ( diff .itmp.new .itmp >& /dev/null ); then \
		rm .itmp.new; \
	else \
		mv .itmp.new .itmp; \
	fi

.btmp:

%.bbl: $(BIBFILES) .btmp
# Only use BibTeX if \bibliography occurs in the document. In that case,
# run BibTeX and recompile. .btmp is touched to prevent useless making
# next time.
# grep regular expression started with "\biblography"
# debugged by Quan Zou, Quan.Zou@iaf.cnrs-gif.fr
	@if ( grep "^\\\\bibliography{" $*.tex > /dev/null ); then \
		$(BIBTEX) $*; \
		touch .rerun; \
	fi
	@touch .btmp

.itmp:

%.ind: .itmp
	@if [ -f $*.idx ]; then \
		$(MAKEINDEX) $*; \
		touch .rerun; \
		touch .itmp; \
	fi

%.eps:%.fig
	@echo Generating figure $@...
	@fig2dev -L ps $< $@

%.dvi: %.aux %.ind %.bbl
# Make sure the dvi-file exists; if not: recompile.
	@if [ ! -f $*.dvi ]; then \
		touch .rerun; \
	fi

	@if [ -f .rerun ]; then \
		rm .rerun; \
		$(LATEX) $*; \
	else \
		$(MAKE) $*.aux; \
	fi

# While references et al. are changed: recompile.
	@while ( grep Rerun $*.log > /dev/null ); do \
		$(LATEX) $*; \
	done

# Touch the figureobjects to prevent making next time
	@if [ -n "$(FIGUREOBJS)" ]; then \
		touch $(FIGUREOBJS); \
		touch $*.aux; \
	fi

	@if [ -f $*.ind ]; then \
		touch $*.ind; \
	fi
	@$(MAKEINDEX) $*.nlo -s nomencl.ist -o $*.nls

latex:
# Below the 'true' is included to prevent unnecessarily many errors.
	@if [ -n "${LATEXTARGET}" ]; then \
		$(MAKE) ${LATEXTARGET}.dvi; \
		true; \
	else \
		if [ `ls *.tex | wc -l` = "1" ]; then \
			$(MAKE) `basename \`ls *.tex\` .tex`.dvi; \
			true; \
		else \
			$(MAKE) `echo $$PWD|tr '/' '\n'|tail -1`.dvi; \
			true; \
		fi; \
	fi
# Below invoke LATEX on target file once more, it will input *.gls file and
# process it accordingly -- Quan Zou
# here is explicit rule which might be different from implicit rule
	@$(MAKEINDEX) *.nlo -s nomencl.ist -o *.nls;\
	$(LATEX) `basename \`ls *.tex\` .tex`.tex

latexfigures:
	@for i in $(FIGUREOBJS); do \
		$(MAKE) $$i; \
	done

view:
# Below the 'true' is included to prevent unnecessarily many errors.
	@if [ -n "${LATEXTARGET}" ]; then \
		$(MAKE) ${LATEXTARGET}.dvi; \
		true; \
	else \
		if [ `ls *.tex | wc -l` = "1" ]; then \
			$(MAKE) `basename \`ls *.tex\` .tex`.dvi;\
			true; \
		else \
			$(MAKE) `echo $$PWD|tr '/' '\n'|tail -1`.dvi;\
			true; \
		fi; \
	fi
# Below invoke LATEX on target file once more, it will input *.gls file and
# process it accordingly -- Quan Zou
	@$(MAKEINDEX) *.nlo -s nomencl.ist -o *.nls;\
	$(LATEX) `basename \`ls *.tex\` .tex`.tex;\
	$(DVIVIEWER) `basename \`ls *.tex\` .tex`.dvi

%.ps: %.dvi
	$(DVIPS) -o $*.ps $<
	@$(MAKEINDEX) $*.nlo -s nomencl.ist -o $*.nls
	@$(LATEX) `basename \`ls *.tex\` .tex`.tex
	$(DVIPS) -o $*.ps $<

# must input *.gls file to .dvi and process it accordingly -- Quan Zou

%.pdf: %.tex
	$(PDFLATEX) $<
	@$(MAKEINDEX) $*.nlo -s nomencl.ist -o $*.nls
	@$(LATEX) `basename \`ls *.tex\` .tex`.tex
	$(PDFLATEX) $<
	$(PDFLATEX) $<
# must input *.gls file to .dvi and process it accordingly -- Quan Zou

latexps:
	@if [ -n "${LATEXTARGET}" ]; then \
		$(MAKE) ${LATEXTARGET}.ps && \
		true; \
	else \
		if [ `ls *.tex | wc -l` = "1" ]; then \
			$(MAKE) `basename \`ls *.tex\` .tex`.ps && \
			true; \
		else \
			$(MAKE) `echo $$PWD|tr '/' '\n'|tail -1`.ps && \
			true; \
		fi; \
	fi

latexpdf:
	@if [ -n "${LATEXTARGET}" ]; then \
		$(MAKE) ${LATEXTARGET}.pdf && \
		true; \
	else \
		if [ `ls *.tex | wc -l` = "1" ]; then \
			$(MAKE) `basename \`ls *.tex\` .tex`.pdf && \
			true; \
		else \
			$(MAKE) `echo $$PWD|tr '/' '\n'|tail -1`.pdf && \
			true; \
		fi; \
	fi

html: .html

.html:
	@if [ -n "${LATEXTARGET}" ]; then \
		if [ -n "${HTMLDIR}" ]; then \
			$(MAKE) ${LATEXTARGET}.dvi; \
			$(LATEX) `basename \`ls *.tex\` .tex`.tex;\
			$(LATEX2HTML) $(LATEX2HTML_OPTS) -dir $(HTMLDIR)/$(LATEXTARGET) $(LATEXTARGET) && \
			chmod a+rx $(HTMLDIR)/$(LATEXTARGET) && \
			chmod a+r $(HTMLDIR)/$(LATEXTARGET)/* &&  \
			touch .html; \
		else \
			echo Set variable HTMLDIR\!; \
		fi; \
	else \
		echo Set variable LATEXTARGET\!; \
	fi

latexhelp:
	@echo "LaTeX Makefile Options"
	@echo "----------------------"
	@echo ""
	@echo "Environment variables:"
	@echo "  LATEXTARGET   Filename to make (without extension)"
	@echo "  HTMLDIR       Directory for HTML-output"
	@echo "  FIGURES       Figures that have to be compiled"
	@echo ""
	@echo "Targets:"
	@echo "  <name>.dvi    Make the given dvi file"
	@echo "  latex         Make the LATEXTARGET or <dirname>.dvi"
	@echo "  latexps       Make the LATEXTARGET or <dirname>.ps"
	@echo "  latexpdf      Make the LATEXTARGET or <dirname>.pdf"
	@echo "  cleanpspdf    Remove the LATEXTARGET or <dirname>.pdf or <dirname>.ps"
	@echo "  view          Make and view the LATEXTARGET or <dirname>.dvi"
	@echo "  html          Make the LATEXTARGET  or <dirname>.dvi and generate HTML output"
	@echo "  latexclean    Remove all generated files"
	@echo "  latexhelp     This overview"

clean latexclean::
	@rm -f *.log *.aux *.dvi *.bbl *.blg *.ilg *.toc *.lof *.lot *.idx *.ind *.out *.brf *.html *.btmp *.itmp *.rerun *.glo *.gls *.nlo *.nls
	@epsfiles=`find * -maxdepth 0 -name "*.eps"`; \
	if [ -n "$$epsfiles" ]; then \
		for i in *.eps; do \
			if [ -f `basename $$i .eps`.fig ]; then \
				rm -f $$i; \
			elif ( rcs `basename $$i .eps`.fig >& /dev/null ); then \
				rm -f $$i; \
			fi \
		done \
	fi

cleanpspdf:: clean
	@rm -f *.ps *.pdf

clobber:: cleanpspdf
	@rm -f *~
