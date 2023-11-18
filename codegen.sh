#!/bin/bash

generate_sol_file() {
    # Parameters from command line arguments
    local JSON_FILE="$1"
    local SOL_FILENAME="$2"
    local SOL_DIR="test/bytecode/"  # Modify this if needed

    # Full path for the Solidity file
    local SOL_FILE="${SOL_DIR}${SOL_FILENAME}.sol"

    # Create SOL_DIR if it does not exist
    mkdir -p "$SOL_DIR"

    # Read hex string from the JSON file and remove '0x' prefix if present
    local HEX_STRING=$(jq -r '.bytecode.object' "$JSON_FILE" | sed 's/^0x//')

    # Check if HEX_STRING is empty
    if [ -z "$HEX_STRING" ]; then
        echo "Error: Bytecode not found in JSON file."
        return 1
    fi

    # Define the Solidity contract template
    read -r -d '' SOL_TEMPLATE << EOM
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

bytes constant DeployedBytecode = hex"$HEX_STRING";
EOM

    # Write the template with bytecode to the Solidity file
    echo "$SOL_TEMPLATE" > "$SOL_FILE"

    echo "Solidity file generated at $SOL_FILE"
}

# Call the function with all command-line parameters
generate_sol_file "$@"
