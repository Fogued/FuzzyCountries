#include "diccionario.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct Entrada {
    char *clave;
    char *valor;
    Entrada *siguiente
} Entrada;

typedef struct Diccionario {
    Entrada *head;
} Diccionario;

Entrada *crear_entrada(char* clave, char* valor){
    Entrada *nueva_entrada = (Entrada*) malloc(sizeof(Entrada));
    if(nueva_entrada == NULL){
        perror("Fallo al crear nueva entrada");
        exit(-1);
    }
    nueva_entrada->clave = strdup(clave);
    if (nueva_entrada->clave == NULL) {
        perror("Fallo al duplicar string (clave)");
        free(nueva_entrada);
        exit(-1);
    }
    nueva_entrada->valor = strdup(valor);
    if (nueva_entrada->valor == NULL) {
        perror("Fallo al duplicar string (valor)");
        free(nueva_entrada);
        exit(-1);
    }
    nueva_entrada->siguiente = NULL;
    return nueva_entrada;
}

Diccionario *crear_diccionario() {
    Diccionario *dicc = (Diccionario*)malloc(sizeof(Diccionario));
    if (dicc == NULL){
        perror("Fallo al crear el diccionario");
    }
    dicc->head = NULL;
    return dicc;
}

void ins_entrada_dicc(Diccionario *dicc, const char *clave, const char *valor) {
    Entrada *nueva_entrada = crear_entrada(clave, valor);
    if(dicc->head == NULL){
        dicc->head = nueva_entrada;
    }
    else{
        Entrada *actual = dicc->head;
        while (actual->siguiente != NULL)
        {
            actual = actual->siguiente;
        }
        actual->siguiente = nueva_entrada;
    }
    
}

char *get_valor(Diccionario *dicc, const char *clave) {

    Entrada *actual = dicc->head;
    while (actual != NULL)
    {
        if(strcmp(actual->clave, clave) == 0){
            return actual->valor;
        }
        actual = actual->siguiente;
    }
    
}

void eliminar_entrada(Diccionario *dicc, const char *clave) {
    Entrada *actual = dicc->head;
    Entrada *anterior = NULL;
    while(actual != NULL && strcmp(actual->clave, clave) != 0){
        anterior = actual;
        actual = actual->siguiente;
    }

    if(actual == NULL){
        // No se encontro la clave
        perror("Se intenta eliminar clave inexistente");
        exit(-1);
    }

    if(anterior == NULL){
        // El nodo a eliminar es la cabeza
        dicc->head = NULL;
    }
    else{
        // No es la cabeza
        anterior->siguiente = actual->siguiente;
    }

    // Liberamos los recursos de la Entrada eliminada
    free(actual->clave);
    free(actual->valor);
    free(actual);
}

void free_diccionario(Diccionario *dicc) {
    
    Entrada *actual = dicc->head;
    Entrada *sig;
    while (actual != NULL) 
    {
        sig = actual->siguiente;
        free(actual->clave);
        free(actual->valor);
        free(actual);
        actual = sig;
    }
    free(dicc);
    
}


void print_diccionario(Diccionario *diccionario) {
    Entrada *entrada = diccionario->head;
    while (entrada != NULL)
    {
        printf("%s: %s\n", entrada->clave, entrada->valor);
        entrada = entrada->siguiente;
    }
}

void write_dicc_to_file(Diccionario *dicc, const char *filename) {
    FILE *file = fopen(filename, "w");
    if (!file) {
        perror("fopen");
        return;
    }

    Entrada *actual = dicc->head;
    while (actual != NULL) {
        fprintf(file, "%s: %s\n", actual->clave, actual->valor);
        actual = actual->siguiente;
    }

    fclose(file);
}