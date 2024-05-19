#ifndef DICCIONARIO_H
#define DICCIONARIO_H

// Estructuras
typedef struct Entrada Entrada;
typedef struct Diccionario Diccionario;

// Funciones del diccionario
Entrada *crear_entrada(char* clave, char* valor);
Diccionario *crear_diccionario();
void ins_entrada_dicc(Diccionario *dicc, const char *clave, const char *valor);
char *get_valor(Diccionario *dicc, const char *clave);
void eliminar_entrada(Diccionario *dicc, const char *clave);
void free_diccionario(Diccionario *dicc);
void print_diccionario(Diccionario *diccionario);
void write_dicc_to_file(Diccionario *dicc, const char *filename);

#endif
