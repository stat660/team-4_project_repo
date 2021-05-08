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
Note: This compares the column "Riders" from Ridership_appended and take the
largest values.

Limitations: How to find the max(5) values for the paired entry and exit? 
Perhaps we need to combine the total entry and total exit to answer, or if not
we will need to refine what constitutes of being the "busiest" station.

Methodology: Use the SUMMARY procedure to classify by Entry and the SUM clause
is added to combine the Riders from Year=2009, 2010, 2020, and 2021. We notice
that the SUMMARY procedure also creates a missing Entry at the last row which
represents the column total. The SORT procedure assembles the Riders in
descending order for non-missing Entry.

Followup Steps: Relabel the column sum appropriately so that it is not 
mistakenly used as an observation. Separate Ridership total by Year for Entry.
*/
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


/* Sort the highest Ridership value for Entry */
proc sort
        data=SummaryOutput_Entry
        out=SummarySort_Entry
    ;
    by descending Riders
    ;
    where Entry ne ' ';
run;


title1 justify=left
'Question 1 of 4: Which five stations are the busiest in January 2009, 2010, 
2020, and 2021?'
;

title2 justify=left
'Rationale: We are interested in the data exploration process.'
;

title3 justify=left
'5 Most Utilized Entry with Most Ridership in Combined Years'
;

footnote1 justify=left
'5 Most Utilized Entry with the highest weekday average ridership from combined years (2009, 2010, 2020, and 2021) are MT, EM, PL, CC, and 12.'
;

footnote2 justify=left
'This tells use about the busiest BART stations by their Entry according to the sum of average weekday ridership in January for the combined years (2009, 2010, 2020, and 2021).'
;

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


/* Summary of the combined ridership for Exit from Ridership_appended */
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


/* Sort the highest Ridership value for Exit */
proc sort
        data=SummaryOutput_Exit
        out=SummarySort_Exit
    ;
    by descending Riders
    ;
    where Exit ne ' ';
run;


title4 justify=left
'5 Most Utilized Exit with Most Ridership in Combined Years'
;

footnote3 justify=left
'5 Most Utilized Exit with the highest weekday average ridership from combined years (2009, 2010, 2020, and 2021) are EM, MT, PL, CC, and RR.'
;

footnote4 justify=left
'This tells use about the busiest BART stations by their Exit according to the sum of average weekday ridership in January for the combined years (2009, 2010, 2020, and 2021).'
;

footnote5 justify=left
'In both Entry and Exit, MT, EM, PL, and CC are both present but they appear in different orders. The 5th Entry and Exit are unique. Further analysis will be necessary to make inferences and find explanation for the difference in order and list.'
;


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


/* Clear titles/footnotes */
title;
footnote;


*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Note: We need to add the total of Riders_200901 given a defined Entry and Exit.
We might need to create an iterative function or use DO LOOP Statement.

Limitations: We assume that the library data from the BART is accurate and 
unchanged. Thus, we confirm with other sources about which stations are located
in the San Francisco's Financial District to create a variable for validation.

Methodology: By Google Maps and the City Supervisory Map (cited on 04/22/2021), 
https://sfplanninggis.org/sffind/
, Exit=EM MT are identified to be in the Financial District, Region="SF_Dist3".
Use DATA step to create and assign Region="SF_Dist3" for Exit=EM MT, otherwise
empty (Region=" "). Use SORT procedure assembles the Riders in descending order.

Followup Steps: Filter Riders by Entry to know the corresponding Entry with most
Riders for the eligible Exit located in the San Francisco's Financial District.
*/
data Region;
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


title1 justify=left
"Question 2 of 4: Which three Entry stations do riders who exit in the San 
Francisco's Financial District commute from?"
;

title2 justify=left
"Rationale: Of the top Exit stations in San Francisco, we identify the Entry 
stations with the largest values. This may point out where San Francisco 
workers commute from."
;

title4 justify=left
"Exit in the Financial District."
;

footnote1 justify=left
'This table shows the first 20 observations of ridership observed of Exit that
are located in the Financial District from Year 2009, 2010, 2020, and 2021.'
;


/* Sort eligible Exit in specified Region by Riders. */
proc sort
        data=Region
        out=SF_Dist3
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


proc print
        data=SF_Dist3(obs=20)
    ;
run;


