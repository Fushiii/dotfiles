## hook for direnv

set @edit:before-readline = $@edit:before-readline {
    var direnv_location = (which direnv)
	try {
		var m = [( $direnv_location export elvish | from-json)]
		if (> (count $m) 0) {
			set m = (all $m)
			keys $m | each { |k|
				if $m[$k] {
					set-env $k $m[$k]
				} else {
					unset-env $k
				}
			}
		}
	} catch e {
		echo $e
	}
}
