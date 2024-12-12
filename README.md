# PPreview

## Overview

This repository contains the simulated data and analysis scripts accompanying the paper:

**Power Priors for Leveraging Historical Data: Looking Back and Looking Forward**

The repository is intended to provide transparency and reproducibility for the normal linear regression part presented in the paper. The simulated data mimics the ADNI data, but protect the privacy. Details of the posterior computation are also listed in the qmd file. Users can explore the simulation results, understand the methodology, and apply the provided scripts to their own data.

## Contents

### 1. Data

- **Simulated Data**: `simu\_data.csv` contains the response variable `y`, treatment indicator `z`, covariates `x1` to `x8`. and group variable `group`.

### 2. Scripts

- **Analysis Scripts**: \`analysis\_simulated data.qmd\` includes posterior computation for the borrowing-by-parts power prior (`bp3`), the partial borrowing-by-parts power prior (`pbp3`), the partial borrowing power prior (`pbpp`), and the iptw power prior (`iptw_pp`). Note that `bp3(a01 = a0, a02 = a0)` gives the result for the power prior with discounting coefficient `a0`.

## Getting Started

### Prerequisites

To run the scripts, you need:

- R (version 4.3.0 or later)
- R packages:
  - `tidyverse`
  - `mvtnorm`

### Steps to Reproduce

1. Clone this repository:
   ```bash
   git https://github.com/MinLinSTAT/PPreview
   cd PPreview
   ```
2. Open R or RStudio and set the working directory to the repository:
   ```R
   setwd("/path/to/PPreview")
   ```

## Citation

If you use this repository or find it helpful, please cite the corresponding paper:

```
Power Priors for Leveraging Historical Data: Looking Back and Looking Forward
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions or issues, please create an issue in the GitHub repository or contact:

- **Maintainer:** Min Lin
- Email: [min.2.lin@uconn.edu](mailto\:min.2.lin@uconn.edu)

