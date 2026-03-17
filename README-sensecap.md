# SenseCAP D1S Fork README

This file documents the current working pattern for this fork and the immediate cleanup/refactor plan.

## Current State (March 7, 2026)

- Active device entrypoint in repo: `sensecap-d1s-v2-001.yaml` 
- SenseCAP modules are in `common/`, `pages/`, `buttons/`, `widgets/`, `hardware/`
- Demo package calls in `sensecap-d1s-v2-001.yaml` (`button_1`, `button_4`, `button_4_page`) are disabled
- Font include paths in `common/fonts-sensecap.yaml` now use `assets/fonts/Nunito-SemiBold.ttf`
- Unused experimental files were moved under `archive/`
- Instance mapping is centralized in `common/package_instance_mapping-sensecap-dani.yaml`
- Page title/text defaults are centralized as `ui_page_*` vars and mapped to Dani family tokens
- First cleanup pass moved reusable page/button template defaults onto canonical `ui_base_*` / `ui_sensor_*` tokens so structural defaults now resolve from one source more consistently
- Thermostat internals now follow shared theme text styles for title/labels/values; thermostat mode dropdowns use shared themed control styling, and the arc knob follows the same local mode accent as the indicator.
- Home page wiring is now normalized through generic `page0_slot*` aliases in `common/page_mapping-sensecap.yaml`; the page keeps existing behavior but no longer uses entity-named tile IDs in the active page/theme-refresh path.

## Repo Rules (SenseCAP Fork)

1. Edit only inside this repo path: `/config/esphome/esphome-modular-lvgl-buttons`
2. Keep upstream template-safe patterns where possible
3. Prefer `-sensecap` fork-owned files for active custom behavior
4. Keep HA entity bindings centralized in `common/ha_entities-sensecap-dani.yaml`
5. Keep page layout concerns in `pages/*-sensecap.yaml`
6. Keep reusable behavior in `buttons/*-sensecap.yaml` only when it clearly reduces duplication

## Current Structure (Recommended)

- `common/ha_entities-sensecap-dani.yaml`
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
- Keep entity defaults in `common/ha_entities-sensecap-dani.yaml`
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

## Working With AI/GPT/Codex/Grok xAI/Co-Pilot

Use this single consolidated rules list in prompts.

1. [Apply: Always] Scope is only `/config/esphome/esphome-modular-lvgl-buttons` (exception: read-only access to explicitly provided external files).
2. [Apply: Always] Do not touch `/config/esphome` root files unless explicitly approved.
3. [Apply: Always] Preserve upstream templates; only change fork-owned `-sensecap` files unless explicitly approved.
4. [Apply: Before non-trivial changes] State exact files to be touched.
5. [Apply: Any out-of-scope/elevated command] Ask first unless covered by always-approved rules below.
6. [Apply: After changes] Report exactly what changed.
7. [Apply: If rule conflict occurs] Stop and ask.
8. [Apply: YAML edits] Prefer `apply_patch` to avoid string-escape side effects.
9. [Apply: PowerShell writes] Use here-strings/literal blocks; avoid escaped newline text writes.
10. [Apply: After scripted/file-write edits] Scan edited YAML for literal artifacts (for example `` `r`n ``, `\\r\\n`, `\\n`).
11. [Apply: After each small edit batch] Validate immediately; avoid large unvalidated rewrite batches.
12. [Apply: Always, architecture] Keep canonical UI defaults in `common/ha_entities-sensecap-dani.yaml` (including icon glyph defaults).
13. [Apply: Page-file edits] Page files should reference `ui_*` vars plus page-level show/hide/layout choices only.
14. [Apply: Page-file edits] Avoid nested icon token substitution patterns in page blocks; use resolved defaults from entity vars.
15. [Apply: Always, architecture] Per-page overrides are allowed, but default source remains entity vars.
16. [Apply: Scripted rewrite attempts] No bulk regex rewrites on YAML; use line-targeted edits.
17. [Apply: If scripted replacement is used] Re-open each touched block before validation.
18. [Apply: UI/page edits] Hidden flags are allowed only on explicit value/state widgets unless explicitly approved.
19. [Apply: UI/page edits] Section title labels should not receive value-state hidden/color rules unless explicitly approved.
20. [Apply: Color pass] Edit control/token files first; touch page/widget files only when wiring requires it.
21. [Apply: Color pass] Keep a single `sensecap-d1s-v2-001.yaml` baseline and avoid parallel variant forks.
22. [Apply: Pre-flash] Root validation must pass: `esphome config /config/esphome/sensecap-d1s-v2.yaml`.
23. [Apply: Optional hygiene] Scan repo for deprecated `custom_components` references before major cleanup passes.
24. [Apply: Optional hygiene] Include a short drift-check summary (files touched, scans run, validate result, intentional exceptions).
25. [Apply: Always approved] Within scope, non-destructive read/search/list operations are pre-approved (for example `Get-Content`, `rg`, `Select-String`, directory listing).
26. [Apply: Always approved] Post-edit artifact scans and root validation are pre-approved.
27. [Apply: Always approved after failed validation] Error extraction and line-range inspection in touched files are pre-approved until compile is green.
28. [Apply: Always] Out-of-scope access, destructive operations, and non-scoped elevated actions still require explicit approval.
29. [Apply: Always approved] After declaring touched in-scope files, proceed through required edit + scan + validate cycles without additional confirmation prompts.
30. [Apply: Always approved] In-scope elevated commands on the network share are allowed for read/search/list/check operations.
31. [Apply: Always approved] In-scope elevated edits are allowed after declaring exact files to be touched.
32. [Apply: Always approved] Post-edit scans (artifact and drift checks) are allowed without additional confirmation.
33. [Apply: Always approved] Root validation and re-validation loops are allowed until compile is green.


