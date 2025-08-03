![Build & Push](https://github.com/wyvernglobal/anchor-crostini/actions/workflows/publish.yml/badge.svg)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![GHCR](https://img.shields.io/badge/container-ghcr.io%2Fwyvernglobal%2Fanchor--crostini-blue?logo=docker)](https://github.com/orgs/wyvernglobal/packages/container/package/anchor-crostini)

# anchor-crostini
Anchor development environment for Crostini / Chromebook and other Debian OSs.
=======
# anchor-crostini (by Wyvern Global)

A Chromebook / Crostini and standard Debian-compatible development container for building and testing Solana smart contracts using Anchor. Uses podman, can work on docker.


## 🚀 Quick Start

### 1. Build locally (on Debian or Crostini)

```bash
podman build -t anchor-crostini .
```

### 2. Run it

```bash
podman run -it --rm -v $PWD:/work -w /work --network host anchor-crostini bash
```

Or add an alias to `~/.bashrc` or `~/.zshrc`:

```bash
echo "alias anchor-dev='podman run -it --rm -v \$PWD:/work -w /work --network host ghcr.io/wyvernglobal/anchor-crostini:latest bash'" >> ~/.bashrc
source ~/.bashrc
```

### 3. Pull from GitHub Container Registry (GHCR) or Dockerhub

```bash
# From GHCR
podman pull ghcr.io/wyvernglobal/anchor-crostini:stable

# From DockerHub
podman pull josh56432/anchor-crostini:stable
```

## ✅ Compatibility

- ✔️ Works on ChromeOS/Crostini (Debian-based)
- ✔️ Works on standard Debian systems with Podman or Docker

## 📄 License

Licensed under the Apache License, Version 2.0.
See the `LICENSE` file or <https://www.apache.org/licenses/LICENSE-2.0>.
>>>>>>> 0b34f5a (Initial Release v1.0.0 Stable)
