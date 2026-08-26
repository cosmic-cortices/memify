#!/usr/bin/env bash
# memify mock — deterministic shippability test double.
#
# This is NOT the real memify skill. It exists solely so the install-and-verify
# loop is honest: invoking this skill must prove that (a) the skill was loaded,
# (b) its relative bundled reference resolved from the clone, and (c) output is
# deterministic.
#
# It resolves references/seed.txt relative to this script's own location, so it
# works regardless of the caller's working directory and verifies the shipped
# asset actually loaded rather than a stray file elsewhere on disk.

set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
seed="${here}/../references/seed.txt"

if [[ ! -r "${seed}" ]]; then
  echo "memify mock: ERROR missing bundled reference ${seed}" >&2
  exit 1
fi

digest="$(sha256sum "${seed}" | awk '{print $1}')"

echo "memify mock: ${digest}"