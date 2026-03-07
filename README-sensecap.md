# SenseCAP D1S Fork README

This file documents the current working pattern for this fork and the immediate cleanup/refactor plan.

## Current State (March 7, 2026)

- Active device entrypoint in repo: `sensecap-d1s-v2-001.yaml`
- SenseCAP modules are in `common/`, `pages/`, `buttons/`, `widgets/`, `hardware/`
- Demo package calls in `sensecap-d1s-v2-001.yaml` (`button_1`, `button_4`, `button_4_page`) are disabled
- Font include paths in `common/fonts-sensecap.yaml` now use `assets/fonts/Nunito-SemiBold.ttf`
- Unused experimental files were moved under `archive/`

## Repo Rules (SenseCAP Fork)

1. Edit only inside this repo path: `/config/esphome/esphome-modular-lvgl-buttons`
2. Keep upstream template-safe patterns where possible
3. Prefer `-sensecap` fork-owned files for active custom behavior
4. Keep HA entity bindings centralized in `common/ha_entities-sensecap.yaml`
5. Keep page layout concerns in `pages/*-sensecap.yaml`
6. Keep reusable behavior in `buttons/*-sensecap.yaml` only when it clearly reduces duplication

## Current Structure (Recommended)

- `common/ha_entities-sensecap.yaml`
  - Entity IDs + default UI values (text/icon/on-off colors/value strings)
  - No page-specific coordinates

- `pages/*-sensecap.yaml`
  - Grid/layout/font/alignment/page-level defaults
  - Slot placement and page-specific show/hide behavior

- `common/core_ha_common-sensecap.yaml`
  - Shared HA sensors/binary sensors and update logic

- `sensecap-d1s-v2-001.yaml`
  - Device composition only (`packages:` includes, hardware include, device wiring)

## What Was Archived

Moved to `archive/` because they were not referenced by active YAML:

- `buttons/override_button_tile-sensecap.yaml`
- `common/ha_entities_substitutions-sensecap.yaml`
- `common/ha_entity_mapping-sensecap.yaml`
- `common/ha_runtime-sensecap.yaml`
- `example_code/sensecap_phase1_shell_validate-sensecap.yaml`
- `pages/lighting_dimmers_grid_2-sensecap.yaml`
- `pages/thermostat_v2_element-sensecap.yaml`

## Immediate Next Steps

1. Stabilize compile baseline
- Keep validation clean on `sensecap-d1s-v2-001.yaml`
- Remove/resolve any stale references introduced by earlier experiments

2. Dani + Sleepy pilot refactor
- Keep entity defaults in `common/ha_entities-sensecap.yaml`
- Keep home slot layout in `pages/home_grid-sensecap.yaml`
- Avoid nested/dotted substitution maps

3. One-to-many mapping phase
- Add a clean page mapping file with flat keys only
- Map `page + slot -> entity key`
- Keep layout ownership in page files

4. Expand pattern entity-by-entity
- Move additional overrides/dimmer entities into the same model after Dani/Sleepy is stable

## Validation Commands

```powershell
# Validate repo entrypoint
esphome config /config/esphome/esphome-modular-lvgl-buttons/sensecap-d1s-v2-001.yaml

# Optional: scan for deprecated custom_components references in repo
rg -n "custom_components" /config/esphome/esphome-modular-lvgl-buttons --glob "!archive/**"
```

## Working With AI/GPT/Codex

Use this block at the top of prompts:

```text
Hard constraints (must follow):
1 Scope: ONLY edit/read under /config/esphome/esphome-modular-lvgl-buttons. Exception is that you can read any files given to you in their given location.
2 Do NOT touch /config/esphome root files unless you explicitly say so.
3 Preserve upstream template files; only change -sensecap/fork-owned files unless you explicitly approve.
4 Before any non-trivial change: state exact files to be touched.
5 If a command needs access outside repo scope or elevated permissions, ask first.
6 After changes: report exactly what changed and run only the validations you requested.
7 If any rule conflicts, stop and ask.
8 Prefer apply_patch for YAML edits (no string-escape side effects).
9 If using PowerShell, avoid writing escaped newline text; use here-strings and literal text blocks.
10 Add a quick check after edits: search for literal `r`n in edited YAML files.
11 Validate immediately after each edit batch (small batches, not big scripted rewrites).
```

## Image Assets

- SenseCAP image assets folder: `images/sensecap/`
