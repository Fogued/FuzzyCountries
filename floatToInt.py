import pandas as pd

# Read the CSV file into a DataFrame
df = pd.read_csv('bdd_float.csv')

# Define the powers for each column, excluding the first.
powers = [2, 2, 5, 3, 0, 1, 0, 0, 2, 0, 2, 2, 2, 0, 1, 1, 1, 1, 0, 1, 1, 2, 0, 5, 5, 5, 0, 0]

# Multiply each column (excluding the firstone) by its corresponding power of 10 and round to int
for col, power in zip(list(df.columns[2:]), powers):
    df[col] = pd.to_numeric(df[col], errors='coerce').fillna(0) * 10**power
    df[col] = df[col].round().astype(int)

# Save the DataFrame to a new CSV file, dont change the bdd output, not working well floatToInt.py
# I had to change by hand the first row and last column in the output file (bdd_cint.csv) to have the correct format.
df.to_csv('bdd_ciao_int.csv', index=False)