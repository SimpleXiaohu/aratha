#!/bin/bash
tPath=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cat << EOF > "$tPath/toolconfig.json"
{
  "z3" : {
    "path" : "$tPath/solverbin/z3/z3"
  },
  "cvc5" : {
      "path" : "$tPath/solverbin/cvc5/cvc5"
  },
  "z3str" : {
      "path" : "$tPath/solverbin/z3str/z3"
  },
  "ostrich" : {
      "path" : "$tPath/../ostrich/ostrich"
  },
  "ostrichcea" : {
      "path" : "$tPath/../ostrich/ostrichCEA"
  }
}
EOF
