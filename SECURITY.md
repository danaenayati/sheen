# Security

Sheen asks for Full Disk Access and can move files to the Trash, so security reports get priority.

## Reporting a vulnerability

Please report privately through [GitHub's private vulnerability reporting](https://github.com/danaenayati/sheen/security/advisories/new), not in a public issue:

1. Open the [Security tab](https://github.com/danaenayati/sheen/security) of this repository.
2. Click **Report a vulnerability**.
3. Describe the issue, the macOS version, and the steps to reproduce it.

## What gets priority

- **Data loss**: anything that removes a file the user did not select, escapes the protected-paths guard (`SafetyGuard`), follows a symlink out of a scanned folder, or bypasses the move-to-Trash default.
- **Privilege**: anything that runs with administrator rights without the user's confirmation.
- **Network exfiltration**: Sheen's only outbound calls are its own update check (the GitHub releases API for this repository), reading third-party apps' update feeds when you open the Updater, and the opt-in MalwareBazaar hash download (`mb-api.abuse.ch`, only after you add an abuse.ch Auth-Key and press Update Now; each request sends only your Auth-Key and the query, never file hashes or paths). When a downloaded hash matches a signed file, macOS also asks Apple whether its signing certificate was revoked, the same OCSP check Gatekeeper makes; that request is about the certificate, not your files. Report any other network activity you observe.

## Verifying a release

Sheen releases are **ad-hoc signed and not notarized by Apple**: the project has no paid Apple Developer account yet. That is why macOS asks you to confirm the first launch. To be sure the app you run is built from this source:

- Compare the DMG's SHA-256 with the checksum published in the release notes: `shasum -a 256 Sheen-*.dmg`
- Or skip the download and build it yourself from the tag you trust:

```bash
git clone https://github.com/danaenayati/sheen.git
cd sheen
git checkout v1.0.0
scripts/build-without-xcode.sh --install
```

## Past advisories

None yet.
