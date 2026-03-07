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

## Upstream vs SenseCAP Fork Surface

### Upstream components currently in use

- `sensors/sensors_base.yaml` (base runtime/device sensors)
- `buttons/time_button.yaml` (time tile behavior)
- `buttons/page_button.yaml` (navigation/page jump tile behavior)
- `buttons/switch_button-sensecap.yaml` (forked from upstream switch pattern)
- `buttons/dimmer_light_button-sensecap.yaml` (forked from upstream dimmer pattern)
- `pages/loading_480px-sensecap.yaml` (loading flow based on upstream loading pattern)
- `pages/info-sensecap.yaml` (info page based on upstream info pattern)

### SenseCAP-added modules and patterns

- `widgets/topbar-sensecap.yaml` (SenseCAP top status/navigation strip)
- `widgets/bottom_nav-sensecap.yaml` (SenseCAP bottom nav bar)
- `pages/display_settings-sensecap.yaml` (display control page; SenseCAP variation of backlight-time behavior)
- `pages/thermostat_v2_lvgl-sensecap.yaml` (SenseCAP thermostat UI/control flow)
- New SenseCAP page templates/layouts in `pages/*-sensecap.yaml` (home/menu/overrides/sensors/lighting/fans shells)

### HA/UI mapping setup (current model)

The fork uses a two-layer mapping model to reduce cross-file editing:

- `common/ha_entities-sensecap.yaml`
  - Canonical HA entity bindings (`ent_*`)
  - Default UI values per entity (`ui_*` for text/icon/on-off colors/value text)

- `common/page_mapping-sensecap.yaml`
  - Page/slot mapping layer (home-slot references and page-facing UI wiring)
  - Keeps page-specific slot assignment separate from entity defaults

- `pages/*-sensecap.yaml`
  - Page layout ownership only (grid, alignment, spacing, fonts)
  - Consumes mapping/default vars instead of hardcoding entity details where possible

## Current Cleanup Status and Page Layout Inventory

The SenseCAP fork is still actively cleaning up both:

- overall configuration structure (entity mapping, page mapping, package boundaries)
- page-level UI consistency (tile behavior, spacing, visibility defaults, and state styling)

This means layout/schema may continue to evolve while keeping root validation green.

### Specific page layouts currently in use

- `pages/home_grid-sensecap.yaml`
  - Home page layout: `3 x 3` grid (`FR(1)` rows x `FR(1)` columns)

- `pages/menu_grid-sensecap.yaml`
  - Menu content container layout: `4 x 3` grid

- `pages/overrides_grid-sensecap.yaml`
  - Overrides page layout: title row + `4` content rows (`5` total rows)
  - Columns: `2`
  - Tile internals use `content, fr(1), content` (icon, text, value)

- `pages/lighting_dimmers_grid_template-sensecap.yaml`
  - Dimmers page layout template: title row + `4` content rows (`5` total rows)
  - Columns: `4`

- `pages/lighting_switches_grid-sensecap.yaml`
  - Lighting switches layout: title row + `3` content rows (`4` total rows)
  - Columns: `2`

- `pages/sensors_grid-sensecap.yaml`
  - Sensors page base layout: `3 x 3` grid
  - Widgets are populated by sensor button includes

- `pages/display_settings-sensecap.yaml`
  - Display settings page uses free-positioned controls inside a page container (non-uniform grid UI)

- `pages/fans_grid-sensecap.yaml`
  - Fans page uses free-positioned controls/cards (non-uniform grid UI)

- `pages/wifi_setup-sensecap.yaml`
  - WiFi setup page uses fixed-position card widgets (non-grid form layout)

- `pages/info-sensecap.yaml`
  - Info page content uses a `10-row x 2-column` grid inside the main card

- `pages/thermostat_v2_lvgl-sensecap.yaml`
  - Thermostat page uses custom positioned controls (arc + labels + dropdowns), not a fixed tile grid
