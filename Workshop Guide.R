## Workshop Guide

# Part I: Resources 
## 1) Help Files 

?principal 


## 1) Working with Help Files

ex_1 <- c(1, NA, 2, 3, 4)
mean(ex_1)
?mean 


# Part II: Steps to Solving Problems 
## `mtcars` 


library(tidyverse) # Load tidyverse to follow along
mtcars # Let's look at our data
?mtcars # More information about the dataset


names(mtcars) # And let's look at the variables


## tep 1: Google


## Step 2: Find a solution you feel you can tackle 


## Step 3: Look at the help file 

## Step 4: Code 

### Sometimes using a small, practice dataset to test before using your full data is useful

testing_ds <- tibble(column_1 = c("a", "b"),
                     column_2 = c(1, 2))


# Part III: Common Errors 
## 1) Function not found

mtcars %>% 
  remane(weight = wt)

principal(mtcars, nfactors = 2)


## 2) Object not found

mtcars %>%  
  rename(weight = tw)

## 3) Non-numeric argument to a binary operator

mtcars %>% 
  rownames_to_column(var = "make_model") %>% 
  mutate(make_model = make_model + 1)

## 4) File does not exist 

practice_dat <- read_csv("practice_ds.csv")

## Practice I: Intermediate 

practice1 <- read_csv("practice_ds.csv")