36. [Apply: Always approved] After an in-scope edit batch, run self-checks on edited files (spot-checks, grep/select-string, line checks) without extra confirmation.
37. [Apply: Always approved] If a self-check finds a small in-scope issue from the same batch, apply a corrective patch and re-check without extra confirmation.
38. [Apply: Always approved] Keep duplicated rule blocks (README list and prompt block) synchronized without extra confirmation.
Prompt block (copy/paste):

```text
Hard constraints (must follow):
1 [Always] Scope only /config/esphome/esphome-modular-lvgl-buttons (except explicit read-only external files).
2 [Always] Do not touch /config/esphome root files unless explicitly approved.
3 [Always] Preserve upstream templates; change only -sensecap files unless explicitly approved.
4 [Before non-trivial change] State exact files to be touched.
5 [Out-of-scope/elevated command] Ask first unless covered by always-approved rules below.
6 [After changes] Report exact changes.
7 [Conflict] Stop and ask.
8 [YAML edits] Prefer apply_patch.
9 [PowerShell writes] Use here-strings/literal blocks.
10 [Post-edit scan] Search for literal `r`n and escaped newline artifacts in edited YAML.
11 [After each small batch] Validate.
12 [Always] Keep canonical UI defaults in ha_entities-sensecap-dani.yaml.
13 [Page edits] Pages reference ui_* vars + page-level show/hide/layout only.
14 [Page edits] Avoid nested icon token substitutions in pages.
15 [Always] Per-page overrides allowed; defaults come from entity vars.
16 [Scripted rewrites] No bulk regex YAML rewrites.
17 [If scripted replacement used] Re-open touched blocks before validate.
18 [UI/page edits] Hidden only on explicit value/state widgets unless approved.
19 [UI/page edits] No value-state color/hidden rules on section title labels unless approved.
20 [Color pass] Token/control files first, page wiring second.
21 [Color pass] Keep a single 001 baseline; avoid split 001 variants.
22 [Pre-flash] Root validate: esphome config /config/esphome/sensecap-d1s-v2.yaml.
23 [Optional hygiene] Scan for deprecated custom_components references before major cleanup passes.
24 [Optional hygiene] Include a short drift-check summary after significant edits.
25 [Always approved] In-scope non-destructive read/search/list commands do not need extra confirmation.
26 [Always approved] Post-edit artifact scans and root validation do not need extra confirmation.
27 [Always approved after failed validation] Capture error output and inspect touched file line ranges until green.
28 [Always] Out-of-scope/destructive/non-scoped elevated actions still require explicit approval.
29 [Always approved] After declaring touched in-scope files, proceed through edit + scan + validate cycles without extra confirmation.
30 [Always approved] In-scope elevated network-share read/search/list/check commands are pre-approved.
31 [Always approved] In-scope elevated edits are pre-approved after declaring exact files to be touched.
32 [Always approved] Post-edit artifact and drift scans are pre-approved.
33 [Always approved] Root validation and re-validation loops are pre-approved until compile is green.


34 [Always approved] After an in-scope edit batch, run self-checks on edited files (spot-checks, grep/select-string, line checks) without extra confirmation.
35 [Always approved] If a self-check finds a small in-scope issue from the same batch, apply a corrective patch and re-check without extra confirmation.
36 [Always approved] Keep duplicated rule blocks (README list and prompt block) synchronized without extra confirmation.
37 [Always approved] After declaring touched in-scope files, execute full edit -> self-check -> root-validate loops without re-asking.
38 [Always approved] If a touched in-scope file is accidentally damaged in the same batch, restore from its in-scope baseline counterpart, then reapply only declared changes.
39 [Always approved after failed validation] If failure is caused by the same batch, apply focused in-scope corrective patches (duplicate keys/syntax/indentation) until compile is green.
40 [Always approved] Read adjacent line ranges in touched files for diagnosis without extra confirmation.
41 [Always approved] For risky YAML rewrites, switch to deterministic line-targeted edits without extra confirmation.
42 [Maintenance] After meaningful structure, token, constraints, or workflow changes, update README-sensecap.md and CHAT_RECOVERY_PROMPT-sensecap.md in the same edit batch.
43 [Maintenance trigger] Treat docs refresh as required when 3+ config files change in a task, or when any architecture/rules decision changes.
44 [Rule hygiene] Keep constraint numbering contiguous and unique; when adding/removing rules, renumber the block in the same edit batch.
45 [Color pass DoD] Before flash, require token update + wiring update + root validate + drift scan for hardcoded color literals in touched scope.
```

