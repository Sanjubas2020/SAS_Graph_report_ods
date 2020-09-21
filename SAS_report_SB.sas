/*SAS Report Procedure*/

/*six usages of report procedure*/
/*Detail rerport: Display and oeder*/
/*summary report: group and Across*/
/*details or Sumamary report: Analysis and computed*/


PROC REPORT DATA=SAS-data-set NOWD <option(s)>;/*Data set variable,computed variable, or a statistic*/
COLUMN report-item-1 < ... report-item-n>; /*The COLUMN statement specifies the report items to include in the report plus controls the order of the report items*/
DEFINE report-item-n / <usage> <option(s)>; /*The DEFINE statement describes how to use and display a report item*/
DEFINE report-item-1 / <usage> <option(s)>;
RUN;

/*lets take shoes datas set from the SAShelp*/
proc print data=sashelp.shoes noobs;
run;

PROC REPORT DATA=Sashelp.shoes NOWD;
COLUMN Region Product Subsidiary Sales Returns; /*seelct the columns you want to*/
DEFINE Region /display "Sales Regions"; /*display the labels*/
Define Product/ display "Type of products";
Define subsidiary/ display "Subsdiary";
define sales/ display "Total Saless" ; 
define returns/display "Total Returns";
run;


/*formating the values: date and numerical values*/
PROC REPORT DATA=Sashelp.shoes NOWD;
COLUMN Region Product Subsidiary Sales Returns; /*seelct the columns you want to*/
DEFINE Region /display "Sales Regions"; /*display the labels*/
Define Product/ display "Type of products";
Define subsidiary/ display "Subsdiary";
define sales/ display "Total Saless" f=dolar10.2 "sal*es"; /*we want to fomat the dollar */
define returns/display "Total Returns" format=dolar10.2;/*f is the alias for the format option*/
RUN;


/*Spanning Column Headings*/

PROC REPORT DATA=Sashelp.shoes NOWD;
COLUMN ("Shoes sold in world" Region Product Subsidiary Sales Returns); /*cloumn (Variable 1 variable 2)*/
DEFINE Region /display "Sales Regions"; 
Define Product/ display "Type of products";
Define subsidiary/ display "Subsdiary";
define sales/ display "Total Sales" f=dolar10.2 "sal*es"; 
define returns/display "Total Returns" format=dolar10.2;
RUN;


/*The spanning column headings can be nested*/
PROC REPORT DATA=Sashelp.shoes NOWD;
COLUMN ('Shoes sold in world' ('Region and Product' Region Product Subsidiary)  ('sales and returns' Sales Returns ));
DEFINE Region /display "Sales Regions"; 
Define Product/ display "Type of products";
Define subsidiary/ display "Subsdiary";
define sales/ display "Total Sales" f=dolar10.2; 
define returns/display "Total Returns" format=dolar10.2;
RUN;



/*SPLIT= Option*/

/*we can split the specific variable*/

PROC REPORT DATA=Sashelp.shoes NOWD split='*';
COLUMN ('Shoes sold in world' ('Region and Product' Region Product Subsidiary)  ('sales and returns' Sales Returns ));
DEFINE Region /display "Sales Regions"; 
Define Product/ display "Type of products";
Define subsidiary/ display "Subs*diary";
define sales/ display"Total Sales" f=dolar10.2; 
define returns/display "Total Returns" format=dolar10.2;
RUN;




/*order usage*/

PROC REPORT DATA=Sashelp.shoes NOWD split='*';
COLUMN ('Shoes sold in world' ('Region and Product' Region Product Subsidiary)  ('sales and returns' Sales Returns ));
DEFINE Region /display "Sales Regions"; 
Define Product/ display "Type of products";
Define subsidiary/ display "Subs*diary";
define sales/ order "Total Sales"; 
define returns/order "Total Returns";/*When multiple order variables are used, the order
of the detail rows are based on how the order
variables appear in the COLUMN statement*/
RUN;