/* Clear titles/footnotes */
title;
footnote;


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Note: This compares the Exit column total from Ridership_202001 to the Exit 
column total from Ridership_202101. We will need to join two datasets and since
the data-preparation file restructured the columns Riders_200901, Riders2010,
Riders_202001, and (soon) Riders_202101, we will take a closer look at the 
changes in the most used Exit.

Limitations: We assume that the Average Weekday Ridership as described by 
Ridership_202101 and Exit are associated with where essential workers work.

Methodology: Use DATA step to subset the Ridership_appended file and assign 
Essential=1 for the eligible Exit. Use SORT procedure to subset Exit that are
Essential=1. Use MEANS procedure to analyze the sum of average weekday 
ridership for eligible Exit in January 2009 (Ride0901), January 2010 (Ride1001),
January 2020 (Ride2001), and January 2021 (Ride2101).

Followup Steps: Add stratification by Entry to find the corresponding Entry
for each eligible Exit.
*/
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


/* Sort eligible Entry that are Essential by Riders. */
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


title1 justify=left
"Question 3 of 4: Where do essential workers work?"
;

title2 justify=left
"Rationale: This would help inform whether essential workers are concentrated in
certain areas of living and work."
;

title3 justify=left
"Table of summary with the sum of Ridership by Exits that are essential."
;

footnote1 justify=left
"We identify that Exit=EM MT PL CC 16 24 in 2021 are near essential businesses
such as transportation hubs, medical centers, and government offices."
;

footnote2 justify=left
"The maximum Ridership for any paired Entry and Exit in 2021. Also, the sum of 
Ridership of any Entry for the essential Exit in 2021."
;


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


/* Create DATA step for the merged Ridership data set */
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


/* Sort eligible Entry that are Essential by Riders. */
proc sort
        data=Workplace_merged
        out=Workplace_merged_essential
        ;
    where
        Essential="1"
    ;
    by
        Exit
    ;
run;


title4 justify=left
"Sum of Ridership for Essential Exits".
;

footnote3 justify=left
"The maximum Ridership for any paired Entry and Exit in 2021. Also, the sum of 
Ridership of any Entry for the essential Exit in 2021."
;

footnote4 justify=left
"We identify that Exit=EM MT PL CC 16 24 in 2021 are near essential businesses
such as transportation hubs, medical centers, and government offices."
;

footnote5 justify=left
"Summary table for the sum of weekday average ridership for Exits that are
essential in January 2021 (Ride2101). The sum of weekday average ridership from
January 2009 (Ride2009) , January 2010 (Ride1001), and January 2020 (Ride2001)
are added for comparison."
;

/* Create analysis by Ride2101. Other years are included for comparison. */
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


/* Clear titles/footnotes */
title;
footnote;


*******************************************************************************;
* Research Question 4 Analysis Starting Point;
*******************************************************************************;
/*
Note: We would assume a linear model between Riders_200901 and Riders_202001, 
and compare the predicted mean to Riders_201001. 

Limitations: We assume of normal distribution and a positively increasing slope 
between Riders_200901 and Riders_202001. We will likely to choose a selected 
number of Exit for means comparison. 

Methodology: In data-analysis, we would add match-merge to horizontally join the tables. 
Then, we can take the sum of Riders based on Exit name to compare the means. 
Here's the means step for a general overview if there is difference in data
summary between 2009 and 2010.

Followup Steps: Add inferential analysis steps to check for significance since
EDA, data processing, and summary are inadequate to draw inferences from.
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


title1 justify=left
"Question 4 of 4: Was there a statistically significant decline in ridership 
during the H1N1 outbreak in 2010?"
;

title2 justify=left
"Rationale: This would require proportion comparisons."
;

title3 justify=left
"Total Riderships in 2009, 2010, 2020, and 2021"
;

footnote2 justify=left
"Sum of average weekday ridership observed in January 2009, 2010, 2020, and 
2021."
;

footnote2 justify=left
"From the column-wise total we notice a decline in the average weekday ridership
in 2010 from 2009 if we assumed that the Ridership growth rate between 2009-2020
is nonnegative. Further analysis needed since this table summary is inadequate
to test for statistical significance."
;


proc print
        data=TotalByYear
        noobs
    ;
run;


/* Clear titles/footnotes */
title;
footnote;
