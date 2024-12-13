data KOCIBA;
input y n dose;
datalines;
9 86 0
3 50 1
18 50 10
34 48 100
;

data NTP;
input y n dose;
datalines;
5 75 0
1 49 1.4
3 50 7.1
12 49 71
;

data combined;
format group $8.;
set kociba(in=i) ntp;
if i then group = "pilot";
else group = "current";
run;

title 'No Borrowing';
%let a0=0;
proc mcmc data=combined nmc=50000 seed=70273
propcov=quanew outpost=ntp_power_noborrow diag=all;
parms beta0 0 beta1 0;
prior beta: ~ general(0);
p = logistic(beta0 + beta1 * dose);
llike = logpdf("binomial", y, p, n);
if group eq "pilot" then
llike = &a0 * llike;
model y ~ general(llike);
run;

title 'Fixed Borrowing: a0 = 0.1';
%let a0=0.1;
proc mcmc data=combined nmc=50000 seed=70273
propcov=quanew outpost=ntp_power_fixed diag=all nbi=10000;
parms beta0 0 beta1 0;
prior beta: ~ general(0);
p = logistic(beta0 + beta1 * dose);
llike = logpdf("binomial", y, p, n);
if group eq "pilot" then
llike = &a0 * llike;
model y ~ general(llike);
run;

title 'Normalized Power Prior';
proc fcmp outlib=WORK.funcs.power;
subroutine bbPower(beta[*], den, pdata[*,*], a0);
outargs den;
nobs = dim(pdata, 1);
lp = 0;
do j = 1 to nobs;
p = logistic(beta[1] + beta[2] * pdata[j,3]);
lp = lp + logpdf("binomial", pdata[j,1], p, pdata[j,2]);
end;
den = exp(a0 * lp);
endsub;
run;

options cmplib=WORK.funcs;
proc mcmc data=ntp nmc=50000 nbi= 5000 seed=70273
propcov=quanew outpost=ntp_normalized_pp diag=all;

array pdata[1] / nosymbols;
begincnst;
rc = read_array("kociba", pdata);
nobs = dim(pdata, 1);
endcnst;

parms beta0 0.1 beta1 0.1 a0 0.2;

array beta[2] beta0 beta1;
array lower[2] -100 -100;
array upper[2] 100 100; 
prior a0 ~ uniform(0, 1); 

beginprior;
lp = 0;
do j = 1 to nobs;
p = logistic(beta[1] + beta[2] * pdata[j,3]);
lp = lp + logpdf("binomial", pdata[j,1], p, pdata[j,2]);
end;
CALL QUAD('bbPower', C, lower, upper, pdata, a0);
lp = -log(C) + a0 * lp;
endprior;
prior beta0 beta1 ~ general(lp);

p = logistic(beta0 + beta1 * dose);
model y ~ binomial(n, p);
run;

*Borrow b0, intercept;
title 'Partial Borrowing Power Prior';
%let a0 = 1;
proc mcmc data=combined nmc=50000 seed=70273
propcov=quanew outpost=ntp_partial_pp_intercept diag=all;
parm beta0 0 beta1 0 beta01 0;
prior beta: ~ general(0);
if group eq "pilot" then do;
p = logistic(beta0 + beta01 * dose);
llike = &a0 * logpdf("binomial", y, p, n);
end;
else do;
p = logistic(beta0 + beta1 * dose);
llike = logpdf("binomial", y, p, n);
end;
model y ~ general(llike);
run;

*Borrow b1, slope;
title 'Partial Borrowing Power Prior';
%let a0 = 1;
proc mcmc data=combined nmc=50000 seed=70273
propcov=quanew outpost=ntp_partial_pp_slope diag=all;
parm beta0 0 beta1 0 beta01 0;
prior beta: ~ general(0);
if group eq "pilot" then do;
p = logistic(beta01 + beta1 * dose);
llike = &a0 * logpdf("binomial", y, p, n);
end;
else do;
p = logistic(beta0 + beta1 * dose);
llike = logpdf("binomial", y, p, n);
end;
model y ~ general(llike);
run;