import pandas as pd
from scipy.stats import spearmanr
import seaborn as sns
import matplotlib.pyplot as plt

# Load data from the first CSV file
file1 = pd.read_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/Refactoring_data_SQL_result.csv')

# Load data from the second CSV file
file2 = pd.read_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/stratified_nonrefactor_sampled_data.csv')

# Specify the columns for correlation analysis
columns_for_analysis = ['#reviewers','#messages','#inline_comments','#revisions','#files','duration','len_messages','len_description','churn']

# Create lists to store correlation results
results = []

# Variables to store information about the most highly correlated pair
max_correlation = 0
max_correlation_pair = None

for i in range(len(columns_for_analysis) - 1):
    for j in range(i + 1, len(columns_for_analysis)):
        variable1 = columns_for_analysis[i]
        variable2 = columns_for_analysis[j]

        # Ensure both arrays have the same length by using the minimum length
        min_length = min(len(file1[variable1]), len(file2[variable2]))

        # Perform Spearman correlation test
        correlation, p_value = spearmanr(file1[variable1][:min_length], file2[variable2][:min_length])

         # Append results to the list
        results.append({
            'Variable1': variable1,
            'Variable2': variable2,
            'Spearman_Correlation': correlation,
            'P_value': p_value
        })

        # Create a DataFrame from the list of results
correlation_results = pd.DataFrame(results)

# Filter only statistically significant and highly correlated pairs
threshold = 0.1  # Set your correlation threshold here
significant_pairs = correlation_results[(correlation_results['P_value'] < 0.05) & (abs(correlation_results['Spearman_Correlation']) > threshold)]

# Plot scatter plots for the significant pairs
for idx, row in significant_pairs.iterrows():
    variable1 = row['Variable1']
    variable2 = row['Variable2']

    # Plot scatter plot with data points for the significant pair
    plt.figure(figsize=(8, 6))
    sns.scatterplot(x=file1[variable1], y=file2[variable2])
    plt.title(f'Scatter Plot: {variable1} vs {variable2}\nSpearman Correlation: {row["Spearman_Correlation"]:.4f}, P-value: {row["P_value"]:.4f}')
    plt.xlabel(variable1)
    plt.ylabel(variable2)
    plt.show()
