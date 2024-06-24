#!/bin/bash
tPath=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cat << EOF > "$tPath/toolconfig.json"
{
  "Binaries" : {
		"z3" : {
			"path" : "$tPath/solverbin/z3"
		},
		"cvc5" : {
				"path" : "$tPath/solverbin/cvc5"
		},
		"ostrich" : {
				"path" : "$tPath/../ostrich/ostrich"
		},
		"ostrichcea" : {
				"path" : "$tPath/../ostrich/ostrichCEA"
		}
  }
}
EOF
