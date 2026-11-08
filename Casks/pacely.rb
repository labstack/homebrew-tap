cask "pacely" do
  version "2026.11.0-beta.7"
  sha256 "41c943795c6e5b87253709e24d3fae4f5fd74737863f072b1a6ee2df0ebe5035"

  url "https://github.com/labstack/homebrew-tap/releases/download/pacely-v2026.11.0-beta.7/pacely-2026.11.0-beta.7.pkg"
  name "Pacely"
  desc "Selected-account computer time limits (Beta)"
  homepage "https://pacely.app/install/mac"

  auto_updates true
  depends_on macos: :tahoe

  pkg "pacely-2026.11.0-beta.7.pkg"

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
