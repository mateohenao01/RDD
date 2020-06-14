/*(Assignment 4) Punishment and Deterrence: Evidence from Drunk Driving
Mateo Henao Cardozo
13/06/2020

Replication*/
use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear
des

//3. Create a dummy equaling 1 if bac1>= 0.08 and 0 otherwise 

gen BAC= 0
replace BAC=1 if bac1>=0.08
label var BAC "Blood alcohol content threshold dummy"

//4. Test for evidence manipulation (McCrady test). Recreate figure 1

net install rddensity, from(https://sites.google.com/site/rdpackages/rddensity/stata) replace
net install lpdensity, from(https://sites.google.com/site/nppackages/lpdensity/stata) replace
rddensity bac1, c(0.08) plot all
histogram bac1, color(gray) width(0.0001) xline(0.08,lcolor(black)) freq

//6.Recreate Figure 2 panel A-D.

ssc install cmogram
*Balance test for Accident at scene
cmogram acc bac1, cut(0.08) scatter line(0.08) lfitci title("Balance Test For ACC With Line Fit") graphopts(xline(0.08) lc(black))
cmogram acc bac1, cut(0.08) scatter line(0.08) qfitci title("Balance Test For ACC With Quadratic Fit")
*Balance test for Male
cmogram male bac1, cut(0.08) scatter line(0.08) lfitci title("balance test for Male with line fit")
cmogram male bac1, cut(0.08) scatter line(0.08) qfitci title("Balance Test For Male With Quadratic Fit")
*Balance test for Age
cmogram aged bac1, cut(0.08) scatter line(0.08) lfitci title("Balance Test For Age With Line Fit")
cmogram aged bac1, cut(0.08) scatter line(0.08) qfitci title("Balance Test For Age With Quadratic Fit")
*Balance test for white
cmogram white bac1, cut(0.08) scatter line(0.08) lfitci title("Balance Test For White With Line Fit")
cmogram white bac1, cut(0.08) scatter line(0.08) qfitci title("Balance Test For White With Quadratic Fit")

//8. Recreate the top panel of figure 3
