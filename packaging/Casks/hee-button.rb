# Reference copy of the Homebrew Cask. The canonical file lives in
# https://github.com/kujiy/homebrew-tap under Casks/hee-button.rb — copy this
# there once. CI (Scripts/update-homebrew-cask.sh) rewrites `version` and
# `sha256` on each release; the rest stays as below.
cask "hee-button" do
  version "0.0.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://github.com/kujiy/hee-button/releases/download/v#{version}/HeeButton-#{version}.zip"
  name "HeeButton"
  desc "Menu bar app that plays he-.mp3 on click"
  homepage "https://github.com/kujiy/hee-button"

  app "HeeButton.app"

  # Unsigned distribution: strip quarantine so it launches without a Gatekeeper prompt.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/HeeButton.app"]
  end

  zap trash: "~/Library/Preferences/com.github.kujiy.hee-button.plist"
end
