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
Question 1 of 4: Which of the stations has the highest weekday entry and exit, on average?
Rationale: This question helps us to understand which station is frequented or busy, and if our common understanding that SF area being generally busy is supported by actual data.
*/


*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;
/*
Question 2 of 4: Where do riders that exit at SFO International airport station mostly come from?
Rationale: This could help us understand where SFO employees live, assuming most bart riders to SFO are employees.
*/


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 3 of 4: Where do riders that enter from the SF stations (Embarcadero, Montgomery, Powell, Civic, 12th and 16th street) mostly exit? 
Rationale: This would help identify where most people that commute to work in the city reside in.
Note: This compares the column NUMTSTTAKR from sat15 to the column TOTAL from

*/

*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*
Question 4 of 4: Which of the stations has the highest weekend exit on average? 
Rationale: This would help identify where bay area commuters frequent for fun. 

*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;
/*

