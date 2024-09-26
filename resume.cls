\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2024/08/05 Academic RESUME LaTeX class]

% base class, font size
% todo: make font size adjustable
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
\RequirePackage{etoolbox} % for AtBeginEnvironment defs, etc.
\RequirePackage{keyval} % for key-value arguments

% page geometry/margins
% todo: make margins adjustable
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

\newenvironment{switch}[1]{%
    \renewcommand{\case}[2]{\ifequals{#1}{##1}{##2}{}}%
}{}

% clickable links
\RequirePackage[draft=false]{hyperref}

% more efficient compilation for links
\RequirePackage{bookmark}

% date formatting
% todo: make date formatting adjustable
% https://ca.mirrors.cicku.me/ctan/macros/latex/contrib/isodate/isodate.pdf
\RequirePackage[english,num]{isodate}
\dateinputformat{tex} % (yyyy/mm/dd)
\isorangesign{\ \textendash\ } % \ to enforce spaces around en dash
\origdate
\printdayoff

% icons
\RequirePackage{fontawesome5}
\RequirePackage{academicons}

% skill bars
\RequirePackage{tikz}

% table settings
\RequirePackage{supertabular,tabularx}

% centered version of 'X' col. type
\newcolumntype{C}{>{\centering\arraybackslash}X}

%% set default spacing
% set default vertical spacing
\newcommand{\defaultvspacing}{0.15cm}

% set default horizontal spacing
\newcommand{\defaulthspacing}{0.1cm}

% define a default separator
\RequirePackage{graphicx}
\newcommand{\defaultseparator}{|}
\NewDocumentCommand{\separator}{
        % O{0} % use spacing on either side, defaults to true
        O{\defaultseparator} % character to use as separator
    }{%
    \hspace{\defaulthspacing}#1\hspace{\defaulthspacing}
    % \begin{switch}{#1}
    %     \case{0}{
    %         #2 % sep
    %     }
    %     \case{1}{
    %         \hspace{0.1em}#2\hspace{0.1em}
    %     }
    % \end{switch}
}

% define a default link icon
\newcommand{\defaultlinkicon}{\faLink}
\NewDocumentCommand{\linkicon}{
        O{\defaultlinkicon} % character to use as link icon
    }{%
    \small\ #1
}

\newenvironment{tightcenter}{%
  \setlength\topsep{0pt}
  \setlength\parskip{0pt}
  \begin{center}
}{%
  \end{center}
}

% define custom itemize
\RequirePackage{enumitem}
\newlist{resumeitemize}{itemize}{1}

% adjust 'label' to use the default bullet
\newcommand{\defaultbullet}{--}
\setlist[resumeitemize,1]{partopsep=0pt, topsep=0pt, noitemsep=0pt, nolistsep=0pt, left=0pt, label=\defaultbullet}

% color functions
\newcommand{\lightercolor}[3]{% Reference Color, Percentage, New Color Name
    \colorlet{#3}{#1!#2!white}
}

\newcommand{\darkercolor}[3]{% Reference Color, Percentage, New Color Name
    \colorlet{#3}{#1!#2!black}
}

% define resumeheader block
\newcommand{\formatheader}[5]{
    \LARGE{\scshape#1 #2}

    \IfValueTF{#3}{
        \normalsize #3
        \smallskip
    }{}
}

% format links
% todo: fix l/r padding issue
\newcommand{\formatlinks}[1]{
    % \small\begin{tabular}{@{}c@{}}#1\end{tabular}
    \mbox{\small#1}
}

\makeatletter
% Define key-value pairs for the resume header
\define@key{resumeheader}{alignment}[c]{\def\RH@alignment{#1}}
\define@key{resumeheader}{firstname}{\def\RH@firstname{#1}}
\define@key{resumeheader}{lastname}{\def\RH@lastname{#1}}
\define@key{resumeheader}{location}[]{\def\RH@location{#1}}
\define@key{resumeheader}{locationicon}[]{\def\RH@locationicon{#1}}

% Resume header command with key-value pairs and a group of links
% todo: should i make links optional?
\NewDocumentCommand{\resumeheader}{O{} m}{
    \setkeys{resumeheader}{alignment=c,firstname=,lastname=,location=,locationicon=,#1}
    \begin{switch}{\RH@alignment}
        \case{c}{
            \begin{center}
                \LARGE{\scshape\RH@firstname\ \RH@lastname}\smallskip

                \IfValueTF{\RH@location}{
                    \normalsize\RH@location
                    \smallskip
                }{}

                \formatlinks{#2}
            \end{center}
        }
        \case{l}{
            \begin{flushleft}
                \LARGE{\scshape\RH@firstname\ \RH@lastname}\smallskip

                \IfValueTF{\RH@location}{
                    \normalsize\RH@location
                    \smallskip
                }{}

                \formatlinks{#2}
            \end{flushleft}
        }
        \case{r}{
            \begin{flushright}
                \LARGE{\scshape\RH@firstname\ \RH@lastname}\smallskip

                \IfValueTF{\RH@location}{
                    \normalsize\RH@location
                    \smallskip
                }{}

                \formatlinks{#2}
            \end{flushright}
        }
    \end{switch}
    \vspace{-\defaultvspacing}
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
        \href{#1}{#2}}
        { % Icon provided
        \href{#1}{#3\ #2}}
}

% define a command for creating an education block
\makeatletter
% Define key-value pairs for the education block
\define@key{edu}{layout}[2]{\def\SH@layout{#1}} % Default layout is 2
\define@key{edu}{name}{\def\SH@name{#1}} % edu Name
\define@key{edu}{location}{\def\SH@location{#1}} % edu Location
\define@key{edu}{date}{\def\SH@date{#1}} % Date
\define@key{edu}{gpa}[]{\def\SH@gpa{#1}} % GPA (optional)
\define@key{edu}{degree}[]{\def\SH@degree{#1}} % Degree (optional)

% edu command with key-value pairs and a separate description argument
\NewDocumentCommand{\edu}{O{} m}{
    \setkeys{edu}{layout=2,name=,location=,date=,gpa=,degree=,#1}

    % Determine the layout based on the `layout` key
    \begin{switch}{\SH@layout}
        \case{1}{
            % Case for 1-line layout
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the edu name in bold and location in italic
                \textbf{\SH@name},~\textit{\SH@location}
                % Optionally include the degree if provided
                \IfValueTF{\SH@degree}
                    {\separator~\SH@degree}
                    {}
                % Align GPA and date on the right
                & \hfill
                & \IfValueTF{\SH@gpa}
                    {\SH@gpa~\separator}
                    {}
                \SH@date
            \end{tabularx}

            % Handle the description as a separate argument if provided
            \IfNoValueTF{#2}
                {}
                {#2}
        }
        \case{2}{
            % Case for 2-line layout (default)
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the edu name in bold
                \textbf{\SH@name}
                % Optionally include the degree if provided
                \IfValueTF{\SH@degree}
                    {\separator \SH@degree}
                    {}
                % Align the date on the right
                & \hfill
                & \SH@date \\ % edu Name and Date
                % Display the edu location in italic and GPA
                \textit{\SH@location}
                & \hfill
                & \IfValueTF{\SH@gpa}
                    {\SH@gpa}
                    {}
            \end{tabularx}

            % Handle the description as a separate argument if provided
            \IfNoValueTF{#2}
                {}
                {#2}
        }
    \end{switch}

    % Add vertical spacing after the entry
    \vspace{\defaultvspacing}
}
\makeatother


\makeatletter
% Define key-value pairs for the experience block
\define@key{experience}{layout}[2]{\def\EX@layout{#1}} % Default layout is 2
\define@key{experience}{title}{\def\EX@title{#1}} % Job Title
\define@key{experience}{company}{\def\EX@company{#1}} % Company Name
\define@key{experience}{location}{\def\EX@location{#1}} % Location
\define@key{experience}{date}{\def\EX@date{#1}} % Date
\define@key{experience}{link}[]{\def\EX@link{#1}} % Link to company website (optional)

% Experience command with key-value pairs and a separate description argument
\NewDocumentCommand{\experience}{O{} m}{
    \setkeys{experience}{layout=2,title=,company=,location=,date=,link=,#1}

    % Determine the layout based on the `layout` key
    \begin{switch}{\EX@layout}
        \case{1}{
            % Case for 1-line layout
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the job title in bold and company name
                \textbf{\EX@title}\ @\ \EX@company
                % Check if the link is non-empty
                \ifx\EX@link\@empty
                    % Do nothing if link is empty
                \else
                    % If link is provided, insert icon with href
                    ~\href{\EX@link}{\linkicon}
                \fi
                % Align the location and date on the right
                & \hfill
                & \textit{\EX@location} \separator \EX@date
            \end{tabularx}

            % Add the description within the 1-line layout
            \IfNoValueTF{#2}
                {}
                {#2}
        }
        \case{2}{
            % Case for 2-line layout (default)
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the job title in bold
                \textbf{\EX@title}
                % Align the date on the right
                & \hfill
                & \EX@date \\ % Job Title and Date
                % Display the company name and location
                \EX@company
                % Optionally include the company website link if provided
                % Check if the link is non-empty
                \ifx\EX@link\@empty
                    % Do nothing if link is empty
                \else
                    % If link is provided, insert icon with href
                    ~\href{\EX@link}{\linkicon}
                \fi
                & \hfill
                & \textit{\EX@location}
            \end{tabularx}

            % Add the description within the 2-line layout
            \IfNoValueTF{#2}
                {}
                {#2}
        }
    \end{switch}

    % Add vertical spacing after the entry
    \vspace{\defaultvspacing}
}
\makeatother

% block for award item
\makeatletter
% Define key-value pairs for the award block
\define@key{award}{layout}[2]{\def\AW@layout{#1}} % Default layout is 2
\define@key{award}{title}{\def\AW@title{#1}} % Award Title
\define@key{award}{organization}{\def\AW@organization{#1}} % Awarding Organization
\define@key{award}{date}{\def\AW@date{#1}} % Date
\define@key{award}{amount}[]{\def\AW@amount{#1}} % Award amount (optional)

% Award command with key-value pairs and a separate description argument
\NewDocumentCommand{\award}{O{} m}{
    \setkeys{award}{layout=2,title=,organization=,date=,amount=,#1}

    % Determine the layout based on the `layout` key
    \begin{switch}{\AW@layout}
        \case{1}{
            % Case for 1-line layout
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the award title and organization
                \textbf{\AW@title},\ \AW@organization
                % Optionally include the amount if provided
                \IfNoValueTF{\AW@amount}
                    {} % Do nothing if amount is not provided
                    { (\AW@amount)} % Add amount in parentheses if provided
                % Align the date on the right
                & \hfill
                & \AW@date
            \end{tabularx}

            % Description as a separate argument
            \IfNoValueTF{#2}
                {} % Do nothing if no description
                {#2}
        }
        \case{2}{
            % Case for 2-line layout (default)
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the award title
                \textbf{\AW@title}
                % Align the date on the right
                & \hfill
                & \AW@date \\ % Award Title and Date
                % Display the awarding organization
                \AW@organization
                % Optionally include the amount if provided
                & \hfill
                & \IfNoValueTF{\AW@amount}
                    {} % Do nothing if no amount
                    {\AW@amount}
            \end{tabularx}

            % Description as a separate argument
            \IfNoValueTF{#2}
                {} % Do nothing if no description
                {#2}
        }
    \end{switch}

    % Add vertical spacing after the entry
    \vspace{\defaultvspacing}
}
\makeatother


% build skill bars
\makeatletter
% Define key-value pairs for the skill bar
\define@key{skillbar}{width}[5]{\def\SKB@width{#1}}      % Default width is 5
\define@key{skillbar}{height}[0.45]{\def\SKB@height{#1}}  % Default height is 11
\define@key{skillbar}{rounding}[6.5pt]{\def\SKB@rounding{#1}}  % Skill percent (default is 6.5pt)
\define@key{skillbar}{percent}[50]{\def\SKB@percent{#1}}  % Skill percent (default is 50)
\define@key{skillbar}{layout}[1]{\def\SKB@layout{#1}}     % Default layout is 1

% Skill bar command with key-value pairs and a separate description argument
\NewDocumentCommand{\skillbar}{O{} m}{
    \setkeys{skillbar}{width=5,height=0.45,rounding=6.5pt,percent=50,layout=1,#1}

    \begin{tikzpicture}
        % Extract width, height, and skill value
        \pgfmathsetmacro{\width}{\SKB@width}
        \pgfmathsetmacro{\height}{\SKB@height}
        \pgfmathsetmacro{\value}{\SKB@rounding}
        \pgfmathsetmacro{\value}{\SKB@percent}

        % Calculate the fill proportion
        \pgfmathsetmacro{\fillwidth}{\width * (\value / 100)}

        % Draw the background rectangle with rounded corners
        \draw[fill=lightaccent, rounded corners=\SKB@rounding, draw=none] (0,0) rectangle (\width,\height);

        % Draw the foreground rectangle with rounded corners and fill level
        \draw[fill=accent, rounded corners=\SKB@rounding, draw=none] (0,0) rectangle (\fillwidth,\height);

        % Determine the label position based on the layout key
        \pgfmathsetmacro{\labelpos}{\SKB@layout}
        \ifnum\labelpos=1
            % Label the skill above the bar
            \node[above right, anchor=west, inner sep=0pt] at (0, 0.25+\height) {\small{#2}};
        \fi
        \ifnum\labelpos=2
            % Label the skill inside the bar with black text
            \node[anchor=east, text=black, inner sep=0pt] at (-0.125, \height/2) {\small{#2}};
        \fi
        \ifnum\labelpos=3
            % Label the skill inside the bar with white text
            \node[anchor=west, text=white, inner sep=0pt] at (0.125, \height/2) {\small{#2}};
        \fi
    \end{tikzpicture}
    \vspace{\defaultvspacing}
}
\makeatother





% footer
\newcommand{\lastupdated}{
  \vfill
  \begin{tightcenter}
    \footnotesize{\color{halfblack}{Last updated: \printdayon\today}}
  \end{tightcenter}
}
