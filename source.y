%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    //#include "tabSymbol.h"
    #define SIZE 1024
    #define DEBUT "<debut>"


    int yydebug=1;
    extern int yylex();
    int yywrap(void) {};
    int yyerror(char *s) {
        printf("%s\n",s);
    }


    typedef struct Cellule Cellule;
    struct Cellule {
        char* nom;
        int constante;
        Cellule* suivante;
    };

    typedef struct Liste Liste;
    struct Liste {
        Cellule* premiere;
    };



    Liste* tabSymbol;
    Liste* bufferSymbol; //pour les declarations a virgule
    FILE * inputFile;
    int index_pile = 0;


    int COD_ADD = 1;
    int COD_SUB = 3;
    int COD_MUL = 2;
    int COD_DIV = 4;
    int COD_COP = 5;
    int COD_AFC = 6;
    int COD_JMP = 7;
    int COD_JMF = 8;
    int COD_INF = 9;
    int COD_SUP = 10;
    int COD_EQU = 11;
    int COD_PRI = 12;

    // Fonctions utiles

    void write_instruction1(int ope_cod, int num){
      // jmp; pri
      if (ope_cod<10){
        fprintf(inputFile,"%d %d\n", ope_cod, num);
      } else {
        fprintf(inputFile,"%c %d\n", 55+ope_cod, num);
      }

    }
    void write_instruction2(int ope_cod, int ret, int op1){
      // cop; afc; jmf
      if (ope_cod<10){
        fprintf(inputFile,"%d %d %d\n", ope_cod, ret, op1);
      } else {
        fprintf(inputFile,"%c %d %d\n", 55+ope_cod, ret, op1);
      }
    }
    void write_instruction3(int ope_cod, int ret, int op1, int op2){
      // add; sub; mul; div; inf; sup; equ
      if (ope_cod<10){
    	  fprintf(inputFile,"%d %d %d %d\n", ope_cod, ret, op1, op2);
      } else {
        fprintf(inputFile,"%c %d %d %d\n", 55+ope_cod, ret, op1, op2);
      }
    }


    Liste* initialise() {
        tabSymbol = malloc(sizeof(Liste));
        Cellule* cellule = malloc(sizeof(Cellule));
        if (tabSymbol == NULL || cellule == NULL)  {
            exit(EXIT_FAILURE);
        }
        cellule->nom = malloc(strlen(DEBUT)+1);
        strncpy(cellule->nom, DEBUT, strlen(DEBUT));
        cellule->constante = 0;
        cellule->suivante = NULL;
        tabSymbol->premiere = cellule;
        return tabSymbol;
    }


    void supprime(Liste* tabSymbol) {
        if (tabSymbol == NULL) {
            exit(EXIT_FAILURE);
        }
        while (tabSymbol->premiere != NULL) {
            Cellule* bientotPlusLa = tabSymbol->premiere;
            tabSymbol->premiere = tabSymbol->premiere->suivante;
            free(bientotPlusLa);
        }
    }


    int ajoute(char* nvNom, int constante) {
        Cellule* nouvelle = malloc(sizeof(*nouvelle));
        if (tabSymbol == NULL || nouvelle == NULL) {
            exit(EXIT_FAILURE);
        }
        nouvelle->nom = malloc(strlen(nvNom)+1);
        strncpy(nouvelle->nom, nvNom, strlen(nvNom));
        nouvelle->constante = constante;

        int compteur = 0;
        Cellule* actuelle = tabSymbol->premiere;
        //printf("compteur ");
        int found = 0;
        while (!found && actuelle->suivante != NULL) {
        	if (strcmp(nvNom, actuelle->nom)==0) {
        		found = 1;
        		break;
        	}
        	compteur++;
            actuelle = actuelle->suivante;
        }
        //printf(" ; found %d\n",found);
        // on rajoute que s'il y a besoin
        if(!found && strcmp(nvNom, actuelle->nom)!=0) {
    	    actuelle->suivante = nouvelle;
    	    nouvelle->suivante = NULL;
    	    compteur++;  //on rajoute un element en plus
        }
        //affiche();
        return compteur;
    }


    int trouve(char* nvNom) {
        //affiche();
        int compteur = 0;
        int arg = -1;
        Cellule* actuelle = tabSymbol->premiere;
        while (actuelle != NULL && arg < 0) {
        	if (strcmp(nvNom, actuelle->nom)==0)
        		arg = compteur;
        	compteur++;
          actuelle = actuelle->suivante;
        }
        return arg;
    }

    int constante(char* nvNom) {
        int compteur = 0;
        int arg = -1;
        Cellule* actuelle = tabSymbol->premiere;
        while (actuelle != NULL && arg < 0) {
          if (strcmp(nvNom, actuelle->nom)==0)
            arg = actuelle->constante;
          compteur++;
          actuelle = actuelle->suivante;
        }
        return arg;
    }


    void affiche() {
        if (tabSymbol == NULL) {
            exit(EXIT_FAILURE);
        }
        Cellule* actuelle = tabSymbol->premiere;
        while (actuelle != NULL) {
            fprintf(inputFile,"(%s, %d) -> ", actuelle->nom, actuelle->constante);
            actuelle = actuelle->suivante;
        }
        fprintf(inputFile,"NULL\n");
    }

    void afficheBuffer() {
        if (bufferSymbol == NULL) {
            exit(EXIT_FAILURE);
        }
        Cellule* actuelle = bufferSymbol->premiere;
        while (actuelle != NULL) {
            fprintf(inputFile,"(%s, %d) -> ", actuelle->nom, actuelle->constante);
            actuelle = actuelle->suivante;
        }
        fprintf(inputFile,"NULL\n");
    }

    Liste* initialiseBuffer() {
        bufferSymbol = malloc(sizeof(Liste));
        Cellule* cellule = malloc(sizeof(Cellule));
        if (bufferSymbol == NULL || cellule == NULL)  {
            exit(EXIT_FAILURE);
        }
        cellule->nom = malloc(strlen(DEBUT)+1);
        strncpy(cellule->nom, DEBUT, strlen(DEBUT));
        cellule->constante = 0;
        cellule->suivante = NULL;
        bufferSymbol->premiere = cellule;
        return bufferSymbol;
    }

    void ecritBuffer(int val) {
        afficheBuffer();
        if (bufferSymbol == NULL) {
            exit(EXIT_FAILURE);
        }
        while (bufferSymbol->premiere != NULL) {
            Cellule* bientotPlusLa = bufferSymbol->premiere;
            if (strcmp(bientotPlusLa->nom,DEBUT)!=0)
                fprintf(inputFile,"AFC %d %d\n", trouve(bientotPlusLa->nom), val);
            bufferSymbol->premiere = bufferSymbol->premiere->suivante;
            free(bientotPlusLa);
        }
    }

    void stocke(char* nvNom, int constante) {
        afficheBuffer();
        Cellule* nouvelle = malloc(sizeof(*nouvelle));
        if (bufferSymbol == NULL || nouvelle == NULL) {
            exit(EXIT_FAILURE);
        }
        nouvelle->nom = malloc(strlen(nvNom)+1);
        strncpy(nouvelle->nom, nvNom, strlen(nvNom));
        nouvelle->constante = constante;
        Cellule* actuelle = bufferSymbol->premiere;
        int found = 0;
        while (!found && actuelle->suivante != NULL) {
        	if (strcmp(nvNom, actuelle->nom)==0) {
        		found = 1;
        		break;
        	}
            actuelle = actuelle->suivante;
        }
        if(!found && strcmp(nvNom, actuelle->nom)!=0) {
    	    actuelle->suivante = nouvelle;
    	    nouvelle->suivante = NULL;
        }
    }



    int empile_tmp(){
      index_pile++;
      return SIZE-index_pile; //pile virtualisee par un simple index de pile (parce qui compte c'est
    }                         //l'adresse pas le contenu de la pile)

    int depile_tmp(){
      index_pile--;
      return SIZE-index_pile;
    }



