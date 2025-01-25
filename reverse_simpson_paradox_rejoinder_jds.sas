data external;
input y n dose;
datalines;
46 50 1
14 18 0
;

data current;
input y n dose;
datalines;
33 59 1
31 68 0
;

data combined;
format group $8.;
set external(in=i) current;
if i then group = 0;
else group = 1;
run;

title 'partial pp, a0 = 0.1';
proc mcmc data=combined nmc=250000 seed=70273
propcov=quanew outpost=ntp_power_fixed diag=all nbi=10000 thin=5; 
parms p00 0.78 p10 0.45 delta 0.12;
p01 = p00 + delta;
p11 = p10 + delta;
prior p00 ~ uniform(0, 1);
prior p10 ~ uniform(0, 1);
prior delta ~ uniform(max(-p00, -p10), min(1 - p00, 1 - p10));
p = (1 - group)*(1-dose)*p00 + (1-group)*(dose)*p01 + (group)*(1-dose)*p10 + (group)*(dose)*p11;
llike1 = logpdf("binomial", y, p, n);
llike = (0.1 + 0.9*group) * llike1;
model y ~ general(llike);
run;

title 'partial pp, a0 = 0.5';
proc mcmc data=combined nmc=250000 seed=70273
propcov=quanew outpost=ntp_power_fixed diag=all nbi=10000 thin=5; 
parms p00 0.78 p10 0.45 delta 0.12;
p01 = p00 + delta;
p11 = p10 + delta;
prior p00 ~ uniform(0, 1);
prior p10 ~ uniform(0, 1);
prior delta ~ uniform(max(-p00, -p10), min(1 - p00, 1 - p10));
p = (1 - group)*(1-dose)*p00 + (1-group)*(dose)*p01 + (group)*(1-dose)*p10 + (group)*(dose)*p11;
llike1 = logpdf("binomial", y, p, n);
llike = (0.5 + 0.5*group) * llike1;
model y ~ general(llike);
run;

title 'partial pp, a0 = 1';
proc mcmc data=combined nmc=250000 seed=70273
propcov=quanew outpost=ntp_power_fixed diag=all nbi=10000 thin=5; 
parms p00 0.78 p10 0.45 delta 0.12;
p01 = p00 + delta;
p11 = p10 + delta;
prior p00 ~ uniform(0, 1);
prior p10 ~ uniform(0, 1);
prior delta ~ uniform(max(-p00, -p10), min(1 - p00, 1 - p10));
p = (1 - group)*(1-dose)*p00 + (1-group)*(dose)*p01 + (group)*(1-dose)*p10 + (group)*(dose)*p11;
llike1 = logpdf("binomial", y, p, n);
llike = (1 + 0*group) * llike1;
model y ~ general(llike);
run;
 

title 'pp, a0 = 0';
proc mcmc data=combined nmc=250000 seed=70273
propcov=quanew outpost=ntp_power_fixed diag=all nbi=10000 thin=5;
parms p10 0.52 delta 0.2;
p11 = p10 + delta;
prior p10 ~ uniform(0, 1);
prior delta ~ uniform(-p10, 1 - p10);
p = (1-dose)*p10 + (dose)*p11;
llike1 = logpdf("binomial", y, p, n);
llike = (0 + 1*group) * llike1;
model y ~ general(llike);
run; 

title 'pp, a0 = 0.1';
proc mcmc data=combined nmc=250000 seed=70273
propcov=quanew outpost=ntp_power_fixed diag=all nbi=10000 thin=5;
parms p10 0.52 delta 0.2;
p11 = p10 + delta;
prior p10 ~ uniform(0, 1);
prior delta ~ uniform(-p10, 1 - p10);
p = (1-dose)*p10 + (dose)*p11;
llike1 = logpdf("binomial", y, p, n);
llike = (0.1 + 0.9*group) * llike1;
model y ~ general(llike);
run; 

title 'pp, a0 = 0.5';
proc mcmc data=combined nmc=250000 seed=70273
propcov=quanew outpost=ntp_power_fixed diag=all nbi=10000 thin=5;
parms p10 0.52 delta 0.2;
p11 = p10 + delta;
prior p10 ~ uniform(0, 1);
prior delta ~ uniform(-p10, 1 - p10);
p = (1-dose)*p10 + (dose)*p11;
llike1 = logpdf("binomial", y, p, n);
llike = (0.5 + 0.5*group) * llike1;
model y ~ general(llike);
run; 

title 'pp, a0 = 1';
proc mcmc data=combined nmc=250000 seed=70273
propcov=quanew outpost=ntp_power_fixed diag=all nbi=10000 thin=5;
parms p10 0.52 delta 0.2;
p11 = p10 + delta;
prior p10 ~ uniform(0, 1);
prior delta ~ uniform(-p10, 1 - p10);
p = (1-dose)*p10 + (dose)*p11;
llike1 = logpdf("binomial", y, p, n);
llike = (1 + 0*group) * llike1;
model y ~ general(llike);
run; 

