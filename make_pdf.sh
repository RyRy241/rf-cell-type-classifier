#!/bin/zsh
# CSC 659/859 HW 2 - run the notebook top to bottom, then export it as the one-PDF report.
# Code cells tagged "hide_input" show only their output in the PDF; the Appendix prints all code.
set -euo pipefail
cd "${0:A:h}"
NB="HW2_RF_e1_cluster.ipynb"
OUT="CSC 659-859 Fall 2026 HW 2 Ryan Selvarajan.PDF"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

.venv/bin/jupyter nbconvert --to notebook --execute --inplace --KernelManager.transport=ipc \
  --ExecutePreprocessor.timeout=1800 --ExecutePreprocessor.startup_timeout=180 "$NB"
.venv/bin/jupyter nbconvert --to html --no-prompt --output report "$NB"

# Print layout: letter pages, wrapped code, tables kept on one page.
.venv/bin/python -I - report.html <<'PY'
import sys
path = sys.argv[1]
css = """<style>
@page { size: Letter; margin: 0.55in 0.6in; }
:root { --jp-code-font-size: 10.5px; --jp-content-font-size1: 13px; }
body { font-size: 10pt; }
.jp-Notebook { padding: 0 !important; }
pre, .jp-OutputArea-output pre, .highlight pre {
  white-space: pre-wrap !important; word-break: break-word; font-size: 7.9pt !important; }
.jp-RenderedSVG svg { max-width: 100%; height: auto; page-break-inside: avoid; }
table { page-break-inside: avoid; font-size: 8.8pt; border-collapse: collapse; }
table caption { font-size: 9.5pt; }
.jp-RenderedImage img { max-width: 100%; page-break-inside: avoid; }
h2 { margin-top: 1.4em; }
h2, h3 { page-break-after: avoid; }
/* cells tagged hide_input: show output only; hide entirely if there is no output */
.celltag_hide_input .jp-Cell-inputWrapper { display: none !important; }
/* keep each table/figure caption on the same page as what it describes */
.jp-MarkdownCell { break-after: avoid; page-break-after: avoid; }
.jp-OutputArea { break-inside: avoid; page-break-inside: avoid; }
.celltag_hide_input.jp-mod-noOutputs { display: none !important; }
</style>"""
html = open(path, encoding="utf-8").read().replace("</head>", css + "</head>", 1)
open(path, "w", encoding="utf-8").write(html)
PY

PROFILE="$(mktemp -d)"
"$CHROME" --headless --disable-gpu --no-pdf-header-footer --user-data-dir="$PROFILE" \
  --virtual-time-budget=20000 --print-to-pdf="$OUT" "file://$PWD/report.html" 2>/dev/null
rm -rf "$PROFILE"
echo "Wrote: $PWD/$OUT"

if grep -q "TODO" report.html; then
  echo "WARNING: the report still contains TODO placeholders - fill them in before submitting."
fi
rm -f report.html                     # intermediate file; the PDF is the deliverable
