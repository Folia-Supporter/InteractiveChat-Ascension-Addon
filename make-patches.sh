#!/usr/bin/env bash
set -e

UPSTREAM_REF=$(grep "^upstreamRef=" gradle.properties | cut -d'=' -f2 | tr -d '[:space:]')
if [ ! -d "src/.git" ]; then echo "ERROR: Run ./setup.sh first."; exit 1; fi

COMMIT_COUNT=$(git -C src rev-list --count "$UPSTREAM_REF"..HEAD)
if [ "$COMMIT_COUNT" -eq 0 ]; then echo "No commits ahead of upstream."; exit 0; fi

echo "Rebuilding $COMMIT_COUNT patch(es)..."
rm -rf patches/ && mkdir -p patches/
git -C src format-patch "$UPSTREAM_REF"..HEAD --output-directory "../patches/"
echo "Done! Run 'git add patches/' to stage."
