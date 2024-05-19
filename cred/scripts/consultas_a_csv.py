import os
import pandas as pd

def get_archivos_resultados():
    archivos_resultados = []
    # Recorrer todos los archivos en el directorio
    for raiz, _, archivos in os.walk('data/'):
        for archivo in archivos:
            # Comprobar si el archivo termina con '_resultados.txt'
            if archivo.endswith('_resultados.txt'):
                # Añadir la ruta completa del archivo a la lista
                archivos_resultados.append(os.path.join(raiz, archivo))
    return archivos_resultados


def leer_archivo_como_diccionario(archivo):
    diccionario = {}
    with open(archivo, 'r') as f:
        for linea in f:
            clave, valor = linea.strip().split(': ', 1)
            diccionario[clave] = valor
    return diccionario


def combinar_diccionarios_en_dataframe(diccionarios, nombres_archivos):
    df = pd.DataFrame(diccionarios).T  # Transponer para tener claves como filas
    df.columns = nombres_archivos  # Nombrar columnas según los nombres de archivos
    df = df.reindex(sorted(df.index))
    return df


def consultas_a_csv():
    archivos_resultados = get_archivos_resultados()
    diccionarios = []
    for archivo in archivos_resultados:
        diccionarios.append(leer_archivo_como_diccionario(archivo))
    nombres_columnas = [nombre.removeprefix('data/').removesuffix('_resultados.txt') for nombre in archivos_resultados]
    df = combinar_diccionarios_en_dataframe(diccionarios, nombres_columnas)
    df.to_csv('data/valores_verdad.csv')