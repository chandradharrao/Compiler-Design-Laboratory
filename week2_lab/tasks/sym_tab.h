#define CHAR 1
#define INT 2
#define FLOAT 3
#define DOUBLE 4

typedef struct symbol{		
	char* name;			//identifier name
	int size;			//storage size of identifier name
	int type;			//identifier type
	char* val;			//value of the identifier
	int line;			//declared line number
	int scope;			//scope of the variable
	struct symbol* next;
}symbol;

typedef struct table{		
	symbol* head;
	symbol* tail;
}table;

extern table* t;

void init_table();	//allocate space for start of table,thus making a new symbol table

symbol* init_symbol(char* name, int size, int type, int lineno, int scope);	//allocates space for items in the list and initialisation

int doesExist(symbol* node); //check if nde exist in symbol table

int insert_into_table(char* name, int size, int type, int lineno, int scope);	//inserts symbols into the table when declared

int insert_value_to_name(char* name,char* value);	//inserts values into the table when a variable is initialised

int check_symbol_table(char* name,int scope); //checks symbol table whether the variable has been declared or not

void display_symbol_table(void); //displays symbol table

int strEq(char* a,char* b); //are strings equal?
