use epm
epm:install &silent-if-installed=$true ^
github.com/zzamboni/elvish-libs ^
github.com/zzamboni/elvish-modules ^

# Utilities
use github.com/zzamboni/elvish-modules/util
use github.com/muesli/elvish-libs/git

# Direnv config
if (has-external direnv) {
    use config/direnv;
}

# Path config
use config/paths
