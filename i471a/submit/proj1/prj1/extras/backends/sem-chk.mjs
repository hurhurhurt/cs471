#!/usr/bin/env node

import fs from 'fs';
import Path from 'path';


function checkExpr(expr, defs, env=[], fn='') {
  const errors = [];
  switch (expr.tag) {
    case 'APP': {
      const fn = expr.kids[0].id;
      const actuals = expr.kids[1].kids;
      if (!defs[fn]) {
	errors.push(`call to unknown function ${fn} ` +
		    (fn ? `in function ${fn}()` : 'at top level'));
      }
      else if (actuals.length !== defs[fn].arity) {
	errors.push(`incorrect # of args in call to ${fn}: ` +
		    `actual ${actuals.length}, expected ${defs[fn].arity}`);
      }
      for (const e of actuals) errors.push(...checkExpr(e, defs, env, fn));
      break;
    }
    case 'ID': 
      if (!env.includes(expr.id)) {
	errors.push(`unknown id ${expr.id} ` +
		    (fn ? `in function ${fn}()` : 'at top level'));
      }
      break;
    default:
      for (const e of expr.kids) errors.push(...checkExpr(e, defs, env, fn));
      break;
  }
  return errors;
}


function defsInfo(defAsts) {
  const infos = {}
  for (const def of defAsts) {
    const name = def.kids[0].id;
    const formals = def.kids[1].kids.map(k => k.id);
    const arity = formals.length;
    const expr = def.kids[2];
    infos[name] = { name, formals, arity, expr };
  }
  return infos;
}

const CHAR_SET = 'utf8'
function main() {
  const text = fs.readFileSync(0, CHAR_SET);
  const asts = JSON.parse(text);
  const defAsts = asts.filter(t => t.tag === 'DEF');
  const exprAsts = asts.filter(t => t.tag !== 'DEF');
  const defs = defsInfo(defAsts);
  const errors = [];
  for (const defInfo of Object.values(defs)) {
    const defErrors =
      checkExpr(defInfo.expr, defs, defInfo.formals, defInfo.name);
    errors.push(...defErrors);
  }
  for (const expr of exprAsts) {
    errors.push(...checkExpr(expr, defs));
  }
  errors.forEach(e => console.error(e));
}

main();
