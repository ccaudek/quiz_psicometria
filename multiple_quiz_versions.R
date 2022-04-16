# Script name: multiple_quiz_versions.R
# Project: teaching
# Script purpose: generate multiple versions of a quiz for Moodle
# @author: Corrado Caudek <corrado.caudek@unifi.it>
# Date Created: Fri Dec 17 07:23:51 2021
# Last Modified Date: Fri Mar 25 14:27:22 2022
#
# 👉 When importing the xml file in Moodle do the following:
#    1) import the .xml file by chosing the xml format, 
#    2) change the name of the exercise, 
#    3) tick the option "alternative in ordine casuale",
#    4) select the box with the exercise and move the exercise to 
#       the appropriate folder.
#    To create a new "Categories" folder, go in "Categorie di domande"
#    from the pull-down menu.
#
#    Tutorial: https://www.youtube.com/watch?v=5K9hrE3YkPs


# 1.0 Preliminaries -------------------------------------------------------

# Load packages and enforce par(ask = FALSE)
library("here")
library("tidyverse")
library("exams")

options(device.ask.default = FALSE)

# 2.0 Inspect individual exercises ----------------------------------------

# Turn a single exercise into a HTML file (shown in browser)
exams2html(
  here::here("quiz", "07_random_vars", "e_rand_vars_01.Rmd"),
  encoding = "UTF-8",
  mathjax = TRUE,
  converter = "pandoc-mathjax"
)

# Convert a single quiz into Moodle format ----
exams2moodle(
  here::here("quiz", "07_random_vars", "e_rand_vars_01.Rmd"),
)


# 3.0 Generate categories and subcategories in Moodle ---------------------

# On Moodle, create a category for the topic. Example, 001_sums.
# Second, generate the subcategories, one for each quiz. Example: 
# 001_sums/sums_01
# 001_sums/sums_02
# 001_sums/sums_03
# ...
# 001_sums/sums_10


# 4.0 Generate multiple versions of each quiz -----------------------------


elearn_exam <- c(
  here::here("quiz", "07_random_vars", "e_rand_vars_01.Rmd")
)

xm <- exams::exams2moodle(
  elearn_exam,
  n = 4,
  name = "rand_var",
  encoding = "UTF-8",
  converter = "pandoc-mathjax"
)


# 5.0 Import quiz ---------------------------------------------------------

# The file 001_sums-xlm contains 4 versions of that quiz.
# This file can be imported in Moodle and moved in the 
# 001_sums/sums_01 folder.


######## END ----








# 4.0 Convert .Rmd file in .xml format ------------------------------------

# The xml file can be imported in Moodle

elearn_exam <- c(
  here::here("quiz", "01_sums", "sums_01.Rnw"),
  here::here("quiz", "01_sums", "sums_02.Rnw"),
  here::here("quiz", "01_sums", "sums_03.Rnw"),
  here::here("quiz", "01_sums", "sums_04.Rnw"),
  here::here("quiz", "01_sums", "sums_05.Rnw"),
  here::here("quiz", "01_sums", "sums_06.Rnw"),
  here::here("quiz", "01_sums", "sums_07.Rnw"),
  here::here("quiz", "01_sums", "sums_08.Rnw"),
  here::here("quiz", "01_sums", "sums_09.Rnw"),
  here::here("quiz", "01_sums", "sums_10.Rnw")
)
  
xm <- exams::exams2moodle(
  elearn_exam,
  n = 4,
  name = "001_sums",
  encoding = "UTF-8",
  converter = "pandoc-mathjax"
)


# 5.0 importing a xml file in Moodle --------------------------------------

# First, create a category for the topic. Example, 001_sums.
# Second, generate the subcategories, one for each quiz. Example: 
# 001_sums/sums_01
# 001_sums/sums_02
# 001_sums/sums_03
# ...
# 001_sums/sums_10
# Third, 


# Exam generation ---------------------------------------------------------


## define an exam (= list of exercises)
## be sure that these are multiple questions exercises with only one correct alternative
## here I used as example the same exercise (there were no others). Note that, also by
## doing this, the order in which the response list is printed is randomized among the
## different questions.



myexam <- list(
  here::here("quiz", "25_parziale_2", "anova_1.Rnw"),
  here::here("quiz", "25_parziale_2", "anova_2.Rnw"),
  here::here("quiz", "25_parziale_2", "bonferroni_1.Rnw"),
  here::here("quiz", "25_parziale_2", "CI_1.Rnw"),
  here::here("quiz", "25_parziale_2", "cohen_d_1.Rnw"),
  here::here("quiz", "25_parziale_2", "cohen_d_2.Rnw"),
  here::here("quiz", "25_parziale_2", "correlation_1.Rnw"),
  here::here("quiz", "25_parziale_2", "interpretation_CI_1.Rnw"),
  here::here("quiz", "25_parziale_2", "linreg_1.Rnw"),
  here::here("quiz", "25_parziale_2", "linreg_2.Rnw"),
  here::here("quiz", "25_parziale_2", "linreg_3.Rnw"),
  here::here("quiz", "25_parziale_2", "linreg_4.Rnw"),
  here::here("quiz", "25_parziale_2", "t_F.Rnw"),
  here::here("quiz", "25_parziale_2", "ttest_1.Rnw"),
  here::here("quiz", "25_parziale_2", "ttest_2.Rnw"), 
  here::here("quiz", "20_reg_lin", "reglin_3.Rnw"),
  here::here("quiz", "20_reg_lin", "reglin_4.Rnw"),
  here::here("quiz", "20_reg_lin", "reglin_5.Rnw"),
  here::here("quiz", "15_test_ipostesi_statistiche", "test_ipotesi_16.Rnw"),
  here::here("quiz", "15_test_ipostesi_statistiche", "test_ipotesi_17.Rnw"),
  here::here("quiz", "19_ANOVA_1_via", "anova_3.Rnw"),
  here::here("quiz", "19_ANOVA_1_via", "anova_4.Rnw"),
  here::here("quiz", "16_intervalli_confidenza", "intervallo_conf_11.Rnw"),
  here::here("quiz", "16_intervalli_confidenza", "intervallo_conf_12.Rnw"),
  here::here("quiz", "16_intervalli_confidenza", "intervallo_conf_13.Rnw")
  
)


# Create multiple exams on the disk ---------------------------------------

##  Here n=1 means that only
## one version of the test will be created. points=1 means that
## all responses are weighted equally. 
set.seed(326457)
ex1 <- exams2nops(
  myexam, 
  n = 1, 
  dir = "nops_pdf", 
  date = "2019-06-03",
  points = 1, # one point for each exercise
  language = "it",
  title	= "Psicometria",
  institution = "Scienze e Tecniche Psicologiche",
  logo = NULL,
  blank = 0,
  duplex = FALSE,
  encoding = "UTF-8",
  showpoints = FALSE
)



# Solutions ---------------------------------------------------------------

# Be sure you are in the right place!
getwd()

# Read metainfo informaton from the RDS file
metainfo <- readRDS("nops_pdf/metainfo.rds")

# Codes used for the different versions of the exam: 
# year / month / day / ... version_number
attributes(metainfo)

# Select, for example, the first version of the exam
selected_version <- metainfo$`19060300001`

# Recover, for example, the solution of the first problem
selected_version$exercise01

# Which response alternative is the correct one?
selected_version$exercise01$metainfo$string
# or
selected_version$exercise01$metainfo$solution


# Print solutions for all exercises ---------------------------------------


# Select each version of the exam
c1 <- metainfo$"19060300001"

