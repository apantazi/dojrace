utils::globalVariables(
  c("P1_001N", "P1_004N", "P1_005N", "P1_006N", "P1_007N", "P1_008N", "P1_011N",
    "P1_012N", "P1_013N", "P1_014N", "P1_015N", "P1_016N", "P1_017N", "P1_018N",
    "P1_019N", "P1_020N", "P1_021N", "P1_022N", "P1_023N", "P1_024N", "P1_025N",
    "P1_027N", "P1_028N", "P1_029N", "P1_030N", "P1_031N", "P1_032N", "P1_033N",
    "P1_034N", "P1_035N", "P1_036N", "P1_037N", "P1_038N", "P1_039N", "P1_040N",
    "P1_041N", "P1_042N", "P1_043N", "P1_044N", "P1_045N", "P1_046N", "P1_048N",
    "P1_049N", "P1_050N", "P1_051N", "P1_052N", "P1_053N", "P1_054N", "P1_055N",
    "P1_056N", "P1_057N", "P1_058N", "P1_059N", "P1_060N", "P1_061N", "P1_062N",
    "P1_064N", "P1_065N", "P1_066N", "P1_067N", "P1_068N", "P1_069N", "P1_071N",
    "P4_002N", "P4_005N", "summary_value"
  )
)
#' Retrieve DOJ/OMB Race Categories from Census Data
#'
#' Downloads 2020 Decennial Census data and returns DOJ/OMB-compliant race category counts by geography.
#'
#' @param geography The census geography (e.g., "block", "tract").
#' @param state 2-letter state abbreviation (e.g., "FL").
#' @param county County name or FIPS code.
#' @param geometry Logical; whether to include spatial data.
#' @param ... Additional arguments passed to tidycensus::get_decennial().
#' @return A data.frame with combined DOJ/OMB race categories.
#' @export
#' @examples
#' get_doj_race_cats(geography = "block", state = "FL", county = "Duval")


get_doj_race_cats <- function(geography = "block", state, county, geometry = FALSE, ...) {
  all_vars <- c(
    "P1_004N","P1_011N","P1_016N","P1_017N","P1_018N","P1_019N","P1_027N","P1_028N",
    "P1_029N","P1_030N","P1_037N","P1_038N","P1_039N","P1_040N","P1_041N","P1_042N",
    "P1_048N","P1_049N","P1_050N","P1_051N","P1_052N","P1_053N","P1_058N","P1_059N",
    "P1_060N","P1_061N","P1_064N","P1_065N","P1_066N","P1_067N","P1_069N","P1_071N",
    "P4_002N","P4_005N","P1_006N","P1_007N","P1_013N","P1_014N","P1_020N","P1_021N",
    "P1_023N","P1_024N","P1_025N","P1_031N","P1_032N","P1_034N","P1_035N","P1_036N",
    "P1_043N","P1_044N","P1_045N","P1_046N","P1_054N","P1_055N","P1_056N","P1_057N",
    "P1_062N","P1_068N","P1_005N","P1_012N","P1_022N","P1_033N","P1_008N","P1_015N","P1_001N"
  )

  # Download wide-format census data
  out <- tidycensus::get_decennial(
    geography = geography,
    state = state,
    county = county,
    variables = all_vars,
    summary_var = "P3_001N",
    year = 2020,
    output = "wide",
    geometry = geometry,
    ...
  )

  # Calculate DOJ/OMB race categories
  out <- transform(out,
                   black = P1_004N+P1_011N+P1_016N+P1_017N+P1_018N+P1_019N+P1_027N+P1_028N+P1_029N+
                     P1_030N+P1_037N+P1_038N+P1_039N+P1_040N+P1_041N+P1_042N+P1_048N+P1_049N+P1_050N+
                     P1_051N+P1_052N+P1_053N+P1_058N+P1_059N+P1_060N+P1_061N+P1_064N+P1_065N+P1_066N+
                     P1_067N+P1_069N+P1_071N,
                   white = P4_005N,
                   hisp = P4_002N,
                   asian = P1_006N+P1_013N+P1_017N+P1_020N+P1_023N+P1_024N+P1_028N+P1_031N+P1_034N+
                     P1_035N+P1_037N+P1_040N+P1_041N+P1_043N+P1_044N+P1_046N+P1_048N+P1_051N+P1_052N+
                     P1_054N+P1_055N+P1_057N+P1_058N+P1_059N+P1_061N+P1_062N+P1_064N+P1_065N+P1_067N+
                     P1_068N+P1_069N+P1_071N,
                   AIAN = P1_005N+P1_012N+P1_016N+P1_020N+P1_021N+P1_022N+P1_027N+P1_031N+P1_032N+
                     P1_033N+P1_037N+P1_038N+P1_039N+P1_043N+P1_044N+P1_045N+P1_048N+P1_049N+P1_050N+
                     P1_054N+P1_055N+P1_056N+P1_058N+P1_059N+P1_060N+P1_062N+P1_064N+P1_065N+P1_066N+
                     P1_068N+P1_069N+P1_071N,
                   PI = P1_007N+P1_014N+P1_018N+P1_021N+P1_023N+P1_025N+P1_029N+P1_032N+P1_034N+
                     P1_036N+P1_038N+P1_040N+P1_042N+P1_043N+P1_045N+P1_046N+P1_049N+P1_051N+P1_053N+
                     P1_054N+P1_056N+P1_057N+P1_058N+P1_060N+P1_061N+P1_062N+P1_064N+P1_066N+P1_067N+
                     P1_068N+P1_069N+P1_071N,
                   other = P1_008N+P1_015N+P1_019N+P1_022N+P1_024N+P1_025N+P1_030N+P1_033N+P1_035N+
                     P1_036N+P1_039N+P1_041N+P1_042N+P1_044N+P1_045N+P1_046N+P1_050N+P1_052N+P1_053N+
                     P1_055N+P1_056N+P1_057N+P1_059N+P1_060N+P1_061N+P1_062N+P1_065N+P1_066N+P1_067N+
                     P1_068N+P1_069N+P1_071N,
                   pop = P1_001N,
                   vap = summary_value
  )
  out$aapi <- out$asian + out$PI
  vars_to_keep <- c("GEOID","NAME","pop","vap","black","white","hisp","asian","PI","AIAN","other","aapi")
  out <- out[, vars_to_keep]
  return(out)
}

#' Check if a Census API Key is set
#'
#' @return Logical TRUE if set, FALSE if not
#' @export
is_census_key_set <- function() {
  key <- Sys.getenv("CENSUS_API_KEY", unset = NA)
  !is.na(key) && nchar(key) > 0
}
