*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

/*
create macro variable with path to directory where this file is located,
enabling relative imports
*/
%let path=%sysfunc(tranwrd(%sysget(SAS_EXECFILEPATH),%sysget(SAS_EXECFILENAME),));

/*
execute data-prep file, which will generate final analytic dataset used to
answer the research questions below
*/
%include "&path.STAT660-01_s21-team-4_data_preparation.sas";


*******************************************************************************;
* Research Question 1 Analysis Starting Point;
*******************************************************************************;
/*
Question 1 of 3: Which of the stations experienced the highest increase in 
frequency of entries, between January 2009 and January 2010?

Limitations: There are no missing values or values that are zero in exit and entry
columns.

Methodolgy: Compare Columns Entry, 2009_01 and 2010_01 from Ridership_merged dataset 
using proc means.

Rationale: This question helps us to understand which station is frequented or 
busy in general, and if there was a significant difference in ridership from 2009 to
2010.

Notes: This analyzes the two columns of entries and exits to see which has the 
highest count. 
*/

title "Station with highest frequency of Entries 2009 vs 2010";
proc means 
		data=Ridership_merged 
        maxdec=1
        missing
        n /* number of observations */
        nmiss /* number of missing values */
        min q1 median q3 max  /* five-number summary */
        mean std /* two-number summary */
    ;
	class
		Entry;
	var 
		Ride0901 Ride1001 
	;
	output out=Ridership_merged_output1;
run;
title;

*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 3: Which of the stations experienced the highest increase in 
frequency of entries, between January 2020 and January 2021?

Limitations: There are no missing values or values that are zero in exit and entry
columns.

Methodolgy: Compare Columns Entry, 2020_01 and 2021_01 from Ridership_merged dataset 
using proc means.

Rationale: To see how Covid-19 affected Bart Ridership during State of Emergency.

Notes: This analyzes the two columns of entries and exits to see which has the 
highest count. 
*/

/* change two character columns to numeric*/
data testing;
	set Ridership_merged;
	Ride_2001=input(Ride2001,8.);
	Ride_2101=input(Ride2101,8.);
run;
proc contents data=testing;run;


title "Station with highest frequency of Entries 2020 vs 2021";
proc means 
		data=testing
        maxdec=1
        missing
        n /* number of observations */
        nmiss /* number of missing values */
        min q1 median q3 max  /* five-number summary */
        mean std /* two-number summary */
    ;
	class
		Entry;
	var 
		Ride_2001 Ride_2101 
	;
	output out=Ridership_merged_output2;
run;
title;

*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 3: Can the Exit station with the highest number of riders in 2009
be used to predict the following year's trend?

Limitation: Any values that are missing should be excluded from data analysis.

Methodology: Using proc freq, we can compare the trend in the four columns.

Rationale: This could help us understand whether or not people move around within
the bay area for work as well as for residence.

Notes: We can compare the exit columns from 2009 to 2010,2020 and 2021.  
*/

/* studying frequency of exits from merged dataset */
title "Predicting frequency of Exits from previous year trends" ;
proc freq
    data= testing;
    table Exit*Ride0901/ missing out=Exit_frequency09;
run;
proc print;run;

proc freq
    data= testing;
    table Exit*Ride1001/ missing out=Exit_frequency10;
run;
proc print;run;
title;

     

