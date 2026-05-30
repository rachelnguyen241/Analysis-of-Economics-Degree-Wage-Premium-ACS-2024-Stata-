# Analysis-of-Economics-Degree-Wage-Premium-ACS-2024-Stata-
Estimated wage returns to Economics majors using OLS, interaction effects, and FWL decomposition in Stata.


Analysis of Economics Degree Wage Premium (IPUMS USA ACS 2024)**

Extracted and cleaned microdata from the 2024 American Community Survey (ACS) via IPUMS USA, constructing an analytical sample of over 578,000 individuals.
Conducted econometric analysis of wage returns to an Economics degree using OLS with robust standard errors, demographic controls, and interaction effects.

* Constructed and analyzed a nationally representative sample of **578,507 individuals** from the 2024 American Community Survey (IPUMS USA), identifying **11,422 Economics degree holders (1.97% of the sample)**. 
* Estimated wage-return models using OLS with robust standard errors; found Economics degree holders earned approximately **33% higher wages** than non-Economics majors in a bivariate specification, with the estimated premium declining to **24% after controlling for age, gender, and race**, suggesting the importance of observable demographic differences. 
* Tested heterogeneous returns by race using an **Economics Degree × Asian interaction**; found the estimated return to an Economics degree was approximately **21 percentage points lower for Asian workers**, implying a wage premium of about **7.2% for Asian Economics graduates compared to 28.0% for non-Asian Economics graduates**. 
* Verified the **Frisch–Waugh–Lovell theorem** by residualizing both log wages and Economics-degree status on age and age-squared and demonstrating that the residualized regression coefficient (**0.333**) exactly matched the coefficient obtained from the corresponding multivariate regression. 
* Applied omitted-variable-bias analysis to assess causal interpretation, showing that unobserved factors such as ability, ambition, and family background likely generate **upward bias** in estimated returns to Economics degrees through positive correlations with both degree choice and earnings. 
* Evaluated the limitations of causal inference in observational data and explained why Economics-degree attainment cannot be treated as an exogenous treatment without additional identification assumptions or research designs. 
* Estimated Linear Probability and Probit models for college enrollment among 19–21-year-olds and compared predicted probabilities across model specification
