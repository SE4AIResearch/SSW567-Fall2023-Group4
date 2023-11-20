import pandas as pd
from scipy.stats import spearmanr

# Load data from the first CSV file
file1 = pd.read_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/Refactoring_data_SQL_result.csv')

# Load data from the second CSV file
file2 = pd.read_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/stratified_nonrefactor_sampled_data.csv')

# Specify the columns for which you want to calculate the correlation
columns_file1 = ['#reviewers','#messages','#inline_comments','#revisions','#files','duration','len_messages','len_description','churn'] 
columns_file2 = ['#reviewers','#messages','#inline_comments','#revisions','#files','duration','len_messages','len_description','churn'] 

# Create an empty DataFrame to store the results
results_df = pd.DataFrame(columns=['Column_File1', 'Column_File2', 'Spearman_Correlation', 'P_value', 'Significance'])

# Perform Spearman rank correlation test for each pair of columns
for col_file1, col_file2 in zip(columns_file1, columns_file2):
    # Ensure both arrays have the same length by using the minimum length
    min_length = min(len(file1[col_file1]), len(file2[col_file2]))
    
    correlation, p_value = spearmanr(file1[col_file1][:min_length], file2[col_file2][:min_length])

    # Interpret the results
    significance = "Significant" if p_value < 0.05 else "Not Significant"

    # Create a DataFrame for the current pair of columns
    result_df = pd.DataFrame({
        'Column_File1': [col_file1],
        'Column_File2': [col_file2],
        'Spearman_Correlation': [correlation],
        'P_value': [p_value],
        'Significance': [significance]
    })

    # Concatenate the DataFrame for the current pair to the overall results DataFrame
    results_df = pd.concat([results_df, result_df], ignore_index=True)

# Save the results to a CSV file
results_df.to_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/spearman_correlation_results.csv', index=False)