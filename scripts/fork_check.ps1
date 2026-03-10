param(
  [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"
$failures = New-Object System.Collections.Generic.List[string]

$allYaml = Get-ChildItem -Path $RepoRoot -Recurse -File -Include *.yaml,*.yml | Where-Object {
  $_.FullName -notmatch "\\archive\\" -and
  $_.Name -notmatch "\.bak-"
}

# Fork-owned scope only (SenseCAP and active entrypoint files)
$yamlFiles = $allYaml | Where-Object {
  $_.Name -match "sensecap" -or
  $_.Name -eq "sensecap-d1s-v2.yaml" -or
  $_.Name -eq "sensecap-d1s-v2-001.yaml"
}

$allowedEntityFiles = @(
  (Resolve-Path (Join-Path $RepoRoot "common\ha_entities-sensecap-dani.yaml")).Path,
  (Resolve-Path (Join-Path $RepoRoot "common\core_ha_common-sensecap.yaml")).Path,
  (Resolve-Path (Join-Path $RepoRoot "sensecap-d1s-v2-001.yaml")).Path
)

# Ignore commented lines and only flag literal domain.object entity IDs
$entityRegex = '^(?!\s*#).*entity_id:\s*"?[a-z_]+\.[a-zA-Z0-9_]+'
foreach ($f in $yamlFiles) {
  $full = $f.FullName
  if ($allowedEntityFiles -contains $full -or $f.Name -eq "sensecap-d1s-v2-001.yaml") { continue }

  $hits = Select-String -Path $f.FullName -Pattern $entityRegex
  foreach ($h in $hits) {
    $rel = $f.FullName.Replace($RepoRoot + "\\", "")
    $failures.Add("Hardcoded entity_id outside allowed files: ${rel}:$($h.LineNumber)")
  }
}

$customHits = Select-String -Path ($yamlFiles.FullName) -Pattern '(^|\s)custom_components($|/|\\|:)'
foreach ($h in $customHits) {
  $rel = $h.Path.Replace($RepoRoot + "\\", "")
  $failures.Add("Deprecated custom_components reference in fork YAML: ${rel}:$($h.LineNumber)")
}

$required = @(
  "sensecap-d1s-v2.yaml",
  "sensecap-d1s-v2-001.yaml",
  "common\ha_entities-sensecap-dani.yaml",
  "common\core_ha_common-sensecap.yaml",
  "external_components\noaa_tides\__init__.py"
)
foreach ($r in $required) {
  if (-not (Test-Path (Join-Path $RepoRoot $r))) {
    $failures.Add("Missing required fork file: $r")
  }
}

if ($failures.Count -gt 0) {
  Write-Output "FAIL"
  $failures | Sort-Object -Unique | ForEach-Object { Write-Output $_ }
  exit 1
}

Write-Output "PASS"
exit 0