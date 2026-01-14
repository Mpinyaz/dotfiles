local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
ls.add_snippets("tex", {
  s(
    "doc",
    fmta(
      [[
\documentclass{article}

\usepackage[margin=1in]{geometry}
\usepackage{amsmath, amssymb}
\usepackage{graphicx}
\usepackage{hyperref}

\title{<>}
\author{<>}
\date{\today}

\begin{document}
\maketitle

<>
\end{document}
]],
      {
        i(1, "Title"),
        i(2, "Author"),
        i(3),
      }
    )
  ),
})

ls.add_snippets("tex", {
  s("sec", fmta("\\section{<>}\n<>", { i(1), i(2) })),
  s("ssec", fmta("\\subsection{<>}\n<>", { i(1), i(2) })),
  s("sssec", fmta("\\subsubsection{<>}\n<>", { i(1), i(2) })),
})

ls.add_snippets("tex", {
  -- Inline math
  s("mm", fmta("$<>$", { i(1) })),

  -- Display math
  s(
    "dm",
    fmta(
      [[
\[
  <>
\]
]],
      { i(1) }
    )
  ),

  -- Fraction
  s("ff", fmta("\\frac{<>}{<>}", { i(1), i(2) })),

  -- Summation
  s("sum", fmta("\\sum_{<>}^{<>}", { i(1, "i=1"), i(2, "n") })),

  -- Integral
  s("int", fmta("\\int_{<>}^{<>} <>", { i(1), i(2), i(3) })),

  -- Limits
  s("lim", fmta("\\lim_{<> \\to <>}", { i(1, "x"), i(2, "\\infty") })),
})

ls.add_snippets("tex", {
  s(
    "beg",
    fmta(
      [[
\begin{<>}
  <>
\end{<>}
]],
      { i(1), i(2), i(1) }
    )
  ),

  s(
    "item",
    fmta(
      [[
\begin{itemize}
  \item <>
\end{itemize}
]],
      { i(1) }
    )
  ),

  s(
    "enum",
    fmta(
      [[
\begin{enumerate}
  \item <>
\end{enumerate}
]],
      { i(1) }
    )
  ),

  s(
    "align",
    fmta(
      [[
\begin{align}
  <>
\end{align}
]],
      { i(1) }
    )
  ),
})

ls.add_snippets("tex", {
  s(
    "fig",
    fmta(
      [[
\begin{figure}[h]
  \centering
  \includegraphics[width=<>\\textwidth]{<>}
  \caption{<>}
  \label{fig:<>}
\end{figure}
]],
      {
        i(1, "0.8"),
        i(2, "image.png"),
        i(3),
        i(4),
      }
    )
  ),

  s(
    "tab",
    fmta(
      [[
\begin{table}[h]
  \centering
  \begin{tabular}{<>}
    <>
  \end{tabular}
  \caption{<>}
\end{table}
]],
      {
        i(1, "c c c"),
        i(2),
        i(3),
      }
    )
  ),
})
ls.add_snippets("tex", {
  s("ref", fmta("\\ref{<>}", { i(1) })),
  s("cite", fmta("\\cite{<>}", { i(1) })),
  s("label", fmta("\\label{<>}", { i(1) })),
})
ls.add_snippets("tex", {
  s("bf", fmta("\\textbf{<>}", { i(1) })),
  s("it", fmta("\\textit{<>}", { i(1) })),
  s("tt", fmta("\\texttt{<>}", { i(1) })),
})
