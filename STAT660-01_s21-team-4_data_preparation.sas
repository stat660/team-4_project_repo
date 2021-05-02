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
was downloaded and transformed to produce file Ridership_200901_raw.xls by 
restructuring the "Weekday OD" worksheet. Excel was used to create the new
columns Year Month Exit Entry Riders that correspond to the Exit-Entry pairing 
from the worksheet "Weekday OD" and converted the file into XLS.

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
https://github.com/stat660/team-4_project_repo/blob/main/data/Ridership_200901_raw.xls?raw=true
;
%let inputDataset1Type = XLS;


/*
[Dataset 2 Name] Ridership_201001

[Dataset Description] BART ridership, January 2010

[Experimental Unit Description] Ridership on weekday at a BART exit station in 
January 2010.

[Number of Observations] 2,500

[Number of Features] 5

[Data Source] The file 
https://www.bart.gov/sites/default/files/docs/ridership_2010.zip
was downloaded and transformed to produce file Ridership_201001_raw.xls by 
restructuring the "Weekday OD" worksheet. Excel was used to create the new
columns Year Month Exit Entry Riders that correspond to the Exit-Entry pairing 
from the worksheet "Weekday OD" and converted the file into XLS.

[Data Dictionary] https://www.bart.gov/about/reports/ridership

[Unique ID Schema] The columns "Year", "Month", "Exit", and "Entry" form a 
composite key, which together forms a unique id in dataset Ridership_201001. 
Each Exit station is paired with all Entry station. The composite key is the 
pair of Exit station and Entry station. The data set forms paired matrix of the 
average ridership for the month. Vertical union may lead us to understand the 
proportion use of the Entry stations compared to other Entry stations. 
Horizontal join may lead us to understand if there exist trends over time.
*/
%let inputDataset2DSN = Ridership_201001_raw;
%let inputDataset2URL =
https://github.com/stat660/team-4_project_repo/blob/main/data/Ridership_201001_raw.xls?raw=true
;
%let inputDataset2Type = XLS;


/*
[Dataset 3 Name] Ridership_202001

[Dataset Description] BART ridership, January 2020

[Experimental Unit Description] Ridership on weekday at a BART exit station in 
January 2020.

[Number of Observations] 1,849      

[Number of Features] 5

[Data Source] The file 
http://64.111.127.166/ridership/Ridership_202001.xlsx
was downloaded and transformed to produce file Ridership_202001_raw.xls by 
restructuring the "Avg Weekday OD" worksheet. Excel was used to create the new
columns Year Month Exit Entry Riders that correspond to the Exit-Entry pairing 
from the worksheet "Weekday OD" and converted the file into XLS.

[Data Dictionary] https://www.bart.gov/about/reports/ridership

[Unique ID Schema] The columns "Year", "Month", "Exit", and "Entry" form a 
composite key, which together forms a unique id in dataset Ridership_202001. 
Each Exit station is paired with all Entry station. The composite key is the 
pair of Exit station and Entry station. The data set forms paired matrix of the 
average ridership for the month. Vertical union may lead us to understand the 
proportion use of the Entry stations compared to other Entry stations. 
Horizontal join may lead us to understand if there exist trends over time.
*/
%let inputDataset3DSN = Ridership_202001_raw;
%let inputDataset3URL =
https://github.com/stat660/team-4_project_repo/blob/main/data/Ridership_202001_raw.xls?raw=true
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
http://64.111.127.166/ridership/Ridership_202101.xls
was downloaded and transformed to produce file Ridership_200901_raw.xls by 
restructuring the "Avg Weekday OD" worksheet. Excel was used to create the new
columns Year Month Exit Entry Riders that correspond to the Exit-Entry pairing 
from the worksheet "Weekday OD" and converted the file into xls.

[Data Dictionary] https://www.bart.gov/about/reports/ridership

[Unique ID Schema] The columns "Year", "Month", "Exit", and "Entry" form a 
composite key, which together forms a unique id in dataset Ridership_202101. 
Each Exit station is paired with all Entry station. The composite key is the 
pair of Exit station and Entry station. The data set forms paired matrix of the 
average ridership for the month. Vertical union may lead us to understand the 
proportion use of the Entry stations compared to other Entry stations. 
Horizontal join may lead us to understand if there exist trends over time.
*/
%let inputDataset4DSN = Ridership_202101_raw;
%let inputDataset4URL =
https://github.com/stat660/team-4_project_repo/blob/main/data/Ridership_202101_raw.xls?raw=true
;
%let inputDataset4Type = XLS;


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
For Ridership_200901_raw, the columns Year, Month, Entry, and Exit are intended 
to form a composite key, so any rows corresponding to multiple values should be 
removed. In addition, rows should be removed if they (a) are missing values for
any of the composite key columns or (b) have a Ridership<1. The variable Riders 
consists of the Average Weekday ridership.

