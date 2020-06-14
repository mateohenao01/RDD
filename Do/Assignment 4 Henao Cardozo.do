/*(Assignment 4) Punishment and Deterrence: Evidence from Drunk Driving
Mateo Henao Cardozo
13/06/2020

Replication*/
use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear
des

//3. Create a dummy equaling 1 if bac1>= 0.08 and 0 otherwise 

gen DUI= 0
replace DUI=1 if bac1>=0.08
label var DUI "driving under influenced dummy"

//4. Test for evidence manipulation (McCrady test). Recreate figure 1

net install rddensity, from(https://sites.google.com/site/rdpackages/rddensity/stata) replace
net install lpdensity, from(https://sites.google.com/site/nppackages/lpdensity/stata) replace
rddensity bac1, c(0.08) plot all
histogram bac1, color(gray) width(0.0001) xline(0.08,lcolor(black)) freq

//5. Checking for covariate balance using equation 1. Recreate table 2

xi: reg male i.DUI*bac1, r
est store Male
xi: reg white i.DUI*bac1, r
est store White
xi: reg aged i.DUI*bac1, r
est store Age
xi: reg acc i.DUI*bac1, r
est store Accident
outreg2 [Male White Age Accident] using balancetest.xls, dec(4) title(" Table 2 Regression Discontinuity Estimates For The Effect of Exceeding BAC Thresholds on Predetermined Characteristics")


//6.Recreate Figure 2 panel A-D.

ssc install cmogram
*Balance test for Accident at scene
cmogram acc bac1, cut(0.08) scatter line(0.08) lfitci title("Balance Test For ACC With Linear Fit") graphopts(xline(0.08) lc(black))
cmogram acc bac1, cut(0.08) scatter line(0.08) qfitci title("Balance Test For ACC With Quadratic Fit")graphopts(xline(0.08) lc(black)) 
*Balance test for Male
cmogram male bac1, cut(0.08) scatter line(0.08) lfitci title("balance test for Male with linear fit") graphopts(xline(0.08) lc(black)) 
cmogram male bac1, cut(0.08) scatter line(0.08) qfitci title("Balance Test For Male With Quadratic Fit") graphopts(xline(0.08) lc(black)) 
*Balance test for Age
cmogram aged bac1, cut(0.08) scatter line(0.08) lfitci title("Balance Test For Age With Linear Fit") graphopts(xline(0.08) lc(black)) 
cmogram aged bac1, cut(0.08) scatter line(0.08) qfitci title("Balance Test For Age With Quadratic Fit") graphopts(xline(0.08) lc(black)) 
*Balance test for white
cmogram white bac1, cut(0.08) scatter line(0.08) lfitci title("Balance Test For White With Linear Fit") graphopts(xline(0.08) lc(black)) 
cmogram white bac1, cut(0.08) scatter line(0.08) qfitci title("Balance Test For White With Quadratic Fit") graphopts(xline(0.08) lc(black)) 

//7. Estimate equation (1) with recidivism (recid) as the outcome. Recrate table 3

*Panel A: bandwidth of 0.05
gen bac1sq= bac1^2
xi: reg recidivism DUI bac1 $aged white male $year if bac1>0.03 & bac1<0.13, r
estout control
xi: reg recidivism i.DUI*c.bac1 $aged white male $year if bac1>0.03 & bac1<0.13, r
estout interact
xi: reg recidivism i.DUI*c.(bac1 bac1sq) $aged white male $year if bac1>0.03 & bac1<0.13, r
estout quad

*Panel B: bandwidth of 0.025
xi: reg recidivism i.DUI bac1 $aged white male $year if bac1>0.055 & bac1<0.105, r
estout control2
xi: reg recidivism i.DUI*c.bac1 $aged white male $year if bac1>0.055 & bac1<0.105, r
estout interact2
xi: reg recidivism i.DUI*c.(bac1 bac1sq) $aged white male $year if bac1>0.055 & bac1<0.105, r
estout quad2
outreg2 [control interact quad control2 interact2 quad2] using reg.xls, dec(4)

//8. Recreate the top panel of figure 3

*Linear fit
cmogram recidivism bac1, cut(0.08) scatter line(0.08) lfitci title("Balance Test For ACC With Linear Fit") graphopts(xline(0.08) lc(black))
*Quadratic fit
cmogram recidivism bac1, cut(0.08) scatter line(0.08) qfitci title("Balance Test For ACC With Quadratic Fit") graphopts(xline(0.08) lc(black)) 
