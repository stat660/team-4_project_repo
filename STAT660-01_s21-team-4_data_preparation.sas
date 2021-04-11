*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

/* 
[Dataset 1 Name] Ridership_200901

[Dataset Description] BART ridership, January 2009

[Experimental Unit Description] Ridership on weekday at a BART exit station in 
January 2009.

[Number of Observations] 1,849   

[Number of Features] 5

[Data Source] The file 
https://www.bart.gov/sites/default/files/docs/ridership_2009.zip
was downloaded and transformed to produce file Ridership_200901_raw.csv by 
restructuring the "Weekday OD" worksheet. Excel was used to create the new
columns Year Month Exit Entry Riders that correspond to the Exit-Entry pairing 
from the worksheet "Weekday OD" and converted the file into CSV.

[Data Dictionary] https://www.bart.gov/about/reports/ridership

[Unique ID Schema] The columns "Year", "Month", "Exit", and "Entry" form a 
composite key, which together forms a unique id in dataset Ridership_200901. 
Each Exit station is paired with all Entry station. The composite key is the 
pair of Exit station and Entry station. The data set forms paired matrix of the 
average ridership for the month. Vertical union may lead us to understand the 
proportion use of the Entry stations compared to other Entry stations. 
Horizontal join may lead us to understand if there exist trends over time.
*/
%let inputDataset1DSN = Ridership_200901_raw;
%let inputDataset1URL = 
https://github.com/mwong70-stat660/team-4_project_repo/blob/feature/data/Ridership_200901_raw.csv
;
%let inputDataset1Type = CSV;


/*
[Dataset 2 Name] Ridership_201001_raw

[Dataset Description] BART ridership, January 2010

[Experimental Unit Description] Ridership on weekday at a BART exit station in 
January 2010.

[Number of Observations] 2,500

[Number of Features] 5

[Data Source] The file 
https://www.bart.gov/sites/default/files/docs/ridership_2010.zip
was downloaded and transformed to produce file Ridership_200901_raw.csv by 
restructuring the "Weekday OD" worksheet. Excel was used to create the new
columns Year Month Exit Entry Riders that correspond to the Exit-Entry pairing 
from the worksheet "Weekday OD" and converted the file into CSV.

[Data Dictionary] https://www.bart.gov/about/reports/ridership

[Unique ID Schema] The columns "Year", "Month", "Exit", and "Entry" form a 
composite key, which together forms a unique id in dataset Ridership_200901. 
Each Exit station is paired with all Entry station. The composite key is the 
pair of Exit station and Entry station. The data set forms paired matrix of the 
average ridership for the month. Vertical union may lead us to understand the 
proportion use of the Entry stations compared to other Entry stations. 
Horizontal join may lead us to understand if there exist trends over time.
*/
%let inputDataset2DSN = Ridership_201001_raw;
%let inputDataset2URL =
https://github.com/mwong70-stat660/team-4_project_repo/blob/feature/data/Ridership_201001_raw.csv
;
%let inputDataset2Type = CSV;


/*
[Dataset 3 Name] Ridership_202001_raw

[Dataset Description] BART ridership, January 2020

[Experimental Unit Description] Ridership on weekday at a BART exit station in 
January 2020.

[Number of Observations] 1,849   

[Number of Features] 5

[Data Source] The file 
http://64.111.127.166/ridership/Ridership_202001.xlsx
was downloaded and transformed to produce file Ridership_200901_raw.csv by 
restructuring the "Avg Weekday OD" worksheet. Excel was used to create the new
columns Year Month Exit Entry Riders that correspond to the Exit-Entry pairing 
from the worksheet "Weekday OD" and converted the file into CSV.

[Data Dictionary] https://www.bart.gov/about/reports/ridership

[Unique ID Schema] The columns "Year", "Month", "Exit", and "Entry" form a 
composite key, which together forms a unique id in dataset Ridership_200901. 
Each Exit station is paired with all Entry station. The composite key is the 
pair of Exit station and Entry station. The data set forms paired matrix of the 
average ridership for the month. Vertical union may lead us to understand the 
proportion use of the Entry stations compared to other Entry stations. 
Horizontal join may lead us to understand if there exist trends over time.
*/
%let inputDataset3DSN = Ridership_202001_raw;
%let inputDataset3URL =
https://github.com/mwong70-stat660/team-4_project_repo/blob/feature/data/Ridership_202001_raw.csv
;
%let inputDataset3Type = XLS;


/*
[Dataset 4 Name] Ridership_202101

[Dataset Description] BART ridership, January 2021

[Experimental Unit Description] Ridership on weekday at a BART exit station in 
January 2021.

[Number of Observations] 2,500   

[Number of Features] 5

[Data Source] The file 
http://64.111.127.166/ridership/Ridership_202101.xlsx
was downloaded and transformed to produce file Ridership_200901_raw.csv by 
restructuring the "Avg Weekday OD" worksheet. Excel was used to create the new
columns Year Month Exit Entry Riders that correspond to the Exit-Entry pairing 
from the worksheet "Weekday OD" and converted the file into CSV.

[Data Dictionary] https://www.bart.gov/about/reports/ridership

[Unique ID Schema] The columns "Year", "Month", "Exit", and "Entry" form a 
composite key, which together forms a unique id in dataset Ridership_200901. 
Each Exit station is paired with all Entry station. The composite key is the 
pair of Exit station and Entry station. The data set forms paired matrix of the 
average ridership for the month. Vertical union may lead us to understand the 
proportion use of the Entry stations compared to other Entry stations. 
Horizontal join may lead us to understand if there exist trends over time.
*/
%let inputDataset4DSN = Ridership_202101_raw;
%let inputDataset4URL =
https://github.com/mwong70-stat660/team-4_project_repo/blob/feature/data/Ridership_202101_raw.csv
;
%let inputDataset4Type = CSV;


/* load raw datasets over the wire, if they doesn't already exist */
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename
                tempfile
                "%sysfunc(getoption(work))/tempfile.&filetype."
            ;
            proc http
                    method="get"
                    url="&url."
                    out=tempfile
                ;
            run;
            proc import
                    file=tempfile
                    out=&dsn.
                    dbms=&filetype.
                ;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%macro loadDatasets;
    %do i = 1 %to 4;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets

/*
print the names of all datasets/tables created above by querying the
"dictionary tables" the SAS kernel maintains for the default "Work" library
*/
proc sql;
    select *
    from dictionary.tables
    where libname = 'WORK'
    order by memname;
quit;
