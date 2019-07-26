# Linear models

library(readr)
library(dplyr)
library(ggplot2)


# specify data type
person <- read_csv(
  file = "data/census_pums/sample.csv",
  col_types = cols_only(
    AGEP = 'i',  # Age
    WAGP = 'd',  # Wages or salary income past 12 months
    SCHL = 'i',  # Educational attainment
    SEX = 'f',   # Sex
    OCCP = 'f',  # Occupation recode based on 2010 OCC codes
    WKHP = 'i')) # Usual hours worked per week past 12 months


# specify levels of education from raw data
person <- within(person, {
  SCHL <- factor(SCHL)
  levels(SCHL) <- list(
    'Incomplete' = c(1:15),
    'High School' = 16,
    'College Credit' = 17:20,
    'Bachelor\'s' = 21,
    'Master\'s' = 22:23,
    'Doctorate' = 24)}) %>%
  filter(
    WAGP > 0,
    WAGP < max(WAGP, na.rm = TRUE))

# Formula Notation

fit <- lm(
  formula = WAGP ~ SCHL,
  data = person)

# Visualize the data
ggplot(person,aes(x=SCHL, y=WAGP)) + geom_boxplot()

fit #lm chooses intercepts for a linear model that minimizes the squares of the residuals (least squares)
# Returns the intercept and the difference from the intercept of each indpt variable.

# (y ~ -1 + a) The "-1" would force an intercept of 0; hardly used in practice.
# (y ~ a*b) = (y ~ a + b + a*b)
# (y ~ I(a*b)) The "I" protects the variables from expanding; only looks at interaction 
#    bt a and b instead of also a and b separately; more common when want to examine data after expansion

# Metadata matters

fit <- lm(
  log(WAGP) ~ SCHL,
  person)

fit <- lm(
  log(WAGP) ~ AGEP,
  person)

ggplot(person,aes(x=AGEP, y=WAGP)) + geom_point()

# GLM families # changes up the method used to minimize the square of the residuals
#    The family gives option of which family of distribution to use in fitting the model
#    Think about the shape of the data and the data type (e.g., numeric, continuous, categorical)

# link function: relationship between the estimated value from combo of predictors and the specific type of distribution

fit <- glm(log(WAGP) ~ SCHL,
           family = gaussian,
           data = person)

# Logistic Regression

fit <- glm(SEX ~ WAGP,
           family = binomial,
           data = person)

# the positive coefficient on WAGP implies that a higher wage tilts the prediction towards men
levels(person$SEX) # check which level is considered a succcess; the first level is alsways considered a "failure" in R; 1 is considered success and is associated with men in the dataset.

anova(fit, update(fit, SEX~1), test = 'Chisq') # fits null model; no predictors
# chisq test on how much the residual deviance has changed
# results indicate the adding WAGP to model results in residual deviance that is significantly different from null model

# Random Intercept

library(lme4)
fit <- lmer(log(WAGP) ~ (1|OCCP) + SCHL,
  data = person)

# Random Slope

fit <- lmer(
  log(WAGP) ~ (WKHP | SCHL),
  data = person) # get "fail to converge" warning message

fit <- lmer(
  log(WAGP) ~ (WKHP | SCHL),
  data = person,
  control = lmerControl(optimizer = "bobyqa")) # specify a different optimizer; the default optimizer is the fastest,# but not necessary the best

ggplot(person,
       aes(x = WKHP, y = log(WAGP), color = SCHL)) +
  geom_point() +
  geom_line(aes(y = predict(fit))) +
  labs(title = 'Random intercept and slope with lmer')
# allowed model to fit different slopes and intercept for model