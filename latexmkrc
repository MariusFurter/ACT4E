$pdflatex='pdflatex --shell-escape -synctex=1 -halt-on-error -file-line-error ';
$pdf_mode = 1;
@generated_exts = (@generated_exts, 'synctex.gz');

# add this to your ~/.latexmkrc
# $pdf_previewer = 'open -a Skim'
