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
Question 1 of 4: Which five stations are the busiest in January 2009, 2010, 
2020, and 2021? 

Rationale: We are interested in the data exploration process.

Note: This compares the column "Riders" from Ridership_202001_raw and take the
largest values.

Limitations: How to find the max(5) values for the paired entry and exit? 
Perhaps we need to combine the total entry and total exit to answer, or if not
we will need to refine what constitutes of being the "busiest" station.
*/
title "Inspect Riders from Ridership_200901_clean";
proc means
        data=Ridership_200901_clean
        maxdec=1
        missing
        n
        nmiss
        min q1 median q3 max
        mean std
    ;
    var
        Riders
    ;
    label
        Ride0901=" "
    ;
run;
title;

title "Inspect Riders from Ridership_201001_clean";
proc means
        data=Ridership_201001_clean
        maxdec=1
        missing
        n
        nmiss
        min q1 median q3 max
        mean std
    ;
    var
        Riders
    ;
    label
        Ride1001=" "
    ;
run;
title;

title "Inspect Riders from Ridership_202001_clean";
proc means
        data=Ridership_202001_clean
        maxdec=1
        missing
        n
        nmiss
        min q1 median q3 max
        mean std
    ;
    var
        Riders
    ;
    label
        Ride2001
    ;
run;
title;

title "Inspect Riders from Ridership_202101_clean";
proc means
        data=Ridership_202101_clean
        maxdec=1
        missing
        n
        nmiss
        min q1 median q3 max
        mean std
    ;
    var
        Riders
    ;
    label
        Ride2101
    ;
run;
title;


*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 4: Which three Entry stations do riders who exit in the San 
Francisco's Financial District commute from? 

Rationale: Of the top Exit stations in San Francisco, we identify the Entry 
stations with the largest values. This may point out where San Francisco 
workers commute from.

Note: We need to add the total of Riders_200901 given a defined Entry and Exit.
We might need to create an iterative function or use DO LOOP Statement.

Limitations: We assume that the library data from the BART is accurate and 
unchanged. Thus, we confirm with other sources about which stations are located
in the San Francisco's Financial District to create a variable for validation.
*/

*We identified the Exit=EM MT are stations are in the Financial District in SF;
/*FinDist. Now, we want to create ...*/

 
*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 4: Where do essential workers work?

Rationale: This would help inform whether essential workers are concentrated in
certain areas of living and work.

Note: This compares the Exit column total from Ridership_202001 to the Exit 
column total from Ridership_202101. We will need to join two datasets and since
the data-preparation file restructured the columns Riders_200901, Riders2010,
Riders_202001, and (soon) Riders_202101, we will take a closer look at the 
changes in the most used Exit.

Limitations: We assume that the Average Weekday Ridership as described by 
Ridership_202101 and Exit are associated with where essential workers work.
*/

* EM and MT are near transportation hubs(?)
  CC is near government offices.
  16 and 24 are near hospitals. 
EM 
MT
PL
CC
16
24

Find the highest value for Riders for these Exits;



*******************************************************************************;
* Research Question 4 Analysis Starting Point;
*******************************************************************************;
/*
Question 4 of 4: Was there a statistically significant decline in ridership 
during the H1N1 outbreak in 2010? 

Rationale: This would require proportion comparisons.

Note: We would assume a linear model between Riders_200901 and Riders_202001, 
and compare the predicted mean to Riders_201001. 

Limitations: We assume of normal distribution and a positively increasing slope 
between Riders_200901 and Riders_202001. We will likely to choose a selected 
number of Exit for means comparison. 
*/

* Horizontal join the tables. Take the sum of Riders based on Exit name. ;
