FROM debian:bookworm

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:/usr/local/rustup/bin:$PATH

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git wget xz-utils gnupg \
    build-essential pkg-config \
    libssl-dev libudev-dev \
    protobuf-compiler \
    clang libclang-dev llvm-dev cmake zlib1g-dev \
    nodejs npm

# Install rustup and latest stable Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y \
 && rustup install stable \
 && rustup default stable

# Install Anchor CLI
RUN cargo install --git https://github.com/coral-xyz/anchor anchor-cli --locked

# Install Solana CLI
RUN sh -c "$(curl -sSfL https://release.solana.com/stable/install)" \
 && ln -s /root/.local/share/solana/install/active_release/bin/solana /usr/local/bin/solana

# Clone and patch Solana repo to build cargo-build-sbf, then clean up
RUN git clone https://github.com/solana-labs/solana.git /tmp/solana \
 && rm /tmp/solana/rust-toolchain.toml \
 && sed -i 's|cargo=.*|cargo="$(which cargo)"|' /tmp/solana/scripts/cargo-install-all.sh \
 && export CARGO=$(which cargo) && export RUSTC=$(which rustc) \
 && cd /tmp/solana && ./scripts/cargo-install-all.sh . \
 && ln -sf /usr/local/cargo/bin/cargo-build-sbf /usr/local/bin/cargo-build-sbf \
 && rm -rf /tmp/solana

WORKDIR /work
