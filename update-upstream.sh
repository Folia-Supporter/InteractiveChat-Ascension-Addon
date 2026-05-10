#!/usr/bin/env bash
set -e

OLD_REF=$(grep "^upstreamRef=" gradle.properties | cut -d'=' -f2 | tr -d '[:space:]')
if [ ! -d "src/.git" ]; then echo "ERROR: Run ./setup.sh first."; exit 1; fi

echo "Fetching upstream..."
git -C src fetch origin
NEW_REF=$(git -C src rev-parse origin/master)

if [ "$OLD_REF" = "$NEW_REF" ]; then
    echo "Already up to date (${OLD_REF:0:12})"
    exit 0
fi

echo "Rebasing onto new upstream: ${OLD_REF:0:12} -> ${NEW_REF:0:12}"
git -C src rebase --onto "$NEW_REF" "$OLD_REF" || {
    echo "CONFLICT: resolve in src/, then: git -C src add -A && git -C src rebase --continue"
    exit 1
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/^upstreamRef=.*/upstreamRef=$NEW_REF/" gradle.properties
else
    sed -i "s/^upstreamRef=.*/upstreamRef=$NEW_REF/" gradle.properties
fi

./make-patches.sh
git add gradle.properties patches/
git commit -m "Update upstream to ${NEW_REF:0:12}"
echo "Done!"
