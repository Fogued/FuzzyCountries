import pandas as pd # type: ignore

# FUENTE 5
# Leemos el excel (hay datos a partir de la columna 5)
df_libertad_economica = pd.read_excel('Data/libertad_economica.xlsx', skiprows=4) # Fuente 5
# Eliminar columnas vacías
df_libertad_economica.dropna(axis=1, how='all', inplace=True)
# Filtramos columnas necesarias
df_libertad_economica = df_libertad_economica[['Year', 'Countries', 'Economic Freedom Summary Index']]
# Nos quedamos solo con el año 2021
df_libertad_economica = df_libertad_economica[df_libertad_economica['Year'] == 2021]
# Eliminamos la columna del año
df_libertad_economica = df_libertad_economica[['Countries', 'Economic Freedom Summary Index']]
# Cambiamos los nombres de las columnas a como estaran en el csv final
df_libertad_economica.rename(columns={'Countries': 'Country', 'Economic Freedom Summary Index': 'Libertad Economica'}, inplace=True)
# Pasamos a csv df_libertad_economica
df_libertad_economica.to_csv('data-pancho/libertad_economica.csv')


# FUENTE 6 (Temperatura promedio de la superficie por años)
# Leemos el csv
df_temperatura_media = pd.read_csv('Data/temperaturas anuales.csv') # Fuente 6
# Filtramos las columnas
df_temperatura_media = df_temperatura_media[['Country', 'Year', 'Annual Mean']]
# Nos quedamos con los datos del año 2021
df_temperatura_media = df_temperatura_media[df_temperatura_media['Year'] == 2021]
# Eliminamos la columna del año
df_temperatura_media = df_temperatura_media[['Country', 'Annual Mean']]
# Renombramos la columna
df_temperatura_media.rename(columns={'Annual Mean': "Temperatura media superficie (2021)"}, inplace=True)
# Pasamos a csv df_temperatura_media
df_temperatura_media.to_csv('data-pancho/temperatura_media.csv')

# FUENTE 7 (Tasa de mortalidad por suicidio (por 100 000 habitantes))
# Leemos el csv
df_suicidios = pd.read_csv('Data/suicidios.csv') # Fuente 7
# Filtramos las columnas
df_suicidios = df_suicidios[['GEO_NAME_SHORT', 'DIM_TIME', 'DIM_SEX', 'VALUE_NUMERIC']]
# Nos quedamos con los datos del 2006
df_suicidios = df_suicidios[df_suicidios['DIM_TIME'] == 2006]
df_suicidios = df_suicidios[['GEO_NAME_SHORT', 'DIM_SEX', 'VALUE_NUMERIC']]
# Hacemos la media entre los datos de diferentes sexos
df_suicidios = df_suicidios.groupby('GEO_NAME_SHORT')['VALUE_NUMERIC'].mean().reset_index()
# Renombramos
df_suicidios.rename(columns={'GEO_NAME_SHORT': 'Country', 'VALUE_NUMERIC': 'Tasa de suicidios (/100.000hab)'}, inplace=True)
# Pasamos a csv df_suicidios
df_suicidios.to_csv('data-pancho/suicidios.csv')


# FUENTE 8 (Corrupción, aunque se podrían sacar bastantes mas datos de aqui)
# Leemos el csv
df_corrupcion = pd.read_csv('Data/World Happiness Report 2021.csv') # Fuente 8
# Filtramos las columnas
df_corrupcion = df_corrupcion[['Country name', 'Perceptions of corruption']]
# Renombramos
df_corrupcion.rename(columns={'Country name': 'Country', 'Perceptions of corruption': 'Poblacion percibe corrupcion'}, inplace=True)
# Pasamos a csv df_corrupcion
df_corrupcion.to_csv('data-pancho/corrupcion.csv')


# JUNTAMOS TODOS LOS CSV POR PAIS
df_final = pd.merge(df_libertad_economica, df_temperatura_media, on='Country', how='inner')
df_final = pd.merge(df_final, df_suicidios, on='Country', how='inner')
df_final = pd.merge(df_final, df_corrupcion, on='Country', how='inner')
# Y con el csv de mister
df_mister = pd.read_csv('data-pancho/cleaned-all.csv')
df_final = pd.merge(df_final, df_mister, on='Country', how='inner')


# PASAMOS EL df_final A CSV
df_final.to_csv('Data/bd_definitiva.csv')
