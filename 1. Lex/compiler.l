/*Antwnopoulos Vasilis      | AEM 01270 | AM 2118204*/
/*Mpakalaros Kwnstantinos   | AEM 01279 | AM 2218213*/
/*Siatras  Odusseas         | AEM 00735 | AM 2116118*/
 
%{ 
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
	#include "tokens.h"

	 
     char str_buf[254];                    //String Buffer for saving string
     int error_counter=0;                  
	 
     void token_print(int token_id);
	 void iconstprint(int token_id, int base);		
	 void rconstprint(int token_id, int base);

	 int HexToInt(char* str);
	 int BinToInt(char* str);
		
	 float HexToFloat(char* str);		/*Had a problem during gcc with the linker of <math.h> and pow function */
	 float BinToFloat(char* str);		/*So i gave to use flag -lm with gcc to link it with library libm.a*/
	
     void yyerror(const char* err);

%}

%option noyywrap
%option case-insensitive				
%option yylineno

/* Sub-Lexer | STRING = For Strings | SLCOMENT =  For single line comment */
%x STRING 
%x SLCOMMENT 

/* Class Declaration */
DIGIT		[0-9]
LETTER		[a-zA-Z]
ALPHANUM	{LETTER}|{DIGIT} 

/*For Finding IDs*/
ID          ([_]{LETTER}{ALPHANUM}*(_{ALPHANUM}+)*_)|({LETTER}{ALPHANUM}*)

/*			 (Hexademical)            					|(Binary)	     			|(Decimal)    (0)
/*ICONST    (0H[1-9][0-9A-F]*)	 				        |(0[B][1][01]*)			    |([1-9][0-9]*)|(0)*/
ICONSTHEX	(0H[1-9][0-9A-F]*)
ICONSTBIN	(0[B][1][01]*)
ICONSTDEC	([1-9][0-9]*)|(0) 

/*			 (Hexademical)					 			|(Binary)     		      	            |(Decimal)  (0)                     	               										       	 
/*RCONST	(((0H[A-F0-9]*)|0)\.([0-9A-F]*))			|((0B[1][0-1]*|0)\.[01]+)|(0B\.[01]+)	|\.[1-9]+E[+-]?[1-9]*|([1-9][0-9]*|0)?\.([1-9][0-9]*|0)|[1-9][0-9]*\.|([1-9]+E?[+-]?\.?[1-9]+[0-9]*)(E[+-]?[0-9]+)?|(0)*/
RCONSTHEX	(((0H[A-F0-9]*)|0)\.([0-9A-F]*))
RCONSTBIN	((0B[1][0-1]*|0)\.[01]+)|(0B\.[01]+)
RCONSTDEC	\.[1-9]+E[+-]?[1-9]*|([1-9][0-9]*|0)?\.([1-9][0-9]*|0)|[1-9][0-9]*\.|([1-9]+E?[+-]?\.?[1-9]+[0-9]*)(E[+-]?[0-9]+)?|(0)

/*				ASCII 32-126 in hex | (\)(nftrbv)*/
CCONST		\'(([\x20-\x7E])|(\\[nftrbv]*))\'

%%
 /* Keywords */