%}
%union        {int nb; char var [32];};
%token        tMAIN tFIN tCONST tVOID tINT tCHAR tFLOAT tPRINTF tEQ tADD tSUB tMUL tDIV tVIRG tPTvirg tPARo tPARf tACCo tACCf tNULL tREAL tEXPO tNOM tVIRGULE
%token        <nb>  tNB tEXPO
%token        <var> tVAR
%type         <nb> EXPRESSION OPE DECLARATION VAL INSTRUCT LVAR LVARS DVAR DVARS

%left tADD tSUB
%left tDIV tMUL
%right tPOW
%start S;

%%
S: MAIN;
MAIN: TYPE tMAIN tPARo LVAR tPARf tACCo BODY tACCf { fprintf(inputFile,"main"); } ;
TYPE:
        tINT
    |   tFLOAT
    |   tCHAR
    |   tVOID
    ;
BODY: DECLARATION INSTRUCT ;
LVAR:

    |   tVAR LVARS
    ;
LVARS:

    |   tVIRG tVAR LVARS
    ;

DECLARATION:

    |   TYPE tVAR tPTvirg DECLARATION            { ajoute($2,0); }
    |   tCONST TYPE tVAR tPTvirg DECLARATION     { ajoute($3,1); }
    |   TYPE tVAR tEQ VAL tPTvirg DECLARATION    { ajoute($2,0); write_instruction2(COD_AFC,trouve($2),$4); }
    |   TYPE tVAR tVIRGULE VARSUIV DECLARATION   { ajoute($2,0); }
    |   tCONST TYPE tVAR tVIRGULE CONSTVARSUIV DECLARATION  { ajoute($3,1); }
    ;

