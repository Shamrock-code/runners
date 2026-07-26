#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

GHLABELS=docker-runner "${SCRIPT_DIR}/_org_runner.sh"
