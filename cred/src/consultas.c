#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>
#include <string.h>
#include "diccionario.h"

void handle_error(const char *msg) {
    perror(msg);
    exit(-1);
}

char* generate_query(const char* predicate) {
    // Partes del string original
    const char* part1 = "consult('../../code.pl').\n";
    const char* part2 = "(X, Prob).\n";

    // Calcular el tamaño necesario para el string resultante
    size_t part1_len = strlen(part1);
    size_t predicate_len = strlen(predicate);
    size_t part2_len = strlen(part2);
    size_t semicolons_len = 48 * 2; // 48 puntos y coma acompañados de saltos de línea (cada uno 2 caracteres)

    size_t total_len = part1_len + predicate_len + part2_len + semicolons_len + 3; // +3 para "\n\n" y '\0'

    // Asignar memoria para el string resultante
    char* result = (char*)malloc(total_len);
    if (result == NULL) {
        perror("malloc");
        exit(-1);
    }

    // Construir el string resultante
    strcpy(result, part1);
    strcat(result, predicate);
    strcat(result, part2);

    // Añadir 48 puntos y coma acompañados de saltos de línea
    for (int i = 0; i < 48; i++) {
        strcat(result, ";\n");
    }

    // Añadir los dos saltos de línea finales
    strcat(result, "\n\n");

    return result;
}

// Estructura para almacenar múltiples patrones
typedef struct PatternNode {
    char *pattern;
    struct PatternNode *next;
} PatternNode;

PatternNode* create_pattern_node(const char *pattern) {
    PatternNode *node = (PatternNode *)malloc(sizeof(PatternNode));
    if (!node) {
        perror("malloc");
        exit(-1);
    }
    node->pattern = strdup(pattern);
    if (!node->pattern) {
        perror("strdup");
        free(node);
        exit(-1);
    }
    node->next = NULL;
    return node;
}

void free_pattern_list(PatternNode *head) {
    PatternNode *current = head;
    PatternNode *next;
    while (current != NULL) {
        next = current->next;
        free(current->pattern);
        free(current);
        current = next;
    }
}

PatternNode* extract_pattern_multiple(const char* source, const char* start, const char* end) {
    PatternNode *head = NULL;
    PatternNode *tail = NULL;
    char *start_pos = (char *)source;

    while ((start_pos = strstr(start_pos, start)) != NULL) {
        start_pos += strlen(start);
        char *end_pos = strstr(start_pos, end);
        if (!end_pos) break;

        size_t length = end_pos - start_pos;
        char *pattern = (char*)malloc(length + 1);
        if (!pattern) {
            perror("malloc");
            exit(-1);
        }
        strncpy(pattern, start_pos, length);
        pattern[length] = '\0';

        PatternNode *node = create_pattern_node(pattern);
        free(pattern);

        if (!head) {
            head = node;
        } else {
            tail->next = node;
        }
        tail = node;

        start_pos = end_pos + strlen(end);
    }

    return head;
}

Diccionario *consultar_valores_verdad(char *funcion) {

    Diccionario *dicc;

    int in_pipe[2], out_pipe[2], err_pipe[2];
    pid_t pid;

    if (pipe(in_pipe) == -1) handle_error("pipe in_pipe");
    if (pipe(out_pipe) == -1) handle_error("pipe out_pipe");
    if (pipe(err_pipe) == -1) handle_error("pipe err_pipe");

    pid = fork();
    if (pid == -1) {
        handle_error("fork");
    } else if (pid == 0) {
        // Proceso hijo

        // Redirigir stdin
        close(in_pipe[1]); // Cerrar la escritura del pipe de entrada
        dup2(in_pipe[0], STDIN_FILENO);
        close(in_pipe[0]);

        // Redirigir stdout
        close(out_pipe[0]); // Cerrar la lectura del pipe de salida
        dup2(out_pipe[1], STDOUT_FILENO);
        close(out_pipe[1]);

        // Redirigir stderr
        close(err_pipe[0]); // Cerrar la lectura del pipe de error
        dup2(err_pipe[1], STDERR_FILENO);
        close(err_pipe[1]);

        // Ejecutar el intérprete (por ejemplo, ciao)
        execlp("ciao", "ciao", NULL);

        // Si execlp falla
        handle_error("execlp");
    } else {
        // Proceso padre

        // Cerrar los extremos no utilizados de las tuberías
        close(in_pipe[0]);
        close(out_pipe[1]);
        close(err_pipe[1]);

        // Escribir en stdin del proceso hijo
        const char *input = generate_query(funcion);
        write(in_pipe[1], input, strlen(input));
        close(in_pipe[1]); // Cerramos la escritura una vez terminada

        // Leer stdout y stderr del proceso hijo
        char buffer[1024];
        ssize_t count;

        // Buffer dinámico para almacenar la salida de stdout
        size_t total_size = 1; // Para el carácter nulo al final
        char *stdout_content = (char *)malloc(total_size);
        stdout_content[0] = '\0';

        // Leer stdout
        while ((count = read(out_pipe[0], buffer, sizeof(buffer) - 1)) > 0) {
            buffer[count] = '\0';
            total_size += count;
            stdout_content = (char *)realloc(stdout_content, total_size);
            if (stdout_content == NULL) {
                perror("realloc");
                exit(-1);
            }
            strcat(stdout_content, buffer);
        }

        // Leer stderr
        while ((count = read(err_pipe[0], buffer, sizeof(buffer) - 1)) > 0) {
            buffer[count] = '\0';
            printf("\nSTDERR: %s", buffer);
        }

        // Cerrar las lecturas una vez terminadas
        close(out_pipe[0]);
        close(err_pipe[0]);

        // Esperar a que el proceso hijo termine
        waitpid(pid, NULL, 0);

        dicc = crear_diccionario();

        // Filtrar para extraer patrones entre dos substrings
        const char *start_paises = ",'";
        const char *end_paises = "',";
        const char *start_prob = ".=.";
        const char *end_prob = " ?";
        PatternNode *patterns_paises = extract_pattern_multiple(stdout_content, start_paises, end_paises);
        PatternNode *patterns_prob = extract_pattern_multiple(stdout_content, start_prob, end_prob);
        // Insertar los patrones encontrados
        PatternNode *current_paises = patterns_paises;
        PatternNode *current_prob = patterns_prob;
        while (current_paises != NULL && current_prob != NULL) {
            ins_entrada_dicc(dicc, current_paises->pattern, current_prob->pattern);
            current_paises = current_paises->next;
            current_prob = current_prob->next;
        }

        /*
        FALTA GESTION DE ERRORES POR SI LAS LONGITUDES NO SON IGUALES
        */

        print_diccionario(dicc);

        // Liberar la memoria del buffer dinámico y la lista de patrones
        free(stdout_content);
        free_pattern_list(patterns_paises);
        free_pattern_list(patterns_prob);
    }

    return dicc;
}
