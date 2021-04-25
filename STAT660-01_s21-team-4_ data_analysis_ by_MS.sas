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
Question 1 of 4: Which of the stations experienced the highest increase in 
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
Question 2 of 5: Which of the stations experienced the highest increase in 
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
Question 3 of 5: Where do riders that exit at SFO International airport station 
mostly come from?

Limitation: Any values that are missing should be excluded from data analysis.

Methodology: Using the where statement, we can filter for Exits at SFO, then use 
proc sort descending.

Rationale: This could help us understand where SFO employees live, assuming most 
bart riders to SFO are employees.

Notes: We can filter out exits at SFO from dataset, and then look at the number 
of riders.  
*/


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 4 of 5: Where do riders that enter from the SF stations (Embarcadero, 
Montgomery, Powell, Civic, 12th and 16th street) mostly exit? 

Limitation: Any missing values should be excluded. 

Methodology: Use where statement to filter for entry at the five stations, then
use proc sort. 

Rationale: This would help identify where most people that commute to work in 
the city reside in.

Note: We can filter out those 5 SF stations first using a where statement. 

*/

*******************************************************************************;
* Research Question 4 Analysis Starting Point;
*******************************************************************************;
/*
Question 5 of 5: Is there a difference for SF area commuters between the years?

Limitation: Any missing values or zeros should be excluded from data analysis. 

Methodology: 

Rationale: Is there a difference from 2019 to 2020 to 2021?  

Note: 2020 and 2021 should see a marked decrease in the 5 busiest exit stations 
due to COVID-19.
/*

