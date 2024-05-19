import subprocess
import glob
from scripts.consultas_a_csv import consultas_a_csv
from scripts.credibilidad import normalizar_parametros, hallar_credibilidades

def ejecutar_consultas():
    with open('data/funciones.txt') as funciones:
        print('...')
        for funcion in funciones:
            funcion_sin_salto = funcion.replace('\n','')
            print(f'Consultando {funcion_sin_salto}\n...')
            subprocess.run(["./src/consultar", funcion_sin_salto])
        print('#####################################################################')


def procesar_datos():
    consultas_a_csv()
    archivos = glob.glob('data/*_resultados.txt')
    subprocess.run(['rm'] + archivos) # Eliminamos los txt que ya no necesitamos
    normalizar_parametros()
    hallar_credibilidades()
    # Borramos mas cosas que no interesa guardar
    subprocess.run(['rm', 'data/valores_verdad.csv'])
    subprocess.run(['rm', 'data/bdd_normalizada.csv'])
    


def main():
    print('#####################################################################')
    print('Iniciando Script...')
    print('#####################################################################')
    print('Ejecutando consultas...')
    ejecutar_consultas()
    print('Procesando datos...')
    procesar_datos()
    print('#####################################################################')
    print('¡Script Finalizado!')
    print('#####################################################################')

if __name__ == "__main__":
    main()