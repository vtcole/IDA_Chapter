# Supplemental material for upcoming chapter on integrative data analysis

The purpose of this supplemental material is to add some explanation and examples to the chapter on IDA in the **Handbook of Research Methods in Developmental Science, Second Edition** (Teti, Cleveland, & Rulison, forthcoming). We provide some examples of code readers can use to conduct their own integrative data analyses, as well as more information on nonlinear factor models.

Here we direct readers to the appropriate folders based on their interests.

## Nonlinear factor models

If readers wish to run their own MNLFA using binary or ordinal data, they should check out the explanation in the **nonlinear** folder. However, this is an incomplete description which should be supplemented by reviewing either or both of the following:

* Bauer, D. J. (2017). A more general model for testing measurement invariance and differential item functioning. *Psychological Methods, 22*(3), 507.

* Bauer, D. J., & Hussong, A. M. (2009). Psychometric approaches for developing commensurate measures across independent studies: Traditional and new models. *Psychological Methods, 14*(2), 101.

## Generating the simulated data

If readers want to know how we simulated the data, the first chunk of code in **allanalyses.R**, which is in the **R** folder, is a good place to start. Most of these decisions were based on their similarity to previously published studies on social cognition.

## Running all of the models mentioned in the chapter

There are two sets of models readers may wish to run. 

* The first are the models which check for unidimensionality in each individual dataset, described as Step 3 in the chapter. These analyses are performed using the lavaan package in R. These are in the **allanalyses.R** file in the **R** folder, beginning on line 151.

* The second are the models in Mplus which were used to test itemwise DIF models, as well as a model containing all of the effects. These are in the **mplus** folder. For a good description of what each line of Mplus code does in an MNLFA, check out [Dan Bauer's very helpful annotated code](https://supp.apa.org/psycarticles/supplemental/met0000077/MET_Bauer_2015-0386R2_Supp%5B1%5D.pdf) or [Nisha Gottfredson's equally helpful instructions for aMNLFA](https://nishagottfredson.web.unc.edu/wp-content/uploads/sites/7007/2021/07/Online-Appendix_v1.0.0.pdf), which apply to MNLFA more generally.

## Plotting factor scores

Finally, readers who want to create different factor score plots can see how we did it in the **allanalyses.R** file in the **R** folder. This input starts at line 168.