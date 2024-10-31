# On the Ripeness of Bananas: An Empirical Study

Accelerating fruit ripening through household methods is a common practice, yet the scientific basis of many
such techniques remains underexplored. This study investigates the effectiveness of two straightforward
interventions—poking holes in fruit and dipping it in different liquids—as potential methods to influence
ripening rates. These methods were selected to assess whether minor physical modifications or exposure to
common liquids can meaningfully alter the ripening process.

For more details on results and the experimental setup, please refer to the `pre-experimental-plan.md` file and generate the final report PDF.

## Description

This project creates datasets from banana images, performs exploratory analysis, runs statistical tests, and generates a PDF report. A ``Makefile`` is included to streamline the workflow, handling data processing, rendering `.Rmd` files, and managing output directories.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Makefile Targets](#makefile-targets)

## Installation

From CLI perform the following:
1. **Clone the repository:**
    To clone the repository
    ```bash
    git clone https://github.com/paoloborello/stats604-project3.git
    ```
2.	**Install Required R Packages:**
    Now move to inside of the repo using cd.
    ```bash
    cd stats604-project3
    ```
    The Makefile includes a rule to install R packages listed in requirements.txt.
    Run the following command to ensure all necessary packages are installed:
    ```bash
    make install_requirements
    ```
    This command reads requirements.txt and installs any missing R packages.

## Usage
This command reads requirements.txt and installs any missing R packages.

```bash
make
```
    
This command will:

1.	Install required R packages.
2.	Run data processing scripts.
3.	Perform exploratory data analysis (EDA) and save the output in PDF format.
4.	Execute statistical tests.
5.	Render the final report to a PDF file in the output directory.

## Makefile Targets

The Makefile includes several targets to facilitate different steps of the workflow:
 - ``make all``: Installs dependencies, processes data, performs EDA, runs tests, and generates the report. This is the default target.
 - ``make install_requirements``: Installs R packages listed in requirements.txt.
 - ``make data``: Runs data processing scripts in the data folder.
 - ``make eda``: Creates necessary directories and renders the 01_EDA.Rmd file to PDF.
 - ``make tests``: Renders the 02_Tests.Rmd file to PDF.
 - ``make report``: Renders the report.Rmd file located in the report folder to PDF.
 - ``make clean``: Removes generated PDF files, plot PNGs, and cleans up the output and plots directories.
   
Now, with a single make command, you can easily manage data processing, analysis, and report generation, helping streamline and simplify your study of banana ripeness.
