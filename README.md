

**Reproducible results. Wastewater-based epidemiology framework:** 
*Collaborative modeling for sustainable disease surveillance* 
================

Science of the Total Environment: (Add DOI)

Repository: (Add zenodo DOI)

Néstor DelaPaz-Ruíz, Ellen-Wien Augustijn, Mahdi Farnaghi, Shaheen A. Abdulkareem, Raul Zurita-Milla. September, 2024

Affiliation: Department of Geo-Information Process (GIP), Faculty of Geo-Information Science and Earth Observation (ITC), University of Twente, Drienerlolaan 5, 7522 NB Enschede, The Netherlands

## About

This repository provides access to the materials (code-data), software-environments (NetLogo, Rstudio, Docker containers), and the steps for reproducing the results from the publication: *Wastewater-based epidemiology framework: Collaborative modeling for sustainable disease surveillance*.

The information below guides you to execute two NetLogo simulations. The main outputs are the figures representing the results of the mentioned publication.

## Getting Started

### Pre-requirements

Used computational environment:

```         
Platform: x86_64-w64-mingw32/x64 (64-bit) 
Running under: Windows 11 x64 (build 22631)
Processor:  Intel(R) Core(TM) i7-10750H CPU @ 2.60GHz   2.59 GHz
Logical processors: 12 
Installed RAM   32.0 GB (31.6 GB usable)
System type 64-bit operating system, x64-based processor

Docker Desktop v.4.16.3

R version 4.3.1 (2023-06-16 ucrt)
RStudio 2023.12.1

NetLogo 6.3
```

You will need the following:

1.  Data:

-   Download or copy this repository to a local folder .

2.  Open-source software:

Quick reproducibility (requires NetLogo/Rstudio experience):

-   Install and run Git Bash. See: <https://gitforwindows.org/>
-   Install and run NetLogo. See: <https://ccl.northwestern.edu/netlogo/6.3>
-   Install Rstudio. See: <https://dailies.rstudio.com/version/2023.12.1+402/>
-   NetLogo configuration: Copy the provided `NetLogo.cfg` file and replace it at the folder: `C:\Program Files\NetLogo 6.3.0\app`. In this way, you are free to use several processors. Please, refer to the following link: [FAQ: How big can my model be? How many turtles, patches, procedures, buttons, and so on can my model contain?](http://ccl.northwestern.edu/netlogo/docs/faq.html#how-big-can-my-model-be-how-many-turtles-patches-procedures-buttons-and-so-on-can-my-model-contain). After the NetLogo installation, make sure to execute the `. ./code/newfiles.txt` in Git Bash.

3.  Libraries and extensions:

-   NetLogo: The first time running the Netlogo file, you will get a windows to install the time extension. Follow the instructions to install it.
-   Rstudio: The first time that you open the R project execute the `renv::restore()` in the R console to load the required libraries. You can explore the library requirements in the `renv.lock` file.

## Quick reproducibility

This section is for Windows users familiar with NetLogo, Rstudio, and Git bash. Mac or Linux users can also try to reproduce results. Jump to the long-term reproducibility (usage) section, which uses Docker to reproduce results as the alternative for non-experienced users.

Steps for a quick reproduction:

1.  In a new folder, execute the following commands in git bash:

``` bash
git clone https://github.com/delapazruiz/ddw.framework.git
```

``` bash
cd ddw.framework/
```

``` bash
. ./code/newfiles.txt
```

2.  Open the NetLogo (v. 6.3) file and run the experiment. In Tools/BehaviorSpace, select number of processors to run the experiment. (time: around 30 min)

First simulation (around 30 min):

``` bash
s4.framework.wastewater.surveillance.nlogo
```

Second simulation (around 30 min):

``` bash
s5.framework.wastewater.tss.loads.nlogo
```

3.  Open the Rstudio project file and verify the library requirements (between 15-30 min).

R Project file:

``` bash
ddw.framework.Rproj
```

Make sure that ‘renv’ is installed and loaded.

``` bash
install.packages("renv")
```

Load the ‘renv’ library.

``` bash
library(renv)
```

Run the following in the R console to install the required libraries.

``` bash
renv::restore()
```

4.  Open the Quarto file (.qmd) and render it to generate the report: (time: around 10 min)

``` bash
Framework.wastewater.surveillance.qmd
```

## Support

This repository is expected to be in continuous improvement. For major changes, please open an issue first to discuss what you would like to improve.

## License

This project is licensed under the MIT license. Feel free to edit and distribute this template as you like. See LICENSE for more information.

[MIT](https://choosealicense.com/licenses/mit/)

## Acknowledgements

The authors wish to express their gratitude for the valuable support in the local implementation of this study, without which this research cannot be consolidated: Carlos Pailles, Ana Velasco, Lucía Guardamino, Rodrigo Tapia-McClung, Araceli Chávez, Diana Ramos, Daniela Goméz, José Luis Pérez, Natalia Volkow, and the anonymous facilitators from Mexico City, citizens of Tepeji del Río, and the INEGI department of microdata. Scholarship funder: CONACYT-Alianza FiiDEM.
