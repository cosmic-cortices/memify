---
name: memify
description: Deterministic shippability mock for the memify skill. Invoking this skill runs scripts/mock.sh, which reads its bundled references/seed.txt from the clone and prints a fixed, reproducible line — `memify mock: <sha256 of the seed>`. Use it to verify that an install from this repo's Git URL actually loaded the shipped skill, executed its script, and resolved its relative bundled reference. This is a test double, not the real memify behavior.
license: proprietary
metadata:
  version: 0.1.0
---

# memify (mock)

This is a **mock / test double**. It does not implement the real memify
behavior, which is intentionally withheld. It exists so the install-and-verify
shippability loop is honest: a fresh install must prove skill discovery, script
execution, and relative-reference resolution all at once, with deterministic
output.

## What it does

Invoke this skill and it executes its tiny bundled script. The script reads the
bundled seed file that ships alongside it and prints one deterministic line:

```
memify mock: <sha256 of references/seed.txt>
```

The output is a function of the shipped seed only — identical input, identical
output. If the skill was installed but its relative assets were not fetched
(or resolution broke), the script fails loudly instead of printing a digest.

## To verify an install

1. Install this repo's skill from its Git URL (see the top-level `README.md`
   for per-harness commands; pi: `pi install git:gitlab.com/cosmic.cortices/memify`).
2. Invoke `/memify`.
3. Assert the exact output:

   ```
   memify mock: 8906398032dde470be84eebdeed8b492a159ba407b36be03c1ce9271637350a8
   ```

   The mock output above is computed from the seed committed with this skill;
   a fresh install must reproduce it exactly, which also proves the bundled
   reference loaded from the clone.

## Files

- `SKILL.md` — this file (name `memify`, folder name `memify`).
- `scripts/mock.sh` — the deterministic script (bash).
- `references/seed.txt` — the bundled reference the script reads.

## Scope

This mock ships for distribution testing only. The real memify behavior is
out of scope and withheld. It is not discoverable under `.pi/skills/` because
those development skills are in a dot-directory and are excluded from the
shipped product; this artifact lives in the non-dot `skills/memify/` path.