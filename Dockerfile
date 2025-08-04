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

# Install both nightly and stable toolchains
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y && \
    rustup install stable && \
    rustup install nightly && \
    rustup default nightly

# Install Anchor CLI using nightly
RUN cargo install --git https://github.com/coral-xyz/anchor anchor-cli --locked

# Clone and build Solana tools with stable
RUN rustup run stable git clone https://github.com/solana-labs/solana.git /tmp/solana && \
    rm /tmp/solana/rust-toolchain.toml && \
    sed -i 's|cargo=.*|cargo="$(which cargo)"|' /tmp/solana/scripts/cargo-install-all.sh && \
    cd /tmp/solana && rustup run stable ./scripts/cargo-install-all.sh . && \
    mkdir -p /tmp/solana/bin && \
    cp target/release/{cargo-build-sbf,solana,spl-token} /tmp/solana/bin/ && \
    strip /tmp/solana/bin/* || true

# Stage 2: Final image
FROM debian:bookworm-slim AS final

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH="/tmp/solana/bin:/usr/local/cargo/bin:/usr/local/rustup/bin:$PATH"

# Runtime dependencies only
RUN apt-get update && apt-get install -y \
    ca-certificates curl libssl-dev libudev-dev pkg-config && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy built tools and rust toolchains
COPY --from=builder /usr/local/cargo /usr/local/cargo
COPY --from=builder /usr/local/rustup /usr/local/rustup
COPY --from=builder /tmp/solana/bin /tmp/solana/bin

# Ensure nightly is default
RUN rustup default nightly

WORKDIR /anchor-crostini
