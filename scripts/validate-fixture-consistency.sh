#!/bin/sh
set -eu

repo_root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
config="$repo_root/atlantis.yaml"
coverage="$repo_root/docs/coverage.md"
tmp_dir=${TMPDIR:-/tmp}/atlantis-fixture-validation.$$
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM
mkdir -p "$tmp_dir"

awk '/^  - dir: / { print $3 }' "$config" >"$tmp_dir/dirs"
while IFS= read -r dir; do
  if [ ! -d "$repo_root/$dir" ]; then
    echo "configured fixture directory does not exist: $dir" >&2
    exit 1
  fi
done <"$tmp_dir/dirs"

awk '/^    name: / { print $2 }' "$config" | sort >"$tmp_dir/names"
duplicates=$(uniq -d "$tmp_dir/names")
if [ -n "$duplicates" ]; then
  echo "duplicate Atlantis project names:" >&2
  echo "$duplicates" >&2
  exit 1
fi

awk '
  /^workflows:/ { in_workflows = 1; next }
  !in_workflows && /^    workflow: / { print $2 }
' "$config" | sort -u >"$tmp_dir/workflow-refs"
awk '
  /^workflows:/ { in_workflows = 1; next }
  in_workflows && /^  [A-Za-z0-9_-]+:/ {
    name = $1
    sub(/:$/, "", name)
    print name
  }
' "$config" | sort -u >"$tmp_dir/workflow-defs"
while IFS= read -r workflow; do
  if ! grep -Fxq "$workflow" "$tmp_dir/workflow-defs"; then
    echo "project references undefined workflow: $workflow" >&2
    exit 1
  fi
done <"$tmp_dir/workflow-refs"

for fixture in \
  apply-regressions/builtin-replan-apply \
  apply-regressions/mixed-plan-mutation \
  custom-workflows/custom-plan-replan; do
  if ! grep -Fq "| \`$fixture\` |" "$coverage"; then
    echo "coverage inventory is missing fixture: $fixture" >&2
    exit 1
  fi
  if ! grep -Eq '^Status: (active|opt-in|negative|scaffold-only)' "$repo_root/$fixture/README.md"; then
    echo "fixture README lacks active/opt-in/negative/scaffold-only status: $fixture" >&2
    exit 1
  fi
done

test -f "$repo_root/custom-workflows/custom-plan-replan/plan-generation-marker.sh"
grep -Fq 'sh plan-generation-marker.sh' "$config"
grep -Fq 'ATLANTIS_E2E_MIXED_BUILTIN_APPLY_MUST_NOT_RUN' "$config"

awk '
  /^  custom-plan-path:/ { in_workflow = 1; next }
  in_workflow && /^  [A-Za-z0-9_-]+:/ { exit }
  in_workflow { print }
' "$config" >"$tmp_dir/custom-plan-path-workflow"
for plan in generated/dev/atlantis.tfplan generated/staging/atlantis.tfplan; do
  grep -Fq -- "-out=$plan" "$tmp_dir/custom-plan-path-workflow"
  grep -Fq "test -f $plan" "$tmp_dir/custom-plan-path-workflow"
done
if [ "$(grep -Fc -- '-out=' "$tmp_dir/custom-plan-path-workflow")" -ne 2 ]; then
  echo "custom plan path workflow must create exactly two nested plan artifacts" >&2
  exit 1
fi
grep -Fq 'terraform apply -input=false -no-color generated/dev/atlantis.tfplan' "$tmp_dir/custom-plan-path-workflow"
if [ "$(grep -Fc 'terraform apply ' "$tmp_dir/custom-plan-path-workflow")" -ne 1 ]; then
  echo "custom plan path workflow must apply exactly one nested plan" >&2
  exit 1
fi
grep -Fq 'test ! -e custom-plan-path-default.tfplan' "$tmp_dir/custom-plan-path-workflow"
grep -Fq 'echo ATLANTIS_E2E_CUSTOM_PLAN_CREATED generated/dev/atlantis.tfplan generated/staging/atlantis.tfplan' "$tmp_dir/custom-plan-path-workflow"
if grep -Fq 'custom-atlantis.tfplan' "$tmp_dir/custom-plan-path-workflow" ||
  grep -Fq "\$PLANFILE" "$tmp_dir/custom-plan-path-workflow"; then
  echo "custom plan path workflow still uses an Atlantis-managed plan path" >&2
  exit 1
fi

if [ "$#" -gt 1 ]; then
  echo "usage: $0 [upstream-e2e-testcase.go]" >&2
  exit 1
fi
if [ "$#" -eq 1 ]; then
  upstream_testcases=$1
  if [ ! -f "$upstream_testcases" ]; then
    echo "upstream E2E testcase file does not exist: $upstream_testcases" >&2
    exit 1
  fi
  sed -n 's/^[[:space:]]*Dir:[[:space:]]*"\([^"]*\)".*/\1/p' "$upstream_testcases" | sort -u >"$tmp_dir/e2e-dirs"
  while IFS= read -r dir; do
    if [ ! -d "$repo_root/$dir" ]; then
      echo "upstream E2E references missing fixture directory: $dir" >&2
      exit 1
    fi
  done <"$tmp_dir/e2e-dirs"

  sed -n 's/.*atlantis\/\(plan\|apply\): \([^"}]*\).*/\2/p' "$upstream_testcases" | sort -u >"$tmp_dir/e2e-projects"
  while IFS= read -r project; do
    case "$project" in
      */*) continue ;;
    esac
    if ! grep -Fq "    name: $project" "$config"; then
      echo "upstream E2E references undefined Atlantis project: $project" >&2
      exit 1
    fi
  done <"$tmp_dir/e2e-projects"

  custom_case=$(sed -n '/Name:.*"custom-plan-path-apply"/,/^\t},/p' "$upstream_testcases")
  if ! printf '%s\n' "$custom_case" | grep -Fq 'ApplyCommand:                  "atlantis apply"'; then
    echo "upstream custom plan path case must use generic atlantis apply" >&2
    exit 1
  fi
fi

echo "fixture consistency validation passed"
