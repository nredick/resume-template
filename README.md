![build](https://github.com/nredick/resume-template/actions/workflows/build.yml/badge.svg)

# Template Documentation

> Note that all commands options inside `[]` are _optional_ and the brackets and their contents can be removed

## Setting default values

Existing defaults:

1. `defaultspacing` (default=0.5ex)
2. `defaultseparator` (default=|)

In the preamble of the `tex` document (before \begin{document}), add:

```latex
\renewcommand{<command name>}{<desired value>}
```

## Location formatting options

1. Location on its own line, between name and links (`\resumeheadercontent` options)

    - With icon: `\resumeheadercontent{firstname}{lastname}[location][\faIcon{map-marker-alt}]`
    - Without icon: `\resumeheadercontent{firstname}{lastname}[location]`

2. In-line location definition, alongside the profile links: `\inlinelocation{location}[\faIcon{map-marker-alt}]`

## Education section options

1. Single-line educational details

    ```latex
    \schoolwithgpa[1]{University of Example}{Example City, EX}{May 2024}{3.83/4.00}[
        \begin{resumeitemize}
            \item Example description
        \end{resumeitemize}
    ]
    ```

2. Two-line education details (default)

    ```latex
    \schoolwithgpa{University of Example}{Example City, EX}{May 2024}{3.83/4.00}[
        \begin{resumeitemize}
            \item Example description
        \end{resumeitemize}
    ]
    ```

    Alternatively, add the [2] parameter.

3. Without GPA: replace `schoolwithgpa` with `schoolwithoutgpa` and delete the brackets and value for GPA

> Note that the description is optional and can be removed.


> This Github Workflow setup was inspired by [jitinnair1/autoCV](https://github.com/jitinnair1/autoCV). The $\LaTeX$ source code is my own.
