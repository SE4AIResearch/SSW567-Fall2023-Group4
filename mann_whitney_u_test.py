import pandas as pd
import numpy as np
from scipy.stats import mannwhitneyu

# Load data from the first CSV file
file1 = pd.read_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/refactoring_data.csv')

# Load data from the second CSV file
file2 = pd.read_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/stratified_nonrefactor_sampled_data.csv')

# Specify the three columns from each file
columns_file1 = ['#reviewers','#messages','#inline_comments','#revisions','#files','duration','len_messages','len_description','churn']
columns_file2 = ['#reviewers','#messages','#inline_comments','#revisions','#files','duration','len_messages','len_description','churn']

# Create a list to store the results
results_list = []

# Perform Mann-Whitney U test for each specified pair of columns between the two files
for col1_file1, col1_file2 in zip(columns_file1, columns_file2):
    data_file1 = file1[col1_file1]
    data_file2 = file2[col1_file2]

    # Perform the Mann-Whitney U test
    statistic, p_value = mannwhitneyu(data_file1, data_file2, alternative='two-sided')

    # Handle NaN values and calculate Cliff's Delta using NumPy
    data_file1_np = np.asarray(data_file1.dropna().sort_values())
    data_file2_np = np.asarray(data_file2.dropna().sort_values())
    
    # Calculate Cliff's Delta manually
    delta = (2 * np.sum(np.less.outer(data_file1_np, data_file2_np)) - len(data_file1_np) * len(data_file2_np)) / (len(data_file1_np) * len(data_file2_np))

    # Append results to the list
    results_list.append({
        'File1_Column': col1_file1,
        'File2_Column': col1_file2,
        'MannWhitneyU': statistic,
        'P-value': p_value,
        'CliffsDelta': delta
    })

# Convert the list of results to a DataFrame
results_df = pd.DataFrame(results_list)

# Save the results to a CSV file
results_df.to_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/mann_whitneyu_Cliffsdelta_test_results.csv', index=False)
