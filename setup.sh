#!/usr/bin/env bash
set -e

UPSTREAM_URL=$(grep "^upstreamUrl=" gradle.properties | cut -d'=' -f2 | tr -d '[:space:]')
UPSTREAM_REF=$(grep "^upstreamRef=" gradle.properties | cut -d'=' -f2 | tr -d '[:space:]')

if [ -z "$UPSTREAM_URL" ] || [ -z "$UPSTREAM_REF" ]; then
    echo "ERROR: upstreamUrl or upstreamRef not found in gradle.properties"
    exit 1
fi

if [ ! -d "src/.git" ]; then
    echo "Cloning upstream ($UPSTREAM_URL)..."
    git -c core.autocrlf=false clone "$UPSTREAM_URL" src
    git -C src config core.autocrlf false
else
    echo "src/ already exists, fetching latest..."
    git -C src fetch origin
fi

echo "Checking out upstream ref: $UPSTREAM_REF"
git -C src checkout -f "$UPSTREAM_REF"
git -C src am --abort 2>/dev/null || true

# Ensure git identity is set for 'git am'
if [ -z "$(git -C src config user.email)" ]; then
    echo "Setting temporary git identity..."
    git -C src config user.email "patcher@example.com"
    git -C src config user.name "Patcher"
fi

PATCHES=$(ls patches/*.patch 2>/dev/null | sort)
if [ -z "$PATCHES" ]; then
    echo "No patches found — setup complete (clean upstream)."
    exit 0
fi

echo "Applying patches..."
for patch in $PATCHES; do
    echo "  -> $patch"
    git -C src am --ignore-whitespace "../$patch" || {
        echo ""
        echo "CONFLICT: Failed to apply $patch"
        echo "Go into src/, resolve conflicts, then run:"
        echo "  git -C src add -A && git -C src am --continue"
        exit 1
    }
done

echo ""
echo "Done! Source is ready in src/"
echo "To build: cd src && ./gradlew build"
