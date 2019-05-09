In CS112 course at Minerva, we learned about causal inference analysis, methods. This course makes me more skeptical in evaluating social sciences research papers when claiming causal effects between different variables. I came across a paper claiming the causal effect of wartime property transfer on voting behaviors using a quasi-binomial model. I did not fully agree with the claims and assumptions of the author. 

As a result, I wrote a decision memo addressing model dependency, invalid assumptions and proposing an alternative method called Genetic Matching and sent to the authors. My proposed method controls the balance between the treatment and control groups, overcoming the model-dependence, and better evaluate the treatment effect based on Rubin's causal model.

We are replicating, critiquing, and extending the results of Charnysh, V., & Finkel, E. (2017, August 10). The Death Camp Eldorado: Political and Economic Effects of Mass Violence | American Political Science Review. Retrieved April 24, 2019, from https://www.cambridge.org/core/journals/american-political-science-review/article/death-camp-eldorado-political-and-economic-effects-of-mass-violence/EF9175FAD1AE5302FFAF5169891E7A98. 

My paper (decision memo) can be found at: https://drive.google.com/open?id=1IAuRis4WUFYuZbJIbUrKPdyr4gfHNHKg

This repo includes: 
- Replicate.R: Replicate the paper's findings 
- Extension1.R: Finding the treatment effect for communities < 50 km distance.
- Extension2.R: Finding the treatment effect for each and every communities between 35 - 62 km distance (25-75% quantile).
- total_effect.csv: The table records all the treatment effects for each and every communities between 35 - 62 km distance (25-75% quantile).
- MainDataset.RData: The Dataset can be retrieved from https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/8SR1GY
