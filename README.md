# Random Forest classifier for the e1 cortical neuron cluster

A scikit-learn Random Forest that classifies the e1 excitatory-neuron
cluster from single-nucleus RNA-seq gene-expression data (871 samples,
608 gene features).

## Results
- Best model: NTREE = 500, MTRY = 12 (grid-searched)
- OOB accuracy: **99.66%**
- Stratified 3-fold CV (hand-implemented): 99.54% pooled
- Feature ranking recovered all 4 known biological marker genes for e1
  (TESPA1, SLC17A7, KCNIP1, LINC00507) in the top 10 of 608

## Report
See [CSC_659-859_Fall_2026_HW_2_Ryan_Selvarajan.PDF](./CSC_659-859_Fall_2026_HW_2_Ryan_Selvarajan.PDF)
for the full write-up: data audit, methodology, results,
feature-importance discussion, and a run-time test on held-out samples.

## Reproduce
Requires Python 3.12 and the dataset (not redistributed; see below).

```bash
python -m venv .venv
.venv/bin/pip install -r requirements.txt
./make_pdf.sh
```

## Data
Dataset from Aevermann et al. 2018 (J. Craig Venter Institute), obtained
through CSC 659/859. Not included in this repo.

## Context
Coursework for CSC 659/859 (Machine Learning), San Francisco State
University, Fall 2026. Prof. D. Petkovic.
