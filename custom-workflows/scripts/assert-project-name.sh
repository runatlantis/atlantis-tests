#!/bin/sh
# Asserts that PROJECT_NAME is set and matches expected value.
# Used by custom workflow pre_workflow_hooks to verify v0.44.0 #6438.
set -e

EXPECTED="custom-workflow-env"

if [ -z "$PROJECT_NAME" ]; then
  echo "FAIL: PROJECT_NAME is not set"
  exit 1
fi

if [ "$PROJECT_NAME" != "$EXPECTED" ]; then
  echo "FAIL: PROJECT_NAME='$PROJECT_NAME' but expected '$EXPECTED'"
  exit 1
fi

echo "PASS: PROJECT_NAME=$PROJECT_NAME"
