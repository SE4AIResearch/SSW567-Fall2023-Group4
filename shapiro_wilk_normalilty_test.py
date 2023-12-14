import pandas as pd
from scipy.stats import shapiro

# Define the columns you want to analyze
columns_of_interest = ['#reviewers','#messages','#inline_comments','#revisions','#files','duration','len_messages','len_description','churn']

# Read data from CSV files
file1 = pd.read_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/Refactoring_data_SQL_result.csv')
file2 = pd.read_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/stratified_nonrefactor_sampled_data.csv')

# Create an empty list to store results
results_list = []

# Iterate over specified columns and perform Shapiro-Wilk test
for column in columns_of_interest:
    try:
        # Shapiro-Wilk test for data in file1
        stat_file1, p_value_file1 = shapiro(file1[column].dropna())

        # Shapiro-Wilk test for data in file2
        stat_file2, p_value_file2 = shapiro(file2[column].dropna())

        # Interpret the results for each column in each file
        normality_file1 = "Not Normally Distributed" if p_value_file1 < 0.05 else "Normally Distributed"
        normality_file2 = "Not Normally Distributed" if p_value_file2 < 0.05 else "Normally Distributed"

        # Append results to the list
        results_list.append({
            'Column': column,
            'Refactored_Test_Statistic': stat_file1,
            'Refactored_P_Value': p_value_file1,
            'Refactored_Normality': normality_file1,
            'NonRefactored_Test_Statistic': stat_file2,
            'NonRefactored_P_Value': p_value_file2,
            'NonRefactored_Normality': normality_file2
        })

    except Exception as e:
        print(f"Error processing column {column}: {e}")


# Create a DataFrame from the list
results_df = pd.DataFrame(results_list)

# Save the results to a CSV file
results_df.to_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/shapiro_wilk_results.csv', index=False)
