#!/usr/bin/env bash
set -euo pipefail

OPENSSL_BIN="${OPENSSL:-openssl}"

if [ ! -f "keys/private_ed25519.pem" ]; then
  echo "Missing keys/private_ed25519.pem. Generate keys first:"
  echo '  mkdir -p keys'
  echo '  $OPENSSL genpkey -algorithm ED25519 -out keys/private_ed25519.pem'
  echo '  $OPENSSL pkey -in keys/private_ed25519.pem -pubout -out keys/public_ed25519.pem'
  exit 1
fi

echo "Signing current/rules_bundle.json ..."
$OPENSSL_BIN pkeyutl -sign -inkey keys/private_ed25519.pem       -in current/rules_bundle.json       -out current/rules_bundle.sig

echo "Copying signature to 1.0.0/ ..."
cp current/rules_bundle.sig 1.0.0/rules_bundle.sig

echo "Done."