VARSUIV:
      tVAR tVIRGULE VARSUIV { ajoute($1,0); }
    | tVAR tPTvirg { ajoute($1,0); }
    ;

CONSTVARSUIV:
      tVAR tVIRGULE CONSTVARSUIV { ajoute($1,1); }
    | tVAR tPTvirg { ajoute($1,1); }
    ;
  //  |    ASSIGNATION DECLARATION
  //  ;

/*DECLARATIONS:

    |  DECLARATION DECLARATIONS
    ;

DECLARATION:
    AVECASSIGNATION
    | SANSASSIGNATION
    ;
SANSASSIGNATION:
    |   TYPE tVAR tPTvirg DECLARATION            { ajoute($2,0); }
    |   tCONST TYPE tVAR tPTvirg DECLARATION     { ajoute($3,1); }
    ;

AVECASSIGNATION: TYPE DVARS tEQ VAL tPTvirg { ecritBuffer($4); };

DVARS:
    tVAR                      { ajoute($1); stocke($1,0); }
    | tVAR tVIRG DVARS        { ajoute($1); stocke($1,0); }
    ;*/

INSTRUCT:

    |   tVAR tEQ EXPRESSION tPTvirg INSTRUCT             { if(!constante($1)){write_instruction2(COD_COP,trouve($1),$3); depile_tmp();}  } /*si constante on change pas*/
    |   PRINT INSTRUCT
    ;

PRINT: tPRINTF tPARo tVAR tPARf tPTvirg  { write_instruction1(COD_PRI,trouve($3)); } ;

