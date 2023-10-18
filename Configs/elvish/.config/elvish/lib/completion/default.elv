# Download needed
use epm
epm:install &silent-if-installed=$true ^
github.com/zzamboni/elvish-completions ^
github.com/xiaq/edit.elv  ^

# Apply smart matcher
use github.com/xiaq/edit.elv/smart-matcher
smart-matcher:apply
# Misc completion

use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/ssh
use github.com/zzamboni/elvish-completions/builtins

# Github completion

use github.com/zzamboni/elvish-completions/git git-completions

# Bang bang

use github.com/zzamboni/elvish-modules/bang-bang

# Utilities

use github.com/zzamboni/elvish-modules/util
use github.com/muesli/elvish-libs/git