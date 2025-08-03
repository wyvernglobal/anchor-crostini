<<<<<<< HEAD
# anchor-crostini
Anchor development environment for Crostini / Chromebook and other Debian OSs.
=======
# anchor-crostini (by Wyvern Global)

A Chromebook/Crostini-compatible **and standard Debian-compatible** development container for building and testing Solana smart contracts using Anchor.

🛠️ Built with:
- ✅ Latest stable Rust
- ✅ Anchor CLI
- ✅ Solana CLI
- ✅ `cargo-build-sbf` patched from source

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

### 3. Pull from GitHub Container Registry (GHCR)

```bash
podman pull ghcr.io/wyvernglobal/anchor-crostini:latest
```

## ✅ Compatibility

- ✔️ Works on ChromeOS/Crostini (Debian-based)
- ✔️ Works on standard Debian systems with Podman or Docker

## 📄 License

Licensed under the Apache License, Version 2.0.
See the `LICENSE` file or <https://www.apache.org/licenses/LICENSE-2.0>.
>>>>>>> 0b34f5a (Initial Release v1.0.0 Stable)
