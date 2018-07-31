*==================================================================*;
* Cleaning Data of Missing Covariates - Single imputation
	- See IDRE powerpoint: Missing data techniques with SAS
*==================================================================*;

*Examine missing data patterns;
title "Examine missing data patterns";
proc mi data=dataset nimpute=0;
var fmdc rage accul21 numcor gender unempl inc2k edu2 insur vinsur pvi2_bi;
ods select misspattern;
run;

*Imputation phase;
title "Imputation phase";
proc mi data=dataset nimpute=1 out=mi_dataset seed=54321;
var fmdc rage accul21 numcor gender unempl inc2k edu2 insur vinsur pvi2_bi;
*plots to assess whether imputation worked;
*	see IDRE powerpoint: Missing data techniques with SAS;
mcmc plots=trace plots=acf;
proc print data=si_chesqolvfl (obs=5);
run;

*Analysis phase: estimate model for each imputed dataset;
title "Analysis phase";
proc glm data = mi_dataset;
model v25_cm = fmdc rage accul21 numcor gender unempl inc2k edu2 insur vinsur pvi2_bi;
by _imputation_;
ods output ParameterEstimates = a_mvn;
run;
quit;
proc print data = a_mvn (obs=15);
run;

*Pooling phase;
title "Pooling phase - combining parameter estimates across datasets";
proc mianalyze parms=a_mvn;
modeleffects intercept fmdc rage accul21 numcor gender unempl inc2k edu2 insur vinsur pvi2_bi;
run;
