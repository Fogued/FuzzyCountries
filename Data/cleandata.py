import pandas as pd

# Load CSV
df = pd.read_csv('Data/world-data-2023(1).csv')

# Drop columns
df.drop('Abbreviation', axis=1, inplace=True)
df.drop('Calling Code', axis=1, inplace=True)
df.drop('Capital/Major City', axis=1, inplace=True)
df.drop('CPI Change (%)', axis=1, inplace=True)
df.drop('Currency-Code', axis=1, inplace=True)
df.drop('Gasoline Price', axis=1, inplace=True)
df.drop('Largest city', axis=1, inplace=True)
df.drop('Maternal mortality ratio', axis=1, inplace=True)
df.drop('Minimum wage', axis=1, inplace=True)
df.drop('Official language', axis=1, inplace=True)
df.drop('Out of pocket health expenditure', axis=1, inplace=True)
df.drop('Physicians per thousand', axis=1, inplace=True)
df.drop('Total tax rate', axis=1, inplace=True)


# New df into a new CSV file
# df.to_csv('CleanData(1234)/cleaned-(1).csv', index=False)

df2 = pd.read_csv('Data/renewable-share-energy(2).csv')
# Drop column Code and Year
df2.drop('Code', axis=1, inplace=True)
# Rename column Entity to Country
df2.rename(columns={'Entity': 'Country'}, inplace=True)
# We want to keep only the rows with the column year=2021
df2 = df2[df2['Year'] == 2021]
df2.drop('Year', axis=1, inplace=True)
# We want to keep only the countries that are in the first dataset
df2 = df2[df2['Country'].isin(df['Country'])]

# df2.to_csv('CleanData(1234)/cleaned-(2).csv', index=False)

df3 = pd.read_csv('Data/minimum_wage(3).csv')
# Only keep first two columns
df3 = df3[['Country', 'Annual-Nominal (US$)']]
# Rename column Annual-Nominal (US$) to Minimum wage
df3.rename(columns={'Annual-Nominal (US$)': 'Minimum wage'}, inplace=True)
# Change NaN values to 0
df3.fillna(0, inplace=True)

# df3.to_csv('CleanData(1234)/cleaned-(3).csv', index=False)

df4 = pd.read_csv('Data/covid19countryinfo(4).csv')
# Only keep medianage
df4 = df4[['country', 'medianage']]
# Rename column country to Country
df4.rename(columns={'country': 'Country'}, inplace=True)
# drop rows with NaN values
df4.dropna(inplace=True)
# Remove duplicated rows
df4.drop_duplicates(subset='Country', inplace=True)

# df4.to_csv('CleanData(1234)/cleaned-(4).csv', index=False)


# Merge all dataframes into one by Country
df = pd.merge(df, df2, on='Country', how='inner')
df = pd.merge(df, df3, on='Country', how='inner')
df = pd.merge(df, df4, on='Country', how='inner')

df.to_csv('CleanData(1234)/cleaned-all.csv', index=False)

