/*Antwnopoulos Vasilis      | AEM 01270 | AM 2118204*/
/*Mpakalaros Kwnstantinos   | AEM 01279 | AM 2218213*/
/*Siatras  Odusseas         | AEM 00735 | AM 2116118*/

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "extra/hashtbl.h"

    extern FILE *yyin;
    extern int yylex();
    extern void yyerror(const char* err);
    
    

    HASHTBL *hashtbl;
    int scope = 0;
%}

%define parse.error verbose

%union{
    int     intval;
    float   flval; 
    char    *strval;
}


%token <strval> T_FUNCTION              "Function"	   
%token <strval> T_SUBROUTINE            "Subroutine"
%token <strval> T_END 		            "End"   
%token <strval> T_INTEGER	            "Integer"   	
%token <strval> T_REAL		            "Real"   
%token <strval> T_LOGICAL	            "Logical"   	
%token <strval> T_CHARACTER	            "Character"   
%token <strval> T_RECORD 	            "Record"   
%token <strval> T_ENDREC 	            "Endrec"   	
%token <strval> T_DATA		            "Data"    
%token <strval> T_CONTINUE	            "Continue"    
%token <strval> T_GOTO		            "Goto"    
%token <strval> T_CALL		            "Call"    
%token <strval> T_READ		            "Read"    
%token <strval> T_WRITE		            "Write"    
%token <strval> T_IF		            "If"    
%token <strval> T_THEN		            "Then"    
%token <strval> T_ELSE		            "Else"    
%token <strval> T_ENDIF		            "Endif"    
%token <strval> T_DO		            "Do"    
%token <strval> T_ENDDO		            "Enddo"    
%token <strval> T_STOP		            "Stop"    
%token <strval> T_RETURN	            "Return"  
%token <strval> T_ID                    "Id"
%token <intval> T_ICONST                "Integer constant"      
%token <flval>  T_RCONST                "Real constant"       
%token <strval> T_LCONST                "Logical constant"       
%token <strval> T_CCONST                "String constant"       
%token <strval> T_OROP                  ".OR."       
%token <strval> T_ANDOP                 ".AND."       
%token <strval> T_NOTOP                 ".NOT."       
%token <strval> T_RELOP                 ".GT. or .GE. or .LT. or .LE. or .EQ. or .NE."       
%token <strval> T_ADDOP                 "+ or -"       
%token <strval> T_MULOP                 "*"       
%token <strval> T_DIVOP                 "/"       
%token <strval> T_POWEROP               "**"        
%token <strval> T_STRING                "String"       
%token <strval> T_LPAREN                "("       
%token <strval> T_RPAREN                ")"       
%token <strval> T_COMMA                 ","       
%token <strval> T_ASSIGN                "="       
%token <strval> T_COLON                 ":"       
%token <strval> T_EOF       0           "End of file"

 /*     Τα warnings  επιλύονται  μελλοντικά στην σημασιολογική ανάλυση 
        Για αυτο γίνονται comment out οι γραμμές 74 - 76

%type <strval>  program body declarations type vars undef_variable dims dim fields field vals value_list values value repeat constant statements labeled_statement
%type <strval>  label statement simple_statement assignment  variable expression expressions goto_statement labels if_statement subroutine_call io_statement read_list read_item iter_space 
%type <strval>  step write_list write_item compound_statement branch_statement tail loop_statement subprogram  subprograms header formal_parameters
*/
 
%right  T_ASSIGN
%left   T_OROP
%left   T_ANDOP
%left   T_RELOP
%left   T_ADDOP
%left   T_MULOP
%left   T_DIVOP
%left   T_POWEROP
%left   T_NOTOP


%start program
%%

program: body T_END {hashtbl_get(hashtbl, scope);scope--;} {scope++;} subprograms  ;
body: declarations statements ;
declarations: declarations type vars 
                            | declarations T_RECORD fields T_ENDREC vars
                            | declarations T_DATA vals
                            | %empty   { }              ;
type: T_INTEGER | T_REAL | T_LOGICAL | T_CHARACTER      ;
vars: vars T_COMMA undef_variable
                            | undef_variable            ;
undef_variable: T_ID T_LPAREN dims T_RPAREN                      {hashtbl_insert(hashtbl, $1, NULL, scope);} 
                            | T_ID                              {hashtbl_insert(hashtbl, $1, NULL, scope);}  ;
dims: dims T_COMMA dim
                           	| dim                       ;
dim: T_ICONST | T_ID                                             {hashtbl_insert(hashtbl, $1, NULL, scope);}    ;
fields: fields field
                            | field                     ;
field: type vars
                            | T_RECORD fields T_ENDREC vars ;
vals: vals T_COMMA T_ID value_list                              {hashtbl_insert(hashtbl, $3, NULL, scope);} 
                            | T_ID value_list                   {hashtbl_insert(hashtbl, $1, NULL, scope);}     ;
value_list: T_DIVOP values T_DIVOP                      ;
values: values T_COMMA value
                            | value                     ;
value: repeat T_MULOP T_ADDOP constant
                            | repeat T_MULOP constant
                            | repeat T_MULOP T_STRING
                            | T_ADDOP constant
                            | constant
                            | T_STRING                  ;
