use epm
epm:install &silent-if-installed=$true ^
github.com/zzamboni/elvish-modules

use github.com/zzamboni/elvish-modules/alias
# Better ls

if (has-external exa) {
  alias:new ls exa;
  alias:new ll exa -l --icons;
  alias:new la exa -la --icons --group-directories-first;
}

# Best editor

if (has-external nvim) {
  alias:new vi nvim;
  alias:new vim nvim;
}

if (has-external bat) {
  alias:new cat bat;
}

# Random aliases

alias:new cnf command-not-found;

