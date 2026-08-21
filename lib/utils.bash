#!/usr/bin/env bash

set -euo pipefail

fail() {
  echo "asdf-helmfile: $*" >&2
  exit 1
}

get_platform() {
  case "$(uname)" in
    Linux) echo "linux" ;;
    Darwin) echo "darwin" ;;
    *) fail "unsupported operating system: $(uname)" ;;
  esac
}

get_cpu() {
  case "$(uname -m)" in
    x86_64) echo "amd64" ;;
    aarch64 | arm64) echo "arm64" ;;
    i386 | i686) echo "386" ;;
    *) fail "unsupported CPU architecture: $(uname -m)" ;;
  esac
}

is_current_release_format() {
  local version="${1%%[-+]*}"
  local major minor patch
  IFS=. read -r major minor patch <<< "$version"
  # list-all advertises two-component tags (0.2, 0.6, ...) that have real
  # roboll releases, so treat the missing components as zero rather than
  # rejecting the version outright.
  minor=${minor:-0}
  patch=${patch:-0}

  if [[ ! "$major" =~ ^[0-9]+$ || ! "$minor" =~ ^[0-9]+$ || ! "$patch" =~ ^[0-9]+$ ]]; then
    fail "unsupported Helmfile version: ${1}"
  fi

  ((major > 0 || minor >= 145))
}

download_release() {
  local version=$1
  local destination=$2
  local platform
  platform=$(get_platform)
  local arch
  arch=$(get_cpu)

  if is_current_release_format "$version"; then
    local url="https://github.com/helmfile/helmfile/releases/download/v${version}/helmfile_${version}_${platform}_${arch}.tar.gz"
    local archive_path
    archive_path=$(mktemp "${TMPDIR:-/tmp}/asdf-helmfile.XXXXXX")
    echo "Downloading Helmfile from ${url}"
    if ! curl -fsSL "$url" -o "$archive_path"; then
      rm -f "$archive_path"
      fail "failed to download Helmfile ${version}"
    fi
    if ! tar -xf "$archive_path" -C "$(dirname "$destination")" helmfile; then
      rm -f "$archive_path" "$destination"
      fail "failed to extract Helmfile ${version}"
    fi
    rm -f "$archive_path"
  else
    local url="https://github.com/roboll/helmfile/releases/download/v${version}/helmfile_${platform}_${arch}"
    echo "Downloading Helmfile from ${url}"
    if ! curl -fsSL "$url" -o "$destination"; then
      rm -f "$destination"
      fail "failed to download Helmfile ${version}"
    fi
  fi
}