## Image Assets

- SenseCAP image assets root: [images/Seed-Studio-SenseCap-D1S/](images/Seed-Studio-SenseCap-D1S/)
- Screenshots: [images/Seed-Studio-SenseCap-D1S/screen-shots/](images/Seed-Studio-SenseCap-D1S/screen-shots/)
- Color palettes: [images/Seed-Studio-SenseCap-D1S/color-palettes/](images/Seed-Studio-SenseCap-D1S/color-palettes/)

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
- `pages/display_settings-sensecap-dani.yaml` (display control page; SenseCAP variation of backlight-time behavior)
- `pages/thermostat_v2_lvgl-sensecap-dani.yaml` (SenseCAP thermostat UI/control flow)
- New SenseCAP page templates/layouts in `pages/*-sensecap.yaml` (home/menu/overrides/sensors/lighting/fans shells)

### HA/UI mapping setup (current model)

The fork uses a two-layer mapping model to reduce cross-file editing:

- `common/ha_entities-sensecap-dani.yaml`
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

Current intentional theme exception/status:

- Shared page/fan/sensor/per-entity defaults plus nav/template/static-style fallbacks now point at generic `theme_*` color IDs instead of `dani_*` IDs where cleaned; runtime theme slots 0..9 now use slot-scoped `theme_slot*` IDs instead of direct `sense_*`/`dani_*`/`split_*` color refs in the theme engine; theme change now also repaints the three stateful home tiles (`Dani`, `Sleepy`, `Bedtime`) from centralized runtime logic
- `pages/light_color-sensecap.yaml` is intentionally exempt for now and still contains hardcoded color literals
- Legacy non-`-sensecap` dimmer pages (`pages/lighting_dimmers_grid_template.yaml`, `pages/lighting_dimmers_grid.yaml`, `pages/lighting_dimmers_grid_2.yaml`) were archived to `archive/retired_baseline_2026-03-15/pages/`; active dimmer layout now comes from `pages/lighting_dimmers_grid_template-sensecap.yaml` via `common/package_instance_mapping-sensecap-dani.yaml`
- `common/core_boot-sensecap.yaml` was archived to `archive/retired_baseline_2026-03-15/common/`; the active fork uses `pages/loading_480px-sensecap.yaml` plus `common/display_runtime-sensecap.yaml` instead of the older `core_boot` orchestration path

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

- `pages/lighting_switches_grid-sensecap-dani.yaml`
  - Lighting switches layout: title row + `3` content rows (`4` total rows)
  - Columns: `2`

- `pages/sensors_grid-sensecap.yaml`
  - Sensors page base layout: `3 x 3` grid
  - Widgets are populated by sensor button includes

- `pages/display_settings-sensecap-dani.yaml`
  - Display settings page uses free-positioned controls inside a page container (non-uniform grid UI)

- `pages/fans_grid-sensecap-dani.yaml`
  - Fans page uses free-positioned controls/cards (non-uniform grid UI)

- `pages/wifi_setup-sensecap.yaml`
  - WiFi setup page uses fixed-position card widgets (non-grid form layout)

