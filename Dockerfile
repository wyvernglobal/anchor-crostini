FROM debian:bookworm as builder

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:/usr/local/rustup/bin:$PATH

# --- Install core build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git wget xz-utils gnupg \
    build-essential pkg-config \
    libssl-dev libudev-dev \
    protobuf-compiler \
    clang libclang-dev llvm-dev cmake zlib1g-dev \
    nodejs npm ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# --- Install Rust (latest stable)
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y \
 && rustup install stable \
 && rustup default stable

# --- Install Anchor CLI
RUN cargo install --git https://github.com/coral-xyz/anchor anchor-cli --locked

# --- Install Solana CLI
RUN sh -c "$(curl -sSfL https://release.solana.com/stable/install)" \
 && ln -s /root/.local/share/solana/install/active_release/bin/solana /usr/local/bin/solana

# --- Install cargo-build-sbf (manual patch)
RUN git clone https://github.com/solana-labs/solana.git /tmp/solana \
 && rm /tmp/solana/rust-toolchain.toml \
 && sed -i 's|cargo=.*|cargo="$(which cargo)"|' /tmp/solana/scripts/cargo-install-all.sh \
 && export CARGO=$(which cargo) && export RUSTC=$(which rustc) \
 && cd /tmp/solana && ./scripts/cargo-install-all.sh . \
 && ln -sf /usr/local/cargo/bin/cargo-build-sbf /usr/local/bin/cargo-build-sbf

# --- Runtime image (smaller)
FROM debian:bookworm-slim

ENV PATH="/usr/local/cargo/bin:/usr/local/rustup/bin:/root/.local/share/solana/install/active_release/bin:$PATH"

# Install runtime deps only
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl libssl-dev pkg-config libudev-dev \
 && rm -rf /var/lib/apt/lists/*

# Copy tools from builder stage
COPY --from=builder /usr/local /usr/local
COPY --from=builder /root/.local /root/.local
COPY --from=builder /tmp/solana/bin /tmp/solana/bin

WORKDIR /work
