# eu-ai-checker-bundles (starter)

Static bundle repo for your app's rule/news updates. GitHub Pages can host these files directly.

## Structure
- `current/` — latest bundle for the app to fetch
- `1.0.0/` — pinned version (duplicate of `current/`)
- `.nojekyll` — disables Jekyll processing on Pages
- `.gitattributes` — keeps JSON LF-only and treats signatures as binary
- `.gitignore` — prevents accidental key commits
- `scripts/sign.sh` — helper to sign `rules_bundle.json` locally

## How to publish
1. Commit and push this repo.
2. Settings → Pages → Deploy from a branch → Branch: `main`, Folder: `/` (root). Enable HTTPS.
3. Wait for Pages to publish, then your files will be at:
   - `https://<username>.github.io/eu-ai-checker-bundles/current/rules_bundle.json`
   - `https://<username>.github.io/eu-ai-checker-bundles/current/rules_bundle.sig`

## Sign what you ship (Ed25519, OpenSSL 3)
```bash
# macOS (Homebrew)
brew install openssl@3
export OPENSSL=/opt/homebrew/opt/openssl@3/bin/openssl   # adjust path if needed

# Generate keys (do NOT commit)
mkdir -p keys
$OPENSSL genpkey -algorithm ED25519 -out keys/private_ed25519.pem
$OPENSSL pkey -in keys/private_ed25519.pem -pubout -out keys/public_ed25519.pem

# Public key for the app (DER→base64, single line)
$OPENSSL pkey -in keys/public_ed25519.pem -pubin -outform DER | base64 > keys/public_ed25519_base64.txt

# Sign the exact bytes you host
$OPENSSL pkeyutl -sign -inkey keys/private_ed25519.pem -in current/rules_bundle.json -out current/rules_bundle.sig
cp current/rules_bundle.sig 1.0.0/rules_bundle.sig
```

## Updating
- Edit `current/rules_bundle.json`
- Re-sign to update `current/rules_bundle.sig`
- Copy both files to a new version folder (e.g., `1.0.1/`)
- Commit and push
