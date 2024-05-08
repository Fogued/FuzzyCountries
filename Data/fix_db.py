import pandas as pd 

# Load the CSV
df = pd.read_csv('Data/bd_definitiva.csv')

# Convert columns that are strings into numbers
df['Land Area(Km2)'] = df['Land Area(Km2)'].str.replace(',', '').str.replace('$', '').str.replace(' ', '').str.replace('N/A', '0').astype(float)
df['Armed Forces size'] = df['Armed Forces size'].str.replace(',', '').str.replace('$', '').str.replace(' ', '').str.replace('N/A', '0').astype(float)
df['Co2-Emissions'] = df['Co2-Emissions'].str.replace(',', '').str.replace('$', '').str.replace(' ', '').str.replace('N/A', '0').astype(float)
df['GDP'] = df['GDP'].str.replace(',', '').str.replace('$', '').str.replace(' ', '').str.replace('N/A', '0').astype(float)
df['Population'] = df['Population'].str.replace(',', '').str.replace('$', '').str.replace(' ', '').str.replace('N/A', '0').astype(float)
df['Urban_population'] = df['Urban_population'].str.replace(',', '').str.replace('$', '').str.replace(' ', '').str.replace('N/A', '0').astype(float)
df['Density (P/Km2)'] = df['Density (P/Km2)'].str.replace(',', '').str.replace('$', '').str.replace(' ', '').str.replace('N/A', '0').astype(float)

# Save the new CSV
df.to_csv('Data/bd_definitiva2.csv', index=False)