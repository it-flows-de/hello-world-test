#!/usr/bin/env bash
#===============================================================================
# Name:         hello-world-test.sh
# Author:       flo.alt@it-flows.de
# Date:         2026-10-27
# Purpose:      Minimal interactive hello-world script to test the whole script
#               process (config, signed tags, GitHub, update on a server).
# Usage:        hello-world-test.sh [--help]
# Requires:     bash; runs as a normal user
# Exit codes:   0 ok | 2 usage | 3 config
#===============================================================================

set -euo pipefail

VERSION="1.0.1"
REQUIRED_CONFIG_VERSION="1"

# The only paths derived in the script: its own directory and, by convention,
# the config next to it.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"
CONFIG_FILE="${SCRIPT_DIR}/${SCRIPT_NAME}.config"

# --- Exit codes ---
EXIT_OK=0
EXIT_USAGE=2
EXIT_CONFIG=3

# Print an error message to stderr and terminate with the given exit code
die() {
    printf 'ERROR: %s\n' "$2" >&2
    exit "$1"
}

# Print usage information
usage() {
    cat <<USAGE
${SCRIPT_NAME} ${VERSION}
Prints a greeting taken from ${SCRIPT_NAME}.config.

Usage: ${SCRIPT_NAME}.sh [--help]
USAGE
}

# Abort unless the file exists and has the expected octal permissions
check_file() {
    local file="$1" expected="$2" actual
    [[ -f "${file}" ]] || die "${EXIT_CONFIG}" "Missing file: ${file}"
    actual="$(stat -c '%a' "${file}")"
    [[ "${actual}" == "${expected}" ]] \
        || die "${EXIT_CONFIG}" "Wrong permissions on ${file}: ${actual} (expected ${expected})"
}

# --- Options ---
case "${1:-}" in
    "")        ;;
    --help|-h) usage; exit "${EXIT_OK}" ;;
    *)         usage >&2; exit "${EXIT_USAGE}" ;;
esac

# --- Load config ---
check_file "${CONFIG_FILE}" 660
# shellcheck source=/dev/null
source "${CONFIG_FILE}"

# Config must match the version this script expects
[[ "${CONFIG_VERSION:-}" == "${REQUIRED_CONFIG_VERSION}" ]] \
    || die "${EXIT_CONFIG}" "CONFIG_VERSION '${CONFIG_VERSION:-unset}' does not match required '${REQUIRED_CONFIG_VERSION}'"

# Required value
[[ -n "${GREETING_NAME:-}" ]] || die "${EXIT_CONFIG}" "GREETING_NAME is not set in ${CONFIG_FILE}"

# --- Main logic ---
echo "${GREETING_TEXT:-Hello}, ${GREETING_NAME}!"
echo "Running ${SCRIPT_NAME}, version ${VERSION}"
if [[ -n "${GREETING_SUFFIX:-}" ]]; then
    echo "${GREETING_SUFFIX}"
fi

exit "${EXIT_OK}"
