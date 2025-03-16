# Effects of Antiparasitic Residues on Dung-Dwelling Invertebrates and Decomposition Processes
 
 Overview
This repository contains the research data, analysis, and findings from my Master Thesis at RPTU Kaiserslautern-Landau, titled:

Effects of Antiparasitic Residues on Dung-Dwelling Invertebrates and Decomposition Processes

This study investigates the environmental impact of antiparasitic residues, particularly Ivermectin and Pyrantel, on dung-inhabiting invertebrate communities and decomposition rates. The research aims to understand how these veterinary pharmaceuticals affect biodiversity and ecosystem processes, particularly in livestock farming.

Methodology
Study Site: Annweiler, Rhineland-Palatinate, Germany
Data Collection: 112 dung samples from horse farms treated with Ivermectin, Pyrantel, or untreated (control).
Experiments:
Fauna Diversity Experiment: Analysis of invertebrate diversity using DNA metabarcoding.
Decomposition Experiment: Measuring dry weight loss of dung samples to assess decomposition rates.
Laboratory Analysis:
DNA Extraction, PCR, and Bioinformatics Analysis (Metabarcoding).
Statistical Analysis in R using ggplot2, vegan, dplyr.

Key Findings
Ivermectin significantly reduced invertebrate abundance, whereas Pyrantel had a weaker effect.
No significant impact of antiparasitic residues on overall species richness.
Dung decomposition rates were not significantly affected, indicating microbial activity compensated for invertebrate loss.
Soil-dwelling invertebrates were less impacted than dung-dwelling communities.

How to Use
If you want to analyze the dataset or reproduce the statistical analysis:

Clone this repository:
git clone https://github.com/yourusername/dung-invertebrate-study.git
cd dung-invertebrate-study

Install dependencies in R:
install.packages(c("ggplot2", "vegan", "dplyr", "tidyr", "lme4"))

Run the analysis:
source("scripts/analysis.R")

References
Beynon et al. (2012). Consequences of antiparasitic residues on dung beetles. Agriculture, Ecosystems & Environment.
Floate et al. (2016). Validation of antiparasitic residue field tests. Environmental Toxicology and Chemistry.
Manning et al. (2017). Quantifying anthelmintic exposure effects. Ecological Entomology.

Author
Shaghayegh Gooranorimi
Master of Environmental Science, RPTU Kaiserslautern-Landau
shaqayeq.g1997@gmail.com

Acknowledgments
Special thanks to Dr. Bernhard Eitzinger and PD Dr. Jens Schirmel for their supervision and guidance, as well as to the research facilities at RPTU Kaiserslautern-Landau.

