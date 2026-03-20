# =========================================
# Telco Customer Churn Analysis
# =========================================

# 1. Business Problem
# 2. Business Questions
# 3. Load Packages
# 4. Load Data
# 5. Data Inspection
# 6. Data Cleaning
# 7. Exploratory Data Analysis
# 8. High-Risk Customer Segment
# 9. Key Insights
# 10. Business Recommendations

# =========================================
# Business problem
# =========================================
# Telco Customer Churn Analysis
# Business Problem:
# A telecom company is experiencing customer churn, leading to revenue loss.
# The goal is to understand the drivers of churn and identify high-risk customers.

# =========================================
# Business Questions
# =========================================
#•	What percentage of customers churn?
#•	Do new customers churn more than long-term customers?
#•	Does internet service type affect churn?
#•	Do customers with fiber internet churn more?
#•	Which contract type has the highest churn rate?
#•	Are high-paying customers more likely to churn?
  
# =========================================
# Load packages
# =========================================
library(tidyverse)
library(janitor)
library(ggplot2)

# =========================================
# Load dataset
# =========================================
df <- read_csv("data/telco_churn.csv")

# =========================================
# Data Inspection
# =========================================
glimpse(df)
dim(df)

# =========================================
# Data cleaning
# =========================================
# Clean column names and change them to snake case
df <- clean_names(df)
glimpse(df)

# Checking for missing values in the dataset
colSums(is.na(df))

# Observation:
# The 'total_charges' column contains 11 missing values

df %>%
  filter(is.na(total_charges))

# Investigation:
# These missing values are associated with customers who have tenure = 0,
# meaning they have just joined and have not yet been billed.
# Decision:
# Since the number of missing values is very small (~0.15% of dataset),
# and they represent edge cases, we will remove these rows to avoid bias.

# Action:
df <- df %>%
  drop_na(total_charges)

# Verification:
# Confirm that there are no missing values remaining
colSums(is.na(df))

# Checking for duplicate rows in the dataset
sum(duplicated(df))

# Observation:
# No duplicate rows found (result = 0), so no action required

# Check dataset dimensions after cleaning
dim(df)

# Save cleaned dataset
write_csv(df, "data/telco_churn_clean.csv")

# =========================================
# Exploratory Data Analysis
# =========================================

# inspect churn distribution and churn rate(%)
table(df$churn)
prop.table(table(df$churn)) 


# visualize customer churn distribution 
p1 <- ggplot(df, aes(x = churn)) +
  geom_bar(fill = "steelblue") +
  labs(
    title = "Customer Churn Distribution",
    x = "Churn",
    y = "Number of Customers"
  )
p1
ggsave("outputs/churn_distribution.png", plot = p1, width = 8, height = 5)
# Churn Distribution Insight:
# Approximately 26.5% of customers have churned, while 73.5% have remained.
# This indicates a significant churn rate, with roughly 1 in 4 customers leaving the service.
# This level of churn can negatively impact revenue and suggests the need for retention strategies.

# churn by contract types
table(df$contract, df$churn)
prop.table(table(df$contract, df$churn), margin = 1)
# Churn by Contract Type Insight:
# Customers on month-to-month contracts have the highest churn rate (~42.7%),
# significantly higher than one-year (~11.3%) and two-year (~2.8%) contracts.
# This indicates that customers with shorter commitment periods are much more likely to leave.

# visualize customer churn distribution by contract type
p2 <- ggplot(df, aes(x = contract, fill = churn)) +
  geom_bar(position = "fill") +
  labs(
    title = "Churn Rate by Contract Type",
    x = "Contract Type",
    y = "Proportion"
  ) +
  scale_y_continuous(labels = scales::percent)
p2
ggsave("outputs/churn_by_contract.png", plot = p2, width = 8, height = 5)
# Visualization Insight:
# The bar chart confirms that churn proportion is highest for month-to-month contracts,
# visually reinforcing the numerical findings.