/*GROUP Usage*/
/*A group variable collapses observations with the same*/
/*values into summary rows. It also orders the summary rows.*/

PROC REPORT DATA=Sashelp.shoes nowd;
COLUMN Region Product Subsidiary Sales;
DEFINE Region /group; 
Define Product/ group;
Define subsidiary/group;
define sales/sum;
run;

/*SPANROWS Option* SPANROWS option in the PROC REPORT statement specifies that a sorted value is in a merged cell
for all rows for which the value is the same*/

PROC REPORT DATA=Sashelp.shoes spanrows;
COLUMN Region Product Subsidiary sales;
DEFINE Region /group; 
Define Product/ group;
Define subsidiary/group;
define sales/group;
run;


/*analysis sum*/
/*break after helps to break the observations and incorporate the sum in this case*/
/*We can sum the values but we need to group variables that we want to sum */

PROC REPORT DATA=Sashelp.shoes NOWD;
COLUMN Region Product Subsidiary Sales Returns;
DEFINE Region /group; 
Define Product/ group;
Define subsidiary/group;
define sales/sum;
define returns/sum;
run;


/*SUM is the default statistic for numeric variables with the usage of ANALYSIS.*/
proc report data=sashelp.shoes nowd;
column region product sales ;
DEFINE Region /group; 
Define Product/ group;
define sales /'sales'; /*all produced the same result*/
run;

proc report data=sashelp.shoes nowd;
column region product sales ;
DEFINE Region /group; 
Define Product/ group;
define sales /mean analysis'sales'; /*using mean isntead of default sum statistics*/
run;
/*all these will give the same value*/
define sales  / analysis 'sales';
define sales / sum 'sales';
define sales  / 'sales';
run;

/*Missing Group or Order Variable Values*/
/*By default, the REPORT procedure excludes observations with a missing value for a group or order variable.*/


PROC REPORT DATA=Sashelp.shoes NOWD missing; /*missing can be specified in the proc data step*/
COLUMN Region Product;
DEFINE Region /group; 
Define Product/ group;
run;



PROC REPORT DATA=Sashelp.shoes NOWD;
COLUMN Region Product;
DEFINE Region /group missing; /*missing can be specified with order or groop*/
Define Product/ order missing;
run;


/*Creating a Summary Report with the ACROSS Usage*/


PROC REPORT DATA=Sashelp.shoes nowd;
COLUMN Region;
DEFINE Region /across; 
run;


PROC REPORT DATA=Sashelp.shoes NOWD;
COLUMN Region Product,sales;/*The comma can be used to stack an analysis variable with an across variable.*/
DEFINE Region /group; 
Define Product/ across;
Define sales/ analysis sum;
run;

proc print data=sashelp.class;
run;

PROC REPORT DATA=Sashelp.class NOWD;
COLUMN name sex,Weight;/*The comma can be used to stack an analysis variable with an across variable.*/
Define name/ group;
DEFINE sex /across; 
define weight/sum;
run;



/*COMPUTED Usage variable that is not in the input*/
/*data set. Instead, it is defined in the procedure.*/

PROC REPORT DATA=Sashelp.class NOWD;
COLUMN name sex height weight bmi;/*a variable is added here*/
Define name/display;
DEFINE sex /display; 
define height /sum;
define weight /sum;
define bmi /computed format=numer5.2;/*we need to define the new variable and also can define format*/
compute bmi;  /*we need to compute bmi like this*/
bmi=_c3_*_c4_; /*4 columns in the class table, c1 t0 c4*/
endcomp;
run;

