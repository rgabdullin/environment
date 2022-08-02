#!/bin/bash
set -e

echo "Running server"
mlflow server \
    --host=0.0.0.0 \
    --port=5000 \
    --backend-store-uri=/mlflow
    --default-artifact-root=/mlflow/articats
