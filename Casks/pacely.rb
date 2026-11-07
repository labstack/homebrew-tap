cask "pacely" do
  version "2026.11.0-beta.6"
  sha256 "4a5e2ecd1b52f5d0dd0d2e94e17c6c50b70939050f9cf742085b593d33ddd5d3"

  url "https://github.com/labstack/homebrew-tap/releases/download/pacely-v2026.11.0-beta.6/pacely-2026.11.0-beta.6.pkg"
  name "Pacely"
  desc "Selected-account computer time limits (Beta)"
  homepage "https://pacely.app/install/mac"

  auto_updates true
  depends_on macos: :tahoe

  pkg "pacely-2026.11.0-beta.6.pkg"

  # Native preparation verifies restrictions and removes all session agents
  # and the setup CLI link. Homebrew owns daemon and package removal; private
  # state is retained for replacement. After `pacely uninstall` the helper is
  # already gone and there is nothing left to prepare.
  uninstall_preflight do
    helper = "/Library/PrivilegedHelperTools/pacelyd"
    if File.exist?(helper)
      system_command helper,
                     args: ["uninstall", "--prepare-only", "-y"],
                     sudo: true,
                     must_succeed: true
    end
  end

  uninstall launchctl: "com.labstack.pacelyd",
            pkgutil: "com.labstack.pacely.pkg"

  caveats <<~EOS
    Beta: signed and notarized; enforcement is verified at runtime on macOS 26+ Apple silicon.
    Keep a parent administrator account and a separate child Standard account.
    Run sudo /Library/PrivilegedHelperTools/pacelyd setup,
    then pair through your adult assistant.
    Removal verifies account-access restoration before stopping the service.
    Homebrew upgrades resume verified enforcement automatically.
    State is retained. To forget this device, run sudo pacely uninstall.
    Automatic updates remain gated on the production TUF key ceremony.
  EOS
end
