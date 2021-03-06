REPrnw = report/report.Rnw
REPpdf = report/report.pdf

IMAGES = images/*.png

DATAraw = data/female-data-2014-15.csv 
DATAscaled = data/scaled-schools.csv 
DATAschool2014 = data/MERGED2014_15_PP.csv
DATAschool2012 = data/MERGED2012_13_PP.csv

DPscript = code/scripts/data-processing-script.R
EDAscript = code/scripts/eda-script.R
MODscript = code/scripts/train-test-data-scripts.R

.phony: all eda dataprocessing premodeling regression simulation data session report slides shinyapp clean cleanall

# IMPORTANT NOTE: Dataprocessing and Simulation arent part of all because the data/MERGED2014_15_PP.csv file isnt in the folder. Too big for upload on GitHub.
# Please download the file and place it in the data folder. Add both to all targets and run project.

all: eda premodeling regression slides report shinyapp  
		# add dataprocessing and simluation above after downloading/run make data

eda: $(EDAscript) $(DATAraw)
	Rscript $(EDAscript) $(DATAraw)
	
dataprocessing: $(DPscript) $(DATAschool2012) $(DATAschool2014)
	Rscript $(DPscript) $(DATAschool2012) $(DATAschool2014)

premodeling: $(MODscript) $(DATAscaled)
	Rscript $(MODscript) $(DATAscaled)	

$(IMAGES):

regression: code/scripts/regression.R $(DATAscaled)
	Rscript code/scripts/regression.R $(DATAscaled)

simulation: code/scripts/simulation.R $(DATAraw) $(DATAschool2014) data/regression-results.RData data/train-test.RData
	Rscript code/scripts/simulation.R $(DATAraw) $(DATAschool2014) data/regression-results.RData data/train-test.RData

data: 
	curl https://ed-public-download.apps.cloud.gov/downloads/Most-Recent-Cohorts-All-Data-Elements.csv
	# NOTE: Data file is around 150MB.

session: session.sh 
	bash session.sh

report: $(REPrnw) $(IMAGES)  
	Rscript -e "library(knitr);knit2pdf('$(REPrnw)', output = 'report/report.pdf')"
	#pandoc -s report.tex -o report.pdf

slides: slides/slides.Rmd  
	Rscript -e "library(markdown);render(slides/slides.Rmd)"


shinyapp: 
	Rscript -e "library(methods); shiny::runApp("shinyApp/app.R", launch.browser=TRUE)"

clean: 
	rm $(REPpdf)

cleanall: 
	rm -rf $(REPpdf)
	rm -rf $(IMAGES)
	rm -rf data/*.txt

