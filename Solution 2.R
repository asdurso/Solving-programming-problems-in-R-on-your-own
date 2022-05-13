library(tidyverse)
library(pewmethods)
library(anesrake)

set.seed(1)

anes <- read_csv("Data/anes.csv")

prac_dat <- read_csv("Data/practice_ds2.csv")

anes_recode <- anes %>%
  rename(
    pid7 = V201231x,
    gender = V201600,
    age = V201507x,
    weight = V200010a
  ) %>%
  mutate(
    pid = case_when(
      between(pid7, 1, 2) ~ "Democrat",
      between(pid7, 3, 5) ~ "Independent",
      between(pid7, 6, 7) ~ "Republican", 
      T ~ "NA") %>% 
      as.factor() %>% factor(
        levels =
          c(
            "Democrat",
            "Independent",
            "Republican",
            "NA"
          )
        ),
    gender = case_when(gender == 1 ~ "Male",
                       gender == 2 ~ "Female",
                       T ~ "NA") %>% as.factor() %>% 
      factor(
        levels = c(
          "Male",
          "Female",
          "NA"
        )
      ),
    age = case_when(
      age >= 18 & age <= 24 ~ "18-24",
      age >= 25 & age <= 54 ~ "25-54",
      age >= 55 ~ "55+",
      T ~ "NA"
    ) %>% factor(
      levels = c(
        "18-24",
        "25-54",
        "55+", 
        "NA"
      )
    )
  ) %>% 
  filter(!is.na(gender), !is.na(pid), !is.na(age))



prac_recode <- prac_dat %>%
  mutate(
    gender = as.factor(gender) %>% 
      factor(
        levels = c(
          "Male",
          "Female",
          "NA"
        )
      ),
    pid = as.factor(pid) %>% 
      factor(
        levels =
          c(
            "Democrat",
            "Independent",
            "Republican",
            "NA"
          )
      ),
    age = case_when(
      age >= 18 & age <= 24 ~ "18-24",
      age >= 25 &
        age <= 54 ~ "25-54",
      age >= 55 ~ "55+", 
      T ~ "NA"
    ) %>%
      as.factor() %>% factor(
        levels = c(
          "18-24",
          "25-54",
          "55+", 
          "NA"
        )
      )
    ) %>% 
  filter(!is.na(age))

targets <- create_raking_targets(
  anes_recode,
  vars = c(
    "pid",
    "age",
    "gender"
  ),
  wt = "weight"
)


demopid <- c(34.6, 33.6, 31.4, 0.3)
names(demopid) <- c("Democrat",
                     "Independent",
                     "Republican",
                     "NA")
levels(demopid) <- c("Democrat",
                      "Independent",
                      "Republican",
                      "NA")


demoage <- c(10.5, 46.7, 38.9, 3.9)
names(demoage) <- c("18-24",
                       "25-54",
                       "55+",
                       "NA")
levels(demoage) <- c("18-24",
                        "25-54",
                        "55+",
                        "NA")


demogender <- c(47.9, 51.5, 0.6)
names(demogender) <- c("Male",
                       "Female",
                       "NA")
levels(demogender) <- c("Male",
                        "Female",
                        "NA")


target <- list(demopid, demoage, demogender)
names(target) <- c("pid", "age", "gender")

prac_recode$caseid <- 1:nrow(prac_recode)
prac_recode <- as.data.frame(prac_recode)
raking <-
  anesrake(target, 
           prac_recode, 
           prac_recode$caseid,
           cap = 5,                      # Maximum value for any given weight
           choosemethod = "total",       # How are parameters compared for selection (other options include 'average' and 'max')
           type = "pctlim",              # What targets should be used to weight
           pctlim = 0.05                 # Threshold for deviation)
           
  )

caseweights <- data.frame(cases=raking$caseid, weights=raking$weightvec)
summary(caseweights)
summary(raking)

prac_recode$weight  <- unlist(raking[1])


prac_recode






