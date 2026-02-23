#!/bin/sh

echo "Waiting for Ollama to be ready..."
until curl -sf http://ollama:11434/api/tags > /dev/null; do
  echo "Ollama not ready, retrying..."
  sleep 2
done

echo "Pulling llama3.2..."
curl -X POST http://ollama:11434/api/pull \
  -H "Content-Type: application/json" \
  -d '{"name": "llama3.2"}' \
  --no-buffer

echo "Waiting for model to be listed..."
until curl -sf http://ollama:11434/api/tags | grep -q "llama3.2"; do
  echo "Model not ready yet..."
  sleep 3
done

echo "Starting API..."
exec uvicorn api:app --host 0.0.0.0 --port 8000