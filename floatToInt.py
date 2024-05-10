import pandas as pd

# Read the CSV file into a DataFrame
df = pd.read_csv('bdd_ciao.csv')

# Define the powers for each column, excluding the first, second and sixteenth one
powers = [2, 2, 5, 3, 0, 1, 0, 0, 2, 0, 2, 2, 2, 0, 1, 1, 1, 1, 0, 1, 1, 2, 0, 5, 5, 5, 0, 0]

# Multiply each column (excluding the first, second and sixteenth one) by its corresponding power of 10 and round to int
for col, power in zip(list(df.columns[2:]), powers):
    df[col] = pd.to_numeric(df[col], errors='coerce').fillna(0) * 10**power
    df[col] = df[col].round().astype(int)

# Save the DataFrame to a new CSV file
df.to_csv('bdd_ciao_int.csv', index=False)