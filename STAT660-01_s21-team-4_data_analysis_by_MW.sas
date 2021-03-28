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
*/


*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 4: Which three Entry stations do riders who exit in the San 
Francisco's Financial District commute from? 
Rationale: Of the top Exit stations in San Francisco, we identify the Entry 
stations with the largest values. This may point out where San Francisco 
workers commute from.
Note: This compares the top feeders.
*/


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 4: Where do essential workers work?
Rationale: This would help inform whether essential workers are concentrated in
certain areas of living and work.
Note: This compares the Exit column total from Ridership_202001 to the Exit 
column total from Ridership_202101.
*/


*******************************************************************************;
* Research Question 4 Analysis Starting Point;
*******************************************************************************;
/*
Question 4 of 4: Was there a statistically significant decline in ridership 
during the H1N1 outbreak in 2010? 
Rationale: This would require proportion comparisons.
Note: We would assume a linear model between Ridership_January2009 and 
Ridership_202001, and compare the predicted mean to Ridership_January2010.
*/
