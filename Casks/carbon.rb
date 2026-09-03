cask "carbon" do
  arch arm: "arm64", intel: "x64"

  # version and both sha256s are rewritten by the release workflow in
  # Achour/carbon (.github/workflows/release.yml). Keep them on these exact
  # lines — that job anchors its sed on them and fails loudly if they move.
  version "0.1.98"
  sha256 arm:   "6684f609d1828e39379aaa642444b71dda1feefaa537f792624011ff368d1151",
         intel: "739d135099a451999070f5f7612c9a5d0b49e96190082fa847ae76050d25e9f5"

  url "https://github.com/Achour/carbon/releases/download/v#{version}/Carbon-#{version}-#{arch}.dmg"
  name "Carbon"
  desc "Desktop app for Claude Code and Codex"
  homepage "https://github.com/Achour/carbon"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Matches LSMinimumSystemVersion in the shipped bundle (Electron 43's floor),
  # so an unsupported Mac is refused at install rather than at first launch.
  # The bare symbol means "Monterey or newer" — `depends_on macos:` parses with
  # comparator `>=`, and the older `">= :monterey"` spelling is deprecated.
  depends_on macos: :monterey

  app "Carbon.app"

  # Carbon is not signed with an Apple Developer ID ($99/yr, and this is a free
  # app), so a *downloaded* copy trips Gatekeeper's "Carbon is damaged and can't
  # be opened" dialog. Homebrew quarantines what it downloads, so without this
  # the cask would reproduce exactly the first-launch failure that building from
  # source avoids — clearing the flag is the same `xattr -cr` the README asks
  # .dmg users to run by hand.
  #
  # `-c` (clear all) rather than `-d com.apple.quarantine`: deleting a named
  # attribute exits non-zero on any file that doesn't carry it, which under `-r`
  # is most of them, and `system_command` would fail the install.
  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/Carbon.app"]
  end

  uninstall quit: "com.achour.carbon"

  # Carbon pins its userData to `ai-gui` so dev and packaged builds share one
  # history; that directory holds chats.db. Deliberately *not* listed:
  # ~/.karbun/worktrees, which holds git checkouts of the user's own projects.
  zap trash: [
    "~/Library/Application Support/ai-gui",
    "~/Library/Preferences/com.achour.carbon.plist",
    "~/Library/Saved Application State/com.achour.carbon.savedState",
  ]
end