# Business Interpretation:
# The high churn rate among month-to-month customers suggests that lack of commitment
# increases the likelihood of customer attrition.
# Encouraging customers to switch to longer-term contracts may improve retention.


# do new customers churn more than old?
# Creating tenure groups by categorizing the tenure variable into intervals
# This helps simplify analysis by grouping customers based on how long they have stayed
# instead of working with many individual numeric values
df$tenure_group <- cut(
  df$tenure,
  breaks = c(0, 12, 24, 48, 72),
  labels = c("0-1yr", "1-2yr", "2-4yr", "4-6yr")
)
glimpse(df$tenure_group)
#Churn rate for each tenure group
prop.table(table(df$tenure_group, df$churn), margin = 1)

# Calculate churn proportion within each tenure group
# Insight: Customers with lower tenure (0-1 year) have the highest churn rate,
# while customers with longer tenure show significantly lower churn.
# This suggests that customer retention improves as tenure increases.


# Visualize customer churn based on tenure group
p3 <- ggplot(df, aes(x = tenure_group, fill = churn)) +
  geom_bar(position = "fill") +
  labs(title = "Churn Rate by Tenure Group",
       y = "Proportion",
       x = "Tenure Group") +
  scale_y_continuous(labels = scales::percent)
p3
ggsave("outputs/churn_by_tenure.png", plot = p3, width = 8, height = 5)
# The highest churn rate occurs within the first year (≈48%),
# suggesting that early-stage customer experience is critical. 
# Targeted onboarding and engagement strategies could significantly reduce churn

# Does internet service affects churn?
# Churn by internet service type
table(df$internet_service, df$churn)

# Convert to proportions (row-wise)
prop.table(table(df$internet_service, df$churn), margin = 1)

# Visualize churn rate by internet service type
p4 <- ggplot(df, aes(x = internet_service, fill = churn)) +
  geom_bar(position = "fill") +
  labs(
    title = "Churn Rate by Internet Service Type",
    x = "Internet Service",
    y = "Proportion"
  ) +
  scale_y_continuous(labels = scales::percent)
p4
ggsave("outputs/churn_by_internet_service.png", plot = p4, width = 8, height = 5)
# Customers using fiber optic internet exhibit the highest churn rate (~42%), 
# more than double that of DSL users (~19%). 
# This suggests potential dissatisfaction,
# pricing concerns, or unmet expectations among fiber customers.

# Recommendaton.
# The company should investigate:
# - Service reliability issues
# - Pricing competitiveness
# - Customer satisfaction levels
# Introducing targeted retention strategies for fiber users could significantly reduce churn.

# =========================================
# High-risk customer segment analysis
# =========================================
# This segment combines three characteristics already associated with higher churn:
# 1. Month-to-month contract
# 2. Fiber optic internet service
# 3. Tenure of 0-1 year

high_risk_segment <- df %>%
  filter(
    contract == "Month-to-month",
    internet_service == "Fiber optic",
    tenure_group == "0-1yr"
  )

high_risk_summary <- high_risk_segment %>%
  count(churn) %>%
  mutate(prop = n / sum(n))

high_risk_summary

# Interpretation:
# About 70% of customers in this segment churned, confirming that
# new fiber-optic customers on month-to-month contracts are a particularly
# vulnerable group for customer attrition.



# =========================================
# Key Insights
# =========================================

# 1. Overall churn rate is approximately 26.5%.
# 2. Customers on month-to-month contracts have the highest churn rate.
# 3. Customers in their first year have the highest churn rate.
# 4. Fiber optic customers churn more than DSL and no-internet customers.
# 5. A high-risk customer segment is made up of new customers
#    on month-to-month contracts using fiber optic internet.

# =========================================
# Business Recommendations
# =========================================

# 1. Improve onboarding and early engagement for new customers.
# 2. Encourage movement from month-to-month contracts to longer-term plans.
# 3. Investigate pricing, service quality, and expectations for fiber optic users.
# 4. Build targeted retention strategies for high-risk customer segments.