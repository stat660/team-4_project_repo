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

Methodolgy: Compare Entry Column from Ridership_200901_clean to column from
Ridership_201001_clean using proc means.

Rationale: This question helps us to understand which station is frequented or 
busy in general, and if there was a significant difference in ridership from 2009 to
2010.

Notes: This analyzes the two columns of entries and exits to see which has the 
highest count. 
*/
title "Station with highest frequency of Entries in 2009";
proc means 
		data=Ridership_200901_clean
        maxdec=1
        missing
        n /* number of observations */
        nmiss /* number of missing values */
        min q1 median q3 max  /* five-number summary */
        mean std /* two-number summary */
    ;
	var 
		Entry Riders
	;
	label
		Entry=" "
	;
run;
title;

title "Station with highest number of Entries in 2010";
proc means 
		data=Ridership_201001_clean
        maxdec=1
        missing
        n /* number of observations */
        nmiss /* number of missing values */
        min q1 median q3 max  /* five-number summary */
        mean std /* two-number summary */
    ;
	var 
		Entry Riders
	;
	label
		Entry=" "
	;
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

Methodolgy: Compare Entry Column from Ridership_202001_clean to column from
Ridership_202101_clean using proc means.

Rationale: To see how Covid-19 affected Bart Ridership during State of Emergency.

Notes: This analyzes the two columns of entries and exits to see which has the 
highest count. 
*/
title "Station with highest frequency of Entries in 2020";
proc means 
		data=Ridership_202001_clean
        maxdec=1
        missing
        n /* number of observations */
        nmiss /* number of missing values */
        min q1 median q3 max  /* five-number summary */
        mean std /* two-number summary */
    ;
	var 
		Entry Riders
	;
	label
		Entry=" "
	;
run;
title;

title "Station with highest number of Entries in 2021";
proc means 
		data=Ridership_202101_clean
        maxdec=1
        missing
        n /* number of observations */
        nmiss /* number of missing values */
        min q1 median q3 max  /* five-number summary */
        mean std /* two-number summary */
    ;
	var 
		Entry Riders
	;
	label
		Entry=" "
	;
run;
title;


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 3: Can the Exit station with the highest number of riders in 2009
be used to predict the following year's trend?

Limitation: Any values that are missing should be excluded from data analysis.

Methodology: Using proc freq, we can compare the two columns.

Rationale: This could help us understand whether or not people move around within
the bay area for work as well as for residence.

Notes: We can compare the exit columns from 2009 and 2010 ridership datasets.  
*/

/* output frequencies of Exit to a dataset for manual inspection */
proc freq
        data= Ridership_2009_2010_01
        noprint
    ;
    table
        Exit
        / out=Ridership_2009_2010_01
    ;
run;

/* use manual inspection to create bins to study missing-value distribution */
proc format;
    value $Exit_bins
        "-","NA"="Explicitly Missing"
        "0.00"="Potentially Missing"
        other="Valid Numerical Value"
    ;
run;

/* inspect study missing-value distribution */
title "Inspect Exit from Ridership_2009_2010_01";
proc freq
        data=Ridership_2009_2010_01
    ;
    table
        Exit
        / nocum
    ;
    format
        Exit $Exit_bins.
    ;
    label
        Exit=" "
    ;
run;
title;

