#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GHLABELS=docker-runner,ollama "${SCRIPT_DIR}/_org_runner.sh"
