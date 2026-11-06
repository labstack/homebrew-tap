cask "pacely" do
  version "2026.11.0-beta.5"
  sha256 "a8ee24566f77ff6e8dbdeda15f563c0ebeda883a0a502b9f347f292fecf7b437"

  url "https://github.com/labstack/homebrew-tap/releases/download/pacely-v2026.11.0-beta.5/pacely-2026.11.0-beta.5.pkg"
  name "Pacely"
  desc "Selected-account computer time limits (Beta)"
  homepage "https://pacely.app/install/mac"

  auto_updates true
  depends_on macos: :tahoe

  pkg "pacely-2026.11.0-beta.5.pkg"

  # Native preparation verifies restrictions and removes all session agents
  # and the setup CLI link. Homebrew owns daemon and package removal; private
  # state is retained for replacement.
  uninstall early_script: {
              executable: "/Library/PrivilegedHelperTools/pacelyd",
              args: ["uninstall", "--prepare-only", "-y"],
              sudo: true,
              must_succeed: true,
            },
            launchctl: "com.labstack.pacelyd",
            pkgutil: "com.labstack.pacely.pkg"

  caveats <<~EOS
    Beta: signed and notarized; enforcement is verified at runtime on macOS 26+ Apple silicon.
    Keep a parent administrator account and a separate child Standard account.
    Run sudo /Library/PrivilegedHelperTools/pacelyd setup,
    then pair through your adult assistant.
    Removal verifies account-access restoration before stopping the service.
    Homebrew upgrades resume verified enforcement automatically, including older preparation latches.
    State is retained. To forget this device, run sudo pacely uninstall.
    Automatic updates remain gated on the production TUF key ceremony.
  EOS
end
