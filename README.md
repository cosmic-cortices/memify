# memify — skill distribution

This repo ships the **memify skill** at `skills/memify/`. The currently
shipped artifact is a **mock / test double**: it exists to prove the
install-and-verify loop works before the real memify behavior ships. It is
minimal, deterministic, and its one assertion exercises the whole load path
(skill discovered → script executed → relative bundled reference resolved from
the fresh clone).

This document is written for **consumers** — end users who want to install and
verify memify. Repo/project dev docs live in `AGENTS.md`.

> License: **proprietary (all rights reserved)**. Anyone with access to this
> repo may install the skill; access control stays with repository access. May
> be re-licensed permissively later.

## The mock's deterministic behavior

Installing the skill and invoking `/memify` runs a tiny bundled script that
reads its own shipped reference file (`skills/memify/references/seed.txt`) and
prints one line whose digest is a pure function of that file:

```
memify mock: 8906398032dde470be84eebdeed8b492a159ba407b36be03c1ce9271637350a8
```

Identical input → identical output. If the relative reference did not resolve
from the clone, the script exits with an error instead of printing a digest —
so a passing verify genuinely proves the full load path shipped.

## Install — pi (primary)

Install from this repo's Git URL. `main` is the default and yields the
canonical skill:

```sh
# project-local
pi install git:gitlab.com/cosmic.cortices/memify

# or global
pi install -g git:gitlab.com/cosmic.cortices/memify
```

### Pin an exact version

To pin a reproducible install, point at a specific git ref — a semver tag or a
commit:

```sh
pi install git:gitlab.com/cosmic.cortices/memify@0.1.0     # semver tag
pi install git:gitlab.com/cosmic.cortices/memify@<commit>  # specific commit
```

This is the flywheel for a future registry (skills.sh) publication: semver git
tags are the mechanism, and a known-good tag stays retrievable later.

### Install an unmerged change during development

To verify a change that is not yet on `main`, install from the specific branch
without touching `main`:

```sh
pi install git:gitlab.com/cosmic.cortices/memify@<branch>
```

## Install — other harnesses (copy/symlink)

pi is one harness. The skill follows the standard Agent Skills layout
(`skills/memify/SKILL.md`, folder name == `metadata.name`), so it installs by
directory into any harness. The shared cross-harness home is `~/.agents/skills/`;
the major harnesses read their own locations:

- **Claude Code** — copy/symlink into `~/.claude/skills/`:
  ```sh
  mkdir -p ~/.claude/skills
  ln -s "$PWD/skills/memify" ~/.claude/skills/memify   # or cp -r
  ```
- **Codex / Cursor / Zed** & **any-harness shared** — copy/symlink into `~/.agents/skills/`:
  ```sh
  mkdir -p ~/.agents/skills
  ln -s "$PWD/skills/memify" ~/.agents/skills/memify   # or cp -r
  ```

Copying instead of symlinking is fine if you prefer a snapshot over a live
link.

## Verify an install

After installing, invoke `/memify` (`/skill:memify` in some harnesses) and
assert the mock's exact output (the digest above). A fresh install must
reproduce it, proving the shipped assets actually loaded.

## Development skills are not shipped

This repo is also a project that uses 29 development skills under `.pi/skills/`.
That path is a dot-directory, which pi's install discovery skips — so those
dev tooling skills never leak into the shipped product. The product lives in
the non-dot `skills/memify/` path.

## What happens next

After this mock is verified end-to-end, the real memify skill is built behind
the same layout, and publication to a registry (skills.sh) is then a matter of
semver tags — prepared for here, not executed.