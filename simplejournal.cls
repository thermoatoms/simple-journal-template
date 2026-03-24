%% simplejournal.cls
%% A minimal, clean document class for scientific papers.
%%
%% Options:
%%   onecolumn  (default) — single-column layout
%%   twocolumn            — two-column layout
%%   preprint             — double line spacing, single column, 12pt
%%   linenumbers          — show line numbers in the margin
%%
%% No watermarks. No decorations. Just text.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{simplejournal}[2026/03/23 v1.0 Simple journal template]

%% ---- Internal flags ----
\newif\if@preprint   \@preprintfalse
\newif\if@linenumbers \@linenumbersfalse
\newif\if@twocol     \@twocolfalse

%% ---- Option declarations ----
\DeclareOption{preprint}{\@preprinttrue}
\DeclareOption{linenumbers}{\@linenumberstrue}
\DeclareOption{twocolumn}{\@twocoltrue}
\DeclareOption{onecolumn}{\@twocolfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

%% ---- Base class ----
\if@preprint
  \LoadClass[12pt]{article}
\else
  \if@twocol
    \LoadClass[10pt,twocolumn]{article}
  \else
    \LoadClass[11pt]{article}
  \fi
\fi

%% ---- Required packages ----
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{mathpazo}           % Palatino text + math
\RequirePackage{microtype}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{amsmath,amssymb}
\RequirePackage{cite}               % compress consecutive citations: [1,2,3]→[1–3]
\RequirePackage{hyperref}
\RequirePackage{xcolor}

%% ---- Page geometry ----
\if@twocol
  \geometry{a4paper, margin=1.8cm, columnsep=0.6cm}
\else
  \geometry{a4paper, left=2.5cm, right=2.5cm, top=2.5cm, bottom=2.5cm}
\fi

%% ---- Hyperlinks ----
\hypersetup{
  colorlinks=true,
  linkcolor={blue!60!black},
  citecolor={blue!60!black},
  urlcolor={blue!60!black},
}

%% ---- Preprint double spacing ----
\if@preprint
  \RequirePackage{setspace}
  \doublespacing
\fi

%% ---- Line numbers ----
\if@linenumbers
  \RequirePackage[mathlines]{lineno}
  \AtBeginDocument{\linenumbers}
\fi

%% ---- Section formatting (clean, no numbering clutter) ----
\RequirePackage{titlesec}
\titleformat{\section}{\large\bfseries}{\thesection.}{0.5em}{}
\titleformat{\subsection}{\normalsize\bfseries}{\thesubsection.}{0.5em}{}
\titleformat{\subsubsection}{\normalsize\itshape}{\thesubsubsection.}{0.5em}{}

%% ---- Paragraph style: flush left, space between paragraphs ----
\RequirePackage{parskip}   % sets \parindent=0pt, adds space between paragraphs

%% ---- Abstract storage (used by twocolumn mode) ----
%% In twocolumn mode, place \begin{abstract}...\end{abstract} BEFORE \maketitle.
%% The abstract text is collected here and output inside the full-width \twocolumn[...] block.
\newbox\@abstractbox
\newif\if@abstractset \@abstractsetfalse

%% ---- Abstract environment ----
\renewenvironment{abstract}{%
  \if@twocol
    %% In twocolumn mode: collect into a box for use in \maketitle
    \global\@abstractsettrue
    \global\setbox\@abstractbox=\vbox\bgroup
      \hsize=0.88\textwidth
      \small\textbf{Abstract.}~\ignorespaces
  \else
    \begin{center}\begin{minipage}{0.88\textwidth}%
      \small\textbf{Abstract.}~\ignorespaces
  \fi
}{%
  \if@twocol
    \egroup  % end \vbox
  \else
    \end{minipage}\end{center}\vskip 1em
  \fi
}

%% ---- Title block ----
\renewcommand{\maketitle}{%
  \setcounter{footnote}{0}%
  \renewcommand{\thefootnote}{\fnsymbol{footnote}}%
  \begingroup
  \if@twocol
    \twocolumn[{%
      \centering
      {\LARGE\bfseries\@title\par}\vskip 0.8em
      {\large\@author\par}\vskip 0.4em
      {\small\@date\par}\vskip 1.2em
      \if@abstractset
        \begin{center}\usebox\@abstractbox\end{center}\vskip 1em
      \fi
    }]%
  \else
    \begin{center}
      {\LARGE\bfseries\@title\par}\vskip 0.8em
      {\large\@author\par}\vskip 0.4em
      {\small\@date\par}
    \end{center}
    \vskip 1em
  \fi
  \endgroup
  \@thanks                          % output email/thanks footnote texts
  \global\let\@thanks\@empty
  \setcounter{footnote}{0}%
  \renewcommand{\thefootnote}{\arabic{footnote}}%
}

%% ---- Keywords ----
\newcommand{\keywords}[1]{%
  \begin{center}%
    \begin{minipage}{0.88\textwidth}%
      \small\textbf{Keywords:} #1%
    \end{minipage}%
  \end{center}%
  \vskip 1em
}

%% ---- Affiliations helper ----
\newcommand{\affil}[1]{{\normalsize\itshape #1}}

%% ---- ORCID ----
%% Usage: \orcid{0000-0000-0000-0000}
%% Renders a linked ORCID iD icon next to the author name.
\RequirePackage{orcidlink}

%% ---- Corresponding author email as footnote ----
%% Usage: \email{address@example.com}  (place inside \author{...})
%% Inserts a \thanks{}-based footnote with the email address.
\newcommand{\email}[1]{\thanks{Corresponding author: \href{mailto:#1}{#1}}}

%% ---- DOI and URL commands ----
\providecommand{\doi}[1]{\href{https://doi.org/#1}{doi:#1}}
\providecommand{\url}[1]{\texttt{#1}}

\endinput
