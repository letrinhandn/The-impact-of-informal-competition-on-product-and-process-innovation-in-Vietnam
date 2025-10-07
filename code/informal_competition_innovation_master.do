/**************************************************************************
 INFORMAL COMPETITION AND FIRM INNOVATION IN EMERGING ASEAN ECONOMIES
 One-file pipeline for a merged dataset: VieThaiCamPhiMalayIndo.dta
 Authors: Le Tri Nhan, Nguyen Thi Ngoc Anh, Nguyen Linh Trang, Le Viet Hoang
 Supervisor: Dr. Tran Lan Huong (NEU)
 Stata: 17+
**************************************************************************/

*-----------------------------*
* 0. INITIAL SETUP
*-----------------------------*
version 17.0
clear all
set more off
capture log close

* Set working directory (edit this)
cd "your_data_path/InformalCompetition_Innovation"

* Folders
capture mkdir "data"
capture mkdir "output"
capture mkdir "output/tables"
capture mkdir "output/figures"

global DAT "data"
global TBL "output/tables"
global FIG "output/figures"

* Dependencies (install if needed)
capture which asdoc
if _rc ssc install asdoc, replace

capture which fitstat
if _rc ssc install spost13_ado, replace

*-----------------------------*
* 1. LOAD MERGED DATASET
*-----------------------------*
* Use the single merged file you still have
use "$DAT/VieThaiCamPhiMalayIndo.dta", clear

* Quick integrity checks (optional)
describe country e30 h1 h3 h4a h4b l1 b5 b7 e1 j6a b2b b2c a4a j5 e2b d3b d3c j30c
tab country

*-----------------------------*
* 2. CLEANING & CONSTRUCTION
*-----------------------------*

* 2.1 Standardize special missing codes
local misslist e30 e1 j6a b7 j5 e2b d3b d3c j30c h1 h3 h4a h4b l1 b5 b2b b2c a4a
foreach v of local misslist {
    capture confirm variable `v'
    if !_rc {
        replace `v' = . if inlist(`v', -9, -8, -7, -4)
    }
}

* 2.2 Core sizes / ages
replace l1 = . if l1<=0
gen size = ln(l1)
label var size "Firm size (ln employment)"

* Survey year mapping by country (WBES 2015–2016 waves)
gen survey_year = .
replace survey_year = 2015 if inlist(country,"Vietnam","Philippines","Malaysia","Indonesia")
replace survey_year = 2016 if inlist(country,"Thailand","Cambodia")

gen age = survey_year - b5
replace age = . if age<=0
gen lnage = ln(age)
label var lnage "Firm age (logged)"

* 2.3 Market & manager experience
gen market = e1
replace market = 0 if market==2
label var market "Main market (dummy: domestic=0, other=1)"

gen experience = b7
replace experience = . if experience<=0
gen lnexperience = ln(experience)
label var lnexperience "Top manager experience (logged)"

* 2.4 Dependent variables (innovation)
replace h1 = 0 if h1==2
label var h1 "Product innovation (binary)"

gen byte pci1 = (h3==1 | h4a==1 | h4b==1)
replace pci1 = 0 if h3==2 & h4a==2 & h4b==2
label var pci1 "Process innovation (binary)"

* 2.5 Independent & polynomial term
label var e30 "Informal competition (obstacle scale 0–4)"
gen ICsq = e30^2
label var ICsq "Informal competition squared"

* 2.6 Ownership / controls
label var b2b "Foreign ownership (%)"
label var b2c "State ownership (%)"
label var j6a "Government contract"
label var a4a "Industry classification"

* 2.7 Export intensity (row-mean of d3b, d3c)
egen export1 = rowmean(d3b d3c)
label var export1 "Export intensity (avg of d3b,d3c)"

* 2.8 Mean-centering for interactions
egen double e30_mean = mean(e30)
gen  double e30_mc   = e30 - e30_mean
label var e30_mc "Informal competition (mean-centered)"

* Interactions for robustness/moderation analyses
gen double e30xj5       = e30_mc*j5
gen double e30xe2b      = e30_mc*e2b
gen double e30xexport1  = e30_mc*export1
gen double e30xb7       = e30_mc*b7
gen double e30xj30c     = e30_mc*j30c

*-----------------------------*
* 3. MAIN MODELS (Pooled & Vietnam-only)
*-----------------------------*

* 3.1 Pooled models (linear + quadratic)
asdoc logit h1   e30, r replace label nest cnames(Model1) save("$TBL/result_all.doc")
asdoc logit pci1 e30, r        label nest cnames(Model2) save("$TBL/result_all.doc")
asdoc logit h1   e30 age size lnexperience b2b b2c i.a4a market j6a, r label nest cnames(Model3) save("$TBL/result_all.doc")
asdoc logit pci1 e30 age size lnexperience b2b b2c i.a4a market j6a, r label nest cnames(Model4) save("$TBL/result_all.doc")

asdoc logit h1   e30 ICsq age size lnexperience b2b b2c i.a4a market j6a, r replace label nest cnames(Quad1) save("$TBL/result_all_quad.doc")
asdoc logit pci1 e30 ICsq age size lnexperience b2b b2c i.a4a market j6a, r        label nest cnames(Quad2) save("$TBL/result_all_quad.doc")

