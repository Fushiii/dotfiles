hook global WinSetOption filetype=(cpp|c) %{
    lsp-enable-window

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


# TODO: make the above automatically set the alt_dirs below again.
# The problem with this is that it only supports two folders for two alternative directories,
# which might not be good if you a lot of projects.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
# set-option global alt_dirs "/home/baldur/projects/monolith.git/main/parser/src" "/home/baldur/projects/monolith.git/main/parser/include/parser"
# define-command -docstring "Edit the alternative file!" droid %{
#     evaluate-commands %sh{
#         file="${kak_buffile##*/}"
#         file_noext="${file%.*}"
#         file_ext="${file##*.}" 
#         dir=$(dirname "${kak_buffile}")
# 
#         # Set $@ to alt_dirs
#         eval "set -- ${kak_quoted_opt_alt_dirs}"
# 
#         # Initialize variables to keep track of the most similar alternative file
#    
# 
#         # Determine the extension based on the file extension
#         case "${file_ext}" in
#             "cpp") ext="hpp" ;;
#             "c") ext="h" ;;
#             "cc") ext="hh" ;;
#             "cxx") ext="hxx" ;;
#             "C") ext="H" ;;
#             "hpp") ext="cpp" ;;
#             "h") ext="c" ;;
#             "hh") ext="cc" ;;
#             "hxx") ext="cxx" ;;
#             "H") ext="C" ;;
#             *) ext="h" ;; 
#         esac
# 
#         IFS=" " read -r -a dirs_array <<< "${kak_quoted_opt_alt_dirs//\'/}"
#         
#         alt_src="${dirs_array[0]}" 
#         alt_include="${dirs_array[1]}" 
# 
#         if [[ "$dir" == *"$alt_src"* ]]; then
#             altname_dir="${dir#$alt_src/}"
#             altname_dir="${dir#$alt_src}"
#             altname="$alt_include/$altname_dir/$file_noext.$ext"
#         else
#             altname_dir="${dir#$alt_include/}"
#             altname_dir="${dir#$alt_include}"
#             altname="$alt_src/$altname_dir/$file_noext.$ext"
#         fi
# 
#         if [ -f "$altname" ]; then
#              printf 'edit %%{%s}\n' "${altname}"
#         else
#             touch "${altname}"
#             printf 'edit %%{%s}\n' "${altname}"
#         fi
# 
#     }
# }
# 

    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
}