- `pages/info-sensecap.yaml`
  - Info page content uses a `10-row x 2-column` grid inside the main card

- `pages/thermostat_v2_lvgl-sensecap-dani.yaml`
  - Thermostat page uses custom positioned controls (arc + labels + dropdowns), not a fixed tile grid

## Color Palette Approach and Rule-Set

This fork uses a token-first color model so page files do not hardcode one-off hex values unless there is a specific exception.

1. Palette ownership
- Keep canonical palette tokens in `common/color-sensecap-dani.yaml` (or variant file such as `common/color-sensecap-dani.yaml`).
- Keep page files consuming semantic color vars/tokens instead of literal hex values.

2. Variant strategy (single `001` baseline)
- Goal state: use a single `sensecap-d1s-v2-001.yaml` baseline and avoid parallel variant root files.
- Theme/palette swaps should happen in control files, not by forking page logic unless strictly required.

3. Top-level defaults
- Top-level page background uses palette token `sense_bg`.
- Current Dani dark background target: `1B1A38`.
- Loading page may remain an exception if UX requires a different visual treatment.

4. Typography defaults for dark backgrounds
- Page titles on dark background should use `white` and `nunito_36` unless a page has a justified local override.

5. State color convention
- Inactive/not-selected controls use a neutral gray token.
- Active/selected controls use role-specific palette tokens (for example fan speeds, thermostat modes, direction state).
- Keep the same state-color meaning across pages so users do not relearn color semantics per page.

6. Slider convention
- Use dedicated slider tokens for on/off track and knob states.
- Apply slider colors through substitutions/vars in includes, not by duplicating button/page files.

7. Implementation rules
- Add or change colors in control files first.
- Wire page includes to tokens/vars second.
- Only fork a `-sensecap` page if upstream template constraints block token-based wiring.

8. Validation rule
- After each color batch, run root validation:
`esphome config /config/esphome/sensecap-d1s-v2.yaml`




## Page File Header Guide
- All \\pages/*-sensecap*.yaml\\ files now start with a \\PAGE EDIT GUIDE (SenseCAP)\\ comment block.
- Keep this header when creating new page files and update paths if architecture changes.


## Baseline Retirement (2026-03-10)
- Active baseline is `sensecap-d1s-v2-001.yaml`, using the `*-sensecap-dani.yaml` include set.
- Non-dani legacy variants retired in this pass were moved to:
  - `archive/retired_baseline_2026-03-10/`
- Rule going forward:
  - New color/theme/entity/page baseline updates go to `*-sensecap-dani.yaml` files.
  - Do not reintroduce retired non-dani duplicates unless explicitly required.

- 2026-03-10 cleanup: retired `common/core_globals-sensecap.yaml`; `rp2040_last_seen_ms` now lives in `common/sensecap_indicator_sensors-sensecap.yaml`.

- Theme selector now supports `Dark` + `Dani` + `Split` in `common/theme_style-sensecap-dani.yaml`, exposed as dropdown `display_theme_dropdown` on `pages/display_settings-sensecap-dani.yaml`.


## Maintenance Notes
- 2026-03-10: Theme runtime logic now uses numeric slot `sense_theme_slot` (index-based) instead of `current_option()=="name"` comparisons in page/style conditionals. Keep new theme additions index-first and avoid name-based branching.


- 2026-03-10: Theme selector labels are tokenized as ui_theme_label_0..ui_theme_label_9. Page/runtime logic must use numeric slots (sense_theme_slot), while labels are UI-only.


- 2026-03-10: Theme slots 3..9 now have distinct style mappings in theme_style-sensecap-dani.yaml; display dropdown uses ui_theme_label_0..ui_theme_label_9 and slot-based selection.
- Theme runtime refresh: centralized runtime repaint remains enabled for the three home tiles (`Dani`, `Sleepy`, `Bedtime`). Fans, Overrides, and Dimmers now follow theme changes through shared LVGL style bindings (`page_style`, `sense_display_row_btn_style`, `sense_nav_btn_style`, `sense_menu_cat*`) instead of page-level repaint scripts; local page/button logic updates only state text, icon/value content, and slider state where needed.















- Fixed the backing `current_theme` selector in `theme_style-sensecap-dani.yaml` so it now exposes `ui_theme_label_0..9`; the Display dropdown and the actual theme selector now advertise the same 10 themes.

- Restored `theme_style-sensecap-dani.yaml` from the provided copy and expanded the backing `current_theme` selector to `ui_theme_label_0..9` so the Display dropdown and selector stay aligned.