After running the proc sort step below, the new dataset Ridership_200901_clean
will have no duplicate. The unique id will correspond to our experimental units 
of interest, the paired Entry and Exit. Combined with the columns Year and 
Month, the columns Entry and Exit will form a composite key. This means each 
columns in Ridership_200901_clean are guaranteed to form a composite key.
*/
proc sort 
        nodupkey
        data=Ridership_200901_raw
        dupout=Ridership_200901_raw_dups
        out=Ridership_200901_clean
    ;
    where
        /* remove rows with missing composite key components */
        not(missing(Year))
        and
        not(missing(Month))
        and
        not(missing(Entry))
        and
        not(missing(Exit))
        and
        /* remove rows with Riders<1*/
        not(missing(Riders))
    ;
    by 
        Entry
        Exit 
        Riders
;
run;
   

/*
For Ridership_201001_raw, the columns Year, Month, Entry, and Exit are intended 
to form a composite key, so any rows corresponding to multiple values should be 
removed. In addition, rows should be removed if they (a) are missing values for
any of the composite key columns or (b) have a Ridership<1. The variable Riders 
consists of the Average Weekday ridership.

After running the proc sort step below, the new dataset Ridership_201001_clean
will have no duplicate. The unique id will correspond to our experimental units 
of interest, the paired Entry and Exit. Combined with the columns Year and 
Month, the columns Entry and Exit will form a composite key. This means each 
columns in Ridership_201001_clean are guaranteed to form a composite key.
*/
proc sort 
        nodupkey
        data=Ridership_201001_raw
        dupout=Ridership_201001_raw_dups
        out=Ridership_201001_clean
    ;
    where
        /* remove rows with missing composite key components */
        not(missing(Year))
        and
        not(missing(Month))
        and
        not(missing(Entry))
        and
        not(missing(Exit))
        and
        /* remove rows with Riders<1*/
        not(missing(Riders))
    ;
    by 
        Entry
        Exit 
        Riders
    ;
run;


/*
For Ridership_202001_raw, the columns Year, Month, Entry, and Exit are intended 
to form a composite key, so any rows corresponding to multiple values should be 
removed. In addition, rows should be removed if they (a) are missing values for
any of the composite key columns or (b) have a Ridership<1. The variable Riders 
consists of the Average Weekday ridership.

After running the proc sort step below, the new dataset Ridership_202001_clean
will have no duplicate. The unique id will correspond to our experimental units 
of interest, the paired Entry and Exit. Combined with the columns Year and 
Month, the columns Entry and Exit will form a composite key. This means each 
columns in Ridership_202001_clean are guaranteed to form a composite key.
*/
proc sort 
        nodupkey
        data=Ridership_202001_raw
        dupout=Ridership_202001_raw_dups
        out=Ridership_202001_clean
    ;
    where
        /* remove rows with missing composite key components */
        not(missing(Year))
        and
        not(missing(Month))
        and
        not(missing(Entry))
        and
        not(missing(Exit))
        and
        /* remove rows with missing Riders*/
        not(missing(Riders))
    ;
    by 
        Entry
        Exit 
        Riders
    ;
run;


/*
For Ridership_202101_raw, the columns Year, Month, Entry, and Exit are intended 
to form a composite key, so any rows corresponding to multiple values should be 
removed. In addition, rows should be removed if they (a) are missing values for
any of the composite key columns or (b) have a Ridership<1. The variable Riders 
consists of the Average Weekday ridership.

After running the proc sort step below, the new dataset Ridership_202101_clean
will have no duplicate. The unique id will correspond to our experimental units 
of interest, the paired Entry and Exit. Combined with the columns Year and 
Month, the columns Entry and Exit will form a composite key. This means each 
columns in Ridership_202101_clean are guaranteed to form a composite key.
*/
proc sort 
        nodupkey
        data=Ridership_202101_raw
        dupout=Ridership_202101_raw_dups
        out=Ridership_202101_clean
    ;
    where
        /* remove rows with missing composite key components */
        not(missing(Year))
        and
        not(missing(Month))
        and
        not(missing(Entry))
        and
        not(missing(Exit))
        and
        /* remove rows with missing Riders*/
        not(missing(Riders))
    ;
    by 
        Entry
        Exit 
        Riders
    ;
