# Stage 1: Builder
FROM debian:bookworm-slim AS builder

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:/usr/local/rustup/bin:$PATH

# Install build dependencies
RUN apt-get update && apt-get install -y \
    curl git wget xz-utils gnupg \
    build-essential pkg-config \
    libssl-dev libudev-dev \
    protobuf-compiler \
    clang libclang-dev llvm-dev cmake zlib1g-dev \
    nodejs npm

# Install Rust with nightly as default, stable also available
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y --default-toolchain nightly && \
    rustup update nightly && \
    rustup install stable && \
    rustup default nightly

# Install Anchor CLI on nightly
RUN cargo install --git https://github.com/coral-xyz/anchor anchor-cli --locked

# Build Solana tools using *stable* Rust to avoid nightly breakage
RUN rustup run stable bash -c '\
    git clone https://github.com/solana-labs/solana.git /tmp/solana && \
    rm /tmp/solana/rust-toolchain.toml && \
    sed -i "s|cargo=.*|cargo=$(which cargo)|" /tmp/solana/scripts/cargo-install-all.sh && \
    cd /tmp/solana && ./scripts/cargo-install-all.sh . && \
    mkdir -p /tmp/solana/bin && \
    cp target/release/cargo-build-sbf /tmp/solana/bin/ && \
    cp target/release/solana /tmp/solana/bin/ && \
    cp target/release/spl-token /tmp/solana/bin/ && \
    strip /tmp/solana/bin/* || true'

# Stage 2: Final minimal image
FROM debian:bookworm-slim AS final

# Minimal runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates curl libssl-dev libudev-dev pkg-config && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH="/tmp/solana/bin:/usr/local/cargo/bin:/usr/local/rustup/bin:$PATH"
WORKDIR /anchor-crostini

# Copy Rust + Solana tooling
COPY --from=builder /usr/local/cargo /usr/local/cargo
COPY --from=builder /usr/local/rustup /usr/local/rustup
COPY --from=builder /tmp/solana/bin /tmp/solana/bin

# Set default toolchain to nightly
RUN rustup default nightly
