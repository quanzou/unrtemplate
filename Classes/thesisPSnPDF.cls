%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                     MSthesis v1.1                                       %
%                            By Quan Zou <quan.zou@gmail.com>                             %
%                            Version 1.1 released 01/10/2010                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%------------------------------------------------------------------------------------------
% Identification
%------------------------------------------------------------------------------------------
%\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{Classes/thesisPSnPDF}[2010/10/01 v1.1 thesis class]

%------------------------------------------------------------------------------------------
% Initial Code
%------------------------------------------------------------------------------------------
% Book style document has the title page related such as frontmatter, mainmatter etc...
% The Book style divides the document into three parts, 
% \frontmatter for Preface, Summary, etc. which have Roman numeral for page numbers,
% \mainmatter for the main content with Arabic numerals, 
% \appendix for the Appendices,
% \backmatter for the Bibliography. 
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\ifx\pdfoutput\undefined
   \LoadClass[dvips, letterpaper]{book}
\else
   \LoadClass[pdftex, letterpaper]{book}
\fi

% Bibliography
% uncomment next line to change bibliography name to references for Book document class
\renewcommand{\bibname}{References}

% note that this doesn't do much if you later define another bibliography style 

%------------------------------------------------------------------------------------------
% Package used
%------------------------------------------------------------------------------------------
\usepackage{amssymb}
\usepackage{graphics}
\usepackage{fancyhdr}
\usepackage{fancybox}
\usepackage{setspace}
\usepackage{eucal}
\usepackage[usenames, dvipsnames]{color}
\usepackage[perpage]{footmisc}
\usepackage[round, sort, numbers]{natbib}
\usepackage{ifthen}
\usepackage{colortbl}			% It has a \rowcolor command
\usepackage{pifont}			% provide circled numbers, part of psnfss package

% packages for language set
%\usepackage{CJK}			%% to use Chinese, Japanese and Korean language
%\usepackage{pinyin}			%% enables the input of pinyin syllables with tones
\usepackage[english]{babel}		%% Babel, a multilingual package for Latex
%\usepackage[francais]{babel}		%% Babel, a multilingual package for Latex
%\usepackage[english, francais]{babel}	%% Babel, a multilingual package for Latex
%\usepackage[my-encoding]{inputenc}	%% my-encoding will be 'latin1' for Linux/Unix and windows,
%\usepackage[latin1]{inputenc}		%% 'applemac' for Macintoshs, or 'cp850' for DOS.
%\usepackage[T1]{fontenc}		%% use EC fonts for French

