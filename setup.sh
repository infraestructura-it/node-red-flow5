#!/bin/bash
echo "🚀 Creando estructura del proyecto Node-RED..."

# Crear carpetas
mkdir -p .devcontainer
mkdir -p .github/workflows

# Crear devcontainer.json
cat <<EOF > .devcontainer/devcontainer.json
{
  "name": "Node-RED Dev",
  "dockerComposeFile": "../docker-compose.yml",
  "service": "nodered",
  "workspaceFolder": "/workspaces/node-red-flow5",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:1": {}
  }
}
EOF

# Crear docker-compose.yml
cat <<EOF > docker-compose.yml
version: "3.8"
services:
  nodered:
    image: nodered/node-red:latest
    container_name: nodered
    ports:
      - "1880:1880"
    volumes:
      - ./data:/data
    restart: unless-stopped
EOF

# Crear workflow main.yml
cat <<EOF > .github/workflows/main.yml
name: CI - Node-RED

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Clonar repo
        uses: actions/checkout@v3

      - name: Construir imagen
        run: docker build -t nodered-app .

      - name: Ejecutar contenedor
        run: docker run -d -p 1880:1880 --name nodered-app nodered/node-red:latest

      - name: Verificar ejecución
        run: docker exec nodered-app node-red --version
EOF

echo "✅ Script finalizado. Estructura lista para trabajar."
