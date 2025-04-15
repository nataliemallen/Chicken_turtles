# %%
import numpy as np
import pandas as pd

# %%
# Load the log likelihood values
data = pd.read_csv('log_likelihoods.txt', sep=' ', header=None, names=['Run', 'LogLikelihood'])

# %%
# Function to extract K value and run number
def extract_k_run(run_identifier):
    parts = run_identifier.split('_')
    k_value = int(parts[1][1:])  # Extract number after 'K'
    run_number = int(parts[2][3:])  # Extract number after 'run'
    return k_value, run_number

# %%
# Apply the function to extract K and run number
extracted_values = data['Run'].apply(lambda x: pd.Series(extract_k_run(x)))
data[['K', 'RunNumber']] = extracted_values

# %%
# Calculate mean and standard deviation for each K
stats = data.groupby('K')['LogLikelihood'].agg(['mean', 'std']).reset_index()

# %%
# Calculate the difference in mean log likelihoods for successive K values
stats['DeltaL'] = stats['mean'].diff().abs()

# %%
# Shift the DeltaL column to align with the current K and calculate DeltaK
stats['DeltaK'] = stats['DeltaL'].shift(-1) / stats['std']

# %%
# Display results
print(stats)

# Save the results to a file
stats.to_csv('deltaK_results.csv', index=False)

# %%
#K=7 is highest deltaK 6.362389e+00; best supported
# sites

# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Load the log likelihood values
data = pd.read_csv('log_likelihoods.txt', sep=' ', header=None, names=['Run', 'LogLikelihood'])

# Function to extract K value and run number
def extract_k_run(run_identifier):
    parts = run_identifier.split('_')
    k_value = int(parts[1][1:])  # Extract number after 'K'
    run_number = int(parts[2][3:])  # Extract number after 'run'
    return k_value, run_number

# Apply the function to extract K and run number
extracted_values = data['Run'].apply(lambda x: pd.Series(extract_k_run(x)))
data[['K', 'RunNumber']] = extracted_values

# Check if K and RunNumber columns are correctly added
print(data.head())

# Calculate mean and standard deviation for each K
stats = data.groupby('K')['LogLikelihood'].agg(['mean', 'std']).reset_index()

# Calculate the difference in mean log likelihoods for successive K values
stats['DeltaL'] = stats['mean'].diff().abs()

# Shift the DeltaL column to align with the current K and calculate DeltaK
stats['DeltaK'] = stats['DeltaL'].shift(-1) / stats['std']

# Display results
print(stats)

# Save the results to a file
stats.to_csv('deltaK_results.csv', index=False)

# Plot K vs DeltaK
plt.figure(figsize=(8, 5))
plt.plot(stats['K'], stats['DeltaK'], marker='o', linestyle='-', color='b')
plt.xlabel('K')
plt.ylabel('Delta K')
plt.title('Delta K vs K')
plt.grid(True)
plt.show()


# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Load the log likelihood values
data = pd.read_csv('log_likelihoods.txt', sep=' ', header=None, names=['Run', 'LogLikelihood'])

# Function to extract K value and run number
def extract_k_run(run_identifier):
    parts = run_identifier.split('_')
    k_value = int(parts[1][1:])  # Extract number after 'K'
    run_number = int(parts[2][3:])  # Extract number after 'run'
    return k_value, run_number

# Apply the function to extract K and run number
extracted_values = data['Run'].apply(lambda x: pd.Series(extract_k_run(x)))
data[['K', 'RunNumber']] = extracted_values

# Filter for K values from 2 to 9
data = data[data['K'].between(4, 9)]

# Calculate mean and standard deviation for each K
stats = data.groupby('K')['LogLikelihood'].agg(['mean', 'std']).reset_index()

# Calculate the difference in mean log likelihoods for successive K values
stats['DeltaL'] = stats['mean'].diff().abs()

# Shift the DeltaL column to align with the current K and calculate DeltaK
stats['DeltaK'] = stats['DeltaL'].shift(-1) / stats['std']

# Save the results to a file
stats.to_csv('deltaK_results.csv', index=False)

# Plot K vs DeltaK
plt.figure(figsize=(8, 5))
plt.plot(stats['K'], stats['DeltaK'], marker='o', linestyle='-', color='b')
plt.xlabel('K')
plt.ylabel('Delta K')
plt.title('Delta K vs K (K=2 to 9)')
plt.grid(True)
plt.show()


# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Load the log likelihood values
data = pd.read_csv('log_likelihoods.txt', sep=' ', header=None, names=['Run', 'LogLikelihood'])

