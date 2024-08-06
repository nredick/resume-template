\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2024/08/05 Academic RESUME LaTeX class]

% require lualatex
% \RequirePackage{iftex}
% \RequireLuaTeX

% base class, font size
\LoadClass[10pt]{article}

% font family
\RequirePackage[T1]{fontenc}
% more font options: https://tug.org/FontCatalogue
\RequirePackage[default]{sourcesanspro} % sans serif
% \RequirePackage[default,light,bold]{sourceserifpro} % serif

% non-numbered pages
\pagenumbering{gobble}

% for more complex/optional inputs to commands
\RequirePackage{xparse}
\RequirePackage{etoolbox} % for AtBeginEnvironment defs, etc

% page geometry/margins
\RequirePackage[
    a4paper,
    left=1cm,
    right=1cm,
    top=0.5cm,
    bottom=0.5cm
]{geometry}

% clickable links
\RequirePackage[hidelinks, draft=false, colorlinks=true]{hyperref}

% more efficient compilation for links
\RequirePackage{bookmark}

% icons
\RequirePackage{fontawesome5}
\RequirePackage{academicons}

% table settings
\RequirePackage{supertabular,tabularx}
\newlength{\fullcollw}
\setlength{\fullcollw}{0.5\textwidth}

% centered version of 'X' col. type
\newcolumntype{C}{>{\centering\arraybackslash}X}

% set default spacing
\newcommand{\defaultspacing}{0.5ex}

% define resume header
\NewDocumentCommand{\resumeheadercontent}{m m o o}{%
    \huge{\scshape #1 #2} \\
    \vspace{\defaultspacing}
    \IfNoValueTF{#3}%
        {\vspace{-1.5ex}}%
        {\IfNoValueTF{#4} % Check if the icon parameter is provided
            {% No icon provided
            \IfNoValueTF{#3}%
                {}% No location
                {\vspace{-0.25ex}\large\textit{#3}}%
            }%
            {% Icon provided
            \vspace{-0.25ex}
            \large\textit{\raisebox{-0.05\height}{#4}\ #3}%
            }%
    }%
}

% inline location def
\NewDocumentCommand{\inlinelocation}{m O{\faIcon{map-marker-alt}}}{
    \raisebox{-0.05\height}{#2}\ #1
}

% define resume header link
\NewDocumentCommand{\resumeheaderlink}{m m o}{%
    % #1: The URL or link destination (required)
    % #2: The link text (required)
    % #3: Optional icon or additional text before the link text (optional)

    % Check if the optional argument #3 (icon) is provided
    \IfNoValueTF{#3}
        { % No icon provided
        \href{#1}{#2} % Just the URL text
        }
        { % Icon provided
        \href{#1}{\raisebox{-0.05\height}{#3}\ #2} % Icon and URL text
        }
}

% define a separator to be used for the resume links
\RequirePackage{graphicx}
\newcommand{\defaultseparator}{$|$}
\NewDocumentCommand{\separator}{O{\defaultseparator} O{1pt}}{%
    \hspace{#2} % Add padding on the left
    \textbf{#1} % Character with padding
    \hspace{#2} % Add padding on the right
}

% define the environment for header
\newenvironment{resumeheader}
    {\begin{center}}
    {\end{center}}

% define custom itemize
\RequirePackage{enumitem}
\newlist{resumeitemize}{itemize}{1}
% adjust 'label' to use the default bullet
\setlist[resumeitemize,1]{partopsep=0pt, noitemsep=0pt, nolistsep=0pt, left=0pt, label=--}
\AtBeginEnvironment{resumeitemize}{\vspace{-1ex}}

% reduce spacing after the resumeheader
\AtEndEnvironment{resumeheader}{\vspace{-0.7ex}}

% switch-case implementation (https://tex.stackexchange.com/a/420399)
\RequirePackage{xifthen}
\newcommand{\ifequals}[4]{\ifthenelse{\equal{#1}{#2}}{#3}{#4}}
\newcommand{\case}[2]{#1 #2} % Dummy, so \renewcommand has something to overwrite...
\newenvironment{switch}[1]{\renewcommand{\case}{\ifequals{#1}}}{}

% school with a gpa value
\NewDocumentCommand{\schoolwithgpa}{
    O{2} % 2 line (default) or 1 line formatting
    m % School Name
    m % School Location
    m % Date
    m % GPA
    O{} % Optional Description (defaults to empty if not provided)
}{
    \vspace{0.5ex}
    \begin{switch}{#1}
        \case{1}{
            % One line layout
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                \textbf{#2}\quad\textit{#3}
                & \hfill
                & #5 \separator #4
            \end{tabularx}
        }{
            % Two line layout (default)
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                \textbf{#2} & \hfill & \textbf{#4} \\ % School Name and Date
                \textit{#3} & \hfill & #5 \\ % School Location and GPA
            \end{tabularx}
        }
    \end{switch}
    \IfNoValueTF{#6}%
        {}%
        {\@ifmtarg{#6}{}{#6}}%
    \vspace{0.5ex}
}

% school without a gpa value
\NewDocumentCommand{\schoolwithoutgpa}{
    O{2} % 1 or 2 line formatting (default is 2)
    m % School Name
    m % School Location
    m % Date
    O{} % Optional Description (defaults to empty if not provided)
}{
    \vspace{0.5ex}
    \begin{switch}{#1}
        \case{1}{
            % One line layout
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                \textbf{#2}\quad\textit{#3}
                & \hfill
                & #4
            \end{tabularx}
        }{
            % Two line layout (default)
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                \textbf{#2} & \hfill & #4 \\ % School Name and Date
                \textit{#3} & \hfill & \hfill \\ % School Location and empty
            \end{tabularx}
        }
    \end{switch}
    \IfNoValueTF{#5}%
        {}%
        {\@ifmtarg{#5}{}{#5}}%
    \vspace{0.5ex}
}
