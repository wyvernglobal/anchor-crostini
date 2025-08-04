![Build & Push](https://github.com/wyvernglobal/anchor-crostini/actions/workflows/publish.yml/badge.svg)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![GHCR](https://img.shields.io/badge/container-ghcr.io%2Fwyvernglobal%2Fanchor--crostini-blue?logo=docker)](https://github.com/orgs/wyvernglobal/packages/container/package/anchor-crostini)

# anchor-crostini
Anchor development environment for Crostini / Chromebook and other Debian OSs.
=======
# anchor-crostini (by Wyvern Global)

A Chromebook / Crostini and standard Debian-compatible development container for building and testing Solana smart contracts using Anchor. Uses podman, can work on docker.

## ☕ Support This Project

<a href="https://www.buymeacoffee.com/josh56432" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="40" />
</a>


## 🚀 Quick Start

## 🛠 Pre checks

Ensure that the following has an output:
```bash
sudo grep $(whoami) /etc/subuid /etc/subgid
```
If not, then perform the following before building or pulling the package:
```bash
echo "$(whoami):100000:65536" | sudo tee -a /etc/subuid | sudo tee -a /etc/subgid
podman system migrate
```
### Option 1. Pull from GitHub Container Registry (GHCR) or Dockerhub

```bash
# From GHCR
podman pull ghcr.io/wyvernglobal/anchor-crostini:stable
```
```bash
# From DockerHub
podman pull josh56432/anchor-crostini:stable
```

### Option 2. Build locally (on Debian or Crostini)

```bash
git clone https://github.com/wyvernglobal/anchor-crostini.git
cd ./anchor-crostini
podman build -t anchor-crostini .
```

### Run it

```bash
podman run -it --rm -v $PWD:/anchor-crostini -w /anchor-crostini --network host anchor-crostini bash
```

Or add an alias to `~/.bashrc` or `~/.zshrc`:

```bash
echo "alias anchor-crostini='podman run -it --rm -v \$PWD:/anchor-crostini -w /anchor-crostini --network host ghcr.io/wyvernglobal/anchor-crostini:latest bash'" >> ~/.bashrc
source ~/.bashrc
```
Then run with:
```bash
anchor-crostini
```

## ✅ Compatibility

- ✔️ Works on ChromeOS/Crostini (Debian-based)
- ✔️ Works on standard Debian systems with Podman or Docker

## 📄 License

Licensed under the Apache License, Version 2.0.
See the `LICENSE` file or <https://www.apache.org/licenses/LICENSE-2.0>.

