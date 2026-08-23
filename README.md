# Arma 3 Mod Development Container

This project provides a Linux devcontainer for Arma 3 mod development with
CLion 2026.2.1, opencode, HEMTT, and Wine.

## Setup

The image installs the following during its Docker build:

- Hemtt CLI
- Wine with 32-bit support for Windows-based Arma tools
- Wine64, Wine32, Winbind, common Wine fonts, and supporting archive tools
- Git
- CMake and the C++ development toolchain
- CLion, opencode, and uv through Dev Container features

The Steam Arma 3 Tools installation is mounted readonly from the Windows host.
By default, the devcontainer uses:

```text
C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools
```

to `/home/vscode/.local/share/arma3tools`. Hemtt receives this location through
the `HEMTT_BI_TOOLS` environment variable.

To override the devcontainer mount, set `ARMA3_TOOLS_PATH` in the environment
before opening the container. The same variable is supported by Docker Compose:

```powershell
$env:ARMA3_TOOLS_PATH = 'D:\SteamLibrary\steamapps\common\Arma 3 Tools'
docker compose up -d --build
```

The Wine prefix is stored in the `wine-prefix` volume and is available at
`/home/vscode/.wine`. It is initialized automatically when the container starts.

GitHub Copilot authentication is not mounted from the host. The JetBrains
Copilot plugin stores credentials through JetBrains Password Safe, which may use
the host OS keychain and is not portable as a container bind mount. Sign in from
the JetBrains client using **Tools > GitHub Copilot > Login to GitHub** and the
device-code flow. A Copilot Free or paid plan is required.

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

Run the dependency checks manually with:

```bash
arma-verify-container
```

The startup checks fail for missing core dependencies and warn when the
host-mounted Arma 3 Tools directory is unavailable. A full HEMTT build and BI
tool execution are project-level checks and are not run automatically.

The project workspace is available at `/workspace`. Arma 3 Tools are available
at `/home/vscode/.local/share/arma3tools` and are mounted readonly.

## Files

- `Dockerfile` — Linux development image with HEMTT, Git, and Wine.
- `docker-compose.yml` — Linux devcontainer service and persistent IDE caches.
- `devcontainer.json` — Dev Container build, features, mounts, environment, and
  JetBrains customizations.
- `.docker/scripts/verify-container.sh` — dependency and mount verification.
- `.docker/scripts/startup-checks.sh` — Wine prefix initialization and startup checks.
- `.docker/scripts/reinstall-cmake.sh` — optional CMake source installer used by
  the image build.
