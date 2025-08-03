# ----------- Stage 1: Builder ------------
FROM debian:bookworm as builder

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:/usr/local/rustup/bin:$PATH \
    SOLANA_INSTALL_DIR=/opt/solana

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git wget xz-utils gnupg \
    build-essential pkg-config \
    libssl-dev libudev-dev \
    protobuf-compiler \
    clang libclang-dev llvm-dev cmake zlib1g-dev \
    nodejs npm ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Install Rust via rustup
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y \
 && rustup install stable \
 && rustup default stable

# Install Anchor CLI
RUN cargo install --git https://github.com/coral-xyz/anchor anchor-cli --locked

# Install Solana CLI to custom path
RUN sh -c "$(curl -sSfL https://release.solana.com/stable/install)" \
 && ln -s $SOLANA_INSTALL_DIR/install/active_release/bin/solana /usr/local/bin/solana

# Manually build and install cargo-build-sbf from Solana repo
RUN git clone https://github.com/solana-labs/solana.git /tmp/solana \
 && rm /tmp/solana/rust-toolchain.toml \
 && sed -i 's|cargo=.*|cargo="$(which cargo)"|' /tmp/solana/scripts/cargo-install-all.sh \
 && export CARGO=$(which cargo) && export RUSTC=$(which rustc) \
 && cd /tmp/solana && ./scripts/cargo-install-all.sh . \
 && ln -sf /usr/local/cargo/bin/cargo-build-sbf /usr/local/bin/cargo-build-sbf

# ----------- Stage 2: Runtime ------------
FROM debian:bookworm-slim

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:/usr/local/rustup/bin:/opt/solana/install/active_release/bin:$PATH

# Install runtime-only dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl libssl-dev pkg-config libudev-dev \
 && rm -rf /var/lib/apt/lists/*

# Copy tools from builder
COPY --from=builder /usr/local /usr/local
COPY --from=builder /opt/solana /opt/solana
COPY --from=builder /tmp/solana/bin /tmp/solana/bin

WORKDIR /work
