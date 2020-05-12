VPATH = images

cover.pdf : cover.tex text-buffers.tex isbn.tex type-mixed-minion-optima.tex chinese-title-golden.pdf chinese-bh-golden.pdf logoblia-golden.pdf logozulai-golden.pdf zulaiqrcode.pdf isbn.pdf hsing.png cover-varnish.pdf
	context cover.tex -result=cover.pdf

cover-varnish.pdf : cover.tex type-mixed-minion-optima.tex chinese-title.pdf chinese-bh.pdf logoblia.pdf logozulai.pdf
	context -mode=varnish cover.tex -result=cover-varnish.pdf

# create the institutional qrcode
zulaiqrcode.pdf :
	qrencode -t EPS -l M -m 7 -o zulaiqrcode.eps 'http://www.templozulai.org.pdf'
	# convert to pdf and move it to the image directory
	epstopdf zulaiqrcode.eps
	mv zulaiqrcode.pdf images/
	# remove intermediary eps file
	rm zulaiqrcode.eps

# create the book title in chinese
chinese-title.pdf : chinese-title.tex umechinese.ctex
	context chinese-title.tex
	# move it to images directory
	mv chinese-title.pdf images/

chinese-title-golden.pdf : chinese-title.tex umechinese.ctex
	context -mode=golden chinese-title.tex -result=chinese-title-golden.pdf
# move it to images directory
	mv chinese-title-golden.pdf images/

# create the series title in chinese
chinese-bh.pdf : chinese-bh.tex umechinese.ctex
	context chinese-bh.tex
	# move it to images directory
	mv chinese-bh.pdf images/

chinese-bh-golden.pdf : chinese-bh.tex umechinese.ctex
	context -mode=golden chinese-bh.tex -result=chinese-bh-golden.pdf
	# move it to images directory
	mv chinese-bh-golden.pdf images/

isbn.pdf : isbn.tex
	zint -o isbn.eps -b 69 -d '9788569862024'
	epstool --copy --bbox isbn.eps --output isbn-9788569862024.eps
	#  change font size from 22pt to 21pt in the eps file to eliminate the truncation of numbers on the bottom
	perl -p -i -e "s|22\.00 scalefont|21\.00 scalefont|g" isbn-9788569862024.eps
	epstopdf --hires isbn-9788569862024.eps -o isbn-9788569862024.pdf
	rm isbn.eps isbn-9788569862024.eps
	# move isbn.pdf to images
	context isbn.tex
	rm isbn-9788569862024.pdf
	mv isbn.pdf images/

clean :
	rm -rf *.tuc *.1 *.log *.mp *.mpb *.mpo *.tmp *.bak *.tuo *.tui
