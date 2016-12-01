REPrnw = report/report.Rnw
REPpdf = report/report.pdf

IMAGES = images/*.png

DATAraw = data/Credit.csv #**********************
DATAscaled = data/scaled-credit.csv #**********************

DPscript = code/scripts/data-processing-script.R
EDAscript = code/scripts/eda-script.R
MODscript = code/scripts/train-test-data-script.R

.phony: all eda dataprocessing premodeling regression simulation data session report slides shinyapp clean cleanall

all: eda dataprocessing premodeling regression simulation report slides

eda: $(EDAscript) $(DATAraw)
	Rscript $(EDAscript) $(DATAraw)
	
dataprocessing: $(DPscript) $(DATAraw)
	Rscript $(DPscript) $(DATAraw)

premodeling: $(MODscript) $(DATAraw)
	Rscript $(MODscript) $(DATAraw)	

$(IMAGES):

regression: code/functions/regression.R $(DATAscaled)
	Rscript code/functions/regression.R $(DATAscaled)

simulation: code/functions/simulation.R $(DATAscaled)
	Rscript code/functions/simulation.R $(DATAscaled)

data:
	curl http://www-bcf.usc.edu/~gareth/ISL/Credit.csv > $(DATAraw)

session: session.sh #k
	bash session.sh

report: $(REPrnw) $(IMAGES)  #k
	Rscript -e "library(rmarkdown);render('$(REPrnw)')"

slides: slides/slides.Rmd  
	Rscript -e "library(markdown);render(slides/slides.Rmd)"

shinyapp: 
	Rscript -e "shiny::runApp("shinyApp/app.R", launch.browser=TRUE)"

clean: #k
	rm $(REPpdf)

cleanall: #k
	rm -rf $(REPpdf)
	rm -rf $(IMAGES)
	rm -rf data/*.RData
	rm -rf data/*.txt

