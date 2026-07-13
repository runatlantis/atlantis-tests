#!/bin/sh
set -eu

generation=$(sed -n 's/^[[:space:]]*e2e_generation[[:space:]]*=[[:space:]]*"\([^"]*\)"[[:space:]]*$/\1/p' generation.auto.tfvars)
if [ -z "$generation" ]; then
  echo "missing e2e_generation in generation.auto.tfvars" >&2
  exit 1
fi

echo "ATLANTIS_E2E_CUSTOM_REPLAN_PLAN_${generation}"
