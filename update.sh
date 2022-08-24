#!/usr/bin/env bash
set -euxo pipefail

cleanup() {
  rm -rf tmp.tar.xz
  rm -rf tmp
}

trap cleanup EXIT

declare -a channels=(
  "nixos-unstable"
  "nixos-22.05"
  "nixos-21.11"
  "nixos-21.05"
)

for channel in ${channels[@]}; do
  echo "Updating $channel.."

  REV_URL="https://channels.nixos.org/$channel/git-revision"
  TAR_URL="https://channels.nixos.org/$channel/nixexprs.tar.xz"

  rm -rf $channel/
  mkdir -p $channel/

  curl -fLo $channel/git-revision "$REV_URL"

  curl -fLo tmp.tar.xz "$TAR_URL"
  mkdir -p tmp
  tar xvf tmp.tar.xz --directory=tmp
  mv $(find tmp -name 'programs.sqlite') $channel/

  cleanup

done
