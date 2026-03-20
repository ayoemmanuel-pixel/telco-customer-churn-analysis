📌 Overview

Customer churn is a major challenge for subscription-based businesses, as losing customers leads to reduced revenue and increased acquisition costs.
In this project, I performed an exploratory data analysis (EDA) on a telecom dataset to identify the key factors influencing customer churn, uncover high-risk customer segments, and provide actionable business recommendations.

🎯 Business Problem
A telecommunications company is experiencing a high rate of customer churn.
The objective of this analysis is to:
Understand why customers leave
Identify customers most likely to churn
Provide data-driven recommendations to improve retention

❓ Business Questions
What percentage of customers churn?
Do new customers churn more than long-term customers?
Does internet service type affect churn?
Do fiber optic customers churn more?
Which contract type has the highest churn rate?
Are high-paying customers more likely to churn?

🛠️ Tools & Technologies
R
tidyverse
janitor
ggplot2

🧹 Data Cleaning
The dataset was cleaned and prepared before analysis:
Column names were standardized using clean_names()
Missing values in total_charges (11 rows) were identified
These rows were removed as they represented new customers with no billing history
Duplicate rows were checked (none found)

📊 Exploratory Data Analysis

🔹 Overall Churn Distribution
Approximately 26.5% of customers churned
About 1 in 4 customers leave the service

🔹 Churn by Contract Type
Month-to-month customers: ~42.7% churn rate
One-year contracts: ~11.3%
Two-year contracts: ~2.8%
👉 Customers with shorter commitments are significantly more likely to churn.

🔹 Churn by Tenure
Customers in their first year (~48%) have the highest churn
Churn decreases as tenure increases
👉 Customer retention improves over time.

🔹 Churn by Internet Service Type
Fiber optic: ~42% churn rate 🚨
DSL: ~19%
No internet: ~7%
👉 Fiber optic customers are the most likely to churn.

🔥 High-Risk Customer Segment
A high-risk group was identified by combining key churn factors:
Month-to-month contract
Fiber optic internet
Tenure: 0–1 year
👉 ~70% of customers in this segment churned
This group represents the most vulnerable customers and should be prioritized for retention efforts.

📌 Key Insights
Overall churn rate is 26.5%
Month-to-month contracts have the highest churn
New customers churn significantly more than long-term customers
Fiber optic users have the highest churn among service types
High-risk customers are new, fiber-optic, month-to-month users

💡 Business Recommendations
Improve onboarding and early engagement for new customers
Encourage customers to switch to longer-term contracts through incentives
Investigate pricing, service quality, and expectations for fiber optic users
Develop targeted retention strategies for high-risk customer segments

📁 Project Structure
telco-customer-churn-analysis/
│
├── data/
│   ├── telco_churn.csv
│   └── telco_churn_clean.csv
│
├── scripts/
│   └── telco_customer_churn_analysis.R
│
├── outputs/
│   ├── churn_distribution.png
│   ├── churn_by_contract.png
│   ├── churn_by_tenure.png
│   └── churn_by_internet_service.png
│
└── README.md

👤 Author
Ayodeji Emmanuel Monehin