repeat: T_ICONST | %empty { }                           ;
constant: T_ICONST | T_RCONST | T_LCONST | T_CCONST     ;
statements: statements labeled_statement
                            | labeled_statement         ;
labeled_statement: label statement
                            | statement                 ;
label: T_ICONST                                         ;
statement: simple_statement
                            | compound_statement        ;
simple_statement: assignment
                            | goto_statement
                            | if_statement
                            | subroutine_call
                            | io_statement
                            | T_CONTINUE
                            | T_RETURN
                            | T_STOP                    ;
assignment: variable T_ASSIGN expression
                            | variable T_ASSIGN T_STRING ;
variable: variable T_COLON T_ID                                {hashtbl_insert(hashtbl, $3, NULL, scope);} 
                            | variable T_LPAREN expressions T_RPAREN
                            | T_ID                             {hashtbl_insert(hashtbl, $1, NULL, scope);}     ;
expressions: expressions T_COMMA expression
                            | expression                 ;
expression: expression T_OROP expression
                            | expression T_ANDOP expression
                            | expression T_RELOP expression
                            | expression T_ADDOP expression
                            | expression T_MULOP expression
                            | expression T_DIVOP expression
                            | expression T_POWEROP expression
                            | T_NOTOP expression
                            | T_ADDOP expression
                            | variable
                            | constant
                            | T_LPAREN expression T_RPAREN ;
goto_statement: T_GOTO label
                            | T_GOTO T_ID T_COMMA T_LPAREN labels T_RPAREN  {hashtbl_insert(hashtbl, $2, NULL, scope);}  ;                           
labels: labels T_COMMA label
                            | label                        ;
if_statement: T_IF T_LPAREN expression T_RPAREN label T_COMMA label T_COMMA label
                            | T_IF T_LPAREN expression T_RPAREN simple_statement ;
subroutine_call: T_CALL variable                            ;
io_statement: T_READ read_list
                            | T_WRITE write_list            ;
read_list: read_list T_COMMA read_item
                            | read_item                     ;
read_item: variable
                            | T_LPAREN read_list T_COMMA T_ID T_ASSIGN iter_space T_RPAREN   {hashtbl_insert(hashtbl, $4, NULL, scope);}  ;
iter_space: expression T_COMMA expression step              ;
step: T_COMMA expression
                            | %empty { }                    ;
write_list: write_list T_COMMA write_item
                            | write_item                    ;
write_item: expression
                            | T_LPAREN write_list T_COMMA T_ID T_ASSIGN iter_space T_RPAREN  {hashtbl_insert(hashtbl, $4, NULL, scope);} 
                            | T_STRING                      ;
compound_statement: branch_statement
                            | loop_statement                ;
branch_statement: T_IF T_LPAREN expression T_RPAREN T_THEN {scope++;} body tail {hashtbl_get(hashtbl, scope);scope--;};
tail: T_ELSE {scope++;} body T_ENDIF  {hashtbl_get(hashtbl, scope);scope--;}
                            | T_ENDIF {hashtbl_get(hashtbl, scope);scope--;}                     ;
loop_statement: T_DO {scope++;} T_ID  {hashtbl_insert(hashtbl, $3, NULL, scope);} T_ASSIGN iter_space body   T_ENDDO      {hashtbl_get(hashtbl, scope);scope--;}  ;
subprograms:  subprograms  {scope++;}  subprogram 
                            | %empty { }                    ;
subprogram: header body T_END {hashtbl_get(hashtbl, scope);scope--;}
                            | header body error     {yyerror ("Wrong use in subprogram"); yyerrok;}             ;
header:  type T_FUNCTION T_ID T_LPAREN formal_parameters T_RPAREN                    {hashtbl_insert(hashtbl, $3, NULL, scope);} 
                            | T_SUBROUTINE T_ID T_LPAREN formal_parameters T_RPAREN {hashtbl_insert(hashtbl, $2, NULL, scope);} 
                            | T_SUBROUTINE T_ID                                      {hashtbl_insert(hashtbl, $2, NULL, scope);} 
                            | error T_ID            {yyerror ("Wrong use in header"); yyerrok;}  
                            | T_SUBROUTINE error    {yyerror ("Wrong use in header"); yyerrok;}
                            | error error           {yyerror ("Wrong use in header"); yyerrok;};
formal_parameters: type vars T_COMMA formal_parameters
                            | type vars 
                            | error vars            {yyerror ("Wrong use in header"); yyerrok;} 
                            | type error            {yyerror ("Wrong use in header"); yyerrok;} ;

%%

int main(int argc, char *argv[]){
	int token;        

    
    if(!(hashtbl = hashtbl_create(10, NULL))){
        puts("Error, failed to initialize");
        return EXIT_FAILURE;
    }
	/* Διάβασε αρχείο */
	if(argc > 1){       
		yyin = fopen(argv[1], "r");
		if (yyin == NULL){
			perror ("[ERROR] Could not open file"); 
			return EXIT_FAILURE;
		}
	}        

	yyparse();

	fclose(yyin);
    hashtbl_destroy(hashtbl);
    return 0;
}

