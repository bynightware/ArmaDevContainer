#!/usr/bin/env bash
set -u

prefix="${WINEPREFIX:-/home/vscode/.wine}"
mkdir -p "$prefix"

if [ "$(stat -c '%u' "$prefix")" -ne "$(id -u)" ]; then
    if command -v sudo >/dev/null 2>&1; then
        sudo -n chown -R "$(id -u):$(id -g)" "$prefix"
    else
        printf 'WARNING: Wine prefix is not owned by the current user and sudo is unavailable\n' >&2
    fi
fi

if [ ! -f "$prefix/system.reg" ]; then
    printf 'Initializing Wine prefix: %s\n' "$prefix"
    if ! WINEPREFIX="$prefix" wineboot --init; then
        printf 'WARNING: Wine prefix initialization failed\n' >&2
    fi
fi

/usr/local/bin/arma-verify-container
