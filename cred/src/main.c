#include "diccionario.h"
#include "consultas.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char** read_lines_from_file(const char *filename, int *line_count) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("fopen");
        return NULL;
    }

    char **lines = NULL;
    char buffer[64];
    *line_count = 0;

    while (fgets(buffer, sizeof(buffer), file) != NULL) {

        char *line = (char *)malloc(strlen(buffer) + 1);
        
        if (!line) {
            perror("Failed to allocate memory for line");
            fclose(file);
            return NULL;
        }
        strcpy(line, buffer);

        char **temp = (char **)realloc(lines, sizeof(char *) * (*line_count + 1));
        if (!temp) {
            perror("Failed to reallocate memory for lines array");
            free(line);
            fclose(file);
            return NULL;
        }
        lines = temp;

        // Add the new line to the array
        lines[*line_count] = line;
        (*line_count)++;
    }

    fclose(file);
    return lines;
}

void free_lines(char **lines, int line_count) {
    for (int i = 0; i < line_count; i++) {
        free(lines[i]);
    }
    free(lines);
}

char* concatenar(const char *str1, const char *str2) {
    // Calcular el tamaño necesario para la cadena resultante
    size_t len1 = strlen(str1);
    size_t len2 = strlen(str2);
    size_t total_length = len1 + len2 + 1; // +1 para el carácter nulo

    // Asignar memoria para la cadena resultante
    char *result = (char *)malloc(total_length);
    if (!result) {
        perror("malloc");
        exit(-1);
    }

    // Copiar la primera cadena a la cadena resultante
    strcpy(result, str1);

    // Concatenar la segunda cadena a la cadena resultante
    strcat(result, str2);

    return result;
}

int main(int argc, char *argv[]){

    char *funcion_a_consultar;

    if (argc != 2){
        perror("error argumentos");
        exit(-1);
    }
    else{
        funcion_a_consultar = argv[1];
    }

    const char *txt_funciones = "data/funciones.txt";
    int line_count = 0;
    char **funciones = read_lines_from_file(txt_funciones, &line_count);

    Diccionario *dicc = consultar_valores_verdad(funcion_a_consultar);
    char *txt_resultados = concatenar("data/", concatenar(funcion_a_consultar, "_resultados.txt"));;
    write_dicc_to_file(dicc, txt_resultados);

    free_lines(funciones, line_count);
    free_diccionario(dicc);

    return 0;
}