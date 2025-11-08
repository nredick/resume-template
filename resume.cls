\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2024/08/05 Academic resume LaTeX class]

\newcommand{\ftsize}{12pt}
% base class, font size
% todo: make font size adjustable
\LoadClass[\ftsize]{article}

% font family
\RequirePackage[T1]{fontenc}
% more font options: https://tug.org/FontCatalogue
\RequirePackage[default]{sourcesanspro} % sans serif
% \RequirePackage{charter} % serif

% non-numbered pages
% \pagenumbering{gobble}

% for more complex/optional inputs to commands
\RequirePackage{xparse}
\RequirePackage{etoolbox} % for AtBeginEnvironment defs, etc.
\RequirePackage{keyval} % for key-value arguments
\RequirePackage{fancyhdr} % for footer (last updated)
\RequirePackage{lastpage} % for page numbering

% page geometry/margins
% todo: make margins adjustable
\RequirePackage[
    a4paper,
    left=0.5in,
    right=0.5in,
    top=0.5in,
    bottom=0.5in,
    footskip=18pt,
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
\isorangesign{\textendash}
\origdate
\printdayoff

% Redefine month names for English (abbreviated without periods)
\makeatletter
\def\month@english{%
  \ifcase\month\or
  Jan\or Feb\or Mar\or Apr\or May\or Jun\or Jul\or Aug\or Sept\or Oct\or Nov\or Dec\fi}
\makeatother

% icons
\RequirePackage{fontawesome5}
\RequirePackage{academicons}

% skill bars
\RequirePackage{tikz}

% publications import
\RequirePackage[ % References
    backend=biber,
    style=apa, % apa, nature, ieee, chicago-authordate, etc.
    sorting=ydmnt, % Sort by year (descending), name, title
    % labeldate=year,
    date=year,
]{biblatex}
\addbibresource{resume.bib}

\DeclareSortingTemplate{ymdnt}{
  \sort[direction=descending]{
    \field{year}
  }
  \sort[direction=descending]{
    \field{month}
  }
  \sort[direction=descending]{
    \field{day}
  }
  \sort{
    \field{author}
  }
  \sort{
    \field{title}
  }
}

\ExecuteBibliographyOptions{sorting=ymdnt}

\RequirePackage{csquotes}

% table settings
\RequirePackage{supertabular,tabularx}

% centered version of 'X' col. type
\newcolumntype{C}{>{\centering\arraybackslash}X}

%% set default spacing
% set default vertical spacing
\newcommand{\defaultvspacing}{3pt}

% set default horizontal spacing
\newcommand{\defaulthspacing}{2pt}

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

% smaller superscript
\newcommand{\ssup}[1]{%
  \texorpdfstring{\textsuperscript{\scriptsize #1}}{#1}%
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

% format links
% todo: fix l/r padding issue
\newcommand{\formatlinks}[1]{
    % \small\begin{tabular}{@{}c@{}}#1\end{tabular}
    \mbox{\small#1}
}

\makeatletter
% todo add a subtitle (i.e. curriculum vitae)
% Define key-value pairs for the resume header
\define@key{resumeheader}{alignment}[c]{\def\RH@alignment{#1}}
\define@key{resumeheader}{firstname}{\def\RH@firstname{#1}}
\define@key{resumeheader}{lastname}{\def\RH@lastname{#1}}
\define@key{resumeheader}{subtitle}{\def\RH@subtitle{#1}}
\define@key{resumeheader}{location}[]{\def\RH@location{#1}}
\define@key{resumeheader}{locationicon}[]{\def\RH@locationicon{#1}}

% resume header command with key-value pairs and a group of links
% todo: should i make links optional?
\NewDocumentCommand{\resumeheader}{O{} m}{
    \setkeys{resumeheader}{alignment=c,firstname=,lastname=,subtitle=,location=,locationicon=,#1}
    \begin{switch}{\RH@alignment}
        \case{c}{
            \begin{center}
                \LARGE{\scshape\RH@firstname~\RH@lastname}
                \ifx\RH@subjtitle\empty
                \else
                    \\ \color{halfblack}\normalsize{\scshape\RH@subtitle}
                    \color{black}
                \fi
                \ifx\RH@location\empty
                \else
                    \smallbreak
                    \normalsize\RH@location
                \fi
                \formatlinks{#2}
            \end{center}
        }
        \case{l}{
            \begin{flushleft}
                \LARGE{\scshape\RH@firstname~\RH@lastname}
                \ifx\RH@subtitle\empty
                \else
                    \\ \color{halfblack}\normalsize{\scshape\RH@subtitle}
                    \color{black}
                \fi
                \ifx\RH@location\empty
                \else
                    \smallbreak
                    \normalsize\RH@location
                \fi
                \formatlinks{#2}
            \end{flushleft}
        }
        \case{r}{
            \begin{flushright}
                \LARGE{\scshape\RH@firstname~\RH@lastname}
                \ifx\RH@subtitle\empty
                \else
                    \\ \color{halfblack}\normalsize{\scshape\RH@subtitle}
                    \color{black}
                \fi
                \ifx\RH@location\empty
                \else
                    \smallbreak
                    \normalsize\RH@location
                \fi
                \formatlinks{#2}
            \end{flushright}
        }
    \end{switch}
    \vspace{-0.3cm}
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
    \ifx#3\empty
        % No icon provided
        \href{#1}{#2}
    \else
        % Icon provided
        \href{#1}{#3~#2}
    \fi
}

% define a command for creating an education block
\makeatletter
% Define key-value pairs for the education block
\define@key{edu}{layout}[2]{\def\SH@layout{#1}} % Default layout is 2
\define@key{edu}{name}{\def\SH@name{#1}} % edu Name
\define@key{edu}{date}{\def\SH@date{#1}} % Date
\define@key{edu}{location}[]{\def\SH@location{#1}} % edu Location (optional)
\define@key{edu}{gpa}[]{\def\SH@gpa{#1}} % GPA (optional)
\define@key{edu}{degree}[]{\def\SH@degree{#1}} % Degree (optional)

% edu command with key-value pairs and a separate description argument
\NewDocumentCommand{\edu}{O{} m}{
    \setkeys{edu}{layout=2,name=,date=,location=,gpa=,degree=,#1}

    % Determine the layout based on the `layout` key
    \begin{switch}{\SH@layout}
        \case{1}{
            % Case for 1-line layout
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                \ifx\SH@gpa\empty
                    \textbf{\SH@degree}~@~\SH@name
                \else
                    \textbf{\SH@degree}~@~\SH@name~(\SH@gpa)
                \fi
                & \hfill
                & \ifx\SH@location\empty
                    \SH@date
                \else
                    \textit{\SH@location}\,\separator\SH@date
                \fi
                % ,~\textit{\SH@location}
            \end{tabularx}

            % Handle the description as a separate argument if provided
            \ifx#2\empty
                % Do nothing if #2 is empty
            \else
                #2
            \fi
        }
        \case{2}{
            % Case for 2-line layout (default)
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                \textbf{\SH@degree}
                \ifx\SH@gpa\empty
                    % Do nothing if gpa is empty
                \else
                    ~(\SH@gpa)
                \fi
                & \hfill
                & \SH@date \\
                % Display the edu location in italic and GPA
                \textit{\SH@name}
                & \hfill
                & \ifx\SH@location\empty
                    % Do nothing if location is empty
                \else
                    \textit{\SH@location}
                \fi
            \end{tabularx}

            % Handle the description as a separate argument if provided
            \ifx#2\empty
                % Do nothing if #2 is empty
            \else
                \vspace{2pt}
                #2
            \fi

        }
        \case{3}{
            % todo make it possible to set the minipage proportions
            \begin{minipage}[t]{0.205\textwidth} % 10% width
                % Content for the first minipage
                \SH@date
            \end{minipage}%
            \hfill
            \begin{minipage}[t]{0.77\textwidth} % 90% width
                % Content for the second minipage
                \ifx\SH@degree\empty
                    % if no degree provided, just use institution name
                    \begin{tabularx}{\textwidth}{@{}lXr@{}}
                        \textbf{\SH@name}
                        \ifx\SH@gpa\empty
                            % do nothing
                        \else
                            ~(\SH@gpa)
                        \fi
                        & \hfill
                        \ifx\SH@location\empty
                            % do nothing
                        \else
                            \textit{\SH@location}
                        \fi
                    \end{tabularx}
                \else
                    \begin{tabularx}{\textwidth}{@{}lXr@{}}
                        \textbf{\SH@degree}
                        \ifx\SH@gpa\empty
                            % do nothing
                        \else
                            ~(\SH@gpa)
                        \fi
                        & \hfill
                        & \SH@name
                        \ifx\SH@location\empty
                            % do nothing
                        \else
                            ~\separator \textit{\SH@location}
                        \fi
                    \end{tabularx}
                \fi

                % Handle the description as a separate argument if provided
                \ifx#2\empty
                    % Do nothing if #2 is empty
                \else
                    #2
                \fi
            \end{minipage}
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
                \ifx\EX@link\empty
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
            \ifx#2\empty
                % Do nothing if #2 is empty
            \else
                #2
            \fi
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
                \ifx\EX@link\empty
                    % Do nothing if link is empty
                \else
                    % If link is provided, insert icon with href
                    ~\href{\EX@link}{\linkicon}
                \fi
                & \hfill
                & \textit{\EX@location}
            \end{tabularx}

            % Add the description within the 2-line layout
            \ifx#2\empty
                % Do nothing if #2 is empty
            \else
                #2
            \fi
        }
        \case{3}{
            % todo make it possible to set the minipage proportions
            \begin{minipage}[t]{0.205\textwidth} % 10% width
                % Content for the first minipage
                \EX@date
            \end{minipage}%
            \hfill
            \begin{minipage}[t]{0.77\textwidth} % 90% width
                % Content for the second minipage
                \begin{tabularx}{\textwidth}{@{}lXr@{}}
                    \textbf{\EX@title} @%\EX@company
                    \ifx\EX@link\empty
                        \EX@company% Do nothing if link is empty
                    \else
                        % If link is provided, insert icon with href
                        % \EX@company ~\href{\EX@link}{\linkicon}
                        ~\href{\EX@link}{\EX@company}
                    \fi
                    & \hfill
                    & \textit{\EX@location}
                \end{tabularx}
                % Handle the description as a separate argument if provided
                \ifx#2\empty
                    % Do nothing if #2 is empty
                \else
                    #2
                \fi
            \end{minipage}
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
                \textit{\AW@title},\ \AW@organization
                % Optionally include the amount if provided
                \ifx\AW@amount\empty
                    % Do nothing if amount is not provided
                \else
                    ~(\AW@amount) % Add amount in parentheses if provided
                \fi
                % Align the date on the right
                & \hfill
                & \AW@date
            \end{tabularx}

            % Description as a separate argument
            \ifx#2\empty
                % Do nothing if no description
            \else
                #2
            \fi
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
                & \ifx\AW@amount\empty
                    % Do nothing if no amount
                \else
                    \AW@amount
                \fi
            \end{tabularx}

            % Description as a separate argument
            \ifx#2\empty
                % Do nothing if no description
            \else
                #2
            \fi
        }
    \end{switch}

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
\define@key{skillbar}{textcolor}[1]{\def\SKB@textcolor{#1}}     % Default layout is 1

% Skill bar command with key-value pairs and a separate description argument
\NewDocumentCommand{\skillbar}{O{} m}{
    \setkeys{skillbar}{width=5,height=0.45,rounding=6.5pt,percent=50,layout=1,textcolor=black,#1}

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
        \ifnum\labelpos=2
            % Label the skill above the bar
            \node[above right, anchor=west, text=\SKB@textcolor, inner sep=0pt] at (0, 0.25+\height) {\small{#2}};
        \fi
        \ifnum\labelpos=1
            % Label the skill inside the bar with black text
            \node[anchor=east, text=\SKB@textcolor, inner sep=0pt] at (-0.125, \height/2) {\small{#2}};
        \fi
        \ifnum\labelpos=3
            % Label the skill inside the bar with set color text
            \node[anchor=west, text=\SKB@textcolor, inner sep=0pt] at (0.125, \height/2) {\small{#2}};
        \fi

    \end{tikzpicture}
    \vspace{\defaultvspacing}
}
\makeatother

% block for skills with n cols
\makeatletter
% Define key-value pairs for the skill block
\define@key{skills}{name}{\def\SK@name{#1}}
% \define@key{skills}{cols}[1]{\def\SK@cols{#1}}
\define@key{skills}{layout}[2]{\def\SK@layout{#1}}


% Skill command with key-value pairs
\NewDocumentCommand{\skills}{O{} m}{
    \setkeys{skills}{name=,layout=2,#1}

    % Determine the number of cols based on the `cols` key
    \begin{switch}{\SK@layout}
        \case{1}{
            % \ifnum\SK@cols=1
            %     #2
            % \else
            %     \setlength{\multicolsep}{0pt}
            %     \begin{multicols}{\SK@cols}
            %         \noindent
            %         #2
            %     \end{multicols}
            % \fi
        }
        \case{2}{
            \begin{minipage}[t]{0.205\textwidth} % 10% width
                % Content for the first minipage
                \textbf{\SK@name}
            \end{minipage}%
            \hfill
            \begin{minipage}[t]{0.77\textwidth} % 90% width
                % Content for the second minipage
                % Description as a separate argument
                \ifx#2\empty
                    % Do nothing if no description
                \else
                    #2
                \fi
            \end{minipage}
        }

    \end{switch}

    % if equals 1 then no multicols env


    % Add vertical spacing after the entry
    \vspace{\defaultvspacing}
}
\makeatother

% block for certifications
% should have title, awarding org, date, optional expiration date, and optional description, optional link

\makeatletter
% Define key-value pairs for the certification block
\define@key{certification}{layout}[2]{\def\CERT@layout{#1}} % Default layout is 2
\define@key{certification}{title}{\def\CERT@title{#1}} % Certification Title
\define@key{certification}{organization}{\def\CERT@organization{#1}} % Awarding Organization
\define@key{certification}{date}{\def\CERT@date{#1}} % Date
\define@key{certification}{expiration}[]{\def\CERT@expiration{#1}} % Expiration Date (optional)
\define@key{certification}{link}[]{\def\CERT@link{#1}} % Link to certification (optional)

% Certification command with key-value pairs and a separate description argument
\NewDocumentCommand{\cert}{O{} m}{
    \setkeys{certification}{layout=1,title=,organization=,date=,expiration=,link=,#1}

    % Determine the layout based on the `layout` key
    \begin{switch}{\CERT@layout}
        \case{1}{
            % Case for 1-line layout
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the certification title and organization
                \textit{\CERT@title},\ \CERT@organization
                % Optionally include the expiration date if provided
                \ifx\CERT@expiration\empty
                    % Do nothing if expiration date is not provided
                \else
                    ~(Expires \CERT@expiration) % Add expiration date in parentheses if provided
                \fi
                % Align the date on the right
                & \hfill
                & \CERT@date
            \end{tabularx}

            % Description as a separate argument
            \ifx#2\empty
                % Do nothing if no description
            \else
                #2
            \fi
        }
        \case{2}{
            % Case for 2-line layout (default)
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the certification title
                \textit{\CERT@title}
                % Align the date on the right
                & \hfill
                & \CERT@date \\ % Certification Title and Date
                % Display the awarding organization
                \CERT@organization
                % Optionally include the expiration date if provided
                & \hfill
                & \ifx\CERT@expiration\empty
                    % Do nothing if no expiration date
                \else
                    Expires~\CERT@expiration
                \fi
            \end{tabularx}

            % Description as a separate argument
            \ifx#2\empty
                % Do nothing if no description
            \else
                #2
            \fi
        }
        \case{3}{
            % Case for left date col layout
            \begin{minipage}[t]{0.205\textwidth} % 10% width
                % Content for the first minipage
                \CERT@date
            \end{minipage}%
            \hfill
            \begin{minipage}[t]{0.77\textwidth} % 90% width
                % Content for the second minipage
                \begin{tabularx}{\textwidth}{@{}lXr@{}}
                    \textbf{\CERT@title}
                    & \hfill
                    &
                    \ifx\CERT@organization\empty
                        % Do nothing if empty
                    \else
                        % If link is provided, insert icon with href
                        ~\href{\CERT@link}{\textit{\CERT@organization}}
                    \fi
                    \ifx\CERT@expiration\empty
                        % do nothing
                    \else
                        (Expires \CERT@expiration)
                    \fi
                \end{tabularx}
                % Handle the description as a separate argument if provided
                \ifx#2\empty
                    % Do nothing if #2 is empty
                \else
                    #2
                \fi
            \end{minipage}
        }
    \end{switch}

    % % Add vertical spacing after the entry
    % \vspace{\defaultvspacing}
}
\makeatother


% block for teaching experience
\makeatletter
% Define key-value pairs for the teaching block
\define@key{teaching}{layout}[2]{\def\TEACH@layout{#1}} % Default layout is 2
\define@key{teaching}{course}{\def\TEACH@course{#1}} % Course title
\define@key{teaching}{institution}{\def\TEACH@institution{#1}} % Institution Name
\define@key{teaching}{location}{\def\TEACH@location{#1}} % Institution Location
\define@key{teaching}{date}{\def\TEACH@date{#1}} % Date
\define@key{teaching}{link}[]{\def\TEACH@link{#1}} % Link to course (optional)

% Teaching command with key-value pairs and a separate description argument
\NewDocumentCommand{\teaching}{O{} m}{
    \setkeys{teaching}{layout=2,course=,institution=,location=,date=,link=,#1}

    % Determine the layout based on the `layout` key
    \begin{switch}{\TEACH@layout}
        \case{1}{
            % Case for 1-line layout
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the course title and institution
                \textbf{\TEACH@course},\ \TEACH@institution
                % Optionally include the location if provided
                \ifx\TEACH@location\empty
                    % Do nothing if location is not provided
                \else
                    ~(\TEACH@location) % Add location in parentheses if provided
                \fi
                % Align the date on the right
                & \hfill
                & \TEACH@date
            \end{tabularx}

            % Description as a separate argument
            \ifx#2\empty
                % Do nothing if no description
            \else
                #2
            \fi
        }
        \case{2}{
            % Case for 2-line layout (default)
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the course title
                \textbf{\TEACH@course}
                % Align the date on the right
                & \hfill
                & \TEACH@date \\ % Course title and Date
                % Display the institution name
                \TEACH@institution
                % Optionally include the location if provided
                & \hfill
                & \ifx\TEACH@location\empty
                    % Do nothing if no location
                \else
                    \TEACH@location
                \fi
            \end{tabularx}

            % Description as a separate argument
            \ifx#2\empty
                % Do nothing if no description
            \else
                #2
            \fi
        }
        \case{3}{
            % todo make it possible to set the minipage proportions
            \begin{minipage}[t]{0.205\textwidth} % 10% width
                % Content for the first minipage
                \TEACH@date
            \end{minipage}%
            \hfill
            \begin{minipage}[t]{0.77\textwidth} % 90% width
                % Content for the second minipage
                \begin{tabularx}{\textwidth}{@{}lXr@{}}
                    \textbf{\TEACH@course}
                    & \hfill
                    & %\TEACH@institution
                    \ifx\TEACH@link\empty
                        \textit{\TEACH@institution}% Do nothing if link is empty
                    \else
                        % If link is provided, insert icon with href
                        % \TEACH@institution ~\href{\TEACH@link}{\linkicon}
                        ~\href{\TEACH@link}{\textit{\TEACH@institution}}
                    \fi

                    % & \textit{\TEACH@location}
                \end{tabularx}
                % Handle the description as a separate argument if provided
                \ifx#2\empty
                    % Do nothing if #2 is empty
                \else
                    #2
                \fi
            \end{minipage}
        }
    \end{switch}

    % Add vertical spacing after the entry
    \vspace{\defaultvspacing}
}
\makeatother


% block for field experience
\makeatletter
% Define key-value pairs for the field block
\define@key{field}{layout}[2]{\def\FLD@layout{#1}} % Default layout is 2
\define@key{field}{activity}{\def\FLD@activity{#1}} % What you did
\define@key{field}{who}{\def\FLD@who{#1}} % Institutions, organizers, etc.
\define@key{field}{location}{\def\FLD@location{#1}} % Institution Location
\define@key{field}{date}{\def\FLD@date{#1}} % Date
\define@key{field}{length}{\def\FLD@length{#1}} % length
\define@key{field}{link}[]{\def\FLD@link{#1}} % Link to course (optional)

% field command with key-value pairs and a separate description argument
\NewDocumentCommand{\field}{O{} m}{
    \setkeys{field}{layout=2,activity=,who=,location=,date=,length=,link=,#1}

    % Determine the layout based on the `layout` key
    \begin{switch}{\FLD@layout}
        \case{1}{
            % Case for 1-line layout
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the course title and institution
                \textbf{\FLD@activity},\ \FLD@who
                % Optionally include the location if provided
                \ifx\FLD@location\empty
                    % Do nothing if location is not provided
                \else
                    ~(\FLD@location) % Add location in parentheses if provided
                \fi
                % Align the date on the right
                & \hfill
                & \FLD@date
                \ifx\FLD@length\empty
                    % Do nothing if location is not provided
                \else
                    ~(\FLD@length) % Add location in parentheses if provided
                \fi
            \end{tabularx}

            % Description as a separate argument
            \ifx#2\empty
                % Do nothing if no description
            \else
                #2
            \fi
        }
        \case{2}{
            % Case for 2-line layout (default)
            \begin{tabularx}{\textwidth}{@{}lXr@{}}
                % Display the course title
                \textbf{\FLD@activity}
                % Align the date on the right
                & \hfill
                & \FLD@date
                \ifx\FLD@length\empty
                    % Do nothing if location is not provided
                \else
                    ~(\FLD@length) % Add location in parentheses if provided
                \fi
                \\
                % Display the institution name
                \FLD@who
                % Optionally include the location if provided
                & \hfill
                & \ifx\FLD@location\empty
                    % Do nothing if no location
                \else
                    \FLD@location
                \fi
            \end{tabularx}

            % Description as a separate argument
            \ifx#2\empty
                % Do nothing if no description
            \else
                #2
            \fi
        }
        \case{3}{
            % todo make it possible to set the minipage proportions
            \begin{minipage}[t]{0.205\textwidth} % 10% width
                % Content for the first minipage
                \FLD@date \\
                \ifx\FLD@length\empty
                    % Do nothing if location is not provided
                \else
                    \textit{\small \FLD@length} % Add location in parentheses if provided
                \fi
            \end{minipage}%
            \hfill
            \begin{minipage}[t]{0.77\textwidth} % 90% width
                % Content for the second minipage
                \begin{tabularx}{\textwidth}{@{}lXr@{}}
                    \textbf{\FLD@activity}
                    & \hfill
                    & \textit{\FLD@location}
                    % \\
                    % \FLD@who
                    % \ifx\FLD@link\empty
                    %     \textit{\FLD@who}% Do nothing if link is empty
                    % \else
                    %     % If link is provided, insert icon with href
                    %     % \FLD@who ~\href{\FLD@link}{\linkicon}
                    %     ~\href{\FLD@link}{\textit{\FLD@who}}
                    % \fi
                    % & 1
                    % & \textit{\FLD@location}
                \end{tabularx}
                \textit{\FLD@who}
                % Handle the description as a separate argument if provided
                \ifx#2\empty
                    % Do nothing if #2 is empty
                \else
                    #2
                \fi
            \end{minipage}
        }
    \end{switch}

    % Add vertical spacing after the entry
    \vspace{\defaultvspacing}
}
\makeatother



% suppress the annoying hbox overfull warning
\hfuzz=11in

% footer
\newcommand{\lastupdated}{
  \vfill
  \begin{tightcenter}
    \footnotesize{\color{halfblack}{Last updated: \printdayon\today}}
  \end{tightcenter}
}

% Set up the fancyhdr style *after* the document begins
\AtBeginDocument{%
  \pagestyle{fancy}
  \fancyhf{}                       % clear header/footer
  \fancyfoot[C]{\footnotesize{\color{halfblack}{Last updated: \printdayon\today}}}      % center footer
%   \quad (Page \thepage/\pageref{LastPage})
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}

% make sure the event title (e.g. AGU23) is printed for @misc entries
\renewbibmacro*{title}{%
  \printfield{title}%
  \iffieldundef{eventtitle}{}{\setunit~.\printfield{eventtitle}}%
  \setunit{\adddot\space}%
%   \printfield{subtitle}%
  \newunit
}

% add + to talks
\renewbibmacro*{author}{%
  \ifentrytype{misc}{%
    \ssup{+}
  }{}%
  \printnames{author}%
}

% Format venue and location fields
\DeclareFieldFormat{venue}{\textit{#1}}
\DeclareFieldFormat{location}{#1}

% Custom driver for misc entries to include venue
\DeclareBibliographyDriver{misc}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \usebibmacro{author/translator+others}%
  \setunit{\printdelim{nametitledelim}}\newblock
  \usebibmacro{title}%
  \newunit\newblock
  \printfield{note}%
  \newunit\newblock
  % Add type if present
  \iffieldundef{type}{}{%
    \printfield{type}%
    \setunit{\addcomma\space}%
  }%
  % Add venue information
  \iffieldundef{venue}{}{%
    \printfield{venue}%
  }%
  \setunit{\adddot\space}\newblock
  \usebibmacro{url+urldate}%
  \setunit{\space}%
  % Add date in parentheses at the end
  \printtext[parens]{\usebibmacro{date}}%
  \newunit\newblock
  \usebibmacro{addendum+pubstate}%
  \setunit{\bibpagerefpunct}\newblock
  \usebibmacro{pageref}%
  \newunit\newblock
  \iftoggle{bbx:related}
    {\usebibmacro{related:init}%
     \usebibmacro{related}}
    {}%
  \usebibmacro{finentry}%
}

% bibliography name highlighting
\DeclareSourcemap{
  \maps[datatype=bibtex]{
    \map{
      % Match last name 'Doe' in author field and bold it
      \step[fieldsource=author,
            match=\regexp{(.*?)(Doe)(.*)},
            replace=\regexp{$1\\textbf{$2}$3}]
    }
    % \map{
    %   % Add more last names if needed
    %   \step[fieldsource=author,
    %         match=\regexp{(.*?)(Tarling)(.*)},
    %         replace=\regexp{$1\\textbf{$2}$3}]
    % }
  }
}