bundle-noload one.kak https://github.com/raiguard/one.kak %{
} %{
  # Post-install code here...
  mkdir -p ${kak_config}/colors

  ln -sf "${kak_opt_bundle_path}/one.kak" "${kak_config}/colors/"
}
