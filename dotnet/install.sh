#!/bin/bash

INSTALL_DIR="$HOME/.dotnet"
ARCH="arm64"
SCRIPT_URL="https://dot.net/v1/dotnet-install.sh"
CHANNELS=("8.0" "9.0" "10.0")

# Add to path for script execution
export DOTNET_ROOT="$INSTALL_DIR"
export PATH="$DOTNET_ROOT:$PATH"

# Create install dir if needed
mkdir -p "$INSTALL_DIR"

# Function: get latest version from a channel using dry-run
get_latest_version() {
  local CHANNEL=$1

  # include optional prerelease/build metadata (e.g. 10.0.100-rc.1.25451.107)
  local output
  output=$(curl -sSL "$SCRIPT_URL" | bash -s -- --channel "$CHANNEL" --dry-run --install-dir "$INSTALL_DIR" --arch "$ARCH" 2>/dev/null)

  # Use C locale to avoid "invalid character range" errors and a POSIX-safe character class
  echo "$output" | LC_ALL=C grep -oE '[0-9]+\.[0-9]+\.[0-9]+([-+][[:alnum:].-]+)?' | head -n 1
}

# Function: remove older SDKs from same major version
remove_old_versions() {
  local VERSION=$1
  local MAJOR=$(echo "$VERSION" | cut -d. -f1)
  local KEEP_VERSION=$VERSION

  echo "  🧹 Checking for SDKs with major version $MAJOR to clean up (except $KEEP_VERSION)..."

  for sdk in "$INSTALL_DIR/sdk"/*; do
    if [[ -d "$sdk" ]]; then
      sdk_version=$(basename "$sdk")
      sdk_major=$(echo "$sdk_version" | cut -d. -f1)
      if [[ "$sdk_major" == "$MAJOR" && "$sdk_version" != "$KEEP_VERSION" ]]; then
        echo "  🗑 Removing $sdk_version"
        rm -rf "$sdk"
      fi
    fi
  done
}

# Function: install latest SDK from a channel
install_dotnet_channel() {
  local CHANNEL=$1
  local LATEST_VERSION
  LATEST_VERSION=$(get_latest_version "$CHANNEL")

  if [[ -z "$LATEST_VERSION" ]]; then
    echo "  ❌ Could not determine latest version for $CHANNEL"
    return
  fi

  # echo "  🔎 Detected latest $CHANNEL SDK version: $LATEST_VERSION"
  if [[ -d "$INSTALL_DIR/sdk/$LATEST_VERSION" ]]; then
    # echo "  ✔️ $LATEST_VERSION already installed for channel $CHANNEL — skipping."
    return
  fi

  remove_old_versions "$LATEST_VERSION"
  echo "  ⬇️ Installing $CHANNEL SDK ($LATEST_VERSION)..."
  curl -sSL "$SCRIPT_URL" | bash -s -- \
    --channel "$CHANNEL" \
    --install-dir "$INSTALL_DIR" \
    --arch "$ARCH" \
    > /dev/null

  xattr -dr com.apple.quarantine "$INSTALL_DIR"
  echo "  ✅ Installed new .NET $CHANNEL SDK ($LATEST_VERSION)."
}

# Main loop
echo "› updating .NET SDKs..."
for CHANNEL in "${CHANNELS[@]}"; do
  install_dotnet_channel "$CHANNEL"
done
