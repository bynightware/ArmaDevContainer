#!/usr/bin/env bash
set -u

errors=0
warnings=0

error() {
    printf 'ERROR: %s\n' "$1" >&2
    errors=$((errors + 1))
}

warning() {
    printf 'WARNING: %s\n' "$1" >&2
    warnings=$((warnings + 1))
}

check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        error "required command is unavailable: $1"
    fi
}

printf 'Checking Arma development container\n'
printf 'Architecture: %s\n' "$(dpkg --print-architecture 2>/dev/null || uname -m)"

check_command git
check_command hemtt
check_command wineboot

if [ ! -x /usr/lib/wine/wine64 ] && ! command -v wine64 >/dev/null 2>&1; then
    error 'Wine64 runtime is unavailable'
fi
if ! command -v wine >/dev/null 2>&1; then
    error 'neither wine nor wine64 is available'
fi

if ! dpkg --print-foreign-architectures 2>/dev/null | grep -qx i386; then
    error 'i386 architecture is not enabled'
fi

if [ "${WINEPREFIX:-}" != "/home/vscode/.wine" ]; then
    error "WINEPREFIX must be /home/vscode/.wine, got: ${WINEPREFIX:-unset}"
fi

if [ ! -d "${WINEPREFIX:-/home/vscode/.wine}" ]; then
    error "Wine prefix does not exist: ${WINEPREFIX:-/home/vscode/.wine}"
fi

if [ -n "${HEMTT_BI_TOOLS:-}" ]; then
    if [ ! -d "$HEMTT_BI_TOOLS" ]; then
        warning "HEMTT_BI_TOOLS is not mounted: $HEMTT_BI_TOOLS"
    else
        found_tool=0
        for tool in Binarize.exe AddonBuilder.exe MakePbo.exe; do
            if find "$HEMTT_BI_TOOLS" -iname "$tool" -print -quit 2>/dev/null | grep -q .; then
                printf 'Found BI tool: %s\n' "$tool"
                found_tool=1
            fi
        done
        if [ "$found_tool" -eq 0 ]; then
            warning "no expected BI executable found below: $HEMTT_BI_TOOLS"
        fi
    fi
else
    warning 'HEMTT_BI_TOOLS is not set'
fi

printf 'Checks completed with %s error(s) and %s warning(s)\n' "$errors" "$warnings"
exit "$errors"
