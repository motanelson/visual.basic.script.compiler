grammar c;

// ==========================
// ENTRY
// ==========================
compilationUnit
    : externalDeclaration* EOF
    ;

externalDeclaration
    : functionDefinition
    | declaration
    ;

// ==========================
// DECLARATIONS
// ==========================
declaration
    : declarationSpecifiers initDeclaratorList? ';'
    ;

declarationSpecifiers
    : declarationSpecifier+
    ;

declarationSpecifier
    : storageClassSpecifier
    | typeSpecifier
    | typeQualifier
    ;

storageClassSpecifier
    : 'typedef'
    | 'extern'
    | 'static'
    | 'auto'
    | 'register'
    ;

typeSpecifier
    : 'void'
    | 'char'
    | 'short'
    | 'int'
    | 'long'
    | 'float'
    | 'double'
    | 'signed'
    | 'unsigned'
    | structSpecifier
    | enumSpecifier
    | Identifier // typedef name
    ;

typeQualifier
    : 'const'
    | 'volatile'
    ;

// ==========================
// STRUCT / ENUM
// ==========================
structSpecifier
    : ('struct' | 'union') Identifier? '{' structDeclaration* '}'
    | ('struct' | 'union') Identifier
    ;

structDeclaration
    : declarationSpecifiers structDeclaratorList ';'
    ;

structDeclaratorList
    : structDeclarator (',' structDeclarator)*
    ;

structDeclarator
    : declarator
    ;

enumSpecifier
    : 'enum' Identifier? '{' enumeratorList '}'
    | 'enum' Identifier
    ;

enumeratorList
    : enumerator (',' enumerator)*
    ;

enumerator
    : Identifier ('=' constantExpression)?
    ;

// ==========================
// DECLARATORS
// ==========================
initDeclaratorList
    : initDeclarator (',' initDeclarator)*
    ;

initDeclarator
    : declarator ('=' initializer)?
    ;

declarator
    : pointer? directDeclarator
    ;

pointer
    : '*' typeQualifier* pointer?
    ;

directDeclarator
    : Identifier
    | '(' declarator ')'
    | directDeclarator '[' constantExpression? ']'
    | directDeclarator '(' parameterTypeList? ')'
    ;

parameterTypeList
    : parameterList (',' '...')?
    ;

parameterList
    : parameterDeclaration (',' parameterDeclaration)*
    ;

parameterDeclaration
    : declarationSpecifiers declarator
    | declarationSpecifiers
    ;

// ==========================
// INITIALIZERS
// ==========================
initializer
    : assignmentExpression
    | '{' initializerList (',' )? '}'
    ;

initializerList
    : initializer (',' initializer)*
    ;

// ==========================
// FUNCTIONS
// ==========================
functionDefinition
    : declarationSpecifiers declarator compoundStatement
    ;

// ==========================
// STATEMENTS
// ==========================
compoundStatement
    : '{' blockItem* '}'
    ;

blockItem
    : declaration
    | statement
    ;

statement
    : labeledStatement
    | compoundStatement
    | expressionStatement
    | selectionStatement
    | iterationStatement
    | jumpStatement
    ;

labeledStatement
    : Identifier ':' statement
    | 'case' constantExpression ':' statement
    | 'default' ':' statement
    ;

expressionStatement
    : expression? ';'
    ;

selectionStatement
    : 'if' '(' expression ')' statement ('else' statement)?
    | 'switch' '(' expression ')' statement
    ;

iterationStatement
    : 'while' '(' expression ')' statement
    | 'do' statement 'while' '(' expression ')' ';'
    | 'for' '(' expression? ';' expression? ';' expression? ')' statement
    ;

jumpStatement
    : 'goto' Identifier ';'
    | 'continue' ';'
    | 'break' ';'
    | 'return' expression? ';'
    ;

// ==========================
// EXPRESSIONS
// ==========================
expression
    : assignmentExpression (',' assignmentExpression)*
    ;

assignmentExpression
    : conditionalExpression
    | unaryExpression assignmentOperator assignmentExpression
    ;

assignmentOperator
    : '=' | '*=' | '/=' | '%=' | '+=' | '-='
    | '<<=' | '>>=' | '&=' | '^=' | '|='
    ;

conditionalExpression
    : logicalOrExpression ('?' expression ':' conditionalExpression)?
    ;

constantExpression
    : conditionalExpression
    ;

logicalOrExpression
    : logicalAndExpression ('||' logicalAndExpression)*
    ;

logicalAndExpression
    : inclusiveOrExpression ('&&' inclusiveOrExpression)*
    ;

inclusiveOrExpression
    : exclusiveOrExpression ('|' exclusiveOrExpression)*
    ;

exclusiveOrExpression
    : andExpression ('^' andExpression)*
    ;

andExpression
    : equalityExpression ('&' equalityExpression)*
    ;

equalityExpression
    : relationalExpression (('==' | '!=') relationalExpression)*
    ;

relationalExpression
    : shiftExpression (('<' | '>' | '<=' | '>=') shiftExpression)*
    ;

shiftExpression
    : additiveExpression (('<<' | '>>') additiveExpression)*
    ;

additiveExpression
    : multiplicativeExpression (('+' | '-') multiplicativeExpression)*
    ;

multiplicativeExpression
    : castExpression (('*' | '/' | '%') castExpression)*
    ;

castExpression
    : unaryExpression
    | '(' typeName ')' castExpression
    ;

typeName
    : declarationSpecifiers
    ;

unaryExpression
    : postfixExpression
    | ('++' | '--') unaryExpression
    | ('&' | '*' | '+' | '-' | '~' | '!') unaryExpression
    | 'sizeof' unaryExpression
    | 'sizeof' '(' typeName ')'
    ;

postfixExpression
    : primaryExpression
      ( '[' expression ']'
      | '(' argumentExpressionList? ')'
      | '.' Identifier
      | '->' Identifier
      | '++'
      | '--'
      )*
    ;

primaryExpression
    : Identifier
    | Constant
    | StringLiteral
    | '(' expression ')'
    ;

argumentExpressionList
    : assignmentExpression (',' assignmentExpression)*
    ;

// ==========================
// TOKENS
// ==========================
Identifier
    : [a-zA-Z_] [a-zA-Z0-9_]*
    ;

Constant
    : IntegerConstant
    | FloatingConstant
    | CharacterConstant
    ;

IntegerConstant
    : [0-9]+
    ;

FloatingConstant
    : [0-9]+ '.' [0-9]* ([eE][+-]?[0-9]+)?
    ;

CharacterConstant
    : '\'' (~['\\\r\n] | '\\' .) '\''
    ;

StringLiteral
    : '"' (~["\\\r\n] | '\\' .)* '"'
    ;

// ==========================
// COMMENTS / WS
// ==========================
LineComment : '//' ~[\r\n]* -> skip;
BlockComment : '/*' .*? '*/' -> skip;
Whitespace : [ \t\r\n]+ -> skip;