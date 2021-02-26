export default {
  $Ignore: /\/\/.*|\s+/,  //this will be ignored.
  ID: /^[a-zA-Z_][a-zA-Z_\d+]*/,
  INT: /\d+/,      //token with kind INT        
  CHAR: /./,       //single char: must be last
};
