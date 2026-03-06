# SenseCAP Simple Pattern

Goal: keep the project modular, but avoid splitting one feature into many tiny files.

## Rules

1. Keep all Home Assistant entity IDs in one file:
   - `common/ha_entities-sensecap.yaml`
2. Keep one file per feature/page element:
   - LVGL widgets
   - HA sensors/text_sensors
   - scripts/actions
   - interval/runtime sync
3. Reuse button/widget components where they help, but keep feature behavior local.

## New thermostat element

- `pages/thermostat_v2_element-sensecap.yaml`

This is the reference implementation of the pattern.

## Include example

```yaml
packages:
  ha_entities: !include esphome-modular-lvgl-buttons/common/ha_entities-sensecap.yaml
  tstat_element: !include esphome-modular-lvgl-buttons/pages/thermostat_v2_element-sensecap.yaml
```

## Why this is simpler

- One HA map file to edit per home.
- One feature file to understand/debug per page.
- No separate runtime/actions/ha/lvgl files unless complexity justifies it.

