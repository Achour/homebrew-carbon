# homebrew-carbon

A [Homebrew](https://brew.sh) tap for [Carbon](https://github.com/Achour/carbon) —
a desktop app for Claude Code and Codex.

```sh
brew install --cask achour/carbon/carbon
```

That installs the latest release into `/Applications` and clears the quarantine
flag, so the app opens without the Gatekeeper prompt an unsigned download would
otherwise trigger.

Homebrew won't load a cask from a third-party tap until you trust it. Installing
one by name counts as trusting it, so the line above is all you need — but a
read-only command like `brew info --cask carbon` will refuse until you've either
installed it or run `brew trust achour/carbon`.

To update:

```sh
brew upgrade --cask carbon
```

Carbon tells you when there's a new version — a banner in the sidebar and
Settings → About → Check for updates — and shows this command when it can see
it was installed this way.

## Notes

Carbon isn't signed with an Apple Developer certificate ($99/yr, and it's a free
app), which is why the cask clears `com.apple.quarantine` after installing. If
you'd rather not have a cask do that, build from source instead — the
[README](https://github.com/Achour/carbon#install) covers it, and a locally
built app is never quarantined in the first place.

`Casks/carbon.rb` is updated automatically by the release workflow in the main
repo; please open issues and pull requests over there.
