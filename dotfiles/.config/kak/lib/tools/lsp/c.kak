hook global WinSetOption filetype=(cpp|c) %{
    lsp-enable-window

    # Evaluate so that you can painlessly switch between the
    # alternate files in your project. For now, can only get the project_root
    # of cmake and make projects, but will expand in the future as i use other
    # other build systems.

    # TODO: make this script aware of superbuilds, maybe?
    evaluate-commands %sh{
     current_dir=$(pwd)
     project_root=""
     project_root_files=("CMakeLists.txt" "Makefile")
     while [ "$current_dir" != "/" ]; do
        for project_root_file in "${project_root_files[@]}"; do
            if [ -f "$current_dir/$project_root_file" ]; then
                project_root="$current_dir"
                break 2  # Break out of both loops
            fi
        done
        current_dir=$(dirname "$current_dir")
     done

     if [ -z "$project_root" ]; then
        alt_dirs=("." "./src" "./include" ".." "../src" "../include")
     else
	  ignores=("build" "result" ".cache")
	  find_command="find \"$project_root/include\" \"$project_root/src\" -type d"
	  for ignore_dir in "${ignores[@]}"; do
	      find_command="$find_command -not \( -path '*/$ignore_dir' -prune \)"
	  done


          readarray -t alt_dirs < <(eval "$find_command")
     fi

     # Construct the set-option command with the obtained list of directories
     set_option_command="set-option global alt_dirs"
     for dir in "${alt_dirs[@]}"; do
         set_option_command="$set_option_command '$dir'"
     done

     printf 'Debug: set_option: %s' "$set_option_command" 1>&2
     printf '%s' "$set_option_command"
    }



    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
}

