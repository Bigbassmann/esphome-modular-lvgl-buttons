# SenseCAP D1S (Fork) README

This document is the SenseCAP-specific guide for this fork of `agillis/esphome-modular-lvgl-buttons`.

## Goals

- Keep upstream-level modularity and package structure.
- Keep SenseCAP customizations isolated and predictable.
- Minimize merge conflicts with upstream.
- Make new device rollout repeatable across homes.

## Relationship To Upstream

This repo is a fork of upstream `esphome-modular-lvgl-buttons`.

We treat upstream as the base library and keep SenseCAP work as a profile layered on top.

### Fork conventions

- SenseCAP-owned files use `-sensecap` suffix where practical.
- Reusable modules remain in upstream-like folders:
  - `buttons/`
  - `pages/`
  - `common/`
  - `hardware/`
  - `widgets/`
- Composition happens in SenseCAP entrypoint YAML files via `packages: !include`.

## Current SenseCAP Entry Points

- Fork-local entrypoint:
  - `esphome-modular-lvgl-buttons/sensecap-d1s-v2-sensecap.yaml`
- Active root entrypoint used by ESPHome dashboard:
  - `../sensecap-d1s-v2.yaml`

These are intentionally mirrored. Keep both in sync unless you intentionally split behavior.

## SenseCAP Modular Architecture

### 1) Shared UI/Foundation modules

- Theme/tokens/colors/fonts/runtime:
  - `common/theme_style-sensecap.yaml`
  - `common/ui_tokens-sensecap.yaml`
  - `common/color-sensecap.yaml`
  - `common/fonts-sensecap.yaml`
  - `common/display_runtime-sensecap.yaml`

### 2) Feature/page modules

- Shell/home/menu/fans/overrides/thermostat/sensors/lights/dimmers are separate page modules in `pages/`.
- Reusable button primitives are in `buttons/`.

### 3) Home Assistant entity mapping layer

- Canonical Home1 map:
  - `common/ha_entities-sensecap.yaml`
- This is the main substitution map for entity IDs and attributes.

### 4) Device hardware layer

- Device-specific hardware files in `hardware/`.
- Current active file:
  - `hardware/seeed-studios-sensecap-indicator-d1s-001.yaml`

## Standards and Guardrails

- Prefer substitutions and modular includes over hardcoding.
- Put colors in `common/color-sensecap.yaml` and reference tokens.
- Keep entity IDs centralized in HA entity map file(s), not scattered across pages.
- Keep page layout reusable through templates (example: dimmers template page).
- Validate after any change:
  - `esphome config sensecap-d1s-v2.yaml`

## Device Provisioning: Home1 New Device (002)

This is the clean process to clone from current 001 setup.

### Step 1: Duplicate hardware file

Create:

- `hardware/seeed-studios-sensecap-indicator-d1s-002.yaml`

Start by copying `hardware/seeed-studios-sensecap-indicator-d1s-001.yaml`.

### Step 2: Set unique device identity in 002 hardware file

In `esphome:` section, set at minimum:

- `name:` unique (example: `sensecap-d1s-002`)
- `friendly_name:` unique (example: `SenseCAP Indicator 002`)

### Step 3: Create a 002 entrypoint YAML

Copy current SenseCAP entrypoint to a new file, for example:

- `sensecap-d1s-v2-002-sensecap.yaml`

In this new file:

- Keep package list identical initially.
- Change hardware include to:
  - `hardware: !include esphome-modular-lvgl-buttons/hardware/seeed-studios-sensecap-indicator-d1s-002.yaml`
- Keep Home1 HA map include for now:
  - `ha_entities_sensecap: !include esphome-modular-lvgl-buttons/common/ha_entities-sensecap.yaml`

### Step 4: Compile check

Run:

```powershell
esphome config sensecap-d1s-v2-002-sensecap.yaml
```

### Step 5: First flash / adopt

Flash and adopt device in Home Assistant as normal.

### Step 6: Optional per-device tweaks

If device 002 needs different pages/colors/behavior, add a small per-device override module and include it near the bottom of `packages:`.

## Device Provisioning: New Device In Home2

Home2 should use a separate HA entity map file.

### Step 1: Create Home2 entity map file

Create:

- `common/ha_entities-home2-sensecap.yaml`

Start by copying `common/ha_entities-sensecap.yaml`.

Then update all `ent_*` substitutions to Home2 entities.

### Step 2: Create Home2 device entrypoint

Copy your Home1 002 entrypoint and create, for example:

- `sensecap-d1s-v2-home2-001-sensecap.yaml`

In this file:

- Include Home2 entity map instead of Home1:
  - `ha_entities_sensecap: !include esphome-modular-lvgl-buttons/common/ha_entities-home2-sensecap.yaml`
- Include hardware file for that physical device (new hardware file if needed).

### Step 3: Validate

```powershell
esphome config sensecap-d1s-v2-home2-001-sensecap.yaml
```

### Step 4: Flash and verify page behavior

Verify key controls first:

- Overrides
- Lights on/off
- Dimmers
- Thermostat/fans

## Suggested File Naming Pattern

- Hardware:
  - `hardware/seeed-studios-sensecap-indicator-d1s-<device-id>.yaml`
- Home1 entrypoint:
  - `sensecap-d1s-v2-<device-id>-sensecap.yaml`
- Home2 entrypoint:
  - `sensecap-d1s-v2-home2-<device-id>-sensecap.yaml`
- Home-specific HA maps:
  - `common/ha_entities-home1-sensecap.yaml` (optional rename from current)
  - `common/ha_entities-home2-sensecap.yaml`

## Upstream Sync Workflow (Recommended)

1. Pull upstream changes into a staging branch.
2. Keep SenseCAP-specific files isolated (`-sensecap` modules).
3. Re-run config validation on each active entrypoint.
4. Smoke test UI pages on hardware 001 before promoting to other devices.

## Quick Checklist Before Commit

- No hardcoded HA IDs outside entity map file.
- No new hardcoded colors unless explicitly required.
- Both entrypoints (root + fork-local) updated if intended.
- `esphome config` passes.

## Useful Commands

```powershell
# Validate active root config
esphome config sensecap-d1s-v2.yaml

# Validate fork-local config
esphome config esphome-modular-lvgl-buttons/sensecap-d1s-v2-sensecap.yaml

# Validate a new device file
esphome config esphome-modular-lvgl-buttons/sensecap-d1s-v2-002-sensecap.yaml
```
