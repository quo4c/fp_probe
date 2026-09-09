# fp_probe

Minimal iOS app that fires one `URLSession` request on launch to
`https://fp.wroblox.xyz/collect?os=<iosver>&dev=<model>&h=<hostname>&r=<rand>`
and quits. Purpose: capture the CFNetwork TLS ClientHello of the running iOS
version by tagging the incoming TCP flow with query params for the fingerprint
server to associate.

Built by GitHub Actions on `macos-14` (unsigned). Consumers (SauceLabs Real Devices)
re-sign with their own enterprise certificate at upload.

## Artifact
Run the `build-ipa` workflow → download `fp_probe-ipa` artifact → `fp_probe.ipa` inside.
