#!/bin/bash
# ============================================================
# build.sh — Compile Hopixel Roleplay (GM.pwn -> GM.amx)
# Compiler: pawncc 3.10.10 resmi (pawn-lang) untuk Linux.
# ============================================================
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
TOOLS="${ROOT}/tools/pawncc"
PAWNCC="${PAWNCC:-${TOOLS}/pawncc}"
INCLUDE="${ROOT}/pawno/include"
GMDIR="${ROOT}/gamemodes"
SOURCE="${GMDIR}/GM.pwn"
OUTPUT="${GMDIR}/GM.amx"

# -O2  optimasi penuh        -d3  debug symbols (crashdetect)
# -i.  agar #include "MODUL.pwn" relatif ke folder gamemodes terbaca
FLAGS="-O2 -d3 -;+ -(+"

cd "${GMDIR}"
echo ">> Compiling GM.pwn (O2, d3)..."
LD_LIBRARY_PATH="${TOOLS}:${LD_LIBRARY_PATH}" \
    "${PAWNCC}" "${SOURCE}" -i"${INCLUDE}" -i. -o"${OUTPUT}" ${FLAGS} 2>&1 | tee "${ROOT}/build.log"

if [ -s "${OUTPUT}" ]; then
    echo ">> SUCCESS: GM.amx ($(stat -c%s "${OUTPUT}") bytes)"
    echo ">> Errors : $(grep -cE 'error [0-9]' "${ROOT}/build.log" || true)"
    echo ">> Warns  : $(grep -cE 'warning [0-9]' "${ROOT}/build.log" || true)"
else
    echo ">> FAILED: GM.amx kosong / tidak terbentuk"
    exit 1
fi
