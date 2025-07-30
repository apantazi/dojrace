
# dojrace

<!-- badges: start -->

<!-- badges: end -->

## What is dojrace?

**dojrace** is a helper package for aggregating U.S. Census 2020 data
into Department of Justice (DOJ) and Office of Management and Budget
(OMB) racial categories using `tidycensus`.

### Why does this exist?

To conform to the DOJ & OMB definitions of racial categories. **If
someone picks a racial category, they are counted in that group—even if
they pick multiple racial categories.**  
- This means people may be double-counted.  
- “White” here means non-Hispanic white only.  
- This approach matches how the [DOJ and
OMB](https://www.justice.gov/archives/opa/press-release/file/1429486/dl?inline=)
define groups for enforcing the Voting Rights Act.  
- This allows voting strength and demographic analysis *without*
excluding multiracial people, so that every person is reflected in the
groups they select.  
- For more information, read [this
story](https://jaxtrib.org/2021/12/16/jacksonvilles-redistricting-plans-ignore-federal-guidelines/)
about a city that did not follow the OMB definitions.

## Installation

You can install the development version of dojrace from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("apantazi/dojrace")
#> Using github PAT from envvar GITHUB_PAT. Use `gitcreds::gitcreds_set()` and unset GITHUB_PAT in .Renviron (or elsewhere) if you want to use the more secure git credential store instead.
#> Downloading GitHub repo apantazi/dojrace@HEAD
#> These packages have more recent versions available.
#> It is recommended to update all of them.
#> Which would you like to update?
#> 
#> 1: All                               
#> 2: CRAN packages only                
#> 3: None                              
#> 4: curl       (6.2.2 -> 6.4.0) [CRAN]
#> 5: tidycensus (1.7.1 -> 1.7.3) [CRAN]
#> 
#> ── R CMD build ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#>          checking for file 'C:\Users\Andrew\AppData\Local\Temp\Rtmp8ehV7x\remotes41a83b6a2e0e\apantazi-dojrace-8555605/DESCRIPTION' ...  ✔  checking for file 'C:\Users\Andrew\AppData\Local\Temp\Rtmp8ehV7x\remotes41a83b6a2e0e\apantazi-dojrace-8555605/DESCRIPTION'
#>       ─  preparing 'dojrace':
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>       ─  checking for LF line-endings in source and make files and shell scripts
#> ─  checking for empty or unneeded directories
#>      Omitted 'LazyData' from DESCRIPTION
#>       ─  building 'dojrace_0.1.0.tar.gz'
#>      
#> 
#> Warning: package 'dojrace' is in use and will not be installed
```

You’ll also need an API key from the U.S. Census Bureau and to set it
with [tidycensus](https://github.com/walkerke/tidycensus):

``` r
library(dojrace)
if (!dojrace::is_census_key_set()) {
  key <- readline(prompt = "Enter your Census API key (get one at https://api.census.gov/data/key_signup.html): ")
  if (nchar(key) > 0) {
    tidycensus::census_api_key(key, install = TRUE)
    message("API key installed. Restart R or run readRenviron('~/.Renviron') to use now.")
  } else {
    message("No API key entered. You may experience rate limits or errors.")
  }
}
```

## Example

This example computes DOJ/OMB racial categories for Duval County census
blocks:

``` r
duval_blocks <- get_doj_race_cats(
  geography = "block",
  state = "FL",
  county = "Duval"
)
#> Getting data from the 2020 decennial Census
#> Using FIPS code '12' for state 'FL'
#> Using FIPS code '031' for 'Duval County'
#> Using the PL 94-171 Redistricting Data Summary File
#> Using FIPS code '12' for state 'FL'
#> Using FIPS code '031' for 'Duval County'
#> Using the PL 94-171 Redistricting Data Summary File
head(duval_blocks)
#>             GEOID                                                                NAME pop vap black white hisp asian PI AIAN other
#> 1 120310001011029 Block 1029, Block Group 1, Census Tract 1.01, Duval County, Florida  18  18     6    11    1     0  0    0     1
#> 2 120310001011032 Block 1032, Block Group 1, Census Tract 1.01, Duval County, Florida  52  47    29    17    2     0  0    4     2
#> 3 120310001011035 Block 1035, Block Group 1, Census Tract 1.01, Duval County, Florida  27  19    19     6    0     1  0    0     1
#> 4 120310001012002 Block 2002, Block Group 2, Census Tract 1.01, Duval County, Florida   0   0     0     0    0     0  0    0     0
#> 5 120310001012006 Block 2006, Block Group 2, Census Tract 1.01, Duval County, Florida  27  21    12    12    0     0  2    3     0
#> 6 120310001012009 Block 2009, Block Group 2, Census Tract 1.01, Duval County, Florida   9   2     5     1    0     1  0    0     0
#>   aapi
#> 1    0
#> 2    0
#> 3    1
#> 4    0
#> 5    2
#> 6    1
```

## What makes this different?

Most “race” aggregations from the Census are mutually exclusive and
undercount multiracial residents.  
**dojrace** ensures every person is counted for every race they select,
matching DOJ guidance, so you can analyze potential voting strength and
compliance with the Voting Rights Act.

See [DOJ/OMB
methodology](https://www.justice.gov/archives/opa/press-release/file/1429486/dl?inline=)
for technical guidance.

    #> R version 4.5.0 (2025-04-11 ucrt)
    #> Platform: x86_64-w64-mingw32/x64
    #> Running under: Windows 11 x64 (build 26100)
    #> 
    #> Matrix products: default
    #>   LAPACK version 3.12.1
    #> 
    #> locale:
    #> [1] LC_COLLATE=English_United States.utf8  LC_CTYPE=English_United States.utf8    LC_MONETARY=English_United States.utf8
    #> [4] LC_NUMERIC=C                           LC_TIME=English_United States.utf8    
    #> 
    #> time zone: America/New_York
    #> tzcode source: internal
    #> 
    #> attached base packages:
    #> [1] stats     graphics  grDevices utils     datasets  methods   base     
    #> 
    #> other attached packages:
    #> [1] dojrace_0.1.0
    #> 
    #> loaded via a namespace (and not attached):
    #>  [1] tidyselect_1.2.1   dplyr_1.1.4        gh_1.4.1           fastmap_1.2.0      xopen_1.0.1        promises_1.3.3    
    #>  [7] digest_0.6.37      mime_0.13          lifecycle_1.0.4    sf_1.0-21          ellipsis_0.3.2     processx_3.8.6    
    #> [13] magrittr_2.0.3     compiler_4.5.0     rlang_1.1.6        tools_4.5.0        yaml_2.3.10        knitr_1.50        
    #> [19] askpass_1.2.1      prettyunits_1.2.0  htmlwidgets_1.6.4  pkgbuild_1.4.7     classInt_0.4-11    curl_6.2.2        
    #> [25] xml2_1.3.8         tidycensus_1.7.1   pkgload_1.4.0      rsconnect_1.4.0    KernSmooth_2.23-26 miniUI_0.1.2      
    #> [31] withr_3.0.2        purrr_1.1.0        sys_3.4.3          desc_1.4.3         grid_4.5.0         roxygen2_7.3.2    
    #> [37] urlchecker_1.0.1   profvis_0.4.0      xtable_1.8-4       e1071_1.7-16       gitcreds_0.1.2     cli_3.6.5         
    #> [43] rmarkdown_2.29     crayon_1.5.3       generics_0.1.4     remotes_2.5.0      rstudioapi_0.17.1  httr_1.4.7        
    #> [49] tzdb_0.5.0         sessioninfo_1.2.3  DBI_1.2.3          cachem_1.1.0       proxy_0.4-27       stringr_1.5.1     
    #> [55] rvest_1.0.4        vctrs_0.6.5        tigris_2.2.1       devtools_2.4.5     jsonlite_2.0.0     callr_3.7.6       
    #> [61] rcmdcheck_1.4.0    hms_1.1.3          credentials_2.0.2  testthat_3.2.3     tidyr_1.3.1        units_0.8-7       
    #> [67] glue_1.8.0         ps_1.9.1           stringi_1.8.7      later_1.4.2        tibble_3.3.0       pillar_1.11.0     
    #> [73] rappdirs_0.3.3     htmltools_0.5.8.1  brio_1.1.5         openssl_2.3.3      httr2_1.1.2        R6_2.6.1          
    #> [79] gert_2.1.5         rprojroot_2.0.4    shiny_1.10.0       evaluate_1.0.3     readr_2.1.5        memoise_2.0.1     
    #> [85] httpuv_1.6.16      class_7.3-23       Rcpp_1.1.0         uuid_1.2-1         whisker_0.4.1      xfun_0.52         
    #> [91] fs_1.6.6           usethis_3.1.0      pkgconfig_2.0.3
