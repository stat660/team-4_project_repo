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
title "Station with Frequency of Entries in 2009 vs 2010";
title1 justify=left 
'Question 1 of 3: Which of the stations experienced the highest increase in 
frequency of entries, between January 2009 and January 2010?';

title2 justify=left 
'Rationale: This question helps us to understand which station is frequented or 
busy in general, and if there was a significant difference in ridership from 2009
to 2010.';

footnote1 justify=left
'The output shows comparison of summary statistics for riders in 2009 versus 2010.';

footnote2 justify=left 
'Result shows that the stations with the highest mean of Entries are Concord, 
Glen Park, and Millbrae.';

footnote3 justify=left
'Result shows that most bay area commuters reside in opposite parts. The assumption
is that entries on average represent city residents.';

footnote4 justify=left
'The result and the assumption makes sense since Concord and Glen Park are largely 
residential and suburban areas.';
/*
Limitations: There are no missing values or values that are zero in exit and entry
columns.

Methodolgy: Compare Columns Entry, 2009_01 and 2010_01 from Ridership_merged dataset 
using proc means.

Notes: This analyzes the two columns of entries and exits to see which has the 
highest count. 
*/

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
footnote;

*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;

title "Station with highest frequency of Entries 2020 vs 2021";
title1 
'Question 2 of 3: Which of the stations experienced the highest decrease in 
frequency of entries, between January 2020 and January 2021?';

title2
'Rationale: To see how Covid-19 affected Bart Ridership during State of Emergency.';

footnote1 justify=left
'The output shows comparison of riders in January of 2020 versus January of 2010.';

footnote2 justify=left 
'Result shows that all stations sharply decreased in riders in January of 2021 but
Montgomery street,Embarcadero and Concord showed the most significant changes.';

footnote3 justify=left
'Result reflect stay at home, work from home and quarantine interventions with the 
advent of COVID-19.';


/*
Limitations: There are no missing values or values that are zero in exit and entry
columns.

Methodolgy: Compare Columns Entry, 2020_01 and 2021_01 from Ridership_merged dataset 
using proc means.

Notes: This analyzes the two columns of entries and exits to see which has the 
highest count. 
*/

/* change two character columns to numeric*/
data testing;
	set Ridership_merged;
	Ride_2001=input(Ride2001,8.);
	Ride_2101=input(Ride2101,8.);
	drop Ride2001 Ride2101;
run;
proc contents data=testing;run;

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
footnote;

*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
title "Predicting frequency of Exits from previous year trends";
title1 justify=left
'Question 3 of 3: Can the Exit station with the highest number of riders in 2009
be used to predict the following year trend?';

title2 justify=left
'Rationale: This could help us understand whether or not people move around within
the bay area for work as well as for residence.';

footnote1 justify=left
'Results of correlation procedure show there is a strong correlation between 2009 
and 2010 ridership, where as 2020 and 2101 not.';

footnote2 justify=left 
'The results somewhat make sense since the trends between 2009 and 2010 are very 
similar, whereas 2021 is a peculiar case.';

/*
Limitation: Any values that are missing should be excluded from data analysis.

Methodology: Using proc freq, we can compare the trend in the four columns.
/*

/* studying frequency of exits from merged dataset */
proc freq
    data= testing;
    table Exit/ missing out=Exit_frequency09;
	by variable;
run;
proc print;run;

proc freq
    data= testing;
    table Exit*Ride1001/ missing out=Exit_frequency10;
run;
proc print;run;
title;
footnote;

/*correlation coefficient to look at trend amongst the four years*/
title "Testing Ridership Correlation throughout the years";
proc corr data= testing outp=correlation_output;
run;
proc print data=correlation_output;proc print;run;
title;

/*data visualization to study question number one */
title "Plot of Riders in 2009 vs 2010";
Proc sgplot data=Ridership_merged_output1;
  hbox Ride0901 /category=Entry;
  hbox Ride1001 /category= Entry; 
  ;
run;