"FUNCTION"                  					    { token_print(T_FUNCTION); return T_FUNCTION; }
"SUBROUTINE"                  					    { token_print(T_SUBROUTINE); return T_SUBROUTINE; }
"END"                  							    { token_print(T_END); return T_END; }
"INTEGER"                  						    { token_print(T_INTEGER); return T_INTEGER; }
"REAL"                  						    { token_print(T_REAL); return T_REAL; }
"LOGICAL"                  						    { token_print(T_LOGICAL); return T_LOGICAL; }
"CHARACTER"                  					    { token_print(T_CHARACTER); return T_CHARACTER; }
"RECORD"                  						    { token_print(T_RECORD); return T_RECORD; }
"ENDREC"                  						    { token_print(T_ENDREC); return T_ENDREC; }
"DATA"                  						    { token_print(T_DATA); return T_DATA; }
"CONTINUE"                  					    { token_print(T_CONTINUE); return T_CONTINUE; }
"GOTO"                  						    { token_print(T_GOTO); return T_GOTO; }
"CALL"                  						    { token_print(T_CALL); return T_CALL; }
"READ"                  						    { token_print(T_READ); return T_READ; }
"WRITE"                  						    { token_print(T_WRITE); return T_WRITE; }
"IF"                  							    { token_print(T_IF); return T_IF; }
"THEN"                  						    { token_print(T_THEN); return T_THEN; }
"ELSE"                  						    { token_print(T_ELSE); return T_ELSE; }
"ENDIF"                  						    { token_print(T_ENDIF); return T_ENDIF; }
"DO"                  							    { token_print(T_DO); return T_DO; }
"ENDDO"                  						    { token_print(T_ENDDO); return T_ENDDO; }
"STOP"                  						    { token_print(T_STOP); return T_STOP; }
"RETURN"                  						    { token_print(T_RETURN); return T_RETURN; }
 
 /*ID*/
{ID}             								    { token_print(T_ID); return T_ID; }

 /*ICONST*/
{ICONSTHEX}        								    { iconstprint(T_ICONST, 16); return T_ICONST;}
{ICONSTBIN}        								    { iconstprint(T_ICONST, 2); return T_ICONST;}
{ICONSTDEC}        								    { iconstprint(T_ICONST, 10); return T_ICONST;}

 /*RCONST*/
{RCONSTHEX}       								    { rconstprint(T_RCONST, 16); return T_RCONST; }
{RCONSTBIN}       								    { rconstprint(T_RCONST, 2 ); return T_RCONST; }
{RCONSTDEC}       							    	{ rconstprint(T_RCONST, 10); return T_RCONST; }

 /*CCONST*/
{CCONST}        								    { token_print(T_CCONST); return T_CCONST; }

 /*LCONST*/
".TRUE."|".FALSE."        						    { token_print(T_LCONST); return T_LCONST; }

 /* Operators */  
".OR."          									{ token_print(T_OROP); return T_OROP; }
".AND."         									{ token_print(T_ANDOP); return T_ANDOP; }
".NOT."         									{ token_print(T_NOTOP); return T_NOTOP; }
".GT."|".GE."|".LT."|".LE."|".EQ."|".NE."           { token_print(T_RELOP); return T_RELOP; }
"+"|"-"         									{ token_print(T_ADDOP); return T_ADDOP; }
"*"         										{ token_print(T_MULOP); return T_MULOP; }
"/"         										{ token_print(T_DIVOP); return T_DIVOP; }
"**"       											{ token_print(T_POWEROP); return T_POWEROP; }
 
 /* For STRINGS */
\"						{strcpy(str_buf, ""); BEGIN(STRING); }  /* Starting sub lexer for string */ /*Cleaning buffer*/ 
<STRING>\"				{ BEGIN(INITIAL);
                                if(strcmp(str_buf,"") ==0 ){    /* Checking if string is empty */
                                    yyerror("Found empty string"); 
                                   } else {
                                    printf("[LINE %d]Found String: '%s' (%d, %s) \n", yylineno, str_buf, T_STRING, TOKEN_NAME[T_STRING]); return T_STRING;}
                                }    
                                             /* Returning to lexer */
