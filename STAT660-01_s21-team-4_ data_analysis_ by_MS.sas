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
Question 1 of 4: Which of the stations has the highest frequency of entries and exits, on average for January?
Rationale: This question helps us to understand which station is frequented or busy, and if our common understanding that SF area being generally busy is supported by actual data.
Notes: This analyzes the two columns of entries and exits to see which has the highest count. 
*/


*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 4: Where do riders that exit at SFO International airport station mostly come from?
Rationale: This could help us understand where SFO employees live, assuming most bart riders to SFO are employees.
Notes: We can filter out exits at SFO from dataset, and then look at the number of riders.  
*/


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 4: Where do riders that enter from the SF stations (Embarcadero, Montgomery, Powell, Civic, 12th and 16th street) mostly exit? 
Rationale: This would help identify where most people that commute to work in the city reside in.
Note: We can filter out those 5 SF stations first using a where statement. 

*/

*******************************************************************************;
* Research Question 4 Analysis Starting Point;
*******************************************************************************;
/*
Question 4 of 4: Is there a difference for SF area commuters between the years?
Rationale: Is there a difference from 2019 to 2020 to 2021?  
Note: 2020 and 2021 should see a marked decrease in the 5 busiest exit stations due to COVID-19.
/*

