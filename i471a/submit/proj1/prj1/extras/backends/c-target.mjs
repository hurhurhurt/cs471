#!/usr/bin/env node

import fs from 'fs';
import Path from 'path';

function exprToC(expr) {
  const { tag, kids } = expr;
  switch (tag) {
    case '?:':
      return (
	`(${exprToC(kids[0])}) ? (${exprToC(kids[1])}) : (${exprToC(kids[2])})`
      );
    case 'INT':
      return expr.value.toString();
    case 'ID':
      return expr.id;
    case 'APP':
      return `${kids[0].id}(${actualsToC(kids[1])})`;
    default:
      if (kids.length === 1) {
	return `(${tag} ${exprToC(kids[0])})`;
      }
      else {
	return `(${exprToC(kids[0])} ${tag} ${exprToC(kids[1])})`;
      }
  }
}

function actualsToC(actuals) {
  let cText = '';
  const exprs = actuals.kids;
  for (const [i, e] of exprs.entries()) {
    cText += exprToC(e);
    if (i < exprs.length - 1) cText += ', ';
  } 
  return cText;
}

function defProtoToC(def) {
  let cText = `static int ${def.kids[0].id}(`; 
  const formals = def.kids[1].kids;
  for (const [i, f] of formals.entries()) {
    cText += `int ${f.id}`;
    if (i < formals.length - 1) cText += ', ';
  } 
  cText += `)`;
  return cText;
}

function defToC(def) {
  let cText = defProtoToC(def);
  cText += `{\n  return `;
  cText += exprToC(def.kids[2]);
  cText += ';\n}\n\n';
  return cText;
}

const CHAR_SET = 'utf8'
function main() {
  const text = fs.readFileSync(0, CHAR_SET);
  const asts = JSON.parse(text);
  const defs = asts.filter(t => t.tag === 'DEF');
  const exprs = asts.filter(t => t.tag !== 'DEF');
  let cText = '#include <stdio.h>\n\n';
  for (const def of defs) cText += defProtoToC(def) + ';\n';
  for (const def of defs) cText += defToC(def);
  cText += `int main() {\n`;
  for (const expr of exprs) {
    cText += `  printf("%d\\n", `;
    cText += exprToC(expr);
    cText += ');\n';
  }
  cText += `}\n`;
  console.log(cText);
}

main();
