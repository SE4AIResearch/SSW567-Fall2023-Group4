import pandas as pd

# Load the data from CSV file
df = pd.read_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/non-refactoring_data_SQL_result.csv')

# Calculate the desired number of records per label
total_sample_size = 1174
num_records_per_label = total_sample_size // df['#messages'].nunique()

# Perform stratified random sampling
stratified = df.groupby('#messages', group_keys=False).apply(lambda x: x.sample(n=num_records_per_label, replace=True, random_state=42))

additional_samples = total_sample_size - len(stratified)
additional_data = df.sample(n=additional_samples, replace=True, random_state=42)
stratified = pd.concat([stratified, additional_data])

# Save the sampled non-refactored records to a new CSV file
stratified.to_csv('C:/Users/Dell/Desktop/SoftwareTesting_QualityAssurance_&_Maintainence/Project/stratified_nonrefactor_sampled_data.csv', index=False)