<STRING>\\(\n|\r\n)     { }                   /* New line for string */
<STRING>(\\.|[^"\\]) 	{                       /* Catching  special characters */
                        if(strlen(yytext) == 2) {
								if(strcmp(yytext, "\\n") == 0) {
									strcat(str_buf, "\n");
								} else if (strcmp(yytext, "\\t") == 0 ) {
									strcat(str_buf, "\t");
								} else if (strcmp(yytext, "\\r") == 0) {
									strcat(str_buf, "\r");
								} else if (strcmp(yytext, "\\f") == 0) {
									strcat(str_buf, "\f");
								} else if (strcmp(yytext, "\\b") == 0) {
									strcat(str_buf, "\b");
								} else if (strcmp(yytext, "\\v") == 0) {
									strcat(str_buf, "\v");
								} else {
									strcat(str_buf, &yytext[1]);
								}
							}else {             /* Catching anything else */
								strcat(str_buf, yytext); 
							}
                        }
<STRING>(\n|\r\n)		{ yyerror("New line found without \\ \n"); }        /* New line without '\' ->  Error */
<STRING><<EOF>>			{ yyerror("End of string without closing it.\n"); } /* EOF in string ->  Error */
<STRING>.				{ yyerror("Unknown Character.\n"); }                /* Anything else -> Error */

 /* For SLCOMENT */
"$"					            { BEGIN(SLCOMMENT); printf("[LINE %d]Found Comment \n", yylineno); } 
<SLCOMMENT>(\n|\r\n)		    { BEGIN(INITIAL); } 
<SLCOMMENT>.				    {  }                                        /* Ignore Commens */

 /* Other Lexical Tokens */
"("                 								{ token_print(T_LPAREN); return T_LPAREN; }
")"               									{ token_print(T_RPAREN); return T_RPAREN; }
","             								    { token_print(T_COMMA); return T_COMMA; }
"="               									{ token_print(T_ASSIGN); return T_ASSIGN; }
":"         										{ token_print(T_COLON); return T_COLON; }
[ \t]					                            {}						/* Ignore Spaces */
[\n]|[\r\n]					                        {} 				/* For New Line (Linux) |  For New Line (Windows) */
<<EOF>>												{ token_print(T_EOF); return T_EOF; } //End of file
.													{ yyerror("Unrecognised character \n"); }

%%

int main(int argc, char *argv[]){
	int token;        
	if(argc > 1){       

		yyin = fopen(argv[1], "r");
		if (yyin == NULL){
			perror ("Error opening file"); 
			return -1;
		}
	 }        

	do{		
		token = yylex(); 
	}while(token != T_EOF);
	fclose(yyin);
	yyterminate();
}


void token_print(int token_id) {
    printf("[LINE %d]Found token \'%s\' (%d, %s) \n", yylineno, yytext, token_id, TOKEN_NAME[token_id]);
}
 //Recognise iconst base convert to decimal and print
void iconstprint(int token_id, int base){		
        int number;
        if(base == 2) number = BinToInt(yytext);
        else if(base == 16) number = HexToInt(yytext);
        else number = atoi(yytext);
        printf("[LINE %d]Found number: %d (%s) | from base: %d | with token number: (%d, %s) \n", yylineno, number, yytext, base, token_id, TOKEN_NAME[token_id]);
    
}
 //Recognise rconst base convert to decimal and print
void rconstprint(int token_id, int base){
        float number;
        if(base == 2) number = BinToFloat(yytext);
        else if(base == 16) number = HexToFloat(yytext);
        else number = atof(yytext);
        printf("[LINE %d]Found float: %f (%s) | from base: %d | with token number: (%d, %s) \n", yylineno, number, yytext, base, token_id, TOKEN_NAME[token_id]);
    
}


//Function converting Hex to Int
int HexToInt(char *str){
    return (int) strtol(&str[2], NULL, 16);
}

//Function converting Bin to Int
int BinToInt(char *str){
    return (int) strtol(&str[2], NULL, 2);
}

//Function converting Hex to Float
float HexToFloat(char*str){
    float number = 0.0;
    int i,length_real;  
    char *character;
    character = strchr(str,'.');
    length_real = strlen(character)-1;
    number = (int)strtol(&str[2],&character,16);
    for(i=1;i<=length_real;i++){
        if(character[i] <= '9')
			number += (character[i] - '0') * (1/pow(16,i));
		else
			number += (character[i] + 10 - 'A') * (1/pow(16,i)); 
	}
    return number;
}

//Function converting Bin to Float
float BinToFloat(char* str){
    float number = 0.0;
    int i,length_real;
    char *character;
    character = strchr(str,'.');
    length_real = strlen(character)-1;
    number = (int)strtol(&str[2],&character,2);
    for(i=1;i<=length_real;i++){
        number += (character[i] - '0') * (1/pow(2,i));
    }
    return number;
}
//Function For Errors
void yyerror(const char* err){
    error_counter++;
    printf("[ERROR - LINE %d] %s\n", yylineno, err);

    if(error_counter == 5) {
        printf("MAXIMUM ERRORS FOUND\n");
        exit(EXIT_FAILURE);
    }
    yyless(1); /* Panic Method */
}