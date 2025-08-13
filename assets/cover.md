---
geometry: a5paper
documentclass: article
header-includes:
  - \usepackage{graphicx}
  - \usepackage{tikz}
  - \usepackage{eso-pic}
  - \usepackage{xcolor}
  - \pagestyle{empty}
---

\AddToShipoutPictureBG{%
  \AtPageLowerLeft{%
    \color{black}\rule{\paperwidth}{\paperheight}%
  }%
}

\AddToShipoutPictureBG{%
  \AtPageLowerLeft{%
    \includegraphics[width=\paperwidth,height=\paperheight]{raccoonops_logo.png}%
  }%
}

\color{white}

\begin{center}
\vspace*{2cm}
{\Huge\textbf{RaccoonOps Field Manual}}

\vspace{1cm}
{\Large RockyDevRaccoon}

\vspace{2cm}
% Add SVG elements using TikZ
\begin{tikzpicture}
\draw[thick,white] (0,0) rectangle (3,1);
\node[white] at (1.5,0.5) {SVG Element};
\end{tikzpicture}
\end{center}