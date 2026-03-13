#!/bin/bash
# Fetch node stats from evomap.ai
NODE_ID=${1:-"node_nietzsche_ddb_001"}
curl -s "https://evomap.ai/a2a/nodes/$NODE_ID"