# Function to extract K value and run number
def extract_k_run(run_identifier):
    parts = run_identifier.split('_')
    k_value = int(parts[1][1:])  # Extract number after 'K'
    run_number = int(parts[2][3:])  # Extract number after 'run'
    return k_value, run_number

# Apply the function to extract K and run number
extracted_values = data['Run'].apply(lambda x: pd.Series(extract_k_run(x)))
data[['K', 'RunNumber']] = extracted_values

# Compute mean and standard deviation for each K
stats = data.groupby('K')['LogLikelihood'].agg(['mean', 'std']).reset_index()

# Print log-likelihood statistics
print(stats)

# Save the log-likelihood statistics
stats.to_csv('log_likelihood_stats.csv', index=False)

# Plot log-likelihood distributions for each K
plt.figure(figsize=(8, 5))
for k in sorted(data['K'].unique()):
    subset = data[data['K'] == k]
    plt.scatter([k] * len(subset), subset['LogLikelihood'], label=f'K={k}', alpha=0.5)

plt.xlabel('K')
plt.ylabel('Log Likelihood')
plt.title('Log Likelihoods Across Runs for Each K')
plt.grid(True)
plt.show()

# Plot mean log likelihood with variance (error bars)
plt.figure(figsize=(8, 5))
plt.errorbar(stats['K'], stats['mean'], yerr=stats['std'], fmt='o-', capsize=5, color='b')
plt.xlabel('K')
plt.ylabel('Mean Log Likelihood')
plt.title('Mean Log Likelihood with Variance')
plt.grid(True)
plt.show()


# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Load the results
data = pd.read_csv('deltaK_results.csv')

# Plot K vs DeltaK
plt.figure(figsize=(10, 5))

# Plot DeltaK
plt.subplot(1, 2, 1)
plt.plot(data['K'], data['DeltaK'], marker='o', linestyle='-', color='b', label='ΔK')
plt.xlabel('K')
plt.ylabel('ΔK')
plt.title('Evanno Method: ΔK vs K')
plt.grid(True)
plt.xticks(data['K'])

# Plot DeltaL
plt.subplot(1, 2, 2)
plt.plot(data['K'], data['DeltaL'], marker='s', linestyle='-', color='r', label='ΔL')
plt.xlabel('K')
plt.ylabel('ΔL')
plt.title('Log-Likelihood Change: ΔL vs K')
plt.grid(True)
plt.xticks(data['K'])

# Show the plots
plt.tight_layout()
plt.show()


# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Load the results
data = pd.read_csv('deltaK_results.csv')

# Compute second derivative (Δ²L)
data['Delta2L'] = data['DeltaL'].diff()

# Create a figure with 3 subplots
plt.figure(figsize=(12, 8))

# 1. Plot log-likelihoods
plt.subplot(3, 1, 1)
plt.plot(data['K'], data['mean'], marker='o', linestyle='-', color='black', label='Ln Pr(X|K)')
plt.xlabel('K')
plt.ylabel('Log-Likelihood')
plt.title('Log-Likelihood (Ln Pr(X|K)) vs. K')
plt.grid(True)
plt.xticks(data['K'])

# 2. Plot DeltaL (First Derivative)
plt.subplot(3, 1, 2)
plt.plot(data['K'], data['DeltaL'], marker='s', linestyle='-', color='red', label='ΔL')
plt.xlabel('K')
plt.ylabel('ΔL')
plt.title('First Derivative: Change in Log-Likelihood (ΔL) vs. K')
plt.grid(True)
plt.xticks(data['K'])

# 3. Plot Delta2L (Second Derivative)
plt.subplot(3, 1, 3)
plt.plot(data['K'], data['Delta2L'], marker='^', linestyle='-', color='blue', label='Δ²L')
plt.xlabel('K')
plt.ylabel('Δ²L')
plt.title('Second Derivative: Change in ΔL (Δ²L) vs. K')
plt.grid(True)
plt.xticks(data['K'])

# Adjust layout and show the plot
plt.tight_layout()
plt.show()


# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Load the results
data = pd.read_csv('deltaK_results.csv')

# Calculate Parsimony Index (PI)
data['PI'] = data['DeltaL'].abs() / data['std'].shift(-1)

# Save results
data.to_csv('parsimony_index_results.csv', index=False)

# Plot PI(K)
plt.figure(figsize=(8, 5))
plt.plot(data['K'], data['PI'], marker='o', linestyle='-', color='green', label='PI(K)')
plt.xlabel('K')
plt.ylabel('Parsimony Index')
plt.title('Parsimony Index vs. K')
plt.grid(True)
plt.legend()
plt.show()
