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

Note: This compares the column "Riders" from Ridership_appended and take the
largest values.

Limitations: How to find the max(5) values for the paired entry and exit? 
Perhaps we need to combine the total entry and total exit to answer, or if not
we will need to refine what constitutes of being the "busiest" station.
*/
title  "Summary of Appended Tables classified by Entry";
proc summary
        data=Ridership_appended(
            where=(not(missing(Exit)))
    );
    class
        Entry
    ;
    var
        Riders
        Year
    ;
    output
        out=SummaryOutput_Entry
        sum=
    ;
run;
title;


/* Sort the highest Ridership value */
proc sort
        data=SummaryOutput_Entry
        out=SummarySort_Entry
    ;
    by descending Riders
    ;
    where Entry ne ' ';
run;


title  "5 Most Utilized Entry in Combined Years (2009, 2010, 2020, 2021)";
proc print
        data=SummarySort_Entry(obs=5)
    ;
    id
        Entry
    ;
    var
        Riders
    ;

run;
title;


title  "Summary of Appended Tables classified by Entry";
proc summary
        data=Ridership_appended(
            where=(not(missing(Exit)))
    );
    class
        Exit
    ;
    var
        Riders
        Year
    ;
    output
        out=SummaryOutput_Exit
        sum=
    ;
run;
title;


/* Sort the highest Ridership value */
proc sort
        data=SummaryOutput_Exit
        out=SummarySort_Exit
    ;
    by descending Riders
    ;
    where Exit ne ' ';
run;


title  "5 Most Utilized Exit in Combined Years (2009, 2010, 2020, 2021)";
proc print
        data=SummarySort_Exit(obs=5)
    ;
    id
        Exit
    ;
    var
        Riders
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

/* 
Using Google Maps and the City Supervisory Map (cited on 04/22/2021), 
https://sfplanninggis.org/sffind/
, Exit=EM MT are located in the Financial District, Region="SF_Dist3" 
*/
data work.Region;
    set Ridership_appended;
    if 
        Exit="EM" 
        then
            Region="SF_Dist3"
    ;
    else if
        Exit="MT" 
        then 
            Region="SF_Dist3"
    ;
    else
        Region=" "
    ;
    keep 
        Year
        Entry
        Exit
        Riders
        Region
    ;
run;


proc sort
        data=Region
        out=work.SF_Dist3
        nodupkey
    ;
    where
        Region="SF_Dist3"
    ;
    by
        Exit
        descending
            Riders
    ;
run;

proc print;
run;


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

* Our alternate hypothesis claims that Exit=EM MT PL CC 16 24 in 2021 have
  a higher means compared to the population means. EM and MT are near a
  transbay transportation hubs, CC is near government offices. 16 and 24 
  are near hospitals. PL and CC are "maybe's" due to its proximity to
  busy buildings. First, we will identify the ones that are essential. 

First, we identify the Exit that stayed busy in 2021 starting from those
listed above;
data work.Workplace;
    set Ridership_appended;
    if 
        Exit="16" then Essential="1";
    else if
        Exit="24" then Essential="1";
    else if
        Exit="EM" then Essential="1";
    else if
        Exit="MT" then Essential="1";
    else if
        Exit="PL" then Essential="1";
    else if
        Exit="CC" then Essential="1";
    else Essential="0";
    keep
        Year 
        Entry
        Exit
        Riders
        Essential;
run;

proc sort
        data=Workplace
        out=Workplace_essential
        ;
    where
        Essential="1"
    ;
    by
        Year
        Entry
    ;
run;


/* In this procedure, we create a table of summary with the sum of essential*/
proc means
        data=Workplace_essential
        nonobs
        max
        sum
        maxdec=0
    ;
    class
        Exit
    ;
    var
        Riders
    ;
run;


data work.Workplace_merged;
    set Ridership;
    if 
        Exit="16" then Essential="1";
    else if
        Exit="24" then Essential="1";
    else if
        Exit="EM" then Essential="1";
    else if
        Exit="MT" then Essential="1";
    else if
        Exit="PL" then Essential="1";
    else if
        Exit="CC" then Essential="1";
    else Essential="0";
run;

proc sort
        data=Workplace_merged
    ;
    where
        Essential=1
    ;
    by
        Exit
    ;
run;


proc sort
        data=Workplace_merged
        out=Workplace_merged_essential
        ;
    where
        Essential="1"
    ;
    by
        Entry
    ;
run;


proc means
        data=Workplace_merged_essential
        nonobs
        sum
        maxdec=0
    ;
    class
        Exit
    ;
    var
        Ride0901
        Ride1001
        Ride2001
        Ride2101
    ;
run;



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

/* 
In data-analysis, we would add match-merge to horizontally join the tables. 
Then, we can take the sum of Riders based on Exit name to compare the means. 
Here's the means step for a general overview if there is difference in data
summary between 2009 and 2010.
*/
/* Total Average Weekday Ridership by Year */
proc summary
        data=Ridership
    ;
    var
        Ride0901
        Ride1001
        Ride2001
        Ride2101
    ;
    output
        out=TotalByYear
        sum=
    ;
run;


/* From the column-wise total we notice a decline in the average weekday ridership
in 2010 from 2009 if we assumed that the Ridership growth rate between 2009-2020
is nonnegative. Summary table is inadequate to evaluate statistical significance.*/
title  "Total Riderships in 2009, 2010, 2020, and 2021";
proc print
        data=TotalByYear
        noobs
    ;
run;
title;
