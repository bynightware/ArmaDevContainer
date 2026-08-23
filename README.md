# Arma 3 Mod Development Container

This project provides a Linux devcontainer for Arma 3 mod development with
CLion, opencode, Hemtt, and Wine.

## Setup

The image installs the following during its Docker build:

- Hemtt CLI
- Wine with 32-bit support for Windows-based Arma tools
- CMake and the C++ development toolchain
- CLion, opencode, and uv through Dev Container features

The Steam Arma 3 Tools installation is mounted readonly from:

```text
C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools
```

to `/home/vscode/.local/share/arma3tools`. Hemtt receives this location through
the `HEMTT_BI_TOOLS` environment variable.

Build and start the container with:

```powershell
docker compose up -d --build
```

Alternatively, open the repository using the IDE's Dev Containers support.

## Day-to-day usage

Run Hemtt directly inside the container:

```bash
hemtt build
```

The project workspace is available at `/workspace`. Arma 3 Tools are available
at `/home/vscode/.local/share/arma3tools` and are mounted readonly.

## Files

- `Dockerfile` — Linux development image with Hemtt and Wine.
- `docker-compose.yml` — Linux devcontainer service and persistent IDE caches.
- `devcontainer.json` — Dev Container build, features, mounts, environment, and
  JetBrains customizations.
- `.docker/scripts/reinstall-cmake.sh` — optional CMake source installer used by
  the image build.
