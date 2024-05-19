from sklearn.metrics import mean_absolute_error

def calcular_credibilidad(valores_reales, valores_difusos):
    """
    Los valores reales son el mapeo de los datos reales que hallemos en las BD asociadas a la funcion difusa cuya credibilidad queramos hallar
    Los valores difusos son los resultados obtenidos por la funcion difusa
    Ambos son valores entre 0 y 1
    Usamos el error absoluto medio como criterio para definir la desviacion y la funcion devuelve la credibilidad de la funcion que queremos analizar
    """
    
    # Calcular el Error Absoluto Medio (MAE)
    mae = mean_absolute_error(valores_reales, valores_difusos)
    
    # Calcular la credibilidad como 1 - MAE, asumiendo que los valores están normalizados [0, 1]
    credibilidad = max(0, (1 - mae))
    
    return credibilidad


def normalizar_valores(valores):
    """Toma una lista y normaliza los valores con el metodo min-max mapeandolos en el intervalo [0,1]"""
    if isinstance(valores[0],str): # Columna final tiene ). y se interpreta como str en dbb_int.csv
        valores = [int(x.replace(').', '')) for x in valores]
    # Obtener el mínimo y máximo valor de la lista
    min_val = min(valores)
    max_val = max(valores)

    # Normalizar los valores utilizando la fórmula min-max
    valores_normalizados = [(x - min_val) / (max_val - min_val) for x in valores]
    
    return valores_normalizados