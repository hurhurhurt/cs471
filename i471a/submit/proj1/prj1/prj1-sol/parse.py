#!/usr/bin/env python3

import re
import sys
from collections import namedtuple
import json

def parse(text):
    def check(kind): return lookahead.kind == kind

    def match(kind):
        nonlocal lookahead
        if (lookahead.kind == kind):
            lookahead = nextToken()
        else:
            print(f'expecting {kind} at {lookahead.id}',
                  file=sys.stderr)
            sys.exit(1)

    def nextToken():
        nonlocal index
        if (index >= len(tokens)):
            return Token('EOF', '<EOF>')
        else:
            tok = tokens[index]
            index += 1
            return tok

    def program():
        asts = []
        while (not check('EOF')):
            if check('DEF'):
                match('DEF')
                asts.append(definition())
            else:
                asts.append(conditional())
        return asts

    def definition():
        i = id1()
        match('(')
        params = formals()
        match(')')
        return Ast('DEF', i, params, conditional())

    def formals():
        ids = []
        while not check(')'):
            ids.append(id1())
            if not check(')'):
                match(',')

        t = Ast('FORMALS')
        t['kids'] = ids
        return t

    def id1():
        ast = Ast('ID')
        ast['id'] = lookahead.id
        match('ID')
        return ast
    
    def conditional():
        t = relational()
        if check('COND1'):
            match('COND1')
            t1 = conditional()
            match('COND2')
            t = Ast('?:', t, t1, conditional())
        return t

    def relational():
        t = expr()
        if check('<=') or check('<') or check('>') or check('>=') or check('==') or check('!='):
            kind = lookahead.kind
            match(kind)
            t = Ast(kind, t, relational())
        return t

    def expr():
        t = term()
        if (check('+') or check('-')):
            kind = lookahead.kind
            match(kind)
            t = Ast(kind, t, expr())
        return t
        
    def term():
        t = factor()
        if check('*') or check('/'):
            kind = lookahead.kind
            match(kind)
            t = Ast(kind, t, term())
        return t

    def factor():
        if check('-'):
            match('-')
            return Ast('-', factor())
        elif check('INT'):
            value = int(lookahead.id)
            match('INT')
            ast = Ast('INT')
            ast['value'] = value
            return ast
        elif check('ID'):
            i = id1()
            if check('('):
                match('(')
                a = actuals()
                match(')')
                return Ast('APP', i, a)
            else:
                return i
        else:
            match('(')
            value = conditional()
            match(')')
            return value
        
    def actuals():
        expressions = []
        while not check(')'):
            expressions.append(conditional())
            if not check(')'):
                match(',')
        t = Ast('ACTUALS')
        t['kids'] = expressions
        return t


    #begin parse()
    tokens = scan(text)
    index = 0
    lookahead = nextToken()
    value = program()
    if (not check('EOF')):
        print(f'expecting <EOF>, got {lookahead.lexeme}', file=sys.stderr)
        sys.exit(1)
    return value

def scan(text):
    def next_match(text):
        #Conditional
        m = re.compile(r'\?').match(text)
        if (m): return (m, 'COND1')
        m = re.compile(r'\:').match(text)
        if (m): return (m, 'COND2')

        # Relational
        m = re.compile(r'<=').match(text)
        if (m): return (m, '<=')
        m = re.compile(r'>=').match(text)
        if (m): return (m, ">=")
        m = re.compile(r'==').match(text)
        if (m): return (m, '==')
        m = re.compile(r'!=').match(text)
        if (m): return (m, '!=')
        m = re.compile(r'<').match(text)
        if (m): return (m, "<")
        m = re.compile(r'>').match(text)
        if (m): return (m, ">")
        
        # Others
        m = re.compile(r'def').match(text)
        if (m): return (m, 'DEF')
        m = re.compile(r'#.*|\s+').match(text)
        if (m): return (m, None)
        m = re.compile(r'^[a-zA-Z_][a-zA-Z_\d+]*').match(text)
        if (m): return (m, 'ID')
        m = re.compile(r'\d+').match(text)
        if (m): return (m, 'INT')
        m = re.compile(r'\*\*|.').match(text)  #must be last: match any char
        if (m): return (m, m.group())

    tokens = []
    while (len(text) > 0):
        (match, kind) = next_match(text)
        lexeme = match.group()
        if (kind): tokens.append(Token(kind, lexeme))
        text = text[len(lexeme):]
    return tokens

def main():
    if (len(sys.argv) != 2): usage();
    contents = readFile(sys.argv[1]);
    asts = parse(contents)
    print(json.dumps(asts, separators=(',', ':')))

def readFile(path):
    with open(path, 'r') as file:
        content = file.read()
    return content


def usage():
    print(f'usage: {sys.argv[0]} DATA_FILE')
    sys.exit(1)

#use a dict so that we can add attributes dynamically
def Ast(tag, *kids):
    return { 'tag': tag, 'kids': kids }

Token = namedtuple('Token', ['kind', 'id'])

if __name__ == "__main__":
    main()
