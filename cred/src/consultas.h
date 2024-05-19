#ifndef CONSULTAS_H
#define CONSULTAS_H

// Estructuras
typedef struct PatternNode PatternNode;

// Funciones
void handle_error(const char *msg);
char* generate_query(const char* predicate);
PatternNode* create_pattern_node(const char *pattern);
void free_pattern_list(PatternNode *head);
PatternNode* extract_pattern_multiple(const char* source, const char* start, const char* end);
Diccionario *consultar_valores_verdad(char *funcion);

#endif