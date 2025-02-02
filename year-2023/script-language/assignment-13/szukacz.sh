#!/bin/bash
# Hlib-Oleksandr Suliz, Script Language, group no.2


count_pattern_occurrences() {
    local directory="$1"
    local patterns=("${@:2}")
    local error_files=()

    find "$directory" -type f | while read -r file_path; do
        local content
        content=$(cat "$file_path" 2>/dev/null)
        for pattern in "${patterns[@]}"; do
            local count=$(grep -o -F "$pattern" <<< "$content" | wc -l)
            if [ "$count" -gt 0 ]; then
                echo "$file_path: $count $pattern occurrences"
            fi
        done
    done
}

main() {
    local directories=()
    local patterns=()

    while [ $# -gt 0 ]; do
        if [ "$1" == "-d" ]; then
            shift
            if [ $# -gt 0 ]; then
                directories+=("$1")
            else
                echo "Missing directory argument after -d option."
                return
            fi
        else
            patterns+=("$1")
        fi
        shift
    done

    if [ ${#directories[@]} -eq 0 ]; then
        echo "No directories specified. Use -d option to specify at least one directory."
        return
    fi

    for directory in "${directories[@]}"; do
        count_pattern_occurrences "$directory" "${patterns[@]}"
    done
}

main "$@"
