#!/bin/sh -l
# All positional arguments are passed directly to flawfinder.
# Output filename is read from FLAWFINDER_OUTPUT env var.

output="${FLAWFINDER_OUTPUT:-flawfinder-output.txt}"

flawfinder "$@" > "$output"
result="$?"

cat "$output"
exit "$result"
