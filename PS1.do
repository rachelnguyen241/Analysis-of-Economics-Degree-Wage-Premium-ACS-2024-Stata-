
*******************************************************************************

* ECO 4349
* Rachel Nguyen 
* Returns to an Economics Degree & College Enrollment (Probit)
* AI: CLAUDE for coding purposes 

*******************************************************************************

clear all
set more off
macro drop _all

cd "/Users/probrachel/Documents/Causal_Inference/Stata_PS/1_Review/Data_raw"

cap log close
log using "/Users/probrachel/Documents/PS1.log", replace

********************************************************************************
* Part A: Returns to an Economics Degree 
********************************************************************************

use "/Users/probrachel/Documents/Causal_Inference/Stata_PS/1_Review/Data_raw/usa_00001.dta", clear

********************************************************************************
* 2)
* Keep only individuals who are Ages 25-65, have a positive wage income, have a bachelor's degree or higher 
********************************************************************************

keep if age >= 25 & age <= 65
keep if incwage > 0 
keep if educ >= 10 

* Referring back to the codebook and according to the IPUMS codebook, educ = 10 corresponds to a bachelor's degree and educ = 11 corresponds to a graduate or professional degree. Therefore, I restrict the sample to individuals with educ >= 10 

********************************************************************************
* 3) 
* Create new variables
********************************************************************************

* Economics degree: 1 if economics major (degfieldd = 5501)
gen econ_degree = (degfieldd == 5501)
label var econ_degree "Economics degree (degfieldd ==5501)"

* ln wage: natural log of wage and salary income | keep if incwage > 0 

gen ln_wage = ln(incwage)
label var ln_wage "Log wage income (ln incwage)"

* female: 1 if female (Sex: 1=male, 2 = female)
gen female = (sex ==2)
label var female "Female (sex==2)"

* asian: 1 if Asian (RACE general: 4=Chinese, 5 =Japanese, 6 =Other Asian/Pacific Islander)
gen asian = inlist(race, 4,5,6)
label var asian "Asian (race in 4,5,6)"

* age2: age squared 
gen age2 = age^2 
label var age2 "Age squared"

* race dummies from RACE ( White omitted as the reference group)
gen black = (race ==2)
gen native = (race ==3)
gen other_race = inlist(race, 7,8,9)


label var black "Black (race==2)"
label var native "Native American (race==3)"
label var other_race "Other or multiracial race"

******************************************************************************
* 4) Run summarize 
******************************************************************************

* I have 578,507 observations | Only 11,422 have an economics degree, which is roughly about 1.97% or 2%. 


******************************************************************************
* 5) Regression using robust standard error 
******************************************************************************

* a) Simple regression
reg ln_wage econ_degree, vce(robust)

** Interpretation: the dependent variable here is log wage, and Beta 1 is the percent difference in wages between econ majors and non-econ majors 

* Coefficient of 0.3288149 means that economics majors earn about ~33% more than non-econ majors 

* b) Add controls 
reg ln_wage econ_degree female age age2 black native asian other_race, vce(robust)

** Interpretation: holding gender, age, age^2, and race constant, people with an economics degree earn about 24% higher wages than comprable individuals without an economics degree 

** Women earn about 40% lower wages than comprable men, holding education, age, & race constant 

** Black individuals earn about 19% less than White counterparts

** Native Americans earn about 27% less than comprable White individuals 

** Asian people earn about 10% more than comprable White counterparts 

** People classified as other or multiracial earn about 15% less than White 

** Earnings rise with age early in the carrer but eventually level off and decline 

* c) Add interaction 

reg ln_wage c.econ_degree##i.asian female age age2 black native other_race, vce(robust)


* As we add more controls, compare the econ_degree coefficient from a) to b), Beta1 from a) is BIGGER than Beta1 from b) --> It shrinks as we add more controls. Economics majors may differ in ways that raise wages (age, demographics, etc.) AND without controls, we may wrongly attribute some of those differences to the economics degree or the model is overestimated the true effect or attributing too much influence to economic degree. 

** Holding all else constant, among non-Asian people, having an econ degree is associated with ~28% higher in wages. (small p-value indicates this effect is statistically siginificant)

** Asian (main effect): being Asian is associated with ~ 10.9% higher wage relative to the reference race group like White, on average

* Return for Asians (adding coefficient)= Base effect of econ_degree + interaction effect = Beta 1 + Beta 3 = 0.2801 - 0.2081  = 0.0720  --> This is a net effect for Asians with Econs degree (~7.2%). For Asians, the wage advantage from holding an Econs degree is smaller than for non-Asians. 

* Put it another way, the return to an Econs degree is about 21 percentage points lower for Asian workers than for non-Asian workers --> Asians still benefit from an Econs degree, but much less than non-Asians; the difference is statistically siginificant. (Coefficient of econ_degree * asian = -0.2081 --> measuring how the marginal effect of one variable (econ_degree) on dependent variable ) 


