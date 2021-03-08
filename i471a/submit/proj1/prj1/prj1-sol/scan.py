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
            print(f'expecting {kind} at {lookahead.lexeme}',
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
        tokens = []
        while not check('EOF'):
            tokens.append(expr())
            match(';')
        return tokens

    def expr():
        t = term()
        while check('+') or check('-'):
            kind = lookahead.kind
            match(kind)
            t1 = expr()
        return t1

    def term():
        t = factor()
        if check('*') or check('/'):
            kind = lookahead.kind
            match(kind)
            t1 = term()
        return t

    def factor():
        if check('INT'):
            value = int(lookahead.lexeme)
            match('INT')
            return value
        elif check('-'):
            match('-')
            return -factor()
        else:
            match('(')
            value = expr()
            match(')')
        return value

    #begin parse
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

        # Others
        if (m): return (m, ">")
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
    tokens.append(Token("<EOF>",  "<EOF>"))
    return tokens

def main():
    if (len(sys.argv) != 2): usage();
    contents = readFile(sys.argv[1]);
    tokens = scan(contents)
    print(json.dumps(scan(contents),separators=(',', ':')))

def readFile(path):
    with open(path, 'r') as file:
        content = file.read()
    return content

def Token(kind, lexeme):
    return {'kind': kind, 'lexeme': lexeme }

def usage():
    print(f'usage: {sys.argv[0]} DATA_FILE')
    sys.exit(1)

if __name__ == "__main__":
    main()
