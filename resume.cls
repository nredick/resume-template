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
% \RequirePackage{lmodern} % serif

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
    bottom=0.25cm
]{geometry}

% switch-case implementation (https://tex.stackexchange.com/a/420399)
\RequirePackage{xifthen}
\newcommand{\ifequals}[4]{\ifthenelse{\equal{#1}{#2}}{#3}{#4}}
\newcommand{\case}[2]{#1 #2} % dummy, so there is something to overwrite
\newenvironment{switch}[1]{\renewcommand{\case}{\ifequals{#1}}}{}

% clickable links
\usepackage[draft=false]{hyperref}

% more efficient compilation for links
\RequirePackage{bookmark}

% date formatting
% https://ca.mirrors.cicku.me/ctan/macros/latex/contrib/isodate/isodate.pdf
\RequirePackage[english,num]{isodate}
\dateinputformat{tex} % (yyyy/mm/dd)
\isorangesign{\ \textendash\ } % \ to enforce spaces around en dash
\origdate
\printdayoff

% icons
\RequirePackage{fontawesome5}
\RequirePackage{academicons}

% table settings
\RequirePackage{supertabular,tabularx}
\newlength{\fullcollw}
\setlength{\fullcollw}{0.5\textwidth}

% centered version of 'X' col. type
\newcolumntype{C}{>{\centering\arraybackslash}X}

%% set default spacing
% set default vertical spacing
\newcommand{\defaultvspacing}{0.75ex}

% set default horizontal spacing
\newcommand{\defaulthspacing}{0.75em}

% define resume header
\NewDocumentCommand{\resumeheadercontent}{m m o o}{%
    \huge{\scshape #1 #2} \\
    \IfNoValueTF{#3}%
        {\vspace{\defaultvspacing}}%
        {\IfNoValueTF{#4} % Check if the icon parameter is provided
            {% No icon provided
            \IfNoValueTF{#3}%
                {}% No location
                {\hspace{\defaulthspacing}\large\textit{#3}\hspace{\defaulthspacing}}%
            }%
            {% Icon provided
            \hspace{\defaulthspacing}\large\textit{\raisebox{-0.05\height}{#4}\ #3}\hspace{\defaulthspacing}%
            }%
    }%
}

% inline location def
\NewDocumentCommand{\inlinelocation}{m O{\faIcon{map-marker-alt}}}{
    #2\ #1
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
        \href{#1}{#3\ #2} % Icon and URL text
        }
}

% define a separator to be used for the resume links
\RequirePackage{graphicx}
\newcommand{\defaultseparator}{$|$}
\NewDocumentCommand{\separator}{
        O{1} % use spacing on either side, defaults to true
        O{\defaultseparator} % character to use as separator
    }{%
    \begin{switch}{#1}
        \case{2}{
            #2 % sep
        }{
            \hspace{0em}#2\hspace{0em}
        }
    \end{switch}
}

% define the environment for header
\newenvironment{resumeheader}
    {\begin{center}}
    {\end{center}\vspace{\defaultvspacing}}

% define custom itemize
\RequirePackage{enumitem}
\newlist{resumeitemize}{itemize}{1}

% adjust 'label' to use the default bullet
\newcommand{\defaultbullet}{--}
\setlist[resumeitemize,1]{partopsep=0pt, topsep=0pt, noitemsep=0pt, nolistsep=0pt, left=0pt, label=\defaultbullet}

% reduce spacing after the resumeheader
\AtEndEnvironment{resumeheader}{\vspace{-1.75ex}}

% color functions
\newcommand{\lightercolor}[3]{% Reference Color, Percentage, New Color Name
    \colorlet{#3}{#1!#2!white}
}

\newcommand{\darkercolor}[3]{% Reference Color, Percentage, New Color Name
    \colorlet{#3}{#1!#2!black}
}

% define a command for creating and education block
\NewDocumentCommand{\school}{
    O{2} % Optional argument: 2-line layout (default) or 1-line layout
    m % Mandatory argument: School Name
    m % Mandatory argument: School Location
    m % Mandatory argument: Date
    O{} % Optional argument: GPA
    O{} % Optional argument: Degree (can be empty)
    O{} % Optional argument: Description (can be empty)
}{
    % Determine the layout based on the first argument
    \begin{switch}{#1}
        \case{1}{
            % Case for 1-line layout
            % Use tabularx environment to arrange content in one line
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the school name in bold and location in italic
                \textbf{#2}\hspace{\defaulthspacing}\textit{#3}
                % Optionally include the degree if provided
                \IfNoValueTF{#6}%
                    {}%
                    {\separator\@ifmtarg{#6}{}{#6}}%
                % Align GPA and date on the right
                & \hfill
                & \IfNoValueTF{#5}%
                    {}%
                    {\@ifmtarg{#5}{}{#5\separator}}%
                \textbf{#4}
            \end{tabularx}

            % Handle the description based on the type
            % Check if the description (#7) is provided
            \IfNoValueTF{#7}
                {}
                {#7}
        }{
            % Case for 2-line layout (default)
            % Use tabularx environment to arrange content in two lines
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the school name in bold
                \textbf{#2}
                % Optionally include the degree if provided
                \IfNoValueTF{#6}%
                    {}%
                    {\separator\@ifmtarg{#6}{}{#6} }%
                % Align the date on the right
                & \hfill
                & \textbf{#4} \\ % School Name and Date
                % Display the school location in italic and GPA
                \textit{#3}
                & \hfill
                & \IfNoValueTF{#5}%
                    {}%
                    {\@ifmtarg{#5}{}{#5}}%
            \end{tabularx}

            % Handle the description based on the type
            % Check if the description (#7) is provided
            \IfNoValueTF{#7}
                {}
                {#7}
        }
    \end{switch}

    % Add vertical spacing after the entry
    \vspace{\defaultvspacing}
}

% build skill bars
\RequirePackage{tikz}
\NewDocumentCommand{\skillbar}{
    O{5} % width of skill bar
    m % skill text
    m % skill percent (out of 100) ex. 25
    O{1} % bar format style
    }{%
    \begin{tikzpicture}
        % Extract width and skill value
        \pgfmathsetmacro{\width}{#1}
        \pgfmathsetmacro{\value}{#3}
        \pgfmathsetmacro{\height}{0.4}

        % Calculate the fill proportion
        \pgfmathsetmacro{\fillwidth}{\width * (\value / 100)}

        % Draw the background rectangle with rounded corners
        \draw[fill=lightaccent,lightaccent, rounded corners=2pt] (0,0) rectangle (\width,\height);

        % Draw the foreground rectangle with rounded corners and fill level
        \draw[fill=white,accent, rounded corners=2pt] (0,0) rectangle (\fillwidth,\height);

        % Determine the label position based on the fourth argument
        \pgfmathsetmacro{\labelpos}{#4}
        \ifnum\labelpos=3
            % Label the skill above the bar
            \node[above left, anchor=east, inner sep=0pt] at (,0.625) {\small{#2}};
        \fi
        \ifnum\labelpos=2
            % Label the skill inside the bar with black text
            \node[anchor=east, text=black, inner sep=0pt] at (-0.125,0.2) {\small{#2}};
        \fi
        \ifnum\labelpos=1
            % Label the skill inside the bar with white text
            \node[anchor=west, text=white, inner sep=0pt] at (0.05,0.2) {\small{#2}};
        \fi
    \end{tikzpicture}
    \vspace{\defaultvspacing}
}

% footer
\newcommand{\footer}{
  \vfill
  \begin{center}
    \footnotesize{\color{halfblack}{Last updated: \printdayon\today}}
  \end{center}
}