******************************************************************************
* 6) FWL Theorem 
******************************************************************************

* i) Regress ln_wage on age and age2 

reg ln_wage age age2, vce(robust)
predict wage_resid, resid 

* ii) Regress econ_degree on age and age2

reg econ_degree age age2, vce(robus)
predict econ_resid, resid 

* iii) Regress wage_resid on econ_resid

reg wage_resid econ_resid, vce(robust)

** After purging age effects, a one-unit increase in econ_resid is associated with about 33% increase in log wages. The effect is large, positive and highly statistcally siginificant. 

** Controlling for age means removing the part of both wages and degree status that is explained by age and age2, and then examining the relationship between what remains. 

* iv) Run multiple regression ln_wage on econ_degree, age, age2 

reg ln_wage econ_degree age age2, vce(robust)
* coefficient on econ_degree here to the coefficient on econ_resid in iii) is matching (tiny rounding differences)

* v) Scatterplot of wage_resid against econ_resid 

twoway (scatter wage_resid econ_resid), ///
    xtitle("Econ residual (econ_degree residualized on age and age2)") ///
    ytitle("Wage residual (ln_wage residualized on age and age2)") ///
    title("FWL: Residualized ln_wage vs residualized econ_degree")

twoway (scatter wage_resid econ_resid) (lfit wage_resid econ_resid), ///
    xtitle("Econ residual") ytitle("Wage residual") ///
    title("FWL Theorem Visualization")

	
******************************************************************************
* 7) econ_degree as a causal effect 
******************************************************************************

* Interpretating the coefficient on an Economics degree as a causal effect on earnings is generally NOT possible because we all know correlation does not imply causation. Let's say if a student with higher math ability choose economics major, the coefficient reflects that ability, not the degree's impact

* Unobserved factors affecting both econ degree choice and wages: 
* Ability or math skill: higher ability people are more likely to choose economics and higher ability also leads to higher wages, regardless of major 
* Ambition: People who are more career-oriented or earnings-focused are more likely to major in economics 
* Family background: more advantaged backgrounds increase the likelihood of choosing economics 


* Direction of bias (omitted variable bias):

** Cov(econ_degree, ability) > 0 (higher ability students are more likely to major in Econs)

** Beta_ability > 0 (ability raises wages)

** Therefore, Bias >0 --> The estimated coefficient on econ_degree is "biased upward". In other word, some of the wage premium we attribute to the economcis degree is actually due to higher ability, ambition, or background, which we did not fully observe or control for. 

** Econ_degree is not a good treatment for causal inference. To be a valid causal treatment, econ_degree would need to be independent of unobserved determinant of wages.  



******************************************************************************
* Part B: College Enrollment (Probit)
******************************************************************************

* Step 1 

use "/Users/probrachel/Documents/Causal_Inference/Stata_PS/1_Review/Data_raw/usa_00001.dta", clear
keep if age >= 19 & age <=21 

* Step 2 
*a)
gen in_school = (school ==2)
label var in_school "Currently enrolled in school"

tab in_school

*b) 

gen fam_income_10k = ftotinc/10000 if ftotinc >= 0 & ftotinc < 9999999
label var fam_income_10k "Family income (in $10,000s)"

* Step 3

sum in_school fam_income_10k

* Step 4 
* a)
reg in_school fam_income_10k, vce(robust)

** A $10,000 increase in family income is associated with 0.277% increase in the probability that a 19-21 year old is enrolled in school. In other word, $100,000 increase in family income is associated with a 2.8% increase in the probability that a 19-21 year old is enrolled in school. This effect is statistically significant (p<0.001)

* b) 
predict p_lpm, xb

probit in_school fam_income_10k
predict p_probit, pr

sum p_lpm p_probit

** The predicted probabilities similar across the 2 models. From the output I got, LPM mean is 0.51144 and Probit mean is 0.51148 --> Both models predict about 51% enrollment probability

** The models differ most at the upper tail of the predicted probability -- LPM max:0.980 and Probit max: 0.892. LPM produces larger predicted probabilities than the probit model due to its linear structure, while the probit model is nonlinear and flattens out as probabilities approach 1. At the high income level, LPM predicts enrollment probabilities closer to 1 than the probit model, while the probit exhibit diminishing marginal effects. 


** We cannot interpret the coefficient on family income as a causal effect, family income is endogenous - it is correlated with unobserved factors that also influence college enrollment, violating the exogeneity assumption. 

** Parental education is one of omitted variables because parental educaiton is positively correlated with family income (more educated parents tend to have higher incomes) AND parental education is postively correlated with college enrollment (children of more educated parents are more likely to attend college) --> Cov(fam income, parental education) > 0 ; Effect of parental education on enrollment > 0 --> THE ESTIMATED EFFECT OF FAMILY INCOME ON ENROLLMENT IS BIASED UPWARD or POSITIVE BIAS. 

log close 