* 3.2 Vietnam-only (for comparability with slides)
asdoc logit h1   e30 if country=="Vietnam", r replace label nest cnames(VN1) save("$TBL/result_vietnam.doc")
asdoc logit pci1 e30 if country=="Vietnam", r        label nest cnames(VN2) save("$TBL/result_vietnam.doc")
asdoc logit h1   e30 ICsq age size lnexperience b2b b2c i.a4a market j6a if country=="Vietnam", r label nest cnames(VN3) save("$TBL/result_vietnam.doc")
asdoc logit pci1 e30 ICsq age size lnexperience b2b b2c i.a4a market j6a if country=="Vietnam", r label nest cnames(VN4) save("$TBL/result_vietnam.doc")

* 3.3 By-country (optional, compact view)
asdoc logit h1   e30 age size lnexperience b2b b2c i.a4a market j6a if country=="Thailand",   r replace label nest cnames(TH)  save("$TBL/result_eachcountry.doc")
asdoc logit h1   e30 age size lnexperience b2b b2c i.a4a market j6a if country=="Cambodia",   r         label nest cnames(CAM) save("$TBL/result_eachcountry.doc")
asdoc logit h1   e30 age size lnexperience b2b b2c i.a4a market j6a if country=="Philippines",r         label nest cnames(PHI) save("$TBL/result_eachcountry.doc")
asdoc logit h1   e30 age size lnexperience b2b b2c i.a4a market j6a if country=="Malaysia",   r         label nest cnames(MYS) save("$TBL/result_eachcountry.doc")
asdoc logit h1   e30 age size lnexperience b2b b2c i.a4a market j6a if country=="Indonesia",  r         label nest cnames(IDN) save("$TBL/result_eachcountry.doc")

asdoc logit pci1 e30 age size lnexperience b2b b2c i.a4a market j6a if country=="Thailand",   r replace label nest cnames(TH)  save("$TBL/result_eachcountry_pi.doc")
asdoc logit pci1 e30 age size lnexperience b2b b2c i.a4a market j6a if country=="Cambodia",   r         label nest cnames(CAM) save("$TBL/result_eachcountry_pi.doc")
asdoc logit pci1 e30 age size lnexperience b2b b2c i.a4a market j6a if country=="Philippines",r         label nest cnames(PHI) save("$TBL/result_eachcountry_pi.doc")
asdoc logit pci1 e30 age size lnexperience b2b b2c i.a4a market j6a if country=="Malaysia",   r         label nest cnames(MYS) save("$TBL/result_eachcountry_pi.doc")
asdoc logit pci1 e30 age size lnexperience b2b b2c i.a4a market j6a if country=="Indonesia",  r         label nest cnames(IDN) save("$TBL/result_eachcountry_pi.doc")

*-----------------------------*
* 4. MARGINS & FIGURES (publication-ready)
*-----------------------------*

* Figure 1: Product innovation – linear
logit h1 e30 age size lnexperience b2b b2c i.a4a market j6a, r
fitstat
estat gof, group(5) table
margins, at(e30=(0(1)4))
marginsplot, title("Effect of Informal Competition on Product Innovation") ///
    ytitle("Predicted Probability") xtitle("Informal Competition (e30)")
graph export "$FIG/figure1_product_linear.png", replace width(2000) height(1400)

* Figure 2: Process innovation – linear
logit pci1 e30 age size lnexperience b2b b2c i.a4a market j6a, r
fitstat
estat gof, group(5) table
margins, at(e30=(0(1)4))
marginsplot, title("Effect of Informal Competition on Process Innovation") ///
    ytitle("Predicted Probability") xtitle("Informal Competition (e30)")
graph export "$FIG/figure2_process_linear.png", replace width(2000) height(1400)

* Figure 3: Process innovation – non-linear (inverted U)
logit pci1 e30 ICsq age size lnexperience b2b b2c i.a4a market j6a, r
fitstat
estat gof, group(5) table
margins, at(e30=(0(0.5)4))
marginsplot, title("Non-linear (Inverted-U) Relationship: e30 and Process Innovation") ///
    ytitle("Predicted Probability") xtitle("Informal Competition (e30)")
graph export "$FIG/figure3_process_Ushape.png", replace width(2000) height(1400)

*-----------------------------*
* 5. MODERATION (Legal barriers j30c)
*-----------------------------*
label var j30c "Legal barriers (regulatory quality)"
label var e30xj30c "Interaction: e30 (centered) × j30c"

asdoc logit pci1 e30 ICsq age size lnexperience b2b b2c i.a4a market j6a j30c e30xj30c, r ///
      replace label nest cnames(Moderation) save("$TBL/result_moderation.doc")

logit pci1 e30 ICsq age size lnexperience b2b b2c i.a4a market j6a j30c e30xj30c, r
fitstat
estat gof, group(5) table
margins, at(e30=(0(1)4) j30c=(0(2)4))
marginsplot, title("Moderating Effect of Legal Barriers (j30c)") ///
    ytitle("Predicted Probability") xtitle("Informal Competition (e30)")
graph export "$FIG/figure4_moderation_j30c.png", replace width(2000) height(1400)

*-----------------------------*
* 6. SAVE CLEANED DATA (optional)
*-----------------------------*
save "$DAT/asean6_clean_ready.dta", replace

display "=============================================================="
display "  DONE. Tables in output/tables/  |  Figures in output/figures/"
display "=============================================================="