EXPRESSION:
        tNB                        { int addr_tmp = empile_tmp(); $$ = addr_tmp; write_instruction2(COD_AFC,addr_tmp,$1); }
    |   tEXPO                      { int addr_tmp = empile_tmp(); $$ = addr_tmp; write_instruction2(COD_AFC,addr_tmp,$1); }
    |   tREAL                      { int addr_tmp = empile_tmp(); $$ = addr_tmp; write_instruction2(COD_AFC,addr_tmp, 1); }
    |   tVAR                       { int addr_tmp = empile_tmp(); $$ = addr_tmp; write_instruction2(COD_COP,addr_tmp,trouve($1)); }
    |   tPARo EXPRESSION tPARf     { $$ = $2; }
    |   EXPRESSION OPE EXPRESSION  { $$ = $1; write_instruction3($2, $1, $1, $3); depile_tmp(); } /*liberation de l'adresse*/
    |   tSUB EXPRESSION %prec tMUL { write_instruction3(COD_SUB, $2, 0, $2); }        /*pas sur du tout : pas de depilage ?*/
    ;

OPE:
        tADD  { $$=COD_ADD; }
    |   tSUB  { $$=COD_SUB; }
    |   tMUL  { $$=COD_MUL; }
    |   tDIV  { $$=COD_DIV; }
    ;

VAL:
        tNB
    |   tREAL
    |   tEXPO
    |   tVAR
    ;

%%
int main(){
    printf("Début\n");
    Liste* tabSymbol = initialise();
    Liste* bufferSymbol = initialiseBuffer();

    inputFile = fopen( "asm.txt", "w" );
    if ( inputFile == NULL ) {
        printf( "Cannot open file %s\n", "ASM" );
        exit( 0 );
    }

    /*printf("ajoute titi: %d\n",ajoute( "titi"));
    printf("trouve titi: %d\n",trouve( "titi"));
    affiche(tabSymbol);
    printf("ajoute totodu31: %d\n",ajoute( "totodu31"));
    printf("trouve titi: %d\n",trouve( "titi"));
    printf("trouve totodu31: %d\n",trouve( "totodu31"));
    affiche(tabSymbol);
    printf("ajoute totodu31400: %d\n",ajoute( "totodu31400"));
    printf("trouve totodu31400: %d\n",trouve( "totodu31400"));
    affiche(tabSymbol);
    printf("ajoute totodu31: %d\n",ajoute( "totodu31"));
    printf("trouve totodu31: %d\n",trouve( "totodu31"));
    affiche(tabSymbol);
    printf("ajoute totodu31400: %d\n",ajoute( "totodu31400"));
    printf("trouve totodu31400: %d\n",trouve( "totodu31400"));
    affiche(tabSymbol);
    supprime(tabSymbol);*/

    yyparse();
    fclose(inputFile);

    printf("\nmemoire libérée\n");
    printf("FIN\n");
    return 0;
}
/*
C:
int a = 5;
int b = 6;
int c = 7;
a = (b-c)*(a+b);


NOUS:
[a,,,,,]
AFC @a 5 -> 6 0 5
[a,b,,,,]
AFC @b 6 -> 6 1 6
[a,b,c,,,]
AFC @c 7 -> 6 2 7
[a,b,c,,,tmp1]
SUB @tmp1 @b @c -> 3 6 1 2
[a,b,c,,tmp2,tmp1]
ADD @tmp2 @a @b -> 1 5 0 1
[a,b,c,@tmp3,tmp2,tmp1]
MUL @tmp3 @tmp1 @tmp2 -> 2 4 6 5
COP @tmp3 @a -> 5 4 0
[a,b,c,,,]




C:
int a = 5;
a = a + 8;


NOUS:
[a,,,,,]
AFC @a 5 -> 6 0 5
[a,,,,,8]
index_pile = 1
ADD @tmp @a @8 -> 1 5 0 6
[a,,,,tmp,8]
COP @tmp @a -> 5 5 0
[a,,,,,]



8 + b + c

tNB tPLUS tVAR tPLUS tVAR

|      |
\_____/

Sachant EXPRESSION -> tNB {actionNB}
Alors, nous executons actionNB
Hypothèse : pas de modif. de la pile
*/
