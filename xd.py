import pandas as pd

# Print column Population without the index
df = pd.read_csv('data-pancho/cleaned-all.csv')
column = df['Minimum wage']
# Quitar el .0 decimal
column = column.astype(int)
print(column.to_string(index=False))
