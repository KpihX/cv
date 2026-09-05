#!/bin/sh
# check-dashes — fail if any tracked .tex file contains an em-dash (---)
# outside of comment lines (%...). Usage: sh scripts/check-dashes.sh
# (also wired into `make check`)
set -eu
fail=0
for f in $(git ls-files '*.tex'); do
	hits=$(grep -v '^[[:space:]]*%' "$f" | grep -n -- '---' || true)
	if [ -n "$hits" ]; then
		echo "$hits" | sed "s|^|$f:|"
		fail=1
	fi
done
if [ "$fail" = 1 ]; then
	echo "check-dashes FAILED: em-dash (---) found above — use -- instead" >&2
	exit 1
else
	echo "check-dashes OK: no em-dash in .tex files"
fi
