import pandas as pd
from scripts.consultas_a_csv import leer_archivo_como_diccionario
from scripts.algoritmos import normalizar_valores, calcular_credibilidad

def get_diccionario_normalizado(parametro):
    return pd.read_csv('data/bdd_int.csv').set_index('Country name')[parametro].to_dict()

def normalizar_parametros():
    df = pd.read_csv('data/bdd_int.csv').set_index('Country_name')
    df_normalizado = df.drop(columns=['Country_number', 'Latitude', 'Longitude'])
    for col in df_normalizado.columns:
        df_normalizado[col] = normalizar_valores(df_normalizado[col].tolist())
    df_normalizado.index = [ pais.strip().replace("'","") for pais in df_normalizado.index ]
    df_normalizado.to_csv('data/bdd_normalizada.csv')

def hallar_credibilidades():
    credibilidades = {}
    df_verdad = pd.read_csv('data/valores_verdad.csv')
    df_normalizado = pd.read_csv('data/bdd_normalizada.csv')
    mapa_col_fun = leer_archivo_como_diccionario('data/mapa_columnas_funciones.txt')

    for parametro in mapa_col_fun:
        credibilidades[mapa_col_fun[parametro]] = str(calcular_credibilidad(df_verdad[mapa_col_fun[parametro]], df_normalizado[parametro]))

    with open('data/credibilidades.txt', 'w') as archivo:
        for funcion in credibilidades:
            archivo.write(f"{funcion}: {credibilidades[funcion]}\n")
