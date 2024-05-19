from sklearn.metrics import mean_absolute_error

def calcular_credibilidad(valores_reales, valores_difusos):
    """
    Los valores reales son el mapeo de los datos reales que hallemos en las BD asociadas a la funcion difusa cuya credibilidad queramos hallar
    Los valores difusos son los resultados obtenidos por la funcion difusa
    Ambos son valores entre 0 y 1
    Usamos el error absoluto medio como criterio para definir la desviacion y la funcion devuelve la credibilidad de la funcion que queremos analizar
    """
    # Verificar que las listas tienen el mismo tamaño
    if len(valores_reales) != len(valores_difusos):
        raise ValueError("Los conjuntos de datos deben tener el mismo número de elementos.")
    
    # Calcular el Error Absoluto Medio (MAE)
    mae = mean_absolute_error(valores_reales, valores_difusos)
    
    # Calcular la credibilidad como 1 - MAE, asumiendo que los valores están normalizados [0, 1]
    credibilidad = max(0, (1 - mae))
    
    return credibilidad


def normalizar_valores(valores):
    """Toma una lista y normaliza los valores con el metodo min-max mapeandolos en el intervalo [0,1]"""

    # Obtener el mínimo y máximo valor de la lista
    min_val = min(valores)
    max_val = max(valores)

    # Normalizar los valores utilizando la fórmula min-max
    valores_normalizados = [(x - min_val) / (max_val - min_val) for x in valores]
    
    return valores_normalizados


# Ejemplo de uso calcular_credibilidad
valores_reales = [0.1, 0.2, 0.3, 0.4, 0.5]
valores_difusos = [0.1, 0.25, 0.28, 0.35, 0.52]

credibilidad = calcular_credibilidad(valores_reales, valores_difusos)
print(f"La credibilidad de la función difusa es: {credibilidad:.2f}")


# Ejemplo de uso normalizar_valores
valores = [10, 20, 30, 40, 50]
valores_normalizados = normalizar_valores(valores)
print("Valores normalizados:", valores_normalizados)