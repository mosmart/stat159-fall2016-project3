# Project 3
#### Authors:

Morgan Smart, Dakota Lim, Lauren Hanlon & Kartik Gupta

## Goal

The CEO of a biotech startup is looking for candidates. She is interested in diversifying the workforce in regards to women in STEM (Science, Technology, Engineering, and Math). 2 In this analysis, we determine where the startup should focus their recruitment and outreach for maximum impact.

__________________________________________________________________________

The project is done in R, managed through git and github and incorporates markdown, sweave, shinyapp and some bash.

All the code is stored in the code/scripts folder. 
The dataset and other data generated through the scripts are stored in the data/ folder.
The report folder contains the .rnw files that build the report. For reproducibility and collaboration, the paper is divided into sections which are then combined into one .Rwn file and converted in a .PDF. 
The slides for the report are contained within the slides/ folder.
The ShinyApp can be used to explore the data and the analysis in an interactive manner. It is present in the shinyApp/ folder.

This project is created in a way so that it can be completely reproduced. Hence, the code and the dataset are available for use. Please keep in mind that the main dataset was too big to upload on github so follow the given link to access it: (link)

The Makefile can essentially reproduce the whole analysis. The Makefile phony targets are:

- all: To run the complete analysis.  
- data: To download the dataset from the website (**LINK**)
- eda: To run the exploratory data analysis which creates graphs etc
- dataprocessing: To process the data before using it in other scripts
- premodeling: To prepare data for cross-fold regressions
- regressions: To run the regression  
- simulation: To execute the simulation code that applies the regression results to create scores for universities 
- report: To execute and combine all the section RNW files into a Report.Rnw 
- slides: To generate slides.html  
- session: To generate the session-info.txt and session.sh that document the session information. 
- shinyapp: To execute the ShinyApp
- clean: To delete the report file.  
- cleanall: To delete all the .pdf, .Rdata, .txt and images produced by the project scripts and functions.  

The code for this open-source project is licensed through the MIT Open Source License. And the media content is licensed through Creative Commons 4.0.

Stat 159 - Project 3 (c) by Morgan Smart, Lauren Hanlon, Dakota Lim & Kartikeya Gupta

[![Creative Commons
License](https://i.creativecommons.org/l/by/4.0/88x31.png)](http://creativecommons.org/licenses/by/4.0/)
This work is licensed under a [Creative Commons Attribution 4.0
International License](http://creativecommons.org/licenses/by/4.0/).