#!/bin/bash

# Docker Healthcheck Script
# Verifies that the web service is running and responsive

set -e

web_ok=false

# Check Web Server
if curl -sf http://127.0.0.1/ > /dev/null 2>&1; then
    web_ok=true
fi

if [ "$web_ok" = true ]; then
    exit 0
else
    echo "Health check failed: web=$web_ok"
    exit 1
fi