%------------------------------------------------------------------------------------------
% Nomenclature
%------------------------------------------------------------------------------------------
% Nomenclature
\usepackage{nomencl}
\renewcommand{\nomname}{List of Abbreviations}	% default name is {Nomenclature}
\makenomenclature
\renewcommand\nomgroup[1]{%
  \ifthenelse{\equal{#1}{G}}{%
   \item[\textbf{Greek Symbols}] }{%         G - Greek
    \ifthenelse{\equal{#1}{Z}}{%
     \item[\textbf{Acronyms}]}{%             Z - Acronyms
      \ifthenelse{\equal{#1}{X}}{%
       \item[\textbf{Other Symbols}]}{{%    X - Other Symbols
            			{{}}}}}}}

%------------------------------------------------------------------------------------------
% Switch between latex and pdflatex
%------------------------------------------------------------------------------------------
% define \ifpdf commond to switch between latex and pdflatex
% Oct 19, 2009 debugged switching of ifpdf
\newif \ifpdf
    \ifx \pdfoutput \undefined
        % for running latex if unspecified
        \pdffalse
    \else
        % check pdfoutput value
        \ifnum \pdfoutput <1  % Not generating pdf, but DVI
            \pdffalse
        \else
            % for running pdflatex 
            \pdfoutput = 1    % positive value for a PDF output
            \pdftrue
        \fi
\fi

% if use pdflatex add some hyperref into the file
\ifpdf
%-->
%--> Google.com search "hyperref options"
%--> 
%--> http://www.ai.mit.edu/lab/sysadmin/latex/documentation/latex/hyperref/manual.pdf
%--> http://www.chemie.unibas.ch/~vogtp/LaTeX2PDFLaTeX.pdf 
%--> http://www.uni-giessen.de/partosch/eurotex99/ oberdiek/print/sli4a4col.pdf
%--> http://me.in-berlin.de/~miwie/tex-refs/html/latex-packages.html
%-->
    \usepackage[ pdftex, plainpages = false, pdfpagelabels, 
                 pdfpagelayout = useoutlines,
                 bookmarks,
                 bookmarksopen = true,
                 bookmarksnumbered = true,
                 breaklinks = true,
                 linktocpage,
                 pagebackref,
                 colorlinks = true,
                 linkcolor = blue,
                 urlcolor  = blue,
                 citecolor = red,
                 anchorcolor = green,
                 hyperindex = true,
                 hyperfigures
                 ]{hyperref} 

    \DeclareGraphicsExtensions{.png, .jpg, .pdf}
    \usepackage[pdftex]{graphicx}
    \pdfcompresslevel=9
    \graphicspath{{ThesisFigs/PNG/}{ThesisFigs/PDF/}{ThesisFigs/}}
\else
    \usepackage[ dvips, 
                 bookmarks,
                 bookmarksopen = true,
                 bookmarksnumbered = true,
                 breaklinks = true,
                 linktocpage,
                 pagebackref,
                 colorlinks = true,
                 linkcolor = blue,
                 urlcolor  = blue,
                 citecolor = red,
                 anchorcolor = green,
                 hyperindex = true,
                 hyperfigures
                 ]{hyperref}

    \DeclareGraphicsExtensions{.eps, .ps}
    \usepackage{epsfig}
    \usepackage{graphicx}
    \graphicspath{{ThesisFigs/EPS/}{ThesisFigs/}}
\fi

%------------------------------------------------------------------------------------------
% Page settings
%------------------------------------------------------------------------------------------
% define the page size including an offset for binding if necessary
% The international standard (ISO 216)
% A4:        210 mm x 297 mm, with aspect ratio of sqrt(2)
% US and Canada use two different formats: `Letter' and PA4
% Letter:    215 mm x 280 mm (8.5  in x 11 in)
% PA4:       210 mm x 280 mm (8.25 in x 11 in)
%
% Other units in length:
%    cm  Centimetres
%    em  The width of the letter M in the current font
%    ex  The height of the letter x in the current font
%    in  Inches
%    pc  Picas (1pc = 12pt)
%    pt  Points (1in = 72.27pt)
%    mm  Millimetres
%    1 quad = 11 pt
%    1 qquad = 2 quad

% A4 settings
%\ifpdf
%   \pdfpageheight=297mm
%   \pdfpagewidth=210mm
%\else
%   \setlength{\paperheight}{297mm}
%   \setlength{\paperwidth}{210mm}
%\fi

%\setlength{\hoffset}{0.00cm}
%\setlength{\voffset}{0.00cm}

% letter settings
\ifpdf
   \pdfpageheight=280mm
   \pdfpagewidth=215mm
\else
   \setlength{\paperheight}{280mm}
   \setlength{\paperwidth}{215mm}
\fi

% see latex page layout picture
\setlength{\hoffset}{0.00cm}			% offset from one inch 

\setlength{\evensidemargin}{1cm}		% for oneside page layout, evensidemargin should 
\setlength{\oddsidemargin}{1cm}			% be set the same as oddsidemargin

% total top margin sums upto 1.0 in
% all following params sums upto to 0
\setlength{\voffset}{-1.00cm}			% offset from one inch
\setlength{\topmargin}{0cm}			% \setlength{\topmargin}{-1cm}
\setlength{\headheight}{0cm}			% \setlength{\headheight}{1.36cm}
\setlength{\headsep}{1.00cm}			% \setlength{\headsep}{1.00cm}

% total bottom margin sums upto 1.25 in
\setlength{\footskip}{3.175cm}			% 1.25 inch
\setlength{\textheight}{22.285cm}		% 28(cm) - (1.25 + 1)(inch) * 2.54(cm/inch)

% total left margin sums upto 1.5 in
\setlength{\marginparsep}{1mm}			% 1.5(inch) * 2.54(cm/in) = 3.81(cm)
\setlength{\marginparwidth}{2.81cm}		% 1 + 2.81 = 3.81 (cm)

% total right margin sums upto 1.0 in
\setlength{\textwidth}{15.15cm}			% 21.5(cm) - 2.5(in) * 2.52(cm/in) = 15.15(cm)

%------------------------------------------------------------------------------------------
% Fancy headers
%------------------------------------------------------------------------------------------
% the fancy page style is first defined and augmented here
\pagestyle{fancy}
\renewcommand{\chaptermark}[1]{\markboth{\MakeUppercase{\thechapter. #1 }}{}}		% chapter mark
\renewcommand{\sectionmark}[1]{\markright{\thesection\ #1}}				% section mark
\fancyhf{}
%\fancyhead[RO]{\bfseries\rightmark}		% R: right aligned; O: odd page; chapter name
%\fancyhead[LE]{\bfseries\leftmark}		% L: left aligned;  E: even page; section name 
\rhead{\thepage}				% current page number at the top right 
%\fancyfoot[C]{\thepage}			% current page number at the bottom center
\renewcommand{\headrulewidth}{0.0pt}		% context headrule width {0.5pt} or {0pt}
\renewcommand{\footrulewidth}{0pt}
\addtolength{\headheight}{0.5pt}

\fancypagestyle{plain}
{% headrule for Chapter page
    \fancyhead{}
    \renewcommand{\headrulewidth}{0pt}
}

% These macros define an environment for front matter that is always 
% single column even in a double-column document.
\newenvironment{alwayssingle}
{ \@restonecolfalse\if@twocolumn\@restonecoltrue\onecolumn
  \else\newpage\fi}{\if@restonecol\twocolumn\else\newpage\fi}

%------------------------------------------------------------------------------------------
% Varialbes for cover and committee page                                                
%------------------------------------------------------------------------------------------
% user defined command without hyperlink:
% the full (unabbreviated) name of the degree
\newcommand{\@degree}{MASTER OF SCIENCE}
\newcommand{\degree}[1]{\renewcommand{\@degree}{#1}}

% the logo of the University
\newcommand{\@logo}{\IncludeGraphicsW{UNR}{25mm}{0 0 166 120}} 
\newcommand{\logo}[1]{\renewcommand{\@logo}{#1}}

% user defined command with hyperlink
% authorship
\renewcommand{\@author}{Quan Zou}

% the name of your major
\newcommand{\@major}{\href{http://www.unr.edu/math}{Mathematics}}

% the name of your college and/or department(eg. Monkey, Rat, Fish)
\newcommand{\@collegeordept}{\href{http://www.unr.edu/math}{Deptartment of Mathematics and Statistics}}

% the name of your school(grad, medical, law or business)
\newcommand{\@school}{\href{http://www.unr.edu/grad}{THE GRADUATE SCHOOL}}


% the name of your University
\newcommand{\@university}{\href{http://www.unr.edu}{University of Nevada, Reno}}
\newcommand{\@univ}{\href{http://www.unr.edu}{UNIVERSITY OF NEVADA, RENO}}

% if use pdflatex add some hyperref into the file
\ifpdf
    \renewcommand{\author}[2][qzou@unr.edu]{\renewcommand{\@author}{\href{mailto:#1}{#2}}}
    \newcommand{\university}[2][http://www.unr.edu]{\renewcommand{\@university}{\href{#1}{#2}}}
    \newcommand{\univ}[2][http://www.unr.edu]{\renewcommand{\@univ}{\href{#1}{#2}}}
    \newcommand{\school}[2][http://www.unr.edu/grad]{\renewcommand{\@school}{\href{#1}{#2}}}
    \newcommand{\collegeordept}[2][http://www.unr.edu/math]{\renewcommand{\@collegeordept}{\href{#1}{#2}}}
    \newcommand{\major}[2][http://www.unr.edu]{\renewcommand{\@major}{\href{#1}{#2}}}
\else
    \renewcommand{\author}[1]{\renewcommand{\@author}{#1}}
    \newcommand{\university}[1]{\renewcommand{\@university}{#1}}
    \newcommand{\univ}[1]{\renewcommand{\@univ}{#1}}
    \newcommand{\school}[1]{\renewcommand{\@school}{#1}}
    \newcommand{\collegeordept}[1]{\renewcommand{\@collegeordept}{#1}}
    \newcommand{\major}[1]{\renewcommand{\@major}{#1}}
\fi

% Defining makelogo command
% \vspace{} is used to adjust to different University logo
% \vspace*{} with optional * argument makes the space never removed even 
% at the end of the page. 
\def\makelogo
{%
    \begin{flushleft}
        \hspace*{5pt}
        {\@logo}  
        \hspace*{33pt}
        \raisebox{22pt}
        {\bf \large{\@school}}
    \end{flushleft}
}

% Defining supervisors name
\newcommand{\@principaladvisor}{Simpson Homer, Ph.D.,}
\newcommand{\principaladvisor}[1]{\renewcommand{\@principaladvisor}{#1}}

\newcommand{\@readera}{Marge Homer, Ph.D.,}
\newcommand{\readera}[1]{\renewcommand{\@readera}{#1}}

\newcommand{\@readerb}{Lisa, Homer, Ph.D.,}
\newcommand{\readerb}[1]{\renewcommand{\@readerb}{#1}}

\newcommand{\@readerc}{Bart, Homer, Ph.D.,}
\newcommand{\readerc}[1]{\renewcommand{\@readerc}{#1}}

\newcommand{\@examinera}{Maggie, Homer, Ph.D.,}
\newcommand{\examinera}[1]{\renewcommand{\@examinera}{#1}}

% Defining signatures
\def\sign#1#2{{#1}{#2}\par \vspace*{8mm}}
\def\signature
{%
    \begin{center}
        \sign{\@principaladvisor}{\, Adviser}
        \sign{\@readera}{\, Adviser}
        \sign{\@readerb}{\, Committee Member}
        \sign{\@readerc}{\, Committee Member}
        \sign{\@examinera}{\, Associate Dean, Graduate School}
    \end{center}
}

% The year and term the degree will be officially conferred
\newcommand{\@submitdate}{\ifcase\the\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space \number\the\year}
\newcommand{\submitdate}[1]{\renewcommand{\@submitdate}{#1}}

% copyright
\ifnum\month=12
    \@tempcnta=\year \advance\@tempcnta by 1
    \edef\@copyrightyear{\number\the\@tempcnta}
\else
    \def\@copyrightyear{\number\the\year}
\fi

\newcommand{\copyrightyear}[1]{\renewcommand{\@copyrightyear}{#1}}

% define copyright page
\def\copyrightpage
{%
    \pagestyle{empty}
    \null\vfill				% rubber length
    \begin{center}
        \large\copyright\ Copyright by \@author~~\number\the\year\ \\
        \large All Rights Reserved
    \end{center}
    \vfill				% ruber length
}

%------------------------------------------------------------------------------------------
%  Cover page defination
%------------------------------------------------------------------------------------------
% define cover page layout
\def\Tspace#1#2{\begin{singlespace}{#1}\end{singlespace} \vspace*{#2}}
\def\makecover
{%
  % begin to render the title page
  \begin{alwayssingle}
    \renewcommand{\footnotesize}{\small}
    \renewcommand{\footnoterule}{\relax}
    \thispagestyle{empty}
    \doublespacing

  % some definations for ifpdf
  \ifpdf
    \pdfinfo { /Title  (THESE OF MASTER)
               /Creator (TeX)
               /Producer (pdfTeX)
               /Author (Quan Zou, qzou@unr.edu)
               /CreationDate (D:20101001000000)  %format D:YYYYMMDDhhmmss
               /ModDate (D:20101001000000)
               /Subject (STDP)
               /Keywords (MS, Thesis)}
    \pdfcatalog { /PageMode (/UseOutlines)
                  /OpenAction (fitbh)  }
  \fi


  \begin{center}

    \vspace*{0mm}
    \Tspace{\@university}{30mm}

    \Tspace{\bf {\@title}}{30mm}

    \Tspace{A thesis submitted in partial fulfillment of the \\
            requirements for the degree of Master of Science in \\
            \@major}{25mm}

    \Tspace{by}{5mm}

    \Tspace{\@author}{25mm}

    \Tspace{{\@principaladvisor}{\, Thesis Adviser}}{25mm}

    {\@submitdate}

  \end{center}

  \copyrightpage

  \end{alwayssingle}
}

% define dummy two sided page
\def\twosidepages
{%
    \pagestyle{empty}
    \null\vfill
    \begin{center} 
      \quad \\ \quad \\ \quad \\ \quad
    \end{center}
    \vfill
}

%------------------------------------------------------------------------------------------
%  Committee page defination
%------------------------------------------------------------------------------------------
% define title page layout
% \maketitle only take one unique spacing, have to embed spacing environment into \tspace
\def\tspace#1{\begin{singlespace}{#1} \end{singlespace} \vspace*{5mm}}
\renewcommand{\maketitle}
{%
  % begin to render the title page
  \begin{alwayssingle}
    \renewcommand{\footnotesize}{\small}
    \renewcommand{\footnoterule}{\relax}
    \thispagestyle{empty}
    \thisfancypage{\shadowbox}{}			% works with onesided
    \doublespacing

  % some definations for ifpdf
  \ifpdf
    \pdfinfo { /Title  (THESE OF MASTER)
               /Creator (TeX)
               /Producer (pdfTeX)
               /Author (Quan Zou, qzou@unr.edu)
               /CreationDate (D:20101001000000)  %format D:YYYYMMDDhhmmss
               /ModDate (D:20101001000000)
               /Subject (STDP)
               /Keywords (MS, Thesis)}
    \pdfcatalog { /PageMode (/UseOutlines)
                  /OpenAction (fitbh)  }
  \fi

  \vspace*{0mm}
    {\makelogo}

  \begin{center}

    
    \tspace{
             We recommend that the thesis \\
              prepared under our supervision by
     }

    \tspace{\bf \large{\@author}}

    \tspace{entitled}

    \tspace{\@title} 

    \tspace{be accepted in partial fulfillment of the \\ 
     requirements for the degree of}

    \tspace{\bf\large {\@degree}}

    {\signature}

    {\@submitdate}

  \end{center}

  % turn it on for twoside settings
  %\twosidepages

  \end{alwayssingle}
}

%------------------------------------------------------------------------------------------
%  Environment settings
%------------------------------------------------------------------------------------------
% DEDICATION
%
% The dedication environment makes sure the dedication gets its
% own page and is set out in verse format.

\newenvironment{dedication}
{\begin{alwayssingle}
  \pagestyle{empty}
  \begin{center}
  \vspace*{1.5cm}
  {\LARGE }
  \end{center}
  \vspace{0.5cm}
  \begin{quote} \begin{center}}
{\end{center} \end{quote} \end{alwayssingle}}

% ACKNOWLEDGEMENTS
%
% The acknowledgements environment puts a large, bold, centered 
% "Acknowledgements" label at the top of the page. The acknowledgements
% themselves appear in a quote environment, i.e. tabbed in at both sides, and
% on its own page.

\newenvironment{acknowledgements}
{\pagestyle{empty}
\begin{alwayssingle}
\begin{center}
\vspace*{1.5cm}
{\Large \bfseries Acknowledgements}
\end{center}
\vspace{0.5cm}
\begin{quote}}
{\end{quote}\end{alwayssingle}}

% The acknowledgementslong environment puts a large, bold, centered 
% "Acknowledgements" label at the top of the page. The acknowledgement itself 
% does not appears in a quote environment so you can get more in.

\newenvironment{acknowledgementslong}
{\pagestyle{empty}
\begin{alwayssingle}
\begin{center}
\vspace*{1.5cm}
{\Large \bfseries Acknowledgements}
\end{center}
\vspace{0.5cm}
}
{\end{alwayssingle}}

% ABSTRACT
%
% The abstract environment puts a large, bold, centered "Abstract" label at
% the top of the page. The abstract itself appears in a quote environment,
% i.e. tabbed in at both sides, and on its own page.

\newenvironment{abstracts} {\begin{alwayssingle} \pagestyle{empty}
  \begin{center}
  \vspace*{1.5cm}
  {\Large \bfseries Abstract}
  \end{center}
  \vspace{0.5cm}
   \begin{quote}}
{\end{quote}\end{alwayssingle}}

% The abstractlong environment puts a large, bold, centered "Abstract" label at
% the top of the page. The abstract itself does not appears in a quote
% environment so you can get more in.

\newenvironment{abstractslong} {\begin{alwayssingle} \pagestyle{empty}
  \begin{center}
  \vspace*{1.5cm}
  {\Large \bfseries Abstract}
  \end{center}
  \vspace{0.5cm}
  }
{\end{alwayssingle}}

% The abstractseparate environment is for running of a page with the abstract
% on including title and author etc as required to be handed in separately

\newenvironment{abstractseparate} {\begin{alwayssingle} \pagestyle{empty}
    \begin{center}
    \vspace*{0cm}
    \Tspace{
        \Large
        \bfseries
        \@title
        }{1ex}
    \Tspace{
        \large
        \@author
        }{1ex}

    \Tspace{
        \large 
        \@collegeordept \\
        \@university
        }{1ex}

    \Tspace{
        \it 
        be accepted in partial fulfillment of the \\ 
        requirements for the degree of\\
        \@degree
        }{2ex}

    \@submitdate

  \end{center}}
{\end{alwayssingle}}

% ROMANPAGES
%
% The romanpages environment set the page numbering to lowercase roman one
% for the contents and figures lists. It also resets
% page-numbering for the remainder of the dissertation (arabic, starting at 1).

\newenvironment{romanpages}
{\setcounter{page}{1}
  \renewcommand{\thepage}{\roman{page}}}

{\newpage\renewcommand{\thepage}{\arabic{page}}\setcounter{page}{1}}
