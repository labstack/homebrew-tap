cask "pacely" do
  version "2026.11.0-beta.1"
  sha256 "249ce2308722ec9680e3cf69dba39ea48e5ec680e12e1be2ec766a5fbab9fdd3"

  url "https://github.com/labstack/homebrew-tap/releases/download/pacely-v2026.11.0-beta.1/pacely-2026.11.0-beta.1.pkg"
  name "Pacely"
  desc "Selected-account computer time limits (Beta)"
  homepage "https://pacely.app/install/mac"

  auto_updates true
  depends_on macos: ">= :tahoe"

  pkg "pacely-2026.11.0-beta.1.pkg"

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
    Beta: signed and notarized; native enforcement is not certified for family use.
    Keep a parent administrator account and a separate child Standard account.
    Run sudo /Library/PrivilegedHelperTools/pacelyd setup,
    then pair through your adult assistant.
    Removal verifies account-access restoration before stopping the service.
    Homebrew replacement requires running setup again; state is retained.
    Automatic updates remain gated on the production TUF key ceremony.
  EOS
end