run;



/*
Concatenate Ridership data vertically, combine composite key into a primary key.
The paired Entry Exit and Month are a primary key since we only evaluate the 
average weekday ridership in January for any given Year.

RideYYMM is the Ridership average for the corresponding 4-digit Year and Month.
*/
data Ridership_200901;
    set 
        Ridership_200901_clean;
    drop
        Year
        Month
        Riders
    ;
    if
        not(missing(Riders))
    then
        Ride0901=Riders;
    ;
run;



data Ridership_201001;
    set 
        Ridership_201001_clean;
    drop
        Year
        Month
        Riders
    ;
    if
        not(missing(Riders))
    then
        Ride1001=Riders;
    ;
run;



data Ridership_202001;
    set 
        Ridership_202001_clean;
    drop
        Year
        Month
        Riders
    ;
    if
        not(missing(Riders))
    then
        Ride2001=Riders;
    ;
run;



data Ridership_202101;
    set 
        Ridership_202101_clean;
    drop
        Year
        Month
        Riders
    ;
    if
        not(missing(Riders))
    then
        Ride2101=Riders;
    ;
run;



/*
Match-merge tables in DATA Step
*/
data Ridership_merged;
    set 
        Ridership_200901
    ;
    set
        Ridership_201001
    ;
    set 
        Ridership_202001
    ;
    set 
        Ridership_202101
    ;
run;



/* Add drop and swap for Ride2001 and Ride2101 to restructure numeric values from character values */
data Ridership(
    drop=
        Ride2001_char
        Ride2101_char
    );
    set work.Ridership_merged(
        rename=(
            Ride2001=Ride2001_char
            Ride2101=Ride2101_char
        )
        where=(
            strip(Ride2001_char) ne "-"
            and
            strip(Ride2101_char) ne "-"
        )
    );
    Ride2001=input(Ride2001_char,best12.);
    Ride2101=input(Ride2101_char,best12.);
run;



/*
Data-integrity step added to check duplicates.
*/
data Ridership_dups;
    set Ridership;
    by 
        Exit
        Entry
    ;
    if
        missing(Ride0901)
        and
        missing(Ride1001)
        and
        missing(Ride2001)
        and
        missing(Ride2101)
    then
        do;
            output;
        end;
run;



/*
Prepare data sets 2009, 2010 for concatenation
*/
data Ridership_200901a;
    set 
        Ridership_200901_clean;
    drop
        Month
    ;
run;



data Ridership_201001a;
    set 
        Ridership_201001_clean;
    drop
        Month
    ;
run;



/*
Restructure Riders in data set 2020 into integers from characters
*/
data Ridership_202001_int(
    drop=
        Riders_char
    );
    set Ridership_202001_clean(
        rename=(
            Riders=Riders_char
        )
        where=(
            strip(Riders_char) ne "-"
        )
    );
    Riders=input(Riders_char,best12.);
run;



/*
Prepare data set 2020 for concatenation
*/
data Ridership_202001a;
    set 
        Ridership_202001_int;
    drop
        Month
    ;
run;



/*
Restructure Riders in data set 2021 into integers from characters
*/
data Ridership_202101_int(
    drop=
        Riders_char
    );
    set Ridership_202101_clean(
        rename=(
            Riders=Riders_char
        )
        where=(
            strip(Riders_char) ne "-"
        )
    );
    Riders=input(Riders_char,best12.);
run;



/*
Prepare data set 2021 for concatenation
*/
data Ridership_202101a;
    set 
        Ridership_202101_int;
    drop
        Month
    ;
run;



data Ridership_appended;
    set
        Ridership_200901a
        Ridership_201001a
        Ridership_202001a
        Ridership_202101a
    ;
run;



/*
Data-integrity step to remove missing
*/
data Ridership_appended_missing;
    set Ridership_appended;
    by
        Year
        Exit
        Entry
    ;
    if
        missing(Riders)
    then
        do;
            output;
        end;
run;
