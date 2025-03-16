# 🪲 Effects of Antiparasitic Residues on Dung-Dwelling Invertebrates

## 📖 Project Overview
This repository contains the research and analysis for my **Master Thesis** at **RPTU Kaiserslautern-Landau**. The study investigates how **antiparasitic residues** from veterinary pharmaceuticals (e.g., **Ivermectin and Pyrantel**) affect **dung-dwelling invertebrate communities** and **decomposition processes** in horse dung.

### 🔍 Research Objectives:
- Assess the impact of **Ivermectin** and **Pyrantel** on **invertebrate diversity**.
- Evaluate the effects of these residues on **dung decomposition rates**.
- Compare **soil-dwelling vs. dung-dwelling** invertebrate responses.


## 🧪 Methodology
- **📍 Field Site:** Annweiler, Rhineland-Palatinate, Germany
- **📝 Study Design:** 112 dung samples from horses treated with:
  - **Ivermectin** (Anthelmintic treatment)
  - **Pyrantel** (Anthelmintic treatment)
  - **Control group** (untreated dung)
- **🔬 Experimental Setup:**
  - **Fauna Diversity Experiment** (DNA metabarcoding analysis of invertebrates)
  - **Decomposition Experiment** (Measurement of dry weight loss over time)
- **🖥️ Statistical Analysis:** Conducted in **R** using:
  - `ggplot2`, `vegan`, `dplyr`, `tidyr`, `lme4`
  - **ANOVA, t-tests, Shannon Diversity Index, NMDS & PERMANOVA**

## 🔬 Key Findings
- **Ivermectin significantly reduces invertebrate abundance** in dung.
- **Pyrantel has a weaker impact** on dung fauna.
- **No significant effect on overall species richness**, suggesting some species resilience.
- **Dung decomposition rates remain unaffected**, likely due to microbial compensation.
- **Soil fauna are less impacted** than dung fauna.

## 💻 How to Use
### 🔹 Clone this repository:
```sh
git clone https://github.com/yourusername/dung-invertebrate-study.git
cd dung-invertebrate-study

Install dependencies in R:
install.packages(c("ggplot2", "vegan", "dplyr", "tidyr", "lme4"))

Run the analysis:
source("R-script.R")