/*adding style and rbreak*/
PROC REPORT DATA=Sashelp.class NOWD
style(header)={background=#A9A9A9 foreground=red}
style(column)={background=#D3D3D3};
COLUMN sex name height weight diffbmi bmi;
Define name/display;
DEFINE sex /group; 
define height /sum;
define weight /sum;
define diffbmi /computed format=numer5.2; 
define bmi /computed format=numer5.2;
compute diffbmi;  
diffbmi=_c4_-_c3_;
endcomp;
rbreak after/ summarize style={background=#A9A9A9};/*rbreak adds style at the end of the table*/
compute bmi;
bmi=_c3_*_c4_; 
endcomp;
run;

/*pbreak adds style at the beginning of the table*/

PROC REPORT DATA=Sashelp.class NOWD
style(header)={background=#A9A9A9 foreground=red}
style(column)={background=#D3D3D3};
COLUMN sex name height weight diffbmi bmi;
Define name/display;
DEFINE sex /group; 
define height /sum;
define weight /sum;
define diffbmi /computed format=numer5.2; 
define bmi /computed format=numer5.2;
compute diffbmi;  
diffbmi=_c4_-_c3_;
endcomp;
compute bmi;
bmi=_c3_*_c4_; 
endcomp;
rbreak before/ summarize style={background=#A9A9A9};/*pbreak adds style at the beginning of the table*/
run;


/**break adds style at the end of varaible*/

PROC REPORT DATA=Sashelp.class NOWD;
COLUMN sex name height weight bmi;
Define name/display;
DEFINE sex /group;
break after sex/ style={background=#A9A9A9}; 
define height /sum;
define weight /sum;
define bmi /computed format=numer5.2; 
break after sex/ summarize style={background=#A9A9A9};
compute bmi;
bmi=_c3_*_c4_; 
endcomp;
run;


/**/
/*SUPPRESS Option*/
/*The SUPPRESS option suppresses the printing of the*/
/*value of the break variable on the summary line.*/


/*LINE Statement: A LINE statement can be used to insert a blank line*/


PROC REPORT DATA=Sashelp.class NOWD;
COLUMN sex name height weight diffbmi bmi;
Define name/display;
DEFINE sex /group; 
define height /sum;
define weight /sum;
define diffbmi /computed format=numer5.2; 
define bmi /computed format=numer5.2;

compute diffbmi;  
diffbmi=_c4_-_c3_;
endcomp;
compute bmi;
bmi=_c3_*_c4_; 
endcomp;
break after sex/ summarize style={background=#A9A9A9};
compute after sex;
sex='Total sex';
line ' ';
endcomp;
run;



/*Below are the codes from guru*/


proc format;
value $gender
'M' = 'MALE'
'F'='FEMALE' ;
value ages
11='kid'
12='child'
13='minor'
14='major';
run;

proc sort data=sashelp.class out=clsssort;
by sex ;
run;

proc freq data=clsssort;
table age height /   out=dsname ;
by sex;
format sex $gender. age ages.;
run;

proc freq data=clsssort;
table age height / nocum nopercent  out=dsname ;
by sex;
format sex $gender. age dollar8.;
run;

/** Two way frequency(cross tabulation freq) **/
/** it will generates rowpercentage column percentage percentage frequency **/

proc freq data=sashelp.class;
table  sex*age sex*height sex*weight  /   out=dsname ;
run;

proc freq data=sashelp.class;
table  sex*age sex*height sex*weight  / missing norow nocol nopercent out=dsname ;
run;

proc freq data=sashelp.class;
table  sex*age sex*height sex*weight  /   out=dsname crosslist;
run;

/* MEANS PROCEDURE:- proc means; */
/* it will generates default discriptive statistics */

proc means data=sashelp.class;
run;

proc means data=sashelp.class;
class sex; /** grouping the data **/
var age; /** numeric variables * */
output out=dsname  
n=analysis_n
min=analysis_min
max=analysis_max
mean=analysis_avg
std=analysis_std;
run;

proc means data=sashelp.class  n min max std mean nmiss;
class sex; /** grouping the data **/
var age; /** numeric variables **/
output out=dsname  
n=
min()=
max()=
mean()=
std()= /autoname;
run;

/* SUMMARY PROCEDURE:- proc summary; */
/* it will generates default summary statistics */
proc summary data=sashelp.class print;
run; /** it will give the number of observations **/

proc summary data=sashelp.class print;
var age; /** numeric variables **/
run;

proc summary data=sashelp.class print;
class sex;
var age; /** numeric variables **/
run;

proc summary data=sashelp.class print;
class sex; /** grouping the data **/
var age; /** numeric variables **/
output out=dsname  
n=analysis_n
min=analysis_min
max=analysis_max
mean=analysis_avg
std=analysis_std;
run;

proc summary data=sashelp.class print;
class sex; /** grouping the data **/
var age height; /** numeric variables **/
output out=dsname  
n=
min()=
max()=
mean()=
std()= /autoname;
run;

/* UNIVARIATE PROCEDURE:- proc univariate; */
/* it will generate all possibile statistics */
proc univariate data=sashelp.class;
class sex;
var age;
run;
/* TABLUATE PROCEDURE: proc tabulate; */
/* genarates user defined reports(table structure) */

proc tabulate data=sashelp.class;
class sex name;
var age height weight;
table  age*(n min max sum median) height*(max sum) weight*(sum), sex*name / box='tabulate';
run;



/* REPORT PROCEDURE: proc report; */
/* generate both detailed and summarized results and enhances the output report results for each variable  */

proc import datafile='D:\Sudha\sas\SAS\5. BANKING PROJECT\EAG Report\EAGBR.csv' out=EAGBR
dbms=csv replace;
run;

proc import datafile='D:\Sudha\sas\SAS\5. BANKING PROJECT\EAG Report\EAGTN.csv' out=EAGTN
dbms=csv replace;
run;

proc format;
value $fmt
'EQUITY BROKERAGE'='Equity Brokerage'
'DERIVATIVE BROKERAGE'='Derivative Brokerage'
;
run;

ods html file='E:\EAG_BROKERAGE.html';
PROC REPORT DATA=EAGBR split='*'
style(header)={background=#A9A9A9 foreground=blue}
style(column)={background=#D3D3D3};
COLUMN  PRODUCT ("EAG + PCG" EAG_EQUITY_REVENUE PCG_EQUITY_REVENUE RELIGARE_REVENUE a b)
("NRI" NRI_EQUITY_REVENUE NRI_IDIRECT_REVENUE c)
("Total Revenue" TEAM_WISE_TOTAL TOTAL_EQUITY_REVENUE d);
DEFINE  PRODUCT / DISPLAY  "PRODUCT" format=$fmt.;
DEFINE  EAG_EQUITY_REVENUE /  "EAG" ;
DEFINE  PCG_EQUITY_REVENUE /  "PCG" ;
DEFINE  RELIGARE_REVENUE /  "RELIGARE" ;
DEFINE  NRI_EQUITY_REVENUE /  "NRI_EQUITY_REVENUE" ;
DEFINE  TEAM_WISE_TOTAL /  "TEAM_WISE_TOTAL" ;
DEFINE  TOTAL_EQUITY_REVENUE /  "TOTAL_EQUITY_REVENUE" ;
DEFINE  NRI_IDIRECT_REVENUE /  "NRI_IDIRECT_REVENUE" ;
define a/ computed "EAG % of*RELIGARE*Revenue" format=percent8.2;
define b/ computed "PCG % of*RELIGARE*Revenue" format=percent8.2;
define c/ computed "NRI % of*RELIGARE*Revenue" format=percent8.2;
define d/ computed "% of RELIGARE*Revenuee" format=percent8.2;
compute a;
a=_c2_/_c4_;
endcomp;
compute b;
b=_c3_/_c4_;
endcomp;
compute c;
c=_c7_/_c8_;
endcomp;
compute d;
d=_c10_/_c11_;
endcomp;
rbreak after  / summarize style={background=#A9A9A9};
compute after ;
PRODUCT='Total';
endcomp;
title bold ITALIC j=c 'EAG Brokerage Report (In Lakhs)';
RUN;
ods html close;


proc sgplot data=sashelp.class;
vbar sex;
run;

proc gchart data=sashelp.class;
hbar sex;
run;

proc corr data=sashelp.class;
var age ;
run;

proc gplot data=sashelp.class;
plot sex*age;
run;